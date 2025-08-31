package sizzle.geom {
    import flash.geom.Point;
    import sizzle.geom.Line;

    public class Curve extends Line {
        private var _c1:Point;
        private var _c2:Point;

        /**
         * Create a new curve segment (cubic bezier)
         * @param start Starting point of the curve
         * @param control1 First control point
         * @param control2 Second control point
         * @param end End point of the curve
         */
        public function Curve(start:Point, control1:Point, control2:Point, end:Point) {
            this._c1 = control1;
            this._c2 = control2;
            super(start, end);
        }

        public function update():void {
            super.update();
            _calculateBounds();
        }

        // vec2 p0, vec2 p1, vec2 p2, vec2 p3
        private function _calculateBounds():void {
            var mi:Point = new Point(bounds.x, bounds.y);
            var ma:Point = new Point(bounds.x + bounds.width, bounds.y + bounds.height);

            var c:Point = new Point(-1.0 * p0.x + 1.0 * p1.x, -1.0 * p0.y + 1.0 * p1.y);
            var b:Point = new Point(1.0 * p0.x - 2.0 * p1.x + 1.0 * p2.x, 1.0 * p0.y - 2.0 * p1.y + 1.0 * p2.y);
            var a:Point = new Point(-1.0 * p0.x + 3.0 * p1.x - 3.0 * p2.x + 1.0 * p3.x, -1.0 * p0.y + 3.0 * p1.y - 3.0 * p2.y + 1.0 * p3.y);

            var h:Point = new Point(b.x * b.x - a.x * c.x, b.y * b.y - a.y * c.y);

            var t:Number;
            var s:Number;
            var q:Number;
            if (h.x > 0.0) {
                h.x = Math.sqrt(h.x);
                t = (-b.x - h.x) / a.x;
                if (t > 0.0 && t < 1.0) {
                    s = 1.0 - t;
                    q = s * s * s * p0.x + 3.0 * s * s * t * p1.x + 3.0 * s * t * t * p2.x + t * t * t * p3.x;
                    mi.x = Math.min(mi.x, q);
                    ma.x = Math.max(ma.x, q);
                }
                t = (-b.x + h.x) / a.x;
                if (t > 0.0 && t < 1.0) {
                    s = 1.0 - t;
                    q = s * s * s * p0.x + 3.0 * s * s * t * p1.x + 3.0 * s * t * t * p2.x + t * t * t * p3.x;
                    mi.x = Math.min(mi.x, q);
                    ma.x = Math.max(ma.x, q);
                }
            }

            if (h.y > 0.0) {
                h.y = Math.sqrt(h.y);
                t = (-b.y - h.y) / a.y;
                if (t > 0.0 && t < 1.0) {
                    s = 1.0 - t;
                    q = s * s * s * p0.y + 3.0 * s * s * t * p1.y + 3.0 * s * t * t * p2.y + t * t * t * p3.y;
                    mi.y = Math.min(mi.y, q);
                    ma.y = Math.max(ma.y, q);
                }
                t = (-b.y + h.y) / a.y;
                if (t > 0.0 && t < 1.0) {
                    s = 1.0 - t;
                    q = s * s * s * p0.y + 3.0 * s * s * t * p1.y + 3.0 * s * t * t * p2.y + t * t * t * p3.y;
                    mi.y = Math.min(mi.y, q);
                    ma.y = Math.max(ma.y, q);
                }
            }
            bounds.setFrom(mi.x, mi.y, ma.x - mi.x, ma.y - mi.y);
        }

        /**
         * Calculates the intersection point between this curve and a line.
         * @param line  A line to calculate the intersection from
         * @return The intersection point, or null if the lines do not intersect
         */
        override public function intersection(line:Line):SegmentPosition {

            return null;
        }

        /**
         * Get the point at a certain position along the segment.
         * @param p     The position along the segment, from 0 to 1
         * @return The point at that position, or null if not on the segment
         */
        override public function getPointAtPosition(p:Number):Point {
            return null;
        }

        /**
         * From a given point on the segment, follow the segment a certain distance.
         * @param pos        The point on the line to start from. Will be populated with the new position.
         * @param distance   The distance to follow the line. If +ve, will go clockwise, otherwise anticlockwise
         * @return If the end of the line was reached, the distance remaining. Otherwise 0.
         **/
        override public function follow(pos:SegmentPosition, distance:Number):Number {
            return 0;
        }

    }
}