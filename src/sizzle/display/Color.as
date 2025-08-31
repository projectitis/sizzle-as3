package sizzle.display {
    import sizzle.utils.MathUtil;
    import sizzle.pooling.IPooled;

    public class Color implements IPooled {
        private static const INV255:Number = 1 / 255;

        // Standard web colors
        public static const ALICE_BLUE:uint = 0xF0F8FF;
        public static const ANTIQUE_WHITE:uint = 0xFAEBD7;
        public static const AQUA:uint = 0x00FFFF;
        public static const AQUAMARINE:uint = 0x7FFFD4;
        public static const AZURE:uint = 0xF0FFFF;
        public static const BEIGE:uint = 0xF5F5DC;
        public static const BISQUE:uint = 0xFFE4C4;
        public static const BLACK:uint = 0x000000;
        public static const BLANCHED_ALMOND:uint = 0xFFEBCD;
        public static const BLUE:uint = 0x0000FF;
        public static const BLUE_VIOLET:uint = 0x8A2BE2;
        public static const BROWN:uint = 0xA52A2A;
        public static const BURLY_WOOD:uint = 0xDEB887;
        public static const CADET_BLUE:uint = 0x5F9EA0;
        public static const CHARTREUSE:uint = 0x7FFF00;
        public static const CHOCOLATE:uint = 0xD2691E;
        public static const CORAL:uint = 0xFF7F50;
        public static const CORNFLOWER_BLUE:uint = 0x6495ED;
        public static const CORNSILK:uint = 0xFFF8DC;
        public static const CRIMSON:uint = 0xDC143C;
        public static const CYAN:uint = 0x00FFFF;
        public static const DARK_BLUE:uint = 0x00008B;
        public static const DARK_CYAN:uint = 0x008B8B;
        public static const DARK_GOLDENROD:uint = 0xB8860B;
        public static const DARK_GRAY:uint = 0xA9A9A9;
        public static const DARK_GREEN:uint = 0x006400;
        public static const DARK_KHAKI:uint = 0xBDB76B;
        public static const DARK_MAGENTA:uint = 0x8B008B;
        public static const DARK_OLIVE_GREEN:uint = 0x556B2F;
        public static const DARK_ORANGE:uint = 0xFF8C00;
        public static const DARK_ORCHID:uint = 0x9932CC;
        public static const DARK_RED:uint = 0x8B0000;
        public static const DARK_SALMON:uint = 0xE9967A;
        public static const DARK_SEA_GREEN:uint = 0x8FBC8F;
        public static const DARK_SLATE_BLUE:uint = 0x483D8B;
        public static const DARK_SLATE_GRAY:uint = 0x2F4F4F;
        public static const DARK_TURQUOISE:uint = 0x00CED1;
        public static const DARK_VIOLET:uint = 0x9400D3;
        public static const DEEP_PINK:uint = 0xFF1493;
        public static const DEEP_SKY_BLUE:uint = 0x00BFFF;
        public static const DIM_GRAY:uint = 0x696969;
        public static const DODGER_BLUE:uint = 0x1E90FF;
        public static const FIRE_BRICK:uint = 0xB22222;
        public static const FLORAL_WHITE:uint = 0xFFFAF0;
        public static const FOREST_GREEN:uint = 0x228B22;
        public static const FUCHSIA:uint = 0xFF00FF;
        public static const GAINSBORO:uint = 0xDCDCDC;
        public static const GHOST_WHITE:uint = 0xF8F8FF;
        public static const GOLD:uint = 0xFFD700;
        public static const GOLDENROD:uint = 0xDAA520;
        public static const GRAY:uint = 0x808080;
        public static const GREEN:uint = 0x008000;
        public static const GREEN_YELLOW:uint = 0xADFF2F;
        public static const HONEYDEW:uint = 0xF0FFF0;
        public static const HOT_PINK:uint = 0xFF69B4;
        public static const INDIAN_RED:uint = 0xCD5C5C;
        public static const INDIGO:uint = 0x4B0082;
        public static const IVORY:uint = 0xFFFFF0;
        public static const KHAKI:uint = 0xF0E68C;
        public static const LAVENDER:uint = 0xE6E6FA;
        public static const LAVENDER_BLUSH:uint = 0xFFF0F5;
        public static const LAWN_GREEN:uint = 0x7CFC00;
        public static const LEMON_CHIFFON:uint = 0xFFFACD;
        public static const LIGHT_BLUE:uint = 0xADD8E6;
        public static const LIGHT_CORAL:uint = 0xF08080;
        public static const LIGHT_CYAN:uint = 0xE0FFFF;
        public static const LIGHT_GOLDENROD_YELLOW:uint = 0xFAFAD2;
        public static const LIGHT_GRAY:uint = 0xD3D3D3;
        public static const LIGHT_GREEN:uint = 0x90EE90;
        public static const LIGHT_PINK:uint = 0xFFB6C1;
        public static const LIGHT_SALMON:uint = 0xFFA07A;
        public static const LIGHT_SEA_GREEN:uint = 0x20B2AA;
        public static const LIGHT_SKY_BLUE:uint = 0x87CEFA;
        public static const LIGHT_SLATE_GRAY:uint = 0x778899;
        public static const LIGHT_STEEL_BLUE:uint = 0xB0C4DE;
        public static const LIGHT_YELLOW:uint = 0xFFFFE0;
        public static const LIME:uint = 0x00FF00;
        public static const LIME_GREEN:uint = 0x32CD32;
        public static const LINEN:uint = 0xFAF0E6;
        public static const MAGENTA:uint = 0xFF00FF;
        public static const MAROON:uint = 0x800000;
        public static const MEDIUM_AQUAMARINE:uint = 0x66CDAA;
        public static const MEDIUM_BLUE:uint = 0x0000CD;
        public static const MEDIUM_ORCHID:uint = 0xBA55D3;
        public static const MEDIUM_PURPLE:uint = 0x9370DB;
        public static const MEDIUM_SEA_GREEN:uint = 0x3CB371;
        public static const MEDIUM_SLATE_BLUE:uint = 0x7B68EE;
        public static const MEDIUM_SPRING_GREEN:uint = 0x00FA9A;
        public static const MEDIUM_TURQUOISE:uint = 0x48D1CC;
        public static const MEDIUM_VIOLET_RED:uint = 0xC71585;
        public static const MIDNIGHT_BLUE:uint = 0x191970;
        public static const MINT_CREAM:uint = 0xF5FFFA;
        public static const MISTY_ROSE:uint = 0xFFE4E1;
        public static const MOCCASIN:uint = 0xFFE4B5;
        public static const NAVAJO_WHITE:uint = 0xFFDEAD;
        public static const NAVY:uint = 0x000080;
        public static const OLD_LACE:uint = 0xFDF5E6;
        public static const OLIVE:uint = 0x808000;
        public static const OLIVE_DRAB:uint = 0x6B8E23;
        public static const ORANGE:uint = 0xFFA500;
        public static const ORANGE_RED:uint = 0xFF4500;
        public static const ORCHID:uint = 0xDA70D6;
        public static const PALE_GOLDENROD:uint = 0xEEE8AA;
        public static const PALE_GREEN:uint = 0x98FB98;
        public static const PALE_TURQUOISE:uint = 0xAFEEEE;
        public static const PALE_VIOLET_RED:uint = 0xDB7093;
        public static const PAPAYA_WHIP:uint = 0xFFEFD5;
        public static const PEACH_PUFF:uint = 0xFFDAB9;
        public static const PERU:uint = 0xCD853F;
        public static const PINK:uint = 0xFFC0CB;
        public static const PLUM:uint = 0xDDA0DD;
        public static const POWDER_BLUE:uint = 0xB0E0E6;
        public static const PURPLE:uint = 0x800080;
        public static const RED:uint = 0xFF0000;
        public static const ROSY_BROWN:uint = 0xBC8F8F;
        public static const ROYAL_BLUE:uint = 0x4169E1;
        public static const SADDLE_BROWN:uint = 0x8B4513;
        public static const SALMON:uint = 0xFA8072;
        public static const SANDY_BROWN:uint = 0xF4A460;
        public static const SEA_GREEN:uint = 0x2E8B57;
        public static const SEA_SHELL:uint = 0xFFF5EE;
        public static const SIENNA:uint = 0xA0522D;
        public static const SILVER:uint = 0xC0C0C0;
        public static const SKY_BLUE:uint = 0x87CEEB;
        public static const SLATE_BLUE:uint = 0x6A5ACD;
        public static const SLATE_GRAY:uint = 0x708090;
        public static const SNOW:uint = 0xFFFAFA;
        public static const SPRING_GREEN:uint = 0x00FF7F;
        public static const STEEL_BLUE:uint = 0x4682B4;
        public static const TAN:uint = 0xD2B48C;
        public static const TEAL:uint = 0x008080;
        public static const THISTLE:uint = 0xD8BFD8;
        public static const TOMATO:uint = 0xFF6347;
        public static const TURQUOISE:uint = 0x40E0D0;
        public static const VIOLET:uint = 0xEE82EE;
        public static const WHEAT:uint = 0xF5DEB3;
        public static const WHITE:uint = 0xFFFFFF;
        public static const WHITE_SMOKE:uint = 0xF5F5F5;
        public static const YELLOW:uint = 0xFFFF00;
        public static const YELLOW_GREEN:uint = 0x9ACD32;

        private var _r:uint;
        private var _g:uint;
        private var _b:uint;
        private var _a:Number;

        /**
         * Create a new Color
         * @param color The RGB color value (0xRRGGBB format), default 0x000000
         * @param alpha The alpha value (0.0 to 1.0), default 1.0
         */
        public function Color(color:uint = 0x000000, alpha:Number = 1.0) {
            init(color, alpha);
        }

        /**
         * Initialise the color with values
         * @param args      color (uint) and alpha (Number)
         */
        public function init(...args):void {
            if (args.length > 0) {
                value = args[0] ? uint(args[0]) : 0x000000;
            }
            else {
                value = BLACK;
            }
            if (args.length > 1) {
                a = Number(args[1]);
            }
            else {
                a = 1.0;
            }
        }

        /**
         * Reset color back to default
         */
        public function reset():void {
            value = BLACK;
            a = 1.0;
        }

        /**
         * Create a new Color from RGBA components
         * @param r Red component (0-255)
         * @param g Green component (0-255)
         * @param b Blue component (0-255)
         * @param a Alpha component (0-1), default 1.0
         * @return A new Color instance
         */
        public static function fromRGBA(r:uint, g:uint, b:uint, a:Number = 1.0):Color {
            var color:Color = new Color();
            color.r = r;
            color.g = g;
            color.b = b;
            color.a = a;
            return color;
        }

        /**
         * Return the 24bit color value. Note, it does not include alpha (a).
         */
        public function get value():uint {
            return _r << 16 | _g << 8 | _b;
        }

        /**
         * Set the color from a 24bit color value. Does not affect alpha.
         */
        public function set value(color:uint):void {
            _r = (color >> 16) & 0xFF;
            _g = (color >> 8) & 0xFF;
            _b = color & 0xFF;
        }

        /**
         * Get the red component of the color (0-255)
         * @return The red component value
         */
        public function get r():uint {
            return _r;
        }

        /**
         * Set the red component of the color
         * @param value The red component value (0-255)
         */
        public function set r(value:uint):void {
            _r = uint(MathUtil.clamp(value, 0, 255));
        }

        /**
         * Get the green component of the color (0-255)
         * @return The green component value
         */
        public function get g():uint {
            return _g;
        }

        /**
         * Set the green component of the color
         * @param value The green component value (0-255)
         */
        public function set g(value:uint):void {
            _g = uint(MathUtil.clamp(value, 0, 255));
        }

        /**
         * Get the blue component of the color (0-255)
         * @return The blue component value
         */
        public function get b():uint {
            return _b;
        }

        /**
         * Set the blue component of the color
         * @param value The blue component value (0-255)
         */
        public function set b(value:uint):void {
            _b = uint(MathUtil.clamp(value, 0, 255));
        }

        /**
         * Get the alpha component of the color (0-1)
         * @return The alpha component value
         */
        public function get a():Number {
            return _a;
        }

        /**
         * Set the alpha component of the color
         * @param value The alpha component value (0-1)
         */
        public function set a(value:Number):void {
            _a = MathUtil.clamp(value, 0, 1);
        }

        /**
         * Return the perceived brightness of a color (0 - 1)
         */
        public function get perceivedBrightness():Number {
            return (0.2126 * r + 0.7152 * g + 0.0722 * b) * INV255;
        }

        /**
         * Return a color that is a copy of this one
         */
        public function clone():Color {
            return new Color(this.value, this.a);
        }

        /**
         * Copy values from another color
         */
        public function copyFrom(color:Color):void {
            r = color.r;
            g = color.g;
            b = color.b;
            a = color.a;
        }

        /**
         * Adjust the brightness of the color
         * @param amount Value between -1 and 1. -1 = black, 0 = original color, 1 = white
         * @return A new Color with adjusted brightness
         */
        public function adjust(amount:Number):void {
            amount = MathUtil.clamp(amount, -1, 1);

            if (amount < 0) {
                // Interpolate to black
                amount = 1 + amount;
                _r = uint(MathUtil.clamp(_r * amount, 0, 255));
                _g = uint(MathUtil.clamp(_g * amount, 0, 255));
                _b = uint(MathUtil.clamp(_b * amount, 0, 255));
            }
            else {
                // Interpolate to white
                _r = uint(MathUtil.clamp(_r + (255 - _r) * amount, 0, 255));
                _g = uint(MathUtil.clamp(_g + (255 - _g) * amount, 0, 255));
                _b = uint(MathUtil.clamp(_b + (255 - _b) * amount, 0, 255));
            }
        }

        /**
         * Adjust the color towards a target color based on perceived brightness
         * @param targetColor The color to adjust towards (can be uint or Color)
         * @param amount Value between -1 and 1. Negative moves away from target, positive moves toward target
         * @return A new Color with adjusted perceived brightness
         */
        public function adjustPerceivedBrightness(toward:Color, amount:Number):void {
            amount = MathUtil.clamp(amount, -1, 1);

            // Get brightness difference
            var currentBrightness:Number = this.perceivedBrightness;
            var targetBrightness:Number = toward.perceivedBrightness;
            var brightnessDiff:Number = targetBrightness - currentBrightness;

            // Calculate color ratios for interpolation
            var rRatio:Number = toward.r / (toward.r + toward.g + toward.b || 1);
            var gRatio:Number = toward.g / (toward.r + toward.g + toward.b || 1);
            var bRatio:Number = toward.b / (toward.r + toward.g + toward.b || 1);

            if (amount < 0) {
                // Move away from target
                amount = -amount;
                rRatio = 1 - rRatio;
                gRatio = 1 - gRatio;
                bRatio = 1 - bRatio;
            }

            // Apply adjustment while maintaining target color ratios
            var adjustment:Number = brightnessDiff * amount;
            _r = uint(MathUtil.clamp(_r + adjustment * 255 * rRatio, 0, 255));
            _g = uint(MathUtil.clamp(_g + adjustment * 255 * gRatio, 0, 255));
            _b = uint(MathUtil.clamp(_b + adjustment * 255 * bRatio, 0, 255));
        }

        /**
         * Tint the color towards another color
         * @param color The target color to tint towards
         * @param amount Value between 0 and 1. 0 = original color, 1 = target color
         * @return A new Color with the applied tint (also affects alpha)
         */
        public function tint(color:Color, amount:Number):void {
            amount = MathUtil.clamp(amount);
            var or:int = _r;
            _r = uint(MathUtil.clamp(_r + (color.r - _r) * amount, 0, 255));
            _g = uint(MathUtil.clamp(_g + (color.g - _g) * amount, 0, 255));
            _b = uint(MathUtil.clamp(_b + (color.b - _b) * amount, 0, 255));
            _a = MathUtil.lerp(_a, color.a, amount);
        }

        /**
         * Interpolate the color an amount between two colors
         * @param color1        The first color
         * @param color2        The second color
         * @param amount        The amount of interpolation between 0 an 1. 0 = fully color1, 1 = fully color2.
         */
        public static function lerp(color1:Color, color2:Color, amount:Number):Color {
            var c:Color = color1.clone();
            c.tint(color2, amount);
            return c;
        }

        /**
         * Convert the color to HSL format
         * @return Object with h (0-360), s (0-1), l (0-1) properties
         */
        public function toHSL():Object {
            // Convert RGB to 0-1 range
            var r:Number = _r / 255;
            var g:Number = _g / 255;
            var b:Number = _b / 255;

            var max:Number = Math.max(r, g, b);
            var min:Number = Math.min(r, g, b);
            var h:Number, s:Number, l:Number;

            // Calculate lightness
            l = (max + min) / 2;

            if (max == min) {
                // Achromatic (gray)
                h = s = 0;
            }
            else {
                var d:Number = max - min;

                // Calculate saturation
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

                // Calculate hue
                switch (max) {
                    case r:
                        h = (g - b) / d + (g < b ? 6 : 0);
                        break;
                    case g:
                        h = (b - r) / d + 2;
                        break;
                    case b:
                        h = (r - g) / d + 4;
                        break;
                }
                h /= 6;
            }

            return {
                    h: h * 360, // Convert to degrees
                    s: s,
                    l: l
                };
        }

        /**
         * String representation of the color
         */
        public function toString(hex:Boolean = false):String {
            if (hex) {
                var h:String = "000000";
                var c:String = value.toString(16);
                return "Color( 0x" + h.substr(0, 6 - c.length) + c + ", " + _a + ")";
            }
            return "Color(R=" + _r + ", G=" + _g + ", B=" + _b + ", a=" + _a + ")";
        }
    }
}
