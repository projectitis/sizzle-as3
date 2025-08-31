package sizzle.display {
    import flash.geom.Point;
    import flash.display.DisplayObject;

    import sizzle.display.Updatable;
    import sizzle.events.Listener;
    import sizzle.utils.MathUtil;
    import sizzle.utils.ObjectUtil;
    import sizzle.utils.Log;

    public class Interactive extends Updatable {

        private static const CLICK_TIME_MS:int = 250;
        private static const CLICK_TIME_S:Number = CLICK_TIME_MS * 0.001;

        public var active:Boolean = true;
        public var containerOnly:Boolean = false;
        public var isOver:Boolean = false;
        public var isDown:Boolean = false;

        public var mousePos:Point = new Point();

        private var _downTime:uint;
        private var _downPos:Point = new Point();
        private var _checkForDblClick:Vector.<Boolean> = Vector.<Boolean>([false, false, false]);
        private var _dblClickTime:Vector.<Number> = Vector.<Number>([0, 0, 0]);
        private var _clickData:Vector.<Object> = Vector.<Object>([null, null, null]);

        /**
         * Attempt to handle the event and return true if the event is handled. This is called internally
         * and should not normally be called. Instead, override the methods enter, exit, move, down, up, click,
         * dblClick,
         */
        public function processEvent(eventId:int, data:Object):Boolean {
            if (!active && !containerOnly) {
                return false;
            }

            // Process children
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
                        return true;
                    }
                }
            }

            // Process self
            if (!active) {
                return false;
            }
            mousePos.copyFrom(globalToLocal(data.globalMousePos));
            var handled:Boolean = false;
            if (containsPoint(mousePos)) {
                switch (eventId) {
                    case Listener.MOUSE_OUT:
                        if (isOver) {
                            isOver = false;
                            exit(data);
                        }
                        break;
                    case Listener.MOUSE_MOVE:
                        if (!isOver) {
                            isOver = true;
                            handled = enter(data) || handled;
                        }

                        handled = move(data) || handled;
                        break;
                    case Listener.MOUSE_DOWN:
                        if (!isDown) {
                            isDown = true;
                            _downTime = data.time;
                            _downPos.copyFrom(mousePos);
                            handled = down(data) || handled;
                        }
                        break;
                    case Listener.MOUSE_UP:
                        if (isDown) {
                            isDown = false;
                            handled = up(data) || handled;
                            // TODO: Make the click time configurable, make pos change configurable
                            var d:Number = MathUtil.distanceSq(mousePos, _downPos);
                            if (((data.time - _downTime) < CLICK_TIME_MS) && (d <= 4)) {
                                if (_checkForDblClick[data.buttonType]) {
                                    handled = dblClick(data) || handled;
                                    _checkForDblClick[data.buttonType] = false;
                                }
                                else {
                                    _clickData[data.buttonType] = data; // ObjectUtil.copy(data);
                                    handled = sglClick(data) || handled;
                                    _checkForDblClick[data.buttonType] = true;
                                    _dblClickTime[data.buttonType] = 0;
                                }
                            }
                        }
                        break;
                }
            }
            else {
                switch (eventId) {
                    case Listener.MOUSE_MOVE:
                    case Listener.MOUSE_OUT:
                        if (isOver) {
                            isOver = false;
                            exit(data);
                        }
                        break;
                    case Listener.MOUSE_UP:
                        if (isDown) {
                            isDown = false;
                            _checkForDblClick[data.buttonType] = false;
                            _clickData[data.buttonType] = null;
                            upOutside(data);
                        }
                        break;
                }
            }
            return handled;
        }

        /**
         * Checks for dbl click.
         */
        override public function processUpdate(dt:Number):void {
            // Unrolled for performance
            if (_checkForDblClick[0]) {
                // left button
                _dblClickTime[0] += dt;
                if (_dblClickTime[0] > CLICK_TIME_S) {
                    _checkForDblClick[0] = false;
                    click(_clickData[0]);
                    _clickData[0] = null;
                }
            }
            if (_checkForDblClick[1]) {
                // Right button
                _dblClickTime[1] += dt;
                if (_dblClickTime[1] > CLICK_TIME_S) {
                    _checkForDblClick[1] = false;
                    click(_clickData[1]);
                    _clickData[1] = null;
                }
            }
            if (_checkForDblClick[2]) {
                // Middle button
                _dblClickTime[2] += dt;
                if (_dblClickTime[2] > CLICK_TIME_S) {
                    _checkForDblClick[2] = false;
                    click(_clickData[2]);
                    _clickData[2] = null;
                }
            }
            super.processUpdate(dt);
        }

        /**
         * Called when the mouse enters this object. Override to handle this case. Should return true if the
         * event is handled and the event should not propagate to lower children.
         * @return True if the event is handled, false otherwise.
         */
        public function enter(data:Object):Boolean {
            return true;
        }

        /**
         * Called when the mouse exits this object.
         */
        public function exit(data:Object):void {
        }

        /**
         * Called when the mouse moves over this object. Override to handle this case. Should return true if the
         * event is handled and the event should not propagate to lower children.
         * @return True if the event is handled, false otherwise.
         */
        public function move(data:Object):Boolean {
            return true;
        }

        /**
         * Called when the mouse button is pressed down over this object. Override to handle this case. Should return
         * true if the event is handled and the event should not propagate to lower children.
         * @return True if the event is handled, false otherwise.
         */
        public function down(data:Object):Boolean {
            return true;
        }

        /**
         * Called when the mouse button is release over this object. Override to handle this case. Should return
         * true if the event is handled and the event should not propagate to lower children.
         * @return True if the event is handled, false otherwise.
         */
        public function up(data:Object):Boolean {
            return true;
        }

        /**
         * Called when the mouse button is release outside this object. Override to handle this case.
         */
        public function upOutside(data:Object):void {
        }

        /**
         * Called when the mouse button is clicked on this object. Override to handle this case.
         */
        public function click(data:Object):void {
        }

        /**
         * Called when the mouse button is clicked on this object, but before the double-click check is complete.
         * Override to handle this case. Normally you would not need to (use click and dblCLick instead), however
         * if you need to pass the event through (by returning false), then override this.
         * Should return true if the event is handled and the event should not propagate to lower children.
         * @return True if the event is handled, false otherwise.
         */
        public function sglClick(data:Object):Boolean {
            return true;
        }

        /**
         * Called when the mouse button is double-clicked on this object. Override to handle this case. Should return
         * true if the event is handled and the event should not propagate to lower children.
         * @return True if the event is handled, false otherwise.
         */
        public function dblClick(data:Object):Boolean {
            return true;
        }

        /**
         * Returns true if the point is contained within the interactive. This is based on the width and height
         * values of the interactive. Override this for interactives that are not simple rectangles.
         */
        public function containsPoint(p:Point):Boolean {
            return (p.x >= 0 && p.x <= width && p.y >= 0 && p.y <= height);
        }
    }
}