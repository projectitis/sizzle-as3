package sizzle.events {
    import sizzle.events.Listener;
    import sizzle.pooling.Pool;
    import sizzle.pooling.PoolManager;

    public class Listeners {

        // Linked list of listeners
        private var _first:Listener;

        // Pool manager
        private var _pool:Pool;

        /**
         * Constructor
         */
        public function Listeners(poolManager:PoolManager) {
            _pool = poolManager.manage(Listener);
        }

        /**
         * Add a new listener
         * @param eventId   The ID of the event to listen for.
         * @param callback  The function to call when triggered. Function(eventId:int, data:Object):Boolean
         *                  The function should return false to stop listening.
         * @param data      An object to supply when the callback is triggered. Depending on the event type, additional
         *                  fields may be included to the object when the callback is triggered.
         **/
        public function add(eventId:int, callback:Function, data:Object = null):void {
            var item:Listener = _pool.take(eventId, callback, data) as Listener;
            item.onRecycle = this._recycle;
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
        private function _recycle(item:Listener):void {
            _pool.recycle(item);
        }

        /**
         * Remove a listener from the list that matches the event ID and callback. The listener is flagged for
         * removal, and will be removed during the next update cycle.
         * @param eventId The ID of the event to remove.
         * @param callback The callback to remove.
         * @param removeFirstOnly If true, only remove the first occurrence of the callback.
         **/
        public function remove(eventId:int, callback:Function, removeFirstOnly:Boolean = false):void {
            if (_first == null) {
                _first = _first.remove(eventId, callback, removeFirstOnly);
            }
        }

        /**
         * Remove all listeners
         */
        public function clear():void {
            var next:Listener = _first;
            var tempNext:Listener;
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
        public function trigger(eventId:int, eventData:Object = null):void {
            if (_first) {
                _first = _first.update(eventId, eventData ? eventData : {});
            }
        }
    }
}