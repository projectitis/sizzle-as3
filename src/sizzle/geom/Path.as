package sizzle.geom {
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.display.GraphicsPathCommand;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    import sizzle.geom.Line;
    import sizzle.geom.Segment;
    import sizzle.geom.Position;
    import sizzle.utils.MathUtil;

    public class Path {
        /**
         * Line segment type
         */
        public static const LINE_TO:int = 0;

        /**
         * Arc segment type - not yet implemented
         */
        public static const ARC_TO:int = 1;

        /**
         * The segments that make up the path.
         * Each segment is a Line or Arc object.
         */
        public var segments:Vector.<Segment> = new Vector.<Segment>();

        /**
         * Indicates whether the path is joined back to the start point.
         */
        private var _joined:Boolean = false;

        /**
         * The display object that this path transform relates to.
         * This is used for rendering and transformations.
         */
        public var parent:DisplayObject;

        /**
         * The bounding rectangle of the path.
         * This is used for fast intersection tests.
         */
        public var bounds:Rectangle = new Rectangle();

        /**
         * Whether the path is active or not.
         * If false, the path will not be considered for intersection tests.
         */
        public var active:Boolean = true;

        /**
         * Create a new Path object
         * @param parent The display object that this path transform relates to
         * @param data   A sequence of path points. The first set or coordinates is the start point. Subsequent sets
         *               start with the segment type (LINE_TO or ARC_TO) followed by the end coordinate.
         *               Example: [3, 5, LINE_TO, 3, 8, LINE_TO, 4, 9, ARC_TO, 5, 10, LINE_TO, 6, 11, ARC_TO, 3, 2]
         */
        public function Path(parent:DisplayObject, data:Vector.<Number> = null) {
            this.parent = parent;
            this.data = data;
        }

        /**
         * Create the path from raw path data
         * @param parent The display object that this path transform relates to
         * @param data   A sequence of path points. The first set or coordinates is the start point. Subsequent sets
         *               start with the segment type (LINE_TO or ARC_TO) followed by the end coordinate.
         *               Example: [3, 5, LINE_TO, 3, 8, LINE_TO, 4, 9, ARC_TO, 5, 10, LINE_TO, 6, 11, ARC_TO, 3, 2]
         */
        public function set data(data:Vector.<Number>):void {
            clear();
            if (!data || data.length == 0) {
                return;
            }
            if ((data.length - 2) % 3 != 0) {
                throw new Error("Invalid path data length");
            }
            var first:Point = new Point(data[0], data[1]);
            var start:Point = new Point(data[0], data[1]);
            var temp:Point = new Point();
            for (var i:int = 2; i < data.length; i += 3) {
                var type:int = data[i];
                temp.setTo(data[i + 1], data[i + 2]);
                if (type == LINE_TO) {
                    segments.push(new Line(start, temp));
                    start.setTo(temp.x, temp.y);
                }
                else if (type == ARC_TO) {
                    throw new Error("Arc segments not yet implemented");
                    // segments.push(new Arc(start, temp));
                }
                else {
                    throw new Error("Unknown segment type: " + type);
                }
            }
            _joined = (MathUtil.isEqual(start.x, first.x) && MathUtil.isEqual(start.y, first.y));
            update();
        }

        /**
         * Get the bounding rectangle of the path.
         * This is calculated from the bounds of each segment.
         */
        public function update():void {
            bounds.setTo(0, 0, 0, 0);
            for each (var segment:Segment in segments) {
                bounds = bounds.union(segment.bounds);
            }
        }

        /**
         * Clear the path segments and reset the bounds.
         */
        public function clear():void {
            segments.length = 0;
            update();
        }

        /**
         * Calculates the intersection point between a line and the paths. Returns the
         * closest intersection position.
         * @param line       A line to calculate the intersection with, in path space.
         * @param outPoint   (out) If provided will be populated with the intersection point, in path space.
         * @return The position, or null if the lines do not intersect.
         */
        public function intersection(line:Line, outPoint:Point = null):Position {
            (parent as Sprite).graphics.clear();

            if (!bounds.intersects(line.bounds)) {
                (parent as Sprite).graphics.lineStyle(0, 0xff0000);
                (parent as Sprite).graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
                (parent as Sprite).graphics.drawRect(line.bounds.x, line.bounds.y, line.bounds.width, line.bounds.height);
                return null;
            }

            var cd:Number = Number.POSITIVE_INFINITY;
            var cp:Position = new Position();
            var pt:Point = new Point();
            var d:Number = 0;
            for each (var s:Segment in segments) {
                var sp:Position = s.intersection(line, pt);
                (parent as Sprite).graphics.lineStyle(0, 0xff0000);
                if (sp) {
                    d = MathUtil.distanceSq(pt, line.p1);
                    (parent as Sprite).graphics.lineStyle(0, 0x00ff00);
                    if (!cp.segment) {
                        cd = MathUtil.distanceSq(pt, line.p1);
                        cp.copyFrom(sp);
                        if (outPoint) {
                            outPoint.copyFrom(pt);
                        }
                    }
                    else {
                        if (d < cd) {
                            cd = d;
                            cp.copyFrom(sp);
                            if (outPoint) {
                                outPoint.copyFrom(pt);
                            }
                        }
                    }
                }

                s.draw((parent as Sprite).graphics);
                line.draw((parent as Sprite).graphics);
            }
            if (cd == Number.POSITIVE_INFINITY) {
                return null;
            }
            cp.path = this;
            return cp;
        }

        /**
         * From a given point on the path, follow the path a certain distance.
         * @param pos        The point on the line to start from. Will be populated with the new position.
         * @param distance   The distance to follow the line. If +ve, will go clockwise, otherwise anticlockwise
         * @return If the end of the line was reached, the distance remaining. Otherwise 0.
         **/
        public function follow(pos:Position, distance:Number, outPoint:Point = null):Number {
            while (distance > 0) {
                distance = pos.segment.follow(pos, distance, outPoint);
                if (distance < 0) {
                    // get previous segment
                    var index:int = segments.indexOf(pos.segment);
                    if (index > 0) {
                        pos.segment = segments[index - 1];
                        pos.position = 1;
                    }
                    else if (_joined) {
                        pos.segment = segments[segments.length - 1];
                        pos.position = 1;
                    }
                    else {
                        pos.position = 0;
                        if (outPoint) {
                            pos.segment.pointAtPosition(pos.position, outPoint);
                        }
                        return distance;
                    }
                }
                else if (distance > 0) {
                    // get next segment
                    var nextIndex:int = segments.indexOf(pos.segment) + 1;
                    if (nextIndex < segments.length) {
                        pos.segment = segments[nextIndex];
                        pos.position = 0;
                    }
                    else if (_joined) {
                        pos.segment = segments[0];
                        pos.position = 0;
                    }
                    else {
                        pos.position = 1;
                        if (outPoint) {
                            pos.segment.pointAtPosition(pos.position, outPoint);
                        }
                        return distance;
                    }
                }
            }
            return 0;
        }

        /**
         * Draw the path to the canvas. Will draw to the parent object if no canvas
         * is supplied.
         * @param canvas The canvas to draw to. If null, will draw to the parent.
         */
        public function draw(canvas:Graphics = null):void {
            if (segments.length == 0) {
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
            for (var i:int = 0; i < segments.length; i++) {
                segments[i].draw(canvas);
            }
        }

        /**
         * Returns a string representation of the path.
         * @return A string representation of the path
         */
        public function toString():String {
            var str:String = "Path: ";
            for (var i:int = 0; i < segments.length; i++) {
                str += segments[i].toString() + " ";
            }
            return str;
        }
    }
}