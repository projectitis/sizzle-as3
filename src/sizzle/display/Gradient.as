package sizzle.display {
    import sizzle.display.Color;
    import sizzle.utils.MathUtil;
    import sizzle.pooling.IPooled;

    public class Gradient implements IPooled {
        public var colors:Vector.<Color> = new Vector.<Color>();
        public var stops:Vector.<Number> = new Vector.<Number>();

        /**
         * Create a new gradient.
         * @param args      Pairs of (color:Color, stop:Number). Where stop is a value between 0.0 and 1.0.
         *                  Stop values must be in order.
         */
        public function Gradient(...args) {
            init.apply(null, args);
        }

        /**
         * Populate a new gradient
         * @param args      Pairs of (color:Color, stop:Number). Where stop is a value between 0.0 and 1.0.
         *                  Stop values must be in order.
         */
        public function init(...args):void {
            colors.length = 0;
            stops.length = 0;
            if (args.length % 2 != 0) {
                throw new Error("Gradient args must be in pairs of 2 (color, stop)");
            }
            if (args.length == 0) {
                colors.push(new Color(Color.BLACK));
                stops.push(0.0);
                colors.push(new Color(Color.WHITE));
                stops.push(1.0);
            }
            else if (args.length == 2) {
                colors.push(args[0] as Color);
                stops.push(0.0);
                colors.push(args[0] as Color);
                stops.push(1.0);
            }
            else {
                var s:Number = 0;
                var c:Color;
                for (var i:int = 0; i < args.length; i += 2) {
                    c = args[i] as Color;
                    s = MathUtil.clamp(Number(args[i + 1]));
                    if (i == 0 && s > 0) {
                        colors.push(c.clone());
                        stops.push(0.0);
                    }
                    colors.push(c);
                    stops.push(s);
                }
                if (s != 1.0) {
                    colors.push(c.clone());
                    stops.push(1.0);
                }
            }
        }

        /**
         * Reset back to empty state
         */
        public function reset():void {
            colors.length = 0;
            stops.length = 0;
        }

        /**
         * Calculate the color at a certain position along the gradient and returns it as a new color object
         * @param pos   The position, between 0 and 1
         */
        public function color(pos:Number):Color {
            if (pos <= 0) {
                return colors[0].clone();
            }
            else if (pos >= 1.0) {
                return colors[colors.length - 1].clone();
            }
            for (var i:int = 1; i < colors.length; i++) {
                if (pos < stops[i]) {
                    var r:Number = stops[i] - stops[i - 1];
                    var p:Number = pos - stops[i - 1];
                    return Color.lerp(colors[i - 1], colors[i], p / r);
                }
            }
            return colors[colors.length - 1].clone();
        }

        /**
         * Calculate the color at a certain position along the gradient and adjusts the provided color object
         * @param pos       The position, between 0 and 1
         * @param color     (out) The resulting color
         */
        public function colorOut(pos:Number, color:Color):void {
            if (pos <= 0) {
                color.copyFrom(colors[0]);
            }
            else if (pos >= 1) {
                color.copyFrom(colors[colors.length - 1]);
            }
            else {
                for (var i:int = 1; i < colors.length; i++) {
                    if (pos < stops[i]) {
                        var r:Number = stops[i] - stops[i - 1];
                        var p:Number = pos - stops[i - 1];
                        color.copyFrom(colors[i - 1]);
                        color.tint(colors[i], p / r);
                        return;
                    }
                }
            }
        }

        /**
         * String representation of this object
         */
        public function toString():String {
            var s:String = "Gradient[";
            for (var i:int = 0; i < colors.length; i++) {
                if (i > 0) {
                    s += ", ";
                }
                s += stops[i] + ": " + colors[i].toString(true);
            }
            return s + "]";
        }
    }
}