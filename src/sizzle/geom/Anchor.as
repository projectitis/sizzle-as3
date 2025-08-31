package sizzle.geom {

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;

    import sizzle.utils.Log;

    public class Anchor {
        public static const TL:int = 0;
        public static const TR:int = 1;
        public static const BL:int = 2;
        public static const BR:int = 3;
        public static const TC:int = 4;
        public static const BC:int = 5;
        public static const LC:int = 6;
        public static const RC:int = 7;
        public static const C:int = 8;

        private var _x:Number = 0;
        private var _y:Number = 0;
        private var _fractional:Boolean = false;
        private var _relative:Boolean = false;

        /**
         * Create a new anchor
         */
        public function Anchor(pos:int = 0) {
            position = pos;
        }

        /**
         * The x value of the anchor position. Do not use this to set the position of the object. Use
         * applyTo or getPosition instead.
         */
        public function set x(value:Number):void {
            _fractional = Math.abs(value) <= 1;
            _x = value;
        }
        public function get x():Number {
            return _x;
        }

        /**
         * The y value of the anchor position. Do not use this to set the position of the object. Use
         * applyTo or getPosition instead.
         */
        public function set y(value:Number):void {
            _fractional = Math.abs(value) <= 1;
            _y = value;
        }
        public function get y():Number {
            return _y;
        }

        /**
         * If true, x and y represent a fraction of the width and height instead of a pixel position.
         */
        public function set fractional(value:Boolean):void {
            _fractional = value;
        }
        public function get fractional():Boolean {
            return _fractional;
        }

        /**
         * If true, negative values are relative to the right and bottom edges.
         */
        public function set relative(value:Boolean):void {
            _relative = value;
        }
        public function get relative():Boolean {
            return _relative;
        }

        /**
         * Set the anchor position to one of the predefined constants (TL. BR, C etc)
         * @value A positional constant (Anchor.TL, Anchor.RC, etc)
         */
        public function set position(value:int):void {
            _x = 0;
            _y = 0;
            _fractional = true;
            _relative = false;
            switch (value) {
                case TR:
                    _x = 1;
                    break;
                case BL:
                    _y = 1;
                    break;
                case BR:
                    _x = 1;
                    _y = 1;
                    break;
                case TC:
                    _x = 0.5;
                    break;
                case BC:
                    _x = 0.5;
                    _y = 1;
                    break;
                case LC:
                    _y = 0.5;
                    break;
                case RC:
                    _x = 1;
                    _y = 0.5;
                    break;
                case C:
                    _x = 0.5;
                    _y = 0.5;
                    break;
                case TL:
                default:
                    _x = 0;
                    _y = 0;
            }
        }

        /**
         * Copy values from another anchor object
         * @param anchor    The anchor to copy from
         */
        public function copyFrom(anchor:Anchor):void {
            this._x = anchor.x;
            this._y = anchor.y;
            this._fractional = anchor.fractional;
            this._relative = anchor.relative;
        }

        /**
         * Apply the anchor position to the child based on the parent size
         * @param child         The display object to position
         * @param parentWidth   The width of the child's parent
         * @param parentHeight  The height of the child's parent
         */
        public function applyTo(child:DisplayObject, bounds:flash.geom.Rectangle):void {
            var sx:Number = _x;
            var sy:Number = _y;
            if (_fractional) {
                sx *= bounds.width;
                sy *= bounds.height;
            }
            child.x = bounds.x + ((_relative && _x < 0) ? bounds.width + sx : sx);
            child.y = bounds.y + ((_relative && _y < 0) ? bounds.height + sy : sy);

        }

        /**
         * Calculate the anchor position based on the parent size
         * @param parentWidth   The width of the parent
         * @param parentHeight  The height of the parent
         * @return A point with the anchor position
         */
        public function getPosition(bounds:flash.geom.Rectangle):Point {
            var sx:Number = _x;
            var sy:Number = _y;
            if (_fractional) {
                sx *= bounds.width;
                sy *= bounds.height;
            }
            return new Point(
                    bounds.x + ((_relative && _x < 0) ? bounds.width + sx : sx),
                    bounds.y + ((_relative && _y < 0) ? bounds.height + sy : sy)
                );
        }
    }
}