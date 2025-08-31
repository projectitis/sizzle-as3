package sizzle.display {

    import flash.display.DisplayObject;
    import flash.display.Sprite;

    import sizzle.pooling.IPooled;

    public class Updatable extends Sprite implements IPooled {

        public function Updatable() {
            super();
        }

        /**
         * Initialise the object after taking from the pool
         */
        public function init(...args):void {
        }

        /**
         * Reset the object when recycling to the pool
         */
        public function reset():void {
        }

        /**
         * Process the update event. This is used internally. For user code, override the update method instead.
         */
        public function processUpdate(dt:Number):void {
            // Step children from top to bottom. If the child is an Updatable, then pass the event through.
            var c:DisplayObject;
            var i:int = numChildren;
            while (i--) {
                c = getChildAt(i);
                if (c is Updatable) {
                    (c as Updatable).processUpdate(dt);
                }
            }
            update(dt);
        }

        /**
         * Called every frame. Override to handle event.
         */
        public function update(dt:Number):void {

        }
    }
}