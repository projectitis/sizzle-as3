package sizzle.geom {
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.Graphics;
    import flash.display.DisplayObject;

    import sizzle.geom.Line;
    import sizzle.geom.Position;

    /**
     * Virtual base class for any path segment
     */
    public class Segment {
        /**
         * The bounding rectangle of this segment.
         * This is used for fast intersection tests.
         */
        public var bounds:Rectangle = new Rectangle();

        /**
         * Calculates the intersection point between this segment and a line.
         * @param line       A line to calculate the intersection from
         * @param outPoint   (out) If provided will be populated with the intersection point, in local space.
         * @return The intersection position, or null if the lines do not intersect
         */
        virtual public function intersection(line:Line, outPoint:Point = null):Position {
            return null;
        }

        /**
         * Get the point at a certain position along the segment.
         * @param position     The position along the segment, from 0 to 1 (clamped)
         * @param outPoint     The point to populate with the position on the segment. If null, a new Point will be created.
         * @return The point at that position
         */
        virtual public function pointAtPosition(position:Number, outPoint:Point = null):Point {
            return null;
        }

        /**
         * Return the closest position on the segment to the provided point.
         * @param p   A point to check
         * @return The position on the boundary closest to the provided point
         *
         virtual public function closest(p:Point):Position {
         return null;
         }
         */

        /**
         * From a given point on the segment, follow the segment a certain distance.
         * @param pos        The point on the line to start from. Will be populated with the new position.
         * @param distance   The distance to follow the line. If +ve, will go clockwise, otherwise anticlockwise.
         * @param outPoint   (out) If provided will be populated with the coordinates, in local space.
         * @return If the end of the line was reached, the distance remaining. Otherwise 0.
         **/
        virtual public function follow(pos:Position, distance:Number, outPoint:Point = null):Number {
            return 0;
        }

        /**
         * Convert the line segment to local coordinates.
         * @param local    The local space to convert to.
         */
        virtual public function globalToLocal(local:DisplayObject):void {
        }

        /**
         * Convert the line segment to global coordinates.
         * @param local    The local space to convert from.
         */
        virtual public function localToGlobal(local:DisplayObject):void {
        }

        /**
         * Draw the segment to the canvas.
         * @param canvas The canvas to draw to.
         */
        virtual public function draw(canvas:Graphics):void {
        }

        /**
         * Return a string representation of the segment
         */
        virtual public function toString():String {
            return "Segment";
        }

    }
}