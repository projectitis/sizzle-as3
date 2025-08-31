package sizzle.events {

    import sizzle.events.Tween;
    import sizzle.pooling.Pool;
    import sizzle.pooling.PoolManager;

    public class Tweens {

        // Linked list of tweens
        private var _first:Tween;

        // Pool manager
        private var _pool:Pool;

        /**
         * Constructor
         */
        public function Tweens(poolManager:PoolManager) {
            _pool = poolManager.manage(Tween);
        }

        /**
         * Add a new Tween
         * @param	clip		The clip to apply the tweens to
         * @param	args		The properties to tween and their end values
         * @param	duration	The duration of the tween (seconds)
         * @param	delay		The delay before the tween starts (seconds)
         * @param	tween		The easing function to use for the tween
         * @param	callback	The callback function to call when the tween is finished
         * @param	callbackArgs	The arguments to pass to the callback function
         */
        public function add(clip:Object, args:Object, duration:Number, delay:Number = 0, tween:Function = null,
                callback:Function = null, callbackArgs:Array = null):void {
            var item:Tween = _pool.take(clip, args, duration, delay, tween, callback, callbackArgs) as Tween;
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
        private function _recycle(item:Tween):void {
            _pool.recycle(item);
        }

        /**
         * Remove a tween if it matches the specified arguments
         * @param	clip	The clip to remove tweens from
         * @param	args	The args to stop tweening (or null to remove all)
         */
        public function remove(clip:Object, args:Object = null):void {
            if (_first == null) {
                _first = _first.remove(clip, args);
            }
        }

        /**
         * Remove all tweens
         */
        public function clear():void {
            var next:Tween = _first;
            var tempNext:Tween;
            while (next) {
                tempNext = next.next;
                _recycle(next);
                next = tempNext;
            }
            _first = null;
        }

        /**
         * Update all tweens
         * @param	dt	The delta time since last update (seconds)
         **/
        public function update(dt:Number):void {
            if (_first) {
                _first = _first.update(dt);
            }
        }

    }
}