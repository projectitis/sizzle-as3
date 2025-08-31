package sizzle.easing {
	public class Bounce {
		public static function easeIn(p:Number):Number {
			return 1 - easeOut(1 - p);
		}

		public static function easeOut(p:Number):Number {
			if (p < 4 / 11.0) {
				return (121 * p * p) / 16.0;
			}
			else if (p < 8 / 11.0) {
				return (363 / 40.0 * p * p) - (99 / 10.0 * p) + 17 / 5.0;
			}
			else if (p < 9 / 10.0) {
				return (4356 / 361.0 * p * p) - (35442 / 1805.0 * p) + 16061 / 1805.0;
			}
			else {
				return (54 / 5.0 * p * p) - (513 / 25.0 * p) + 268 / 25.0;
			}
		}

		public static function easeInOut(p:Number):Number {
			if (p < 0.5) {
				return 0.5 * easeIn(p * 2);
			}
			else {
				return 0.5 * easeOut(p * 2 - 1) + 0.5;
			}
		}
	}
}