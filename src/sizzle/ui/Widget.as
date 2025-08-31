package sizzle.ui {
    import sizzle.display.Interactive;
    import sizzle.geom.Anchor;

    public class Widget extends Interactive {
        public var anchor:Anchor = new Anchor();

        public function Widget(anchor:Anchor = null) {
            if (anchor) {
                this.anchor.copyFrom(anchor);
            }
        }

        /**
         * Clean up when no longer needed
         */
        public function destroy():void {
        }
    }
}