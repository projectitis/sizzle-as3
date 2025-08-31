package sizzle.geom {
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Point;
    import sizzle.geom.Shape;
    import sizzle.geom.Line;
    import sizzle.geom.Vector2d;
    import sizzle.utils.MathUtil;

    public class Rectangle extends Shape {

        private var _width:Number;
        private var _height:Number;
        private var _lines:Vector.<Line> = new Vector.<Line>(4, true);

        /**
         * Create a new rectangle shape
         */
        public function Rectangle(width:Number, height:Number, parent:DisplayObject = null) {
            super(parent);

            _lines[0] = new Line();
            _lines[1] = new Line();
            _lines[2] = new Line();
            _lines[3] = new Line();
            this._width = width;
            this._height = height;
            _recalculateLines();
        }

        /**
         * Set the rectangle width
         */
        public function set width(value:Number):void {
            _width = value;
            _recalculateLines();
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
            _recalculateLines();
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
        private function _recalculateLines():void {
            _lines[0].setTo(0, 0, _width, 0);
            _lines[1].setTo(_width, 0, _width, _height);
            _lines[2].setTo(_width, _height, 0, _height);
            _lines[3].setTo(0, _height, 0, 0);
        }

        /**
         * Check if a point is inside the rectangle.
         * @param p     A point in the local coordinates of the rect
         * @return true if the point lies within the rect
         */
        override public function contains(p:Point):Boolean {
            return p.x >= 0 && p.x <= width && p.y >= 0 && p.y <= height;
        }

        /**
         * Return the closest point to the provided point that is on
         * the boundary of this rectangle.
         * @param p     A position in the rectangles local coordinate space
         * @return The point on the boundary closest to the provided point
         */
        override public function closest(p:Point):Point {
            var c:Point = new Point(
                    MathUtil.clamp(p.x, 0, width),
                    MathUtil.clamp(p.y, 0, height)
                );

            // If outside the boundary, return as-is
            if (!contains(p)) {
                return c;
            }

            // Distance from left
            var l:Number = Math.abs(p.x);
            // Distance from right
            var r:Number = Math.abs(width - p.x);
            // Distance from top
            var t:Number = Math.abs(p.y);
            // Distance from bottom
            var b:Number = Math.abs(height - p.y);

            var d:Number = Math.min(l, r, t, b);
            if (d == l) {
                c.x = 0;
            }
            else if (d == r) {
                c.x = width;
            }
            else if (d == t) {
                c.y = 0;
            }
            else {
                c.y = height;
            }

            return c;
        }

        /**
         * Return the intersection point between a line segment and the rect.
         * If there are more than one intersection, the closest to the start
         * of the line is returned (the line is a raycast from start to end).
         * @param l         A line segment
         * @param normal    (out) If not null, will be populated by the normal at the intersection point
         * @return The point where the line segment intersects, or null
         */
        override public function intersection(l:Line):Vector2d {
            var c:Vector2d = new Vector2d();
            var d:Number = Number.POSITIVE_INFINITY;

            d = _intersectEdge(_lines[0], l, c, d);
            d = _intersectEdge(_lines[1], l, c, d);
            d = _intersectEdge(_lines[2], l, c, d);
            d = _intersectEdge(_lines[3], l, c, d);

            if (d == Number.POSITIVE_INFINITY) {
                return null;
            }
            return c;
        }

        /**
         * Helper to calculate closest edge intersected by the line
         */
        private function _intersectEdge(e:Line, l:Line, c:Vector2d, d:Number):Number {
            var i:Point = e.intersection(l);
            if (i != null) {
                var d2:Number = MathUtil.distanceSq(l.p1, i);
                if (d2 < d) {
                    c.setFrom(i, e.normal.angle);
                    d = d2;
                }
            }
            return d;
        }

        override public function draw(canvas:Graphics = null):void {
            if (!canvas) {
                if (parent && (parent is Sprite)) {
                    canvas = (parent as Sprite).graphics;
                }
                else {
                    return;
                }
            }
            canvas.drawRect(0, 0, _width, _height);
        }

        /**
         * Calculates a new point on the shape boundary that is obtained by starting
         * from the specified point and moving a set distance in either the clockwise
         * or anti-clockwise direction.
         * @param p     The point to start from. Closest point on the boundary will be used.
         * @param d     The distance to move (local coordinate space)
         * @param cw       If true, move clockwise, otherwise move anti-clockwise
         * @return The new point after moving along the boundary
         */
        override public function follow(p:Point, d:Number, cw:Boolean = true):void {
            var i:int = 0;
            if (p.y == _lines[0].p1.y) {
                i = 0;
            }
            else if (p.x == _lines[1].p1.x) {
                i = 1;
            }
            else if (p.y == _lines[2].p1.y) {
                i = 2;
            }
            else {
                i = 3;
            }
            while (d > 0) {
                var line:Line = _lines[i];
                d = line.follow(p, d, cw);
                if (d > 0) {
                    i = (i + (cw ? 1 : -1)) % _lines.length;
                    if (i < 0) {
                        i += _lines.length;
                    }
                }
            }
        }
    }
}