package sizzle.pooling {

    import flash.utils.getQualifiedClassName;

    import sizzle.pooling.Pool;
    import sizzle.pooling.IPooled;

    /**
     * A manager for pooling any object type
     */
    public class PoolManager {
        private var _pools:Vector.<Pool> = new Vector.<Pool>();

        /**
         * Drain and then remove all pools
         */
        public function clear():void {
            for each (var pool:Pool in _pools) {
                pool.drain();
            }
            _pools.length = 0;
        }

        /**
         * Add a new managed pool for a specific class if it doesn't exist, and return it
         * @param class     The class to create a pool for
         */
        public function manage(managedClass:Class):Pool {
            var pool:Pool;
            for each (var p:Pool in _pools) {
                if (p.managedClass == managedClass) {
                    pool = p;
                    break;
                }
            }
            if (!pool) {
                pool = new Pool(managedClass);
                _pools.push(pool);
            }
            return pool;
        }

        /**
         * Remove a pool from the managed pools
         * @param class     The class of the pool to unmanage
         * @param drain     If true, will also drain the pool. If taking over management of the pool but continuing
         *                  to use it, set this to false.
         */
        public function unmanage(managedClass:Class, drain:Boolean = true):Pool {
            for (var i:int = 0; i < _pools.length; i++) {
                if (_pools[i].managedClass == managedClass) {
                    var pool:Pool = _pools[i];
                    if (drain) {
                        pool.drain();
                    }
                    _pools.splice(i, 1);
                    return pool;
                }
            }
            return null;
        }

        /**
         * Take an item from the pool, or create a new one if the pool is empty
         * @param class     The class of the object to take or create
         * @param rest      Other arguments required to construct the object
         */
        public function take(managedClass:Class, ...rest):IPooled {
            var pool:Pool = manage(managedClass);
            return pool.take.apply(null, rest);
        }

        /**
         * Recycle the object back to it's pool
         */
        public function recycle(object:IPooled):void {
            var pool:Pool = manage(Object(object).constructor);
            if (!pool) {
                throw new Error("The class " + getQualifiedClassName(object) + " does not have a pool");
            }
            return pool.recycle(object);
        }

        /**
         * Drain the pool for a specific class, removing any pooled
         * objects.
         */
        public function drain(managedClass:Class):void {
            var pool:Pool = manage(managedClass);
            if (pool) {
                pool.drain();
            }
        }

        /**
         * String representation of this object
         */
        public function toString():String {
            if (_pools.length == 0) {
                return "PoolManager[]";
            }
            var s:String = "PoolManager[";
            for (var i:int = 0; i < _pools.length; i++) {
                if (i > 0) {
                    s += ", ";
                }
                s += _pools[i].toString();
            }
            return s + "]";
        }
    }
}