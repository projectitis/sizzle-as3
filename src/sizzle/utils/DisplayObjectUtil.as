package sizzle.utils {

    import flash.display.DisplayObject;
    import flash.geom.Point;
    import sizzle.utils.MathUtil;

    public class DisplayObjectUtil {
        private static const _180_PI:Number = 180 / Math.PI;
        private static const _PI_180:Number = Math.PI / 180;

        /**
         * Remove a display object from its parent.
         * @param obj The display object to remove.
         */
        public static function reset(obj:DisplayObject):void {
            if (obj && obj.parent) {
                obj.parent.removeChild(obj);
            }
            obj.x = 0;
            obj.y = 0;
            obj.scaleX = 1;
            obj.scaleY = 1;
            obj.scaleZ = 1;
            obj.rotation = 0;
            obj.rotationX = 0;
            obj.rotationY = 0;
            obj.rotationZ = 0;
            obj.alpha = 1;
            obj.visible = true;
            obj.transform.matrix = null; // Reset transformation matrix
            obj.transform.colorTransform = null; // Reset color transform
        }

        /**
         * Rotate a display object about a point
         */
        public static function rotateAbout(obj:DisplayObject, point:Point, angle:Number):void {
            obj.transform.matrix.translate(-point.x, -point.y);
            obj.rotation = angle;
            obj.transform.matrix.translate(point.x, point.y);
        }

        public static function angleFrom(a:DisplayObject, b:DisplayObject):Number {
            var angle:Number = Math.atan2(b.y - a.y, b.x - a.x) * _180_PI;
            return angle < 0 ? angle + 360 : angle;
        }

        public static function distanceFrom(a:DisplayObject, b:DisplayObject):Number {
            return Math.sqrt(MathUtil.sq(b.x - a.x) + MathUtil.sq(b.y - a.y));
        }

        /**
         * Calculate the rotation difference between two display objects
         * @param a     The object to calculate rotation of
         * @param b     The object that rotation is calculated relative to. Should be lower on hierarchy.
         *              If not provided or not found in hierarchy, rotation from stage is calculated.
         */
        public static function rotationBetween(a:DisplayObject, b:DisplayObject = null):Number {
            var r:Number = a.rotation;
            while (a.parent != null) {
                a = a.parent;
                if (a == b) {
                    break;
                }
                r += a.rotation;
            }
            return r;
        }
    }
}