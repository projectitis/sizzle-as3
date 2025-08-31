package sizzle.physics {

    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.geom.Point;

    import sizzle.Game;
    import sizzle.physics.Body;

    public class World extends Sprite {

        // Gravity vector
        public var gravity:Point;

        // Pixels per meter
        public var ppm:Number = 100;

        /**
         * Constructor for the World class.
         * @param gravityX  The x component of the gravity vector (metres per second squared).
         * @param gravityY  The y component of the gravity vector (metres per second squared).
         * @param ppm       Pixels per meter for scaling physics calculations.
         */
        public function World(ppm:Number = 100, gravityX:Number = 0, gravityY:Number = 9.8) {
            this.gravity = new Point(gravityX, gravityY);
            this.ppm = ppm;

            Game.context.addUpdate(update);
        }

        public function destroy():void {
            Game.context.removeUpdate(update);
            while (numChildren > 0) {
                var child:DisplayObject = removeChildAt(0);
                if (child is Body) {
                    (child as Body).recycle();
                }
            }
        }

        /**
         * Update the physics world.
         * @param dt The time delta for the update.
         * @return False if the update should be removed from the update list, true otherwise.
         */
        public function update(dt:Number):Boolean {
            // Update logic for all bodies in the world
            for (var i:int = 0; i < numChildren; i++) {
                var child:DisplayObject = getChildAt(i);
                if (child is Body) {
                    (child as Body).update(this, dt);
                }
            }
            return true;
        }
    }
}
