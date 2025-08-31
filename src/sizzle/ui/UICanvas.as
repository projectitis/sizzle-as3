package sizzle.ui {

    import flash.geom.Rectangle;
    import flash.display.DisplayObject;

    import sizzle.display.Canvas;
    import sizzle.events.Listeners;
    import sizzle.ui.Widget;

    /**
     * A UI canvas is a container for UI elements
     */
    public class UICanvas extends Canvas {
        public var scaleWithGame:Boolean = true;

        public function UICanvas(listeners:Listeners) {
            super(listeners);
        }

        override public function set bounds(bounds:Rectangle):void {
            super.bounds = bounds;
            updateWidgets();
        }

        public function updateWidgets():void {
            // Reposition child widgets
            var c:DisplayObject;
            var w:Widget;
            var i:int = numChildren;
            while (i--) {
                c = getChildAt(i);
                if (c is Widget) {
                    w = (c as Widget);
                    w.anchor.applyTo(w, bounds);
                }
            }
        }

    }
}