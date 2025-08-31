package sizzle.display {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.display.IGraphicsData;
    import flash.display.GraphicsGradientFill;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsEndFill;
    import flash.display.GraphicsPath;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;

    import sizzle.display.Bump;
    import sizzle.display.Light;
    import sizzle.utils.MathUtil;
    import sizzle.utils.DisplayObjectUtil;

    public class BumpMap extends Sprite {
        private var _gradient:Gradient;
        private var _src:Shape;
        private var _dest:Shape;
        private var _data:Vector.<IGraphicsData>;
        private var _bumps:Vector.<Bump>;

        public function BumpMap() {
            super();

            if (numChildren == 1 && getChildAt(0) is Shape) {
                _src = getChildAt(0) as Shape;
                _data = new Vector.<IGraphicsData>();
                _bumps = new Vector.<Bump>();
                var srcGraphicsData:Vector.<IGraphicsData> = _src.graphics.readGraphicsData(false);
                for each (var gd:IGraphicsData in srcGraphicsData) {
                    if (gd is GraphicsGradientFill) {
                        if (!_gradient) {
                            var fill:GraphicsGradientFill = gd as GraphicsGradientFill;
                            var args:Array = [];
                            for (var i:int = 0; i < fill.colors.length; i++) {
                                args.push(new Color(fill.colors[i], fill.alphas[i]));
                                args.push(fill.ratios[i] / 255);
                            }
                            _gradient = new Gradient();
                            _gradient.init.apply(null, args);
                        }
                    }
                    else if (gd is GraphicsSolidFill || gd is GraphicsEndFill || gd is GraphicsPath) {
                        _data.push(gd);
                        if (gd is GraphicsSolidFill) {
                            _bumps.push(new Bump(gd as GraphicsSolidFill));
                        }
                    }
                }
                if (!_gradient) {
                    _gradient = new Gradient();
                }

                _dest = new Shape();
                addChild(_dest);
                _dest.transform.matrix = _src.transform.matrix;

                _src.visible = false;
            }

            redraw(new Light(), this);
        }

        public function redraw(light:Light, parent:DisplayObject):void {
            if (_src) {
                _dest.graphics.clear();
                var normal:Matrix3D = new Matrix3D();
                var color:Color = new Color();
                var drawGraphicsData:Vector.<IGraphicsData> = _src.graphics.readGraphicsData(false);
                var angle:Number = -DisplayObjectUtil.rotationBetween(this, parent);
                var factor:Number;
                var lightColor:Color = light.color.clone();
                var lightStrength:Number = light.color.a;
                lightColor.a = 1.0;
                for each (var bump:Bump in _bumps) {
                    // Lambertian diffuse reflection model
                    normal.identity();
                    normal.appendTranslation(bump.normal.x, bump.normal.y, bump.normal.z);
                    normal.appendRotation(angle, Vector3D.Z_AXIS);
                    factor = MathUtil.clamp(0.5 + 0.5 * normal.position.dotProduct(light.direction));

                    _gradient.colorOut(factor, color);
                    color.tint(lightColor, lightStrength * factor);
                    bump.fill.color = color.value;
                    bump.fill.alpha = color.a;
                }
                _dest.graphics.drawGraphicsData(_data);
            }
        }
    }
}