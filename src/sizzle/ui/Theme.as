package sizzle.ui {

    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.AntiAliasType;
    import sizzle.ui.ButtonType;
    import sizzle.utils.Assert;

    public class Theme {

        // Style sheets for each button type
        private var _styleSheet:Vector.<StyleSheet> = new Vector.<StyleSheet>();

        // Base theme colors
        private var _panel:Vector.<Color> = new Vector.<Color>(3);
        private var _primary:Vector.<Color> = new Vector.<Color>(3);
        private var _secondary:Vector.<Color> = new Vector.<Color>(3);
        private var _neutral:Vector.<Color> = new Vector.<Color>(3);
        private var _warning:Vector.<Color> = new Vector.<Color>(3);
        private var _textLight:Color;
        private var _textDark:Color;

        /**
         * Create a predefined theme from one of the built in types
         */
        public static function create(type:int):Theme {
            switch (type) {
                case 0:
                default:
                    return new Theme(
                            0x353531, // panel
                            0xB7245C, // primary
                            0xE4B1AB, // secondary
                            0xFFDBDA, // neutral
                            0xDCA450, // warning
                            0xFDEDED, // light
                            0x1D1D1B // dark
                        );
            }
        }

        /**
         * Theme constructor
         */
        public function Theme(panel:Color, primary:Color, secondary:Color, neutral:Color, warning:Color, textLight:Color, textDark:Color) {
            assert(panel && primary && secondary && neutral && warning && textLight && textDark, "All colors are required");
            changeColors(panel, primary, secondary, neutral, warning, textLight, textDark);
        }

        /**
         * Change the theme colors and rebuild the theme
         */
        public function changeColors(panel:Color, primary:Color, secondary:Color, neutral:Color, warning:Color, textLight:Color, textDark:Color):void {
            _panel[0] = panel ? panel : _panel[0];
            _primary[0] = primary ? panel : _primary[0];
            _secondary[0] = secondary ? panel : _secondary[0];
            _neutral[0] = neutral ? panel : _neutral[0];
            _warning[0] = warning ? panel : _warning[0];
            _textLight = textLight ? panel : _textLight;
            _textDark = textDark ? panel : _textDark;
            _build();
        }

        /**
         * Calculate all theme colors from the base colors
         */
        private function _build():void {
            if (_panel[0].perceivedBrightness < 0.5) {
                _panel[1] = _panel[0].clone().adjustPerceivedBrightness(_textLight, 0.05);
                _panel[2] = _panel[0].clone().adjustPerceivedBrightness(_textLight, 0.1);
            }
            else {
                _panel[1] = _panel[0].clone().adjustPerceivedBrightness(_textLight, -0.05);
                _panel[2] = _panel[0].clone().adjustPerceivedBrightness(_textLight, -0.1);
            }
            _buildShades(_primary);
            _buildShades(_secondary);
            _buildShades(_neutral);
            _buildShades(_warning);
        }

        /**
         * Creates two shades of a base color for hover and down states
         */
        private function _buildShades(colors:Vector.<Color>):void {
            if (colors[0].perceivedBrightness < 0.5) {
                colors[1] = colors[0].clone().adjustPerceivedBrightness(_textLight, 0.05);
                colors[2] = colors[0].clone().adjustPerceivedBrightness(_textLight, 0.2);
            }
            else {
                colors[1] = colors[0].clone().adjustPerceivedBrightness(_textDark, -0.05);
                colors[2] = colors[0].clone().adjustPerceivedBrightness(_textDark, -0.2);
            }
        }

        /**
         * Create a new textfield with the current theme
         */
        public function createLabel(text:String, type:ButtonType = NORMAL):TextField {
            var tf:TextField = new TextField();
            tf.text = text;
            tf.autoSize = TextFieldAutoSize.CENTER;
            tf.antiAliasType = AntiAliasType.ADVANCED;
            tf.styleSheet = _styleSheet[type];
        }

    }
}