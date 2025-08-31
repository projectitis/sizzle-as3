package sizzle.ui {

    import flash.geom.Point;

    import sizzle.display.Color;
    import sizzle.ui.Widget;
    import sizzle.utils.Log;

    public class IconButton extends Widget {

        public static const ICON_NONE:int = 0;
        public static const ICON_MOVE:int = 1;
        public static const ICON_RESIZE:int = 2;
        public static const ICON_EXPAND:int = 3;

        public var icon:int;
        public var color:Color;
        public var size:Number = 20;
        public var padding:Number = 4;

        public var onClick:Function;
        public var onDblClick:Function;
        public var onDown:Function;
        public var onUp:Function;

        private var size_2:Number = 0;

        public function IconButton(icon:int, color:Color, eventData:Object = null):void {
            this.icon = icon;
            this.color = color;
            redraw();
        }

        public function redraw():void {
            size_2 = size * 0.5;
            graphics.clear();
            if (isOver) {
                graphics.beginFill(0x888888);
            }
            else {
                graphics.beginFill(0x484848);
            }
            graphics.drawRect(-size_2, -size_2, size, size);
            graphics.endFill();

            var s_1:Number = size - padding - padding;
            var s_2:Number = s_1 * 0.5;
            var s_4:Number = s_1 * 0.25;
            var s_8:Number = s_1 * 0.125;
            graphics.lineStyle(1, this.color.value, this.color.a);
            switch (icon) {
                case ICON_RESIZE:
                    graphics.drawRect(0, 0, s_2, s_2);
                    graphics.moveTo(-s_2 + s_8, s_2);
                    graphics.lineTo(-s_2, s_2);
                    graphics.lineTo(-s_2, -s_2);
                    graphics.lineTo(s_2, -s_2);
                    graphics.lineTo(s_2, -s_2 + s_8);

                    break;
                case ICON_MOVE:
                    graphics.moveTo(-s_8, -s_2 + s_8);
                    graphics.lineTo(0, -s_2);
                    graphics.lineTo(0, s_2);
                    graphics.lineTo(s_8, s_2 - s_8);

                    graphics.moveTo(s_8, -s_2 + s_8);
                    graphics.lineTo(0, -s_2);
                    graphics.moveTo(-s_8, s_2 - s_8);
                    graphics.lineTo(0, s_2);

                    graphics.moveTo(-s_2 + s_8, -s_8);
                    graphics.lineTo(-s_2, 0);
                    graphics.lineTo(s_2, 0);
                    graphics.lineTo(s_2 - s_8, -s_8);

                    graphics.moveTo(-s_2 + s_8, s_8);
                    graphics.lineTo(-s_2, 0);
                    graphics.moveTo(s_2 - s_8, s_8);
                    graphics.lineTo(s_2, 0);

                    break;
                case ICON_EXPAND:
                    graphics.moveTo(-s_2, -s_2 + s_8);
                    graphics.lineTo(-s_2, -s_2);
                    graphics.lineTo(s_2, s_2);
                    graphics.lineTo(s_2, s_2 - s_8);
                    graphics.moveTo(s_2, s_2);
                    graphics.lineTo(s_2 - s_8, s_2);
                    graphics.moveTo(-s_2, -s_2);
                    graphics.lineTo(-s_2 + s_8, -s_2);

                    graphics.moveTo(s_2, -s_2 + s_8);
                    graphics.lineTo(s_2, -s_2);
                    graphics.lineTo(-s_2, s_2);
                    graphics.lineTo(-s_2, s_2 - s_8);
                    graphics.moveTo(-s_2, s_2);
                    graphics.lineTo(-s_2 + s_8, s_2);
                    graphics.moveTo(s_2, -s_2);
                    graphics.lineTo(s_2 - s_8, -s_2);
                    break;
            }
        }

        override public function enter(data:Object):Boolean {
            redraw();
            return true;
        }

        override public function exit(data:Object):void {
            redraw();
        }

        override public function down(data:Object):Boolean {
            if (onDown != null) {
                onDown();
                return true;
            }
            return false;
        }

        override public function up(data:Object):Boolean {
            if (onUp != null) {
                onUp();
                return true;
            }
            return false;
        }

        override public function click(data:Object):void {
            if (onClick != null) {
                onClick();
            }
        }

        override public function dblClick(data:Object):Boolean {
            if (onDblClick != null) {
                onDblClick();
                return true;
            }
            return false;
        }

        override public function containsPoint(p:Point):Boolean {
            return (p.x >= -size_2 && p.x <= size_2 && p.y >= -size_2 && p.y <= size_2);
        }
    }
}