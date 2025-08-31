package sizzle.utils {
    import flash.geom.Point;
    import flash.geom.Matrix;

    public class MathUtil {
        public static const epsilon:Number = 0.000001;
        private static const _180_PI:Number = 180 / Math.PI;
        private static const _PI_180:Number = Math.PI / 180;

        /**
         * Square a number
         * @param value     The number to square
         * @return the squared value
         */
        public static function sq(value:Number):Number {
            return value * value;
        }

        /**
         * Check if a number is zero, or very close to it.
         * @param value     The number to check
         * @return true if the value is zero or close to it, otherwise false
         */
        public static function isZero(value:Number, epsilon:Number = MathUtil.epsilon):Boolean {
            return Math.abs(value) < epsilon;
        }

        /**
         * Check if two numbers are equal within a small epsilon range.
         * @param a     The first number
         * @param b     The second number
         * @param epsilon The tolerance for equality
         * @return true if the numbers are considered equal, otherwise false
         */
        public static function isEqual(a:Number, b:Number, epsilon:Number = MathUtil.epsilon):Boolean {
            return Math.abs(a - b) < epsilon;
        }

        /**
         * Clamp a value between a min and max
         * @param value     The number to clamp
         * @param min       The minimum of the clamp range
         * @param max       The maximum of the clamp range
         * @return The clamped value
         */
        public static function clamp(value:Number, min:Number = 0.0, max:Number = 1.0):Number {
            return Math.min(Math.max(value, min), max);
        }

        /**
         * Linearly interpolate between start and end by p.
         * @param start     The starting value
         * @param end       The end value
         * @param p         The amount to interpolate (0.0 .. 1.0)
         * @return The interpolated value
         */
        public static function lerp(start:Number, end:Number, p:Number):Number {
            return start + (end - start) * p;
        }

        /**
         * Calculate the squared distance between two points
         * @param p1    The first point
         * @param p2    The second point
         * @return The squared distance between the points
         */
        public static function distanceSq(p1:Point, p2:Point):Number {
            return MathUtil.sq(p2.x - p1.x) + MathUtil.sq(p2.y - p1.y);
        }

        /**
         * Calculate the distance between two points specified by their x and y coordinates
         * @param x1    X position of the first point
         * @param y1    Y position of the first point
         * @param x2    X position of the second point
         * @param y2    Y position of the second point
         * @return The distance between the points
         */
        public static function distanceFromCoords(x1:Number, y1:Number, x2:Number, y2:Number):Number {
            return Math.sqrt(MathUtil.sq(x2 - x1) + MathUtil.sq(y2 - y1));
        }

        /**
         * Calculate the squared distance between two points specified by their x and y coordinates
         * @param x1    X position of the first point
         * @param y1    Y position of the first point
         * @param x2    X position of the second point
         * @param y2    Y position of the second point
         * @return The squared distance between the points
         */
        public static function distanceSqFromCoords(x1:Number, y1:Number, x2:Number, y2:Number):Number {
            return MathUtil.sq(x2 - x1) + MathUtil.sq(y2 - y1);
        }

        /**
         * Convert an angle from radians to degrees
         * @param rad   The angle in radians
         * @return The angle in degrees
         */
        public static function radToDeg(rad:Number):Number {
            return rad * _180_PI;
        }

        /**
         * Convert an angle from degrees to radians
         * @param deg   The angle in degrees
         * @return The angle in radians
         */
        public static function degToRad(deg:Number):Number {
            return deg * _PI_180;
        }

        /**
         * Rotate a point about the origin
         * @param p         The point to rotate
         * @param deg       The rotation amount in degrees
         * @return The rotated point
         */
        public static function rotatePoint(p:Point, deg:Number):Point {
            var rad:Number = deg * _PI_180;
            var cos:Number = Math.cos(rad);
            var sin:Number = Math.sin(rad);
            return new Point(
                    p.x * cos - p.y * sin,
                    p.x * sin + p.y * cos
                );
        }

        /**
         * Multiply two points component-wise
         * @param p1     The first point
         * @param p2     The second point
         * @return A new point with each component multiplied
         */
        public static function multiplyPoints(p1:Point, p2:Point):Point {
            return new Point(p1.x * p2.x, p1.y * p2.y);
        }

        /**
         * Calculate the angle, in degrees, from the origin to the point.
         * @param p     The point to calculate the angle from
         * @return The angle in degrees (0-360)
         */
        public static function angle(p:Point):Number {
            var angle:Number = Math.atan2(p.y, p.x) * _180_PI;
            return angle < 0 ? angle + 360 : angle;
        }

        /**
         * Calculate the angle, in degrees, from the origin to a coordinate
         * @param x     The X coordinate
         * @param y     The Y coordinate
         * @return The angle in degrees (0-360)
         */
        public static function angleFromCoords(x:Number, y:Number):Number {
            var angle:Number = Math.atan2(y, x) * _180_PI;
            return angle < 0 ? angle + 360 : angle;
        }

        /**
         * Calculate the normal vector for a given angle in degrees.
         * @param angle     The angle in degrees
         * @param outPoint  The point to store the normal vector
         */
        public static function normal(angle:Number, outPoint:Point):void {
            var rad:Number = angle * _PI_180;
            outPoint.setTo(Math.cos(rad), -Math.sin(rad));
        }

        /**
         * Reflect a point about the axis vector
         * @param p     The point to reflect
         * @param axis  The axis vector to reflect about
         * @return The reflected point
         */
        public static function reflect(p:Point, axis:Point):Point {
            // Handle zero vector case
            if (isZero(axis.x) && isZero(axis.y))
                return p.clone();

            // Calculate dot product
            var dot:Number = (p.x * axis.x + p.y * axis.y);
            // Calculate squared length of axis
            var lenSq:Number = axis.x * axis.x + axis.y * axis.y;
            // Scale factor for projection
            var scale:Number = 2 * dot / lenSq;

            // Reflect = 2 * projection - point
            return new Point(
                    scale * axis.x - p.x,
                    scale * axis.y - p.y
                );
        }

        /**
         * Check if two numbers have the same sign
         * @param a     The first number
         * @param b     The second number
         * @return True if both numbers have the same sign, otherwise false
         */
        public static function sameSign(a:Number, b:Number):Boolean {
            if (a == 0 || b == 0) {
                return a == b;
            }
            return (a ^ b) >= 0;
        }
    }
}