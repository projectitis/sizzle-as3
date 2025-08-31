package sizzle.geom {
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Point;
    import sizzle.geom.Shape;
    import sizzle.geom.Line;
    import sizzle.geom.Vector2d;
    import sizzle.utils.MathUtil;

    public class Circle extends Shape {

        private var _radius:Number;
        private var _radiusSquared:Number;

        /**
         * Create a new circle shape
         */
        public function Circle(radius:Number, parent:DisplayObject = null) {
            super(parent);
            this.radius = radius;
        }

        /**
         * Set the radius
         */
        public function set radius(value:Number):void {
            _radius = Math.abs(value);
            _radiusSquared = _radius * _radius;
        }

        /**
         * Get the radius
         */
        public function get radius():Number {
            return _radius;
        }

        /**
         * Check if a point is inside the circle.
         * @param p     A point in the local coordinates of the circle
         * @return true if the point lies within the circle
         */
        override public function contains(p:Point):Boolean {
            var r:Number = p.x * p.x + p.y * p.y;
            return r <= _radiusSquared;
        }

        /**
         * Return the closest point to the provided point that is on the
         * boundary of this circle.
         * @param p     A position in the circle local coordinate space
         * @return The point on the boundary closest to the provided point
         */
        override public function closest(p:Point):Point {
            var c:Point = p.clone();
            c.normalize(1);
            c.setTo(c.x * _radius, c.y * _radius);
            return c;
        }

        /**
         * Calculates the intersection point between a line and this shape.
         * @param line  A line to calculate the intersection from
         * @return The intersection point, or null if the line does not intersect
         */
        override public function intersection(l:Line):Vector2d {
            var A:Number = l.p2.y - l.p1.y;
            var B:Number = l.p1.x - l.p2.x;
            var C:Number = l.p2.x * l.p1.y - l.p1.x * l.p2.y;
            var a:Number = MathUtil.sq(A) + MathUtil.sq(B);
            var b:Number, c:Number;
            var bnz:Boolean = true;

            if (Math.abs(B) >= 0.00000000001) {
                b = 2 * (A * C);
                c = MathUtil.sq(C) - MathUtil.sq(B) * _radiusSquared;
            }
            else {
                b = 2 * B * C;
                c = MathUtil.sq(C) - MathUtil.sq(A) * _radiusSquared;
                bnz = false;
            }

            var d:Number = MathUtil.sq(b) - 4 * a * c; // discriminant
            if (d < 0) {
                return null;
            }

            function within(x:Number, y:Number):Boolean {
                var d1Sq:Number = MathUtil.sq(l.p2.x - l.p1.x) + MathUtil.sq(l.p2.y - l.p1.y);
                var d2Sq:Number = MathUtil.sq(x - l.p1.x) + MathUtil.sq(y - l.p1.y);
                var d3Sq:Number = MathUtil.sq(l.p2.x - x) + MathUtil.sq(l.p2.y - y);

                var delta:Number = d1Sq - d2Sq - d3Sq;
                var d2d3:Number = Math.sqrt(d2Sq * d3Sq);

                return Math.abs(delta - 2 * d2d3) < 0.0000001;
            }

            function fx(x:Number):Number {
                return -(A * x + C) / B;
            }

            function fy(y:Number):Number {
                return -(B * y + C) / A;
            }

            var x:Number, y:Number;
            var v:Vector2d;
            if (d == 0.0) {
                // line is tangent to circle, so just one intersect at most
                if (bnz) {
                    x = -b / (2 * a);
                    y = fx(x);
                    if (within(x, y)) {
                        v = new Vector2d(x, y);
                        v.setNormal(x, y);
                        return v;
                    }
                }
                else {
                    y = -b / (2 * a);
                    x = fy(y);
                    if (within(x, y)) {
                        v = new Vector2d(x, y);
                        v.setNormal(x, y);
                        return v;
                    }
                }
            }
            else {
                d = Math.sqrt(d);
                if (bnz) {
                    x = (-b + d) / (2 * a);
                    y = fx(x);
                    if (within(x, y)) {
                        v = new Vector2d(x, y);
                        v.setNormal(x, y);
                        return v;
                    }
                    x = (-b - d) / (2 * a);
                    y = fx(x);
                    if (within(x, y)) {
                        v = new Vector2d(x, y);
                        v.setNormal(x, y);
                        return v;
                    }
                }
                else {
                    y = (-b + d) / (2 * a);
                    x = fy(y);
                    if (within(x, y)) {
                        v = new Vector2d(x, y);
                        v.setNormal(x, y);
                        return v;
                    }
                    y = (-b - d) / (2 * a);
                    x = fy(y);
                    if (within(x, y)) {
                        v = new Vector2d(x, y);
                        v.setNormal(x, y);
                        return v;
                    }
                }
            }

            return null;
        }

        /**
         * Draw the circle on the provided canvas.
         * @param canvas The graphics context to draw on
         */
        override public function draw(canvas:Graphics = null):void {
            if (!canvas) {
                if (parent && (parent is Sprite)) {
                    canvas = (parent as Sprite).graphics;
                }
                else {
                    return;
                }
            }
            canvas.drawCircle(0, 0, _radius);
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
            p.copyFrom(closest(p));
            var angle:Number = Math.atan2(p.y, p.x);
            var angleStep:Number = d / _radius; // angle in radians to move
            angle += (cw ? angleStep : -angleStep);
            p.x = Math.cos(angle) * _radius;
            p.y = Math.sin(angle) * _radius;
        }
    }
}