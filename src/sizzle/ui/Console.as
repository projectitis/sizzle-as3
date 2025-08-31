package sizzle.ui {

    import flash.text.TextField;
    import flash.text.TextFormat;

    import sizzle.display.Color;
    import sizzle.geom.Anchor;
    import sizzle.ui.Widget;
    import sizzle.utils.Log;
    import sizzle.Game;

    public class Console extends Widget {
        private var _textfield:TextField;
        private var _color:Color;
        private var _w:Number = 0;
        private var _h:Number = 0;

        public var autoscroll:Boolean = true;

        public function Console(color:Color) {
            super();

            anchor.position = Anchor.TL;

            _color = color;

            // Create the text field with specified properties
            _textfield = new TextField();
            _textfield.x = 16;
            _textfield.y = 16;
            _textfield.multiline = true;
            _textfield.wordWrap = true;
            _textfield.border = false;
            _textfield.background = false;
            _textfield.defaultTextFormat = new TextFormat("Courier New", 12);

            // Set contrasting text color
            var luminance:Number = (0.299 * color.r + 0.587 * color.g + 0.114 * color.b) / 255;
            _textfield.textColor = luminance > 0.5 ? 0x000000 : 0xFFFFFF;

            addChild(_textfield);
        }

        public function setSize(w:Number, h:Number):void {
            _w = Math.abs(w);
            _h = Math.abs(h);
            graphics.clear();
            graphics.beginFill(_color.value, _color.a);
            graphics.drawRect(0, 0, _w, _h);
            graphics.endFill();

            _textfield.width = _w - 32;
            _textfield.height = _h - 32;
        }

        public function show():void {
            parent.setChildIndex(this, parent.numChildren - 1);
            visible = true;
            _textfield.selectable = true;
        }

        public function hide():void {
            visible = false;
            _textfield.selectable = false;
        }

        public function log(...args):void {
            if (args.length == 0) {
                return;
            }
            args = Log.arrayToStrings(args);
            _textfield.appendText(args.join(', ') + "\n");
            if (autoscroll) {
                _textfield.scrollV = _textfield.maxScrollV;
            }
        }

        public function logStrings(...args):void {
            if (args.length == 0) {
                return;
            }
            _textfield.appendText(args.join(', ') + "\n");
            if (autoscroll) {
                _textfield.scrollV = _textfield.maxScrollV;
            }
        }
    }
}