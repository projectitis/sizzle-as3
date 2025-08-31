package sizzle.geom {
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import sizzle.geom.Chain;
    import sizzle.geom.Line;
    import sizzle.geom.Vector2d;
    import sizzle.utils.MathUtil;

    public class Polygon extends Chain {

        /**
         * Create a new closed polygon shape
         * @param path      The coordinates, in x,y pairs, that make up the polygon path.
         *                  Must be clockwise. The shape will be closed.
         * @param parent    The display object that this shape represents
         */
        public function Polygon(path:Array, parent:DisplayObject = null) {
            super(path, parent);
        }

        /**
         * Recalculate the lines that represent the edges of the polygon.
         */
        override public function changed():void {
            if (!path[0].equals(path[path.length - 1])) {
                path.push(new Point(path[0].x, path[0].y));
            }
            super.changed();
        }

        /**
         * Check if a point is inside the polygon. This is true if the point in on the right hand side of every line.
         * @param p     A point in the local coordinates of the rect
         * @return true if the point lies within the polygon
         */
        override public function contains(p:Point):Boolean {
            if (_lines.length == 0) {
                return false;
            }
            if (!_bounds.contains(p.x, p.y)) {
                return false;
            }
            // Cast a ray from outside the polygon to the point and count how many sides it intersects
            var ray:Line = new Line(new Point(_bounds.x - 1, _bounds.y + _bounds.height * 0.5), p);
            var c:int = 0;
            for each (var l:Line in _lines) {
                if (l.intersects(ray)) {
                    c++;
                }
            }
            // If it's odd, it's inside the polygon
            return (c & 1) == 1;
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
            var index:int = _closestLineIndex;
            while (d > 0) {
                var line:Line = _lines[index];
                d = line.follow(p, d, cw);
                trace("  line", "distance remaining:", d, "new point:", p);
                if (d > 0) {
                    index = (index + (cw ? 1 : -1)) % _lines.length;
                    if (index < 0) {
                        index += _lines.length;
                    }
                }
            }
        }
    }
}