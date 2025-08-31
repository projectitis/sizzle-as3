package sizzle.geom {
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.Graphics;
    import flash.display.DisplayObject;

    import sizzle.geom.Line;
    import sizzle.geom.Segment;
    import sizzle.geom.Position;
    import sizzle.utils.MathUtil;

    public class Line extends Segment {
        /**
         * The start position of the line segment
         */
        public var p1:Point = new Point();

        /**
         * The end position of the line segment
         */
        public var p2:Point = new Point();

        /**
         * Whether the line is active or not.
         * If false, the line will not be considered for intersection tests.
         */
        public var active:Boolean = true;

        private var _normal:Number = 0;
        private var _dx:Number = 0;
        private var _dy:Number = 0;
        private var _length:Number = 0;
        private var _invLength:Number = 0;
        // private var _ndx:Number = 0;
        // private var _ndy:Number = 0;

        /**
         * Create a new line
         * @param p1    Starting point
         * @param p2    End point
         */
        public function Line(p1:Point = null, p2:Point = null) {
            if (p1 != null) {
                this.p1.setTo(p1.x, p1.y);
            }
            if (p2 != null) {
                this.p2.setTo(p2.x, p2.y);
            }
            update();
        }

        /**
         * Set coordinates of line segment ends
         * @param x1    X position of start
         * @param y1    Y position of start
         * @param x2    X position of end
         * @param y2    Y position of end
         */
        public function setTo(x1:Number, y1:Number, x2:Number, y2:Number):void {
            this.p1.setTo(x1, y1);
            this.p2.setTo(x2, y2);
            update();
        }

        /**
         * Copy the values from another line.
         * @param line The line to copy from
         */
        public function copyFrom(line:Line):void {
            this.p1.copyFrom(line.p1);
            this.p2.copyFrom(line.p2);
            update();
        }

        /**
         * Clone the line and return a copy
         * @return a clone of the line
         */
        public function clone():Line {
            return new Line(p1, p2);
        }

        /**
         * Convert the line segment to local coordinates.
         * @param local    The local space to convert to.
         */
        override public function globalToLocal(local:DisplayObject):void {
            if (local) {
                p1 = local.globalToLocal(p1);
                p2 = local.globalToLocal(p2);
                update();
            }
        }

        /**
         * Convert the line segment to global coordinates.
         * @param local    The local space to convert from.
         */
        override public function localToGlobal(local:DisplayObject):void {
            if (local) {
                p1 = local.localToGlobal(p1);
                p2 = local.localToGlobal(p2);
                update();
            }
        }

        /**
         * Calculate the length and the normal (always "clockwise" from p1 to p2)
         */
        public function update():void {
            bounds.setTo(
                    Math.min(p1.x, p2.x),
                    Math.min(p1.y, p2.y),
                    Math.max(p1.x, p2.x),
                    Math.max(p1.y, p2.y)
                );
            bounds.width -= bounds.x;
            bounds.height -= bounds.y;
            if (bounds.width == 0 && bounds.height != 0) {
                bounds.width = 0.5;
            }
            else if (bounds.height == 0 && bounds.width != 0) {
                bounds.height = 0.5;
            }
            _dx = p2.x - p1.x;
            _dy = p2.y - p1.y;
            _length = Math.sqrt(_dx * _dx + _dy * _dy);
            _invLength = _length > 0 ? 1 / _length : 0;
            _normal = MathUtil.radToDeg(Math.atan2(_dy, -_dx)) - 90;
            // _ndx = _dx * _invLength;
            // _ndy = _dy * _invLength;
        }

        /**
         * Calculates the intersection point between this line and another.
         * @param line  A line to calculate the intersection from
         * @param outPoint   (out) If provided will be populated with the intersection point, in local space.
         * @return The intersection point, or null if the lines do not intersect
         */
        override public function intersection(line:Line, outPoint:Point = null):Position {
            var x12:Number = -_dx;
            var x34:Number = line.p1.x - line.p2.x;
            var y12:Number = -_dy;
            var y34:Number = line.p1.y - line.p2.y;

            var c:Number = x12 * y34 - y12 * x34;

            if (Math.abs(c) < 0.00000001) {
                // Lines are parallel
                return null;
            }

            // Calculate intersection point
            var a:Number = p1.x * p2.y - p1.y * p2.x;
            var b:Number = line.p1.x * line.p2.y - line.p1.y * line.p2.x;

            var x:Number = (a * x34 - b * x12) / c;
            var y:Number = (a * y34 - b * y12) / c;

            // Check if intersection point lies on both line segments
            if (!_isWithinBounds(x, y, p1, p2) || !_isWithinBounds(x, y, line.p1, line.p2)) {
                return null;
            }

            if (outPoint) {
                outPoint.setTo(x, y);
            }
            return new Position(null, this, Math.abs(p1.x + x) / _dx, _normal);
        }

        private function _isWithinBounds(x:Number, y:Number, p1:Point, p2:Point):Boolean {
            // Check if point lies within the bounding box of the line segment
            if (x < Math.min(p1.x, p2.x) - 0.00000001 || x > Math.max(p1.x, p2.x) + 0.00000001 ||
                    y < Math.min(p1.y, p2.y) - 0.00000001 || y > Math.max(p1.y, p2.y) + 0.00000001) {
                return false;
            }
            return true;
        }

        /**
         * Check if another line intersects with this one
         * @param line      The other line
         * @return True if the lines intersect, false otherwise
         *
         public function intersects(line:Line):Boolean {
         return !MathUtil.sameSign(
         (_dx) * (line.p1.y - p2.y) - (_dy) * (line.p1.x - p2.x),
         (_dx) * (line.p2.y - p2.y) - (_dy) * (line.p2.x - p2.x)
         ) &&
         !MathUtil.sameSign(
         (line.p2.x - line.p1.x) * (p1.y - line.p2.y) - (line.p2.y - line.p1.y) * (p1.x - line.p2.x),
         (line.p2.x - line.p1.x) * (p2.y - line.p2.y) - (line.p2.y - line.p1.y) * (p2.x - line.p2.x)
         );
         }
         
         /**
         * Check if the line has the point on it
         * @param p   The point to check
         * @return True if the point is on the line, false otherwise
         *
         public function has(p:Point):Boolean {
         // Check if point is on the line segment
         var crossProduct:Number = (p.y - p1.y) * _dx - (p.x - p1.x) * _dy;
         if (Math.abs(crossProduct) > MathUtil.epsilon) {
         return false; // Not collinear
         }
         
         // Check if point is within the bounds of the line segment
         var dotProduct:Number = (p.x - p1.x) * _ndx + (p.y - p1.y) * _ndy;
         return dotProduct >= 0 && dotProduct <= _length;
         }
         
         /**
         * Return the closest point on the line to the provided point.
         * @param p   A point to check
         * @return The point on the boundary closest to the provided point
         *
         public function closest(p:Point):Point {
         // Length squared of segment
         var lenSq:Number = _dx * _dx + _dy * _dy;
         
         // If segment is just a point, return p1
         if (lenSq == 0)
         return p1.clone();
         
         // Calculate projection parameter t
         var t:Number = ((p.x - p1.x) * _dx + (p.y - p1.y) * _dy) / lenSq;
         
         // Clamp t to segment bounds
         t = MathUtil.clamp(t, 0, 1);
         
         // Return interpolated point
         return new Point(
         p1.x + t * _dx,
         p1.y + t * _dy
         );
         }*/

        /**
         * From a given point on the segment, follow the segment a certain distance.
         * @param pos        The point on the line to start from. Will be populated with the new position.
         * @param distance   The distance to follow the line. If +ve, will go clockwise, otherwise anticlockwise
         * @param outPoint   (Output) The point, local to the segment, of the position
         * @return If the end of the line was reached, the distance remaining. Otherwise 0.
         **/
        override public function follow(pos:Position, distance:Number, outPoint:Point = null):Number {
            if (_length == 0 || pos.segment != this) {
                return distance;
            }

            // Calculate the new distance
            var d:Number = pos.position + distance * _invLength;
            if (d < 0) {
                pos.position = 0;
                distance = -d * _length;
            }
            else if (d > 1) {
                pos.position = 1;
                distance = (d - 1) * _length;
            }
            else {
                pos.position = d;
                distance = 0;
            }
            if (outPoint) {
                outPoint.setTo(p1.x + _dx * pos.position, p1.y + _dy * pos.position);
            }
            pos.normal = _normal;
            return distance;
        }

        /**
         * Get the point at a certain position along the segment.
         * @param position     The position along the segment, from 0 to 1 (clamped)
         * @param outPoint     The point to populate with the position on the segment. If null, a new Point will be created.
         * @return The point at that position
         */
        override public function pointAtPosition(position:Number, outPoint:Point = null):Point {
            position = MathUtil.clamp(position, 0, 1);
            if (outPoint == null) {
                outPoint = new Point();
            }
            outPoint.setTo(p1.x + position * _dx, p1.y + position * _dy);
            return outPoint;
        }

        /**
         * Draw the segment to the canvas.
         * @param canvas The canvas to draw to
         */
        override public function draw(canvas:Graphics):void {
            canvas.moveTo(p1.x, p1.y);
            canvas.lineTo(p2.x, p2.y);
        }

        /**
         * Return a string representation of the line
         * @return A string describing the line
         */
        override public function toString():String {
            return "Line(" + p1.x + ", " + p1.y + " -> " + p2.x + ", " + p2.y + ")";
        }
    }
}