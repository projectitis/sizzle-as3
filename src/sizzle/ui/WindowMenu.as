package sizzle.ui {

    import sizzle.display.Color;
    import sizzle.geom.Anchor;
    import sizzle.ui.Widget;
    import sizzle.ui.IconButton;
    import sizzle.Game;

    public class WindowMenu extends Widget {

        public var btnResize:IconButton;

        public function WindowMenu() {
            anchor.position = Anchor.TR;
            containerOnly = true;

            graphics.beginFill(0x303030);
            graphics.drawRect(-300, 0, 300, 24);
            graphics.endFill();

            btnResize = new IconButton(IconButton.ICON_RESIZE, new Color(Color.WHITE_SMOKE));
            addChild(btnResize);
            btnResize.x = -12;
            btnResize.y = 12;
            btnResize.onDown = _startResize;
        }

        private function _startResize():void {
            if (stage) {
                stage.nativeWindow.startResize("TR");
            }
        }
    }
}