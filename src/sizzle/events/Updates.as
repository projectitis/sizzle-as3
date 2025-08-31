package sizzle.events {
    import sizzle.events.Update;
    import sizzle.pooling.Pool;
    import sizzle.pooling.PoolManager;

    public class Updates {

        // Linked list of updates
        private var _first:Update;

        // Pool manager
        private var _pool:Pool;

        /**
         * Constructor
         */
        public function Updates(poolManager:PoolManager) {
            _pool = poolManager.manage(Update);
        }

        /**
         * Add a new update
         * @param callback  The function to call when triggered. Function(dt:Number):Boolean
         *                  The function should return false to stop listening.
         **/
        public function add(callback:Function):void {
            var item:Update = _pool.take(callback) as Update;
            item.onRecycle = _recycle;
            if (_first == null) {
                _first = item;
            }
            else {
                _first.push(item);
            }
        }

        /**
         * Recycle an item back to the pool
         */
        private function _recycle(item:Update):void {
            _pool.recycle(item);
        }

        /**
         * Remove an update.
         * @param callback          The callback of the update to remove.
         * @param removeFirstOnly   If true, only remove the first occurrence of the callback.
         **/
        public function remove(eventId:int, callback:Function, removeFirstOnly:Boolean):void {
            if (_first == null) {
                _first = _first.remove(callback, removeFirstOnly);
            }
        }

        /**
         * Remove all updates
         */
        public function clear():void {
            var next:Update = _first;
            var tempNext:Update;
            while (next) {
                tempNext = next.next;
                _recycle(next);
                next = tempNext;
            }
            _first = null;
        }

        /**
         * Trigger an event. All listeners of that event will fire.
         * @param eventId       The ID of the event to trigger
         * @param eventData     Any data to pass to triggered listeners
         */
        public function update(dt:Number):void {
            if (_first) {
                _first = _first.update(dt);
            }
        }
    }
}