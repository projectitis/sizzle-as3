package sizzle {
    import flash.display.Bitmap;
    import flash.display.PixelSnapping;

    import sizzle.IGameObject;

    public class SzBitmap extends Bitmap implements IGameObject {

        public function SzBitmap() {
            super();
            pixelSnapping = PixelSnapping.AUTO;
            smoothing = false;
        }

        public function update(dt: Number): void {
            
        }

    }
}