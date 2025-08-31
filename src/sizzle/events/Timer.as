package sizzle.events {

    import sizzle.pooling.IPooled;
    import sizzle.pooling.Pool;

    public class Timer implements IPooled {

        // #region Pooling

        /**
         * Callback to recycle object back to pool
         */
        public var onRecycle:Function;

        /**
         * Initialize the Timer with the provided parameters
         * @param	duration	The duration of the timer (seconds)
         * @param	delay		The delay before the timer starts (seconds)
         * @param	callback	The callback function to call when the timer is finished. callback():Boolean
         *                      The callback should return false to remove itself, or true to continue to loop.
         * @param	callbackArgs	The arguments to pass to the callback function
         */
        public function init(...rest):void {
            _duration = Math.max(0, rest[0]);
            _progress = -Math.max(0, rest[1]);
            _callback = rest[2] as Function;
            _callbackArgs = rest[3];
            _finished = false;
            _remove = false;
        }

        /**
         * Reset Listener to defaults
         */
        public function reset():void {
            next = null;
            _callback = null;
            _callbackArgs = null;
        }

        // #endregion Pooling
        // #region Class

        public var next:Timer;

        private var _duration:Number;
        private var _progress:Number;
        private var _finished:Boolean;
        private var _remove:Boolean;

        private var _callback:Function;
        private var _callbackArgs:Array;

        /**
         * Create a new Timer
         * @param	duration	The duration of the timer (seconds)
         * @param	delay		The delay before the timer starts (seconds)
         * @param	callback	The callback function to call when the timer is finished. callback():Boolean
         *                      The callback should return false to remove itself, or true to continue to loop.
         * @param	callbackArgs	The arguments to pass to the callback function
         */
        public function Timer(duration:Number = 0, delay:Number = 0, callback:Function = null, callbackArgs:Array = null) {
            init(duration, delay, callback, callbackArgs);
            next = null;
        }

        /**
         * Add a new timer to the end of the linked list
         * @param	timer	The timer to add
         */
        public function push(timer:Timer):void {
            if (next == null) {
                next = timer;
            }
            else {
                next.push(timer);
            }
        }

        /**
         * Remove a timer with a given callback
         * @param	callback	The callback of the timer to remove
         * @return	The new first timer in the linked list
         */
        public function remove(callback:Function):Timer {
            var removeNow:Boolean = false;
            if (_callback == callback) {
                if (!_finished) {
                    removeNow = true;
                }
                else {
                    _remove = true;
                }
            }
            if (next != null) {
                next = next.remove(callback);
            }
            if (removeNow) {
                var tempNext:Timer = next;
                onRecycle(this);
                return tempNext;
            }
            return this;
        }

        /**
         * Update each timer. Will start timing once the delay time has passed.
         * @param	dt	The delta time since last update (seconds)
         * @return	The new first timer in the linked list
         **/
        public function update(dt:Number):Timer {
            _progress += dt;
            _remove = false;
            // If the timer is set with a very short duration, it might fire
            // multiple times during an update.
            while (_progress >= _duration && !_remove) {
                _progress -= _duration;
                _finished = true;
                if (_callback != null) {
                    if (_callbackArgs != null) {
                        if (!_callback.apply(null, _callbackArgs)) {
                            _remove = true;
                        }
                    }
                    else {
                        if (!_callback()) {
                            _remove = true;
                        }
                    }
                }
            }
            if (next != null) {
                next = next.update(dt);
            }
            _finished = false;
            if (_remove) {
                var tempNext:Timer = next;
                onRecycle(this);
                return tempNext;
            }
            return this;
        }

        // #endregion Class

    }

}