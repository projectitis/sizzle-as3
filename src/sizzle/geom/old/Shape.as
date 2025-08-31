package sizzle.geom {

    import flash.geom.Point;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import sizzle.geom.Line;
    import sizzle.geom.Vector2d;

    /**
     * A shape is a collider that represents the outline of a visible object (but is
     * not visible itself). Shapes are invisible but each usually tied to an object in the
     * world. For example, in the world there could be a large complex building (image, graphic
     * etc - some sort of display object). However, for player interaction it would be represented
     * by a rectangle shape of the same size. This means collisions with the graphic are
     * simplified by testing for collisions with the Shape instead.
     *
     * The parent display object transformation is applied to the shape.
     */
    public class Shape {
        /**
         * The parent (visible on the stage) that corresponds to this shape
         */
        public var parent:DisplayObject = null;

        /**
         * Whether this shape is active or not
         */
        public var active:Boolean = true;

        /**
         * Create a new shape
         */
        public function Shape(parent:DisplayObject = null) {
            this.parent = parent;
        }

        /**
         * Check if the shape contains a given point.
         * @param p The point, in the same coordinate space as the shape
         * @return true if the point is inside the shape, false otherwise
         */
        virtual public function contains(p:Point):Boolean {
            return false;
        }

        /**
         * Return the closest point to the provided point that is on the
         * boundary of this shape.
         * @param localPos  A position in the rectangles local coordinate space
         * @return The point on the boundary closest to the provided point
         */
        virtual public function closest(p:Point):Point {
            return null;
        }

        /**
         * Calculates the intersection point between a line and this shape.
         * @param line      A line to calculate the intersection from
         * @param normal    (out) If not null, will be populated by the normal at the intersection point
         * @return The intersection point, or null if the line does not intersect
         */
        virtual public function intersection(l:Line):Vector2d {
            return null;
        }

        /**
         * Calculates a new point on the shape boundary that is obtained by starting
         * from the specified point and moving a set distance in either the clockwise
         * or anti-clockwise direction.
         * @param p     The point to start from. Point will be modified to the new position.
         * @param d     The distance to move (local coordinate space)
         * @param cw       If true, move clockwise, otherwise move anti-clockwise
         */
        virtual public function follow(p:Point, d:Number, cw:Boolean = true):void {
        }

        /**
         * Draw the shape path to the canvas. WIll draw to the parent object if no canvas
         * is supplied.
         * @param canvas        The canvas to draw to. If null, will draw to the parent.
         */
        virtual public function draw(canvas:Graphics = null):void {
        }
    }
}