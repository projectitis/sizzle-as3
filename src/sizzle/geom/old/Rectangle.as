package sizzle.geom {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Point;
    import sizzle.geom.Polygon;
    import sizzle.geom.Line;

    public class Rectangle extends Polygon {

        private var _width:Number;
        private var _height:Number;

        /**
         * Create a new rectangle shape
         */
        public function Rectangle(width:Number, height:Number, parent:DisplayObject = null) {
            super([0, 0, width, 0, width, height, 0, height], parent);
            this._width = width;
            this._height = height;
        }

        /**
         * Set the rectangle width
         */
        public function set width(value:Number):void {
            _width = value;
            _changed();
        }

        /**
         * Return the rectangle width
         */
        public function get width():Number {
            return _width;
        }

        /**
         * Set the rectangle height
         */
        public function set height(value:Number):void {
            _height = value;
            _changed();
        }

        /**
         * Return the rectangle height
         */
        public function get height():Number {
            return _height;
        }

        /**
         * Recalculate the lines that represent the edges of the rectangle.
         * Note: Clockwise
         */
        private function _changed():void {
            path[0].setTo(0, 0);
            path[1].setTo(_width, 0);
            path[2].setTo(_width, _height);
            path[3].setTo(0, _height);
            changed();
        }

        /**
         * Check if a point is inside the rectangle.
         * @param p     A point in the local coordinates of the rect
         * @return true if the point lies within the rect
         */
        override public function contains(p:Point):Boolean {
            return p.x >= 0 && p.x <= width && p.y >= 0 && p.y <= height;
        }
    }
}