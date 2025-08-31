package sizzle.geom {
    import flash.geom.Point;
    import sizzle.utils.MathUtil;
    import sizzle.geom.Vector2d;

    /**
     * Represents a position along a line segment, defined by a line and a position value.
     * The position is a normalized value between 0 and 1, where 0 is the start of the line
     * and 1 is the end of the line.
     */
    public class LinePosition {
        public var line:Line;
        private var _position:Number;

        public function LinePosition(line:Line, position:Number) {
            this.line = line;
            this.position = position;
        }

        /**
         * Set the position along the line segment.
         * @param value A normalized value between 0 and 1.
         */
        public function set position(value:Number):void {
            _position = MathUtil.clamp(value, 0, 1);
        }

        /**
         * Get the position along the line segment.
         * @return A normalized value between 0 and 1.
         */
        public function get position():Number {
            return _position;
        }

        /**
         * Get the point at the specified position along the line.
         * @return A Point representing the position on the line.
         */
        public function getPoint():Point {
            var x:Number = line.p1.x + (line.p2.x - line.p1.x) * position;
            var y:Number = line.p1.y + (line.p2.y - line.p1.y) * position;
            return new Point(x, y);
        }

        /**
         * Copy the position to a Point object.
         * @param p The Point object to copy the position into.
         */
        public function copyTo(p:Point):void {
            var x:Number = line.p1.x + (line.p2.x - line.p1.x) * position;
            var y:Number = line.p1.y + (line.p2.y - line.p1.y) * position;
            p.setTo(x, y);
        }
    }