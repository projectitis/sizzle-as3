package sizzle.geom {
    import flash.geom.Point;
    import sizzle.utils.MathUtil;

    public class Vector2d extends Point {
        private static const _180_PI:Number = 180 / Math.PI;
        private static const _PI_180:Number = Math.PI / 180;

        // Angle in degrees
        public var angle:Number = 0;

        // Magnitude
        public var magnitude:Number = 0;

        /**
         * Constructor
         */
        public function Vector2d(x:Number = 0, y:Number = 0, a:Number = 0, m:Number = 0) {
            this.x = x;
            this.y = y;
            this.angle = a;
            this.magnitude = m;
            normalize(1);
        }

        // Normalize
        override public function normalize(thickness:Number):void {
            if (this.magnitude < 0) {
                rotate(180);
            }
            this.magnitude = thickness;
        }

        public function normal():Point {
            var rad:Number = this.angle * _PI_180;
            return new Point(Math.cos(rad) * this.magnitude, Math.sin(rad) * this.magnitude);
        }

        /**
         * Set from a point representing position and an angle representing a normal.
         **/
        public function setFrom(p:Point, angle:Number):void {
            x = p.x;
            y = p.y;
            this.angle = angle;
            this.magnitude = 1;
        }

        /**
         * Set the normal vector from x and y components.
         * @param x The x component of the normal
         * @param y The y component of the normal
         */
        public function setNormal(x:Number, y:Number):void {
            this.angle = MathUtil.radToDeg(Math.atan2(y, x));
            this.magnitude = 1;
        }

        /**
         * Rotate the normal
         */
        public function rotate(deg:Number):void {
            this.angle = (this.angle + deg) % 360;
        }
    }
}
