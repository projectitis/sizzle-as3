package sizzle.geom {
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import sizzle.geom.Shape;
    import sizzle.geom.Line;
    import sizzle.geom.Vector2d;
    import sizzle.utils.MathUtil;

    /**
     * A chain is a series of connected lines, which can be used to represent paths or shapes.
     * It is similar to a polygon but does not require the last point to connect back to the first.
     */
    public class Chain extends Shape {

        public var path:Vector.<Point> = new Vector.<Point>();
        protected var _lines:Vector.<Line> = new Vector.<Line>();
        protected var _bounds:flash.geom.Rectangle = new flash.geom.Rectangle();
        protected var _closestLineIndex:int = -1;

        /**
         * Create a new chain shape
         * @param path      The coordinates, in x,y pairs, that make up the chain path.
         *                  Must be clockwise. The shape will be closed.
         * @param parent    The display object that this shape represents
         */
        public function Chain(path:Array, parent:DisplayObject = null) {
            super(parent);
            for (var i:int = 0; i < path.length; i += 2) {
                this.path.push(new Point(path[i], path[i + 1]));
            }
            changed();
        }

        /**
         * Recalculate the lines that represent the edges of the chain.
         */
        public function changed():void {
            _lines.length = 0;
            if (path.length > 1) {
                _bounds.setTo(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY);
                for (var i:int = 1; i < path.length; i++) {
                    _lines.push(new Line(path[i - 1], path[i]));
                    _bounds.x = Math.min(_bounds.x, path[i - 1].x);
                    _bounds.y = Math.min(_bounds.y, path[i - 1].y);
                    _bounds.width = Math.max(_bounds.width, path[i - 1].x);
                    _bounds.height = Math.max(_bounds.height, path[i - 1].y);
                }
                _bounds.width -= _bounds.x;
                _bounds.height -= _bounds.y;
            }
            else {
                _bounds.setTo(0, 0, 0, 0);
            }
        }

        /**
         * Check if a point is on the chain
         * @param p     A point in the local coordinates of the shape
         * @return true if the point lies within the chain
         */
        override public function contains(p:Point):Boolean {
            if (_lines.length == 0) {
                return false;
            }
            if (!_bounds.contains(p.x, p.y)) {
                return false;
            }
            // Check each line to see if point is on that line
            var c:int = 0;
            for each (var l:Line in _lines) {
                if (l.has(p)) {
                    return true;
                }
            }
            return false;
        }

        /**
         * Return the closest point to the provided point that is on
         * the boundary of this shape.
         * @param p     A position in the rectangles local coordinate space
         * @return The point on the boundary closest to the provided point
         */
        override public function closest(p:Point):Point {
            _closestLineIndex = -1;
            var cd:Number = Number.POSITIVE_INFINITY;
            var cp:Point = p.clone();
            for (var i:int = 0; i < _lines.length; i++) {
                var l:Line = _lines[i];
                var lp:Point = l.closest(p);
                var d:Number = MathUtil.distanceSq(lp, p);
                if (d < cd) {
                    cd = d;
                    cp = lp;
                    _closestLineIndex = i;
                }
            }
            return cp;
        }

        /**
         * Return the intersection point between a line segment and the shape.
         * If there are more than one intersection, the closest to the start
         * of the line is returned (the line is a raycast from start to end).
         * @param l         A line segment
         * @param normal    (out) If not null, will be populated by the normal at the intersection point
         * @return The point where the line segment intersects, or null
         */
        override public function intersection(line:Line):Vector2d {
            var cd:Number = Number.POSITIVE_INFINITY;
            var cp:Vector2d = new Vector2d();
            for each (var l:Line in _lines) {
                var lp:Point = l.intersection(line);
                if (lp) {
                    var d:Number = MathUtil.distanceSq(lp, cp);
                    if (d < cd) {
                        cd = d;
                        cp.setFrom(lp, l.normal.angle);
                    }
                }
            }
            if (cd == Number.POSITIVE_INFINITY) {
                return null;
            }
            return cp;
        }

        /**
         * Draw the shape path to the canvas. WIll draw to the parent object if no canvas
         * is supplied.
         * @param canvas        The canvas to draw to. If null, will draw to the parent.
         */
        override public function draw(canvas:Graphics = null):void {
            if (path.length == 0) {
                return;
            }
            if (!canvas) {
                if (parent is Sprite) {
                    canvas = (parent as Sprite).graphics;
                }
                else {
                    return;
                }
            }
            canvas.moveTo(path[0].x, path[0].y);
            for (var i:int = 1; i < path.length; i++) {
                canvas.lineTo(path[i].x, path[i].y);
            }
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
                if (d > 0) {
                    if (cw) {
                        index += 1;
                        if (index >= _lines.length) {
                            d = 0;
                        }
                    }
                    else {
                        index -= 1;
                        if (index < 0) {
                            d = 0;
                        }
                    }
                }
            }
        }
    }
}