package sizzle.pooling {

    import flash.utils.getQualifiedClassName;
    import sizzle.pooling.IPooled;

    /**
     * An object pool
     * Used by PoolManager
     */
    public class Pool {
        private var _items:Vector.<IPooled> = new Vector.<IPooled>();
        private var _class:Class = undefined;
        private var _taken:int = 0;
        private var _recycled:int = 0;

        /**
         * Create a new pool for the provided class
         */
        public function Pool(managedClass:Class) {
            _class = managedClass;
        }

        /**
         * Get the class of this pool
         */
        public function get managedClass():Class {
            return _class;
        }

        /**
         * Return the total number of items taken from this pool
         */
        public function get taken():int {
            return _taken;
        }

        /**
         * Return the total number of items recycles to this pool
         */
        public function get recycled():int {
            return _recycled;
        }

        /**
         * Get an object from the pool or create a new one
         * @return An object instance
         */
        public function take(...rest):IPooled {
            var instance:IPooled;
            if (_items.length > 0) {
                instance = _items.pop();
            }
            else {
                instance = new _class();
            }
            instance.init.apply(null, rest);
            _taken++;
            return instance;
        }

        /**
         * Return an object to the pool
         * @param obj The object to return
         */
        public function recycle(object:IPooled):void {
            object.reset();
            _items.push(object);
            _recycled++;
        }

        /**
         * Drain the pool
         */
        public function drain():void {
            _items.length = 0;
            _taken = 0;
            _recycled = 0;
        }

        /**
         * String representation of this object
         */
        public function toString():String {
            return "Pool.<" + getQualifiedClassName(_class) + ">(pooled:" + _items.length + ", taken:" + _taken + ", recycled:" + _recycled + ")";
        }
    }
}