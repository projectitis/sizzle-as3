package sizzle.display {

    import flash.display.GraphicsSolidFill;
    import flash.geom.Vector3D;

    public class Bump {
        private static var INV_255:Number = 1 / 255;

        public var normal:Vector3D;
        public var fill:GraphicsSolidFill;

        public function Bump(f:GraphicsSolidFill) {
            fill = f;
            var r:Number = (((f.color >> 16) & 0xFF) * INV_255 - 0.5) * 2;
            var g:Number = (((f.color >> 8) & 0xFF) * INV_255 - 0.5) * 2;
            var b:Number = ((f.color & 0xFF) * INV_255 - 0.5) * 2;
            normal = new Vector3D(r, g, b);
            normal.normalize();
        }
    }
}