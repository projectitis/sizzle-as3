package sizzle.easing {
	public class Sine {
		private static const _PI_2:Number = Math.PI * 0.5;

		// Modeled after quarter-cycle of sine wave
		public static function easeIn(p:Number):Number {
			return Math.sin((p - 1) * _PI_2) + 1;
		}

		// Modeled after quarter-cycle of sine wave (different phase)
		public static function easeOut(p:Number):Number {
			return Math.sin(p * _PI_2);
		}

		// Modeled after half sine wave
		public static function easeInOut(p:Number):Number {
			return 0.5 * (1 - Math.cos(p * Math.PI));
		}
	}
}