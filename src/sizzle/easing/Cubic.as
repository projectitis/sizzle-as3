package sizzle.easing {
	public class Cubic {
		// Modeled after the cubic y = x^3
		public static function easeIn(p:Number):Number {
			return p * p * p;
		}

		// Modeled after the cubic y = (x - 1)^3 + 1
		public static function easeOut(p:Number):Number {
			var f:Number = (p - 1);
			return f * f * f + 1;
		}

		// Modeled after the piecewise cubic
		// y = (1/2)((2x)^3)       ; [0, 0.5)
		// y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
		public static function easeInOut(p:Number):Number {
			if (p < 0.5) {
				return 4 * p * p * p;
			}
			else {
				var f:Number = ((2 * p) - 2);
				return 0.5 * f * f * f + 1;
			}
		}
	}
}