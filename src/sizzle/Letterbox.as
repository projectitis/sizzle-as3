package sizzle {

    import flash.display.Sprite;
    import flash.display.Screen;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import sizzle.Game;
    import sizzle.display.Color;
    import sizzle.utils.Log;

    public class Letterbox extends Sprite {
        private var _color:Color = new Color(0x000000);
        private var _active:Boolean = false;
        private var _vw:Number = 0;
        private var _vh:Number = 0;

        public function Letterbox() {
            super();

            mouseEnabled = false;
            mouseChildren = false;
        }

        public function set active(value:Boolean):void {
            _active = value;
            update(_vw, _vh);
        }

        public function get active():Boolean {
            return _active;
        }

        public function set color(value:Color):void {
            _color = value;
            if (_color == null) {
                _color = new Color(0x000000);
            }
            update(_vw, _vh);
        }

        public function get color():Color {
            return _color;
        }

        public function update(vw:Number, vh:Number):void {
            _vw = vw;
            _vh = vh;
            graphics.clear();
            if (_active) {
                graphics.beginFill(_color.value, _color.a);
                var dw:Number = (stage.stageWidth - vw) * 0.5;
                var dh:Number = (stage.stageHeight - vh) * 0.5;
                if (dw > 0) {
                    // Letterbox the sides
                    graphics.drawRect(0, 0, dw, vh);
                    graphics.drawRect(stage.stageWidth, 0, -dw, vh);
                }
                else if (dh > 0) {
                    // Letterbox the top and bottom
                    graphics.drawRect(0, 0, vw, dh);
                    graphics.drawRect(0, stage.stageHeight, vw, -dh);
                }
                graphics.endFill();
            }
        }
    }
}