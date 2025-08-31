package sizzle.events {

    import sizzle.utils.ObjectUtil;

    import sizzle.pooling.IPooled;
    import sizzle.pooling.Pool;

    /**
     * Listener is a callback that listens for a specific event
     */
    public class Listener implements IPooled {

        // Global
        public static const UPDATE:int = 0;
        public static const RESIZE:int = 1;

        // From KeyboardEvent
        public static const KEY_DOWN:int = 2;
        public static const KEY_UP:int = 3;

        // From MouseEvent
        public static const MOUSE_CLICK:int = 4;
        public static const MOUSE_CONTEXT_MENU:int = 5;
        public static const MOUSE_DOUBLE_CLICK:int = 6;
        public static const MOUSE_DOWN:int = 7;
        public static const MOUSE_MOVE:int = 8;
        public static const MOUSE_OUT:int = 9;
        public static const MOUSE_OVER:int = 10;
        public static const MOUSE_UP:int = 11;
        public static const MOUSE_WHEEL:int = 12;
        public static const MOUSE_WHEEL_HORIZONTAL:int = 13;
        public static const MOUSE_UP_OUTSIDE:int = 14;

        // Used by mouse event
        public static const MOUSE_BUTTON_LEFT:int = 0;
        public static const MOUSE_BUTTON_RIGHT:int = 1;
        public static const MOUSE_BUTTON_MIDDLE:int = 2;

        // Mapping for flash events to sizzle event IDs
        public static var EVENT_MAP:Object = {
                // Keyboard events
                keyDown: Listener.KEY_DOWN,
                keyUp: Listener.KEY_UP,

                // Mouse events
                click: Listener.MOUSE_CLICK,
                contextMenu: Listener.MOUSE_CONTEXT_MENU,
                doubleCLick: Listener.MOUSE_DOUBLE_CLICK,
                mouseDown: Listener.MOUSE_DOWN,
                mouseMove: Listener.MOUSE_MOVE,
                mouseOut: Listener.MOUSE_OUT,
                mouseOver: Listener.MOUSE_OVER,
                mouseUp: Listener.MOUSE_UP,
                mouseWheel: Listener.MOUSE_WHEEL,
                mouseWheelHorizontal: Listener.MOUSE_WHEEL_HORIZONTAL,
                releaseOutside: Listener.MOUSE_UP_OUTSIDE
            };

        // #region Pooling

        /**
         * Callback to recycle object back to pool
         */
        public var onRecycle:Function;

        /**
         * Initialize the Listener with a callback.
         * @param eventId   The ID of the event to listen for.
         * @param callback  The function to call when triggered. Function(eventId:int, data:Object):Boolean
         *                  The function should return false to stop listening.
         * @param data      An object to supply when the callback is triggered. Depending on the event type, additional
         *                  fields may be added to the object.
         **/
        public function init(...rest):void {
            _remove = false;
            _eventId = rest[0];
            _callback = rest[1] as Function;
            _callbackData = rest[2] ? rest[2] : {};
        }

        /**
         * Reset Listener to defaults
         */
        public function reset():void {
            next = null;
            _callback = null;
            _callbackData = null;
        }

        // #endregion Pooling
        // #region Class

        // Next listener in the linked list
        public var next:Listener;

        // The ID of the event to listen for
        private var _eventId:int;

        // The function to call when triggered. Function(eventId:int, data:Object):Boolean
        // The function should return false to stop listening.
        private var _callback:Function;

        // The data to pass to the callback when triggered
        private var _callbackData:Object;

        // This listener has been flagged for removal
        private var _remove:Boolean = false;

        /**
         * Create a new listener
         * @param eventId   The ID of the event to listen for.
         * @param callback  The function to call when triggered. Function(eventId:int, data:Object):Boolean
         *                  The function should return false to stop listening.
         * @param data      An object to supply when the callback is triggered. Depending on the event type, additional
         *                  fields may be added to the object.
         **/
        public function Listener(eventId:int = 0, callback:Function = null, data:Object = null) {
            init(eventId, callback, data);
        }

        /**
         * Push a new listener onto the end of the list.
         * @param listener The listener to push onto the list.
         **/
        public function push(listener:Listener):void {
            if (next == null)
                next = listener;
            else
                next.push(listener);
        }

        /**
         * Remove a listener from the list that matches the event ID and callback. The listener is flagged for
         * removal, and will be removed during the next update cycle.
         * @param eventId The ID of the event to remove.
         * @param callback The callback to remove.
         * @param removeFirstOnly If true, only remove the first occurrence of the callback.
         * @return The next listener in the list after the removed listener, or null if this was the last listener.
         **/
        public function remove(eventId:int, callback:Function, removeFirstOnly:Boolean):Listener {
            // Remove this callback?
            if (_eventId == eventId && _callback == callback) {
                if ((!removeFirstOnly) && (next != null)) {
                    next = next.remove(eventId, callback, removeFirstOnly);
                }
                _remove = true;
                return next;
            }
            if (next != null) {
                next = next.remove(eventId, callback, removeFirstOnly);
            }
            return this;
        }

        /**
         * Trigger any listeners that are listening for this event.
         * @param eventId       The ID of the event to trigger
         * @param eventData     Any event data to add to this object
         **/
        public function update(eventId:int, eventData:Object):Listener {
            // If this listener is flagged for removal, remove it and continue to the next listener.
            if (_remove) {
                var tempNext:Listener = next;
                onRecycle(this);
                if (tempNext != null) {
                    return tempNext.update(eventId, eventData);
                }
                return null;
            }

            // This listener is listening for the correct event. Trigger the callback
            if (_eventId == eventId) {
                if (_callback != null) {
                    _remove = (_callback(eventId, ObjectUtil.combine(_callbackData, eventData)) === false) || _remove;
                }
            }

            // Move to the next event
            if (next != null) {
                next = next.update(eventId, eventData);
            }
            return this;
        }

        // #endregion Class

    }

}