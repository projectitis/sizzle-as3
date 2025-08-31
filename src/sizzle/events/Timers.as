package sizzle.events {

    import sizzle.events.Timer;
    import sizzle.pooling.Pool;
    import sizzle.pooling.PoolManager;

    public class Timers {

        // Linked list of timers
        private var _first:Timer;

        // Pool manager
        private var _pool:Pool;

        /**
         * Constructor
         */
        public function Timers(poolManager:PoolManager) {
            _pool = poolManager.manage(Timer);
        }

        /**
         * Add a new Timer
         * @param	duration	The duration of the timer (seconds)
         * @param	delay		The delay before the timer starts (seconds)
         * @param	callback	The callback function to call when the timer is finished. callback():Boolean
         *                      The callback should return false to remove itself, or true to continue to loop.
         * @param	callbackArgs	The arguments to pass to the callback function
         */
        public function add(duration:Number, delay:Number = 0, callback:Function = null, callbackArgs:Array = null):void {
            var item:Timer = _pool.take(duration, delay, callback, callbackArgs) as Timer;
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
        private function _recycle(item:Timer):void {
            _pool.recycle(item);
        }

        /**
         * Remove a timer with a given callback
         * @param	callback	The callback of the timer to remove
         * @return	The new first timer in the linked list
         */
        public function remove(callback:Function):void {
            if (_first == null) {
                _first = _first.remove(callback);
            }
        }

        /**
         * Remove all timers
         */
        public function clear():void {
            var next:Timer = _first;
            var tempNext:Timer;
            while (next) {
                tempNext = next.next;
                _recycle(next);
                next = tempNext;
            }
            _first = null;
        }

        /**
         * Update all timers
         * @param	dt	The delta time since last update (seconds)
         **/
        public function update(dt:Number):void {
            if (_first) {
                _first = _first.update(dt);
            }
        }

    }
}