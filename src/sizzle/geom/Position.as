package sizzle.geom {
    import flash.geom.Point;

    import sizzle.geom.Path;
    import sizzle.geom.Segment;
    import sizzle.utils.MathUtil;

    /**
     * Represents a position along a segment on a particular path.
     * The position is a normalized value between 0 and 1, where 0 is the start of the line
     * and 1 is the end of the line.
     */
    public class Position {
        public var path:Path;
        public var segment:Segment;
        private var _position:Number;
        public var normal:Number = 0; // Angle of the normal at this position

        public function Position(path:Path = null, segment:Segment = null, position:Number = 0, normal:Number = 0) {
            this.path = path;
            this.segment = segment;
            this.position = position;
            this.normal = normal;
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
         * Set the point at the specified position along the line.
         */
        public function point(outPoint:Point = null):Point {
            if (outPoint == null) {
                outPoint = new Point();
            }
            segment.pointAtPosition(_position, outPoint);
            return outPoint;
        }

        /**
         * Copy the values from another Position.
         * @param other The Position to copy from
         */
        public function copyFrom(other:Position):void {
            this.segment = other.segment;
            this.position = other.position;
            this.normal = other.normal;
        }

        /**
         * Get a string representation of the Position.
         * @return A string describing the segment and position.
         */
        public function toString():String {
            return "[Position segment=" + segment + ", position=" + _position + ", normal=" + normal + "]";
        }
    }
}