package sizzle.geom {

    import flash.display.DisplayObject;
    import flash.geom.Point;

    import sizzle.geom.Line;
    import sizzle.geom.Position;
    import sizzle.geom.Path;

    /**
     * Collection of paths
     */
    public class Paths {
        public var paths:Vector.<Path> = new Vector.<Path>();

        public var parent:DisplayObject;

        /**
         * Create a new Paths object
         * @param parent The display object that this paths transform relates to
         */
        public function Paths(parent:DisplayObject) {
            this.parent = parent;
        }

        /**
         * Calculates the intersection point between a line and the paths. Returns the
         * closest intersection position.
         * @param line     A line to calculate the intersection with. Line is in same space as parent.
         * @param outPoint (out) If provided, will be populated by the intersection point in Paths.parent space.
         * @return The position object, or null if the lines do not intersect
         */
        public function intersection(line:Line, outPoint:Point = null):Position {
            if (paths.length == 0) {
                return null;
            }
            var globalLine:Line = line.clone();
            globalLine.localToGlobal(parent);
            var pos:Position = new Position();
            var hasPos:Boolean = false;
            for each (var path:Path in paths) {
                if (!path.active) {
                    continue;
                }
                var ln:Line = globalLine.clone();
                ln.globalToLocal(path.parent);
                var pt:Point = new Point();
                var p:Position = path.intersection(ln, pt);
                if (p != null) {
                    ln.p2 = parent.globalToLocal(path.parent.localToGlobal(pt));
                    if (outPoint) {
                        outPoint.copyFrom(ln.p2);
                    }
                    pos.copyFrom(p);
                    pos.normal = (p.normal - path.parent.rotation) % 360;
                    hasPos = true;
                }
            }
            return hasPos ? pos : null;
        }

        /**
         * From a given point on a path, follow the path a certain distance.
         * @param pos        The point on the line to start from. Will be populated with the new position.
         * @param distance   The distance to follow the line. If +ve, will go clockwise, otherwise anticlockwise
         * @return If the end of the line was reached, the distance remaining. Otherwise 0.
         **/
        public function follow(pos:Position, distance:Number, outPoint:Point = null):Number {
            if (pos.path) {
                distance = pos.path.follow(pos, distance, outPoint);
                if (outPoint) {
                    outPoint.copyFrom(parent.globalToLocal(pos.path.parent.localToGlobal(outPoint)));
                }
            }
            return distance;
        }

        /**
         * String representation of the Paths object
         */
        public function toString():String {
            var result:String = "Paths: ";
            for each (var path:Path in paths) {
                result += path.toString() + "\n";
            }
            return result;
        }

    }
}