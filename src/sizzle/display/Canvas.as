package sizzle.display {

    import flash.geom.Rectangle;
    import flash.display.DisplayObject;

    import sizzle.display.Interactive;
    import sizzle.display.Updatable;
    import sizzle.events.Listeners;
    import sizzle.events.Listener;

    /**
     * A canvas is a container for interactive child elements (mouse interaction)
     */
    public class Canvas extends Updatable {

        private var _listeners:Listeners;
        private var _bounds:Rectangle = new Rectangle();

        public function Canvas(listeners:Listeners):void {
            super();
            mouseEnabled = false;
            mouseChildren = false;

            _listeners = listeners;
            _listeners.add(Listener.MOUSE_MOVE, _mouseEvent);
            _listeners.add(Listener.MOUSE_DOWN, _mouseEvent);
            _listeners.add(Listener.MOUSE_UP, _mouseEvent);
            _listeners.add(Listener.MOUSE_UP_OUTSIDE, _mouseEvent);
            _listeners.add(Listener.MOUSE_OUT, _mouseEvent);
        }

        /**
         * Clean up
         */
        public function destroy():void {
            _listeners.remove(Listener.MOUSE_MOVE, _mouseEvent);
            _listeners.remove(Listener.MOUSE_DOWN, _mouseEvent);
            _listeners.remove(Listener.MOUSE_UP, _mouseEvent);
            _listeners.remove(Listener.MOUSE_UP_OUTSIDE, _mouseEvent);
            _listeners.remove(Listener.MOUSE_OUT, _mouseEvent);
            _listeners = null;
        }

        /**
         * The bounds of the canvas
         */
        public function set bounds(bounds:Rectangle):void {
            _bounds.copyFrom(bounds);
        }
        public function get bounds():Rectangle {
            return _bounds;
        }

        /**
         * Process mouse events for all interactive children
         */
        private function _mouseEvent(eventId:int, data:Object):Boolean {
            // Step children from top to bottom. If the child is an Interactive, then pass the event through.
            // If the interactive handles the event, stop processing.
            var c:DisplayObject;
            var n:Interactive;
            var i:int = numChildren;
            while (i--) {
                c = getChildAt(i);
                if (c is Interactive) {
                    n = (c as Interactive);
                    if (n.processEvent(eventId, data)) {
                        break;
                    }
                }
            }

            return true;
        }

    }
}