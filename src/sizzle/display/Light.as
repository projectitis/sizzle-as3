package sizzle.display {
    import flash.geom.Vector3D;

    import sizzle.display.Color;

    public class Light {
        public var direction:Vector3D = new Vector3D(0, 0, 1);
        public var ambient:Boolean = true;
        public var color:Color = new Color(Color.VIOLET, 0.0);

        public function setDirection(x:Number, y:Number, z:Number):void {
            direction.setTo(x, y, z);
            direction.normalize();
        }
    }
}