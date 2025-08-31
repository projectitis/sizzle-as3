package sizzle.geom {
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import sizzle.geom.Shape;
    import sizzle.geom.Line;
    import sizzle.geom.Vector2d;
    import sizzle.utils.Log;
    import sizzle.utils.MathUtil;

    public class ShapeSet {
        private var _shapes:Vector.<Shape> = new Vector.<Shape>();
        public var parent:DisplayObject;
        private var _closestShapeIndex:int = -1;

        public function ShapeSet(parent:DisplayObject) {
            this.parent = parent;
        }

        /**
         * Add a shape to the set.
         * @param shape The shape to add
         */
        public function add(shape:Shape):void {
            _shapes.push(shape);
        }

        /**
         * Remove a shape from the set.
         * @param shape The shape to remove
         */
        public function remove(shape:Shape):void {
            var i:int = _shapes.indexOf(shape);
            if (i >= 0) {
                _shapes.splice(i, 1);
            }
        }

        /**
         * Check if a point is contained within any active shape in the set.
         * @param p The point to check
         * @return true if the point is contained within any shape
         */
        public function contains(p:Point):Boolean {
            for (var i:int = 0; i < _shapes.length; i++) {
                if (_shapes[i].active && _shapes[i].contains(_parentToLocal(p, _shapes[i].parent))) {
                    return true;
                }
            }
            return false;
        }

        /**
         * Return a list of active shapes that contain the point.
         * @param p The point to check
         * @return A vector of shapes that contain the point
         */
        public function contained(p:Point):Vector.<Shape> {
            var containedShapes:Vector.<Shape> = new Vector.<Shape>();
            for (var i:int = 0; i < _shapes.length; i++) {
                if (_shapes[i].active && _shapes[i].contains(_parentToLocal(p, _shapes[i].parent))) {
                    containedShapes.push(_shapes[i]);
                }
            }
            return containedShapes;
        }

        /**
         * Find the closest point on any active shape in the set to a given point.
         * @param p The point to find the closest shape to
         * @return The closest point on the shape, or null if no shapes are active
         */
        public function closest(p:Point):Point {
            _closestShapeIndex = -1;
            var closestPoint:Point = null;
            var closestDistance:Number = Number.POSITIVE_INFINITY;
            for (var i:int = 0; i < _shapes.length; i++) {
                if (_shapes[i].active) {
                    var localPoint:Point = _parentToLocal(p, _shapes[i].parent);
                    var cp:Point = _shapes[i].closest(localPoint);
                    if (cp) {
                        var distance:Number = Point.distance(localPoint, cp);
                        if (distance < closestDistance) {
                            closestDistance = distance;
                            _closestShapeIndex = i;
                            closestPoint = cp;
                        }
                    }
                }
            }
            if (_closestShapeIndex >= 0) {
                return _localToParent(closestPoint, _shapes[_closestShapeIndex].parent);
            }
            return null;
        }

        /**
         * Return the intersection point between a line segment and active shapes
         * in the set. If there are more than one intersection, the closest to the
         * start of the line is returned (the line is a raycast from start to
         * end).
         * @param l         A line segment
         * @param normal    (out) If not null, will be populated by the normal
         *                  at the intersection point
         * @return The point where the line segment intersects, or null
         */
        public function intersection(l:Line):Vector2d {
            if (_shapes.length == 0) {
                return null;
            }
            var line:Line = l.clone();
            var shape:Shape;
            var v:Vector2d = new Vector2d();
            var n:Point = new Point();
            var hasPoint:Boolean = false;
            for (var j:int = 0; j < _shapes.length; j++) {
                shape = _shapes[j];
                if (!shape.active) {
                    continue;
                }
                line = _lineParentToLocal(line, shape.parent);
                var i:Vector2d = shape.intersection(line);
                if (i != null) {
                    line.p2.copyFrom(i);
                    line = _lineLocalToParent(line, shape.parent);
                    v.setFrom(line.p2, i.angle);
                    v.rotate(shape.parent.rotation);
                    hasPoint = true;
                }
                else {
                    line = _lineLocalToParent(line, shape.parent);
                }
            }
            return hasPoint ? v : null;
        }

        private function _parentToLocal(p:Point, object:DisplayObject):Point {
            return object.globalToLocal(parent.localToGlobal(p));
        }

        private function _localToParent(p:Point, object:DisplayObject):Point {
            return parent.globalToLocal(object.localToGlobal(p));
        }

        private function _lineParentToLocal(line:Line, object:DisplayObject):Line {
            return new Line(
                    _parentToLocal(line.p1, object),
                    _parentToLocal(line.p2, object)
                );
        }

        private function _lineLocalToParent(line:Line, object:DisplayObject):Line {
            return new Line(
                    _localToParent(line.p1, object),
                    _localToParent(line.p2, object)
                );
        }

        /**
         * Calculates a new point on the shape boundary that is obtained by starting
         * from the specified point and moving a set distance in either the clockwise
         * or anti-clockwise direction. Will follow the outside edge of all active shapes
         * in the set.
         * @param p     The point to start from. Closest point on a shape will be used.
         *              Will be populated with the new point.
         * @param d     The distance to move (local coordinate space)
         * @param cw    If true, move clockwise, otherwise move anti-clockwise
         */
        public function follow(p:Point, d:Number, cw:Boolean = true):void {
            // Find the closest shape to the point
            closest(p);
            if (_closestShapeIndex < 0) {
                return;
            }

            // The problem is that the closest point could be within another
            // shape if they overlap. Do we now call "contained" and check this? That
            // is a pretty big overhead for every step along a path.

            // Instead of allowing shapes to overlap, there must be a better way to
            // join shapes together deliberately so that a path along multiple shapes
            // could be followed?

            // One way could be to only support chains (no other shapes), but that chains
            // can contain curves as well as straight lines. Those lines could be activated
            // and deactivated individually so that not all of them were active at once and did
            // not need to be continually checked when following (or other operations).

            // To prevent "closest" being invoked all the time, follow should return a
            // LinePosition, which would allow subsequent follows without calculations again.

            // Next steps:
            // - Create a "Curve" class, or add these features to "Line"
            // - Create a Path class to replace Chain
            // - Retire all shape classes
            // - ShapeSet to become Paths
        }

    }
}