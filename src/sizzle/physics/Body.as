package sizzle.physics {

    import flash.display.Sprite;
    import flash.geom.Point;

    import sizzle.pooling.IPooled;
    import sizzle.pooling.Pool;
    import sizzle.physics.World;
    import sizzle.utils.DisplayObjectUtil;

    public class Body extends Sprite implements IPooled {

        // #region Pooling

        /**
         * Initialise the body with starting values.
         */
        public function init(mass:Number = 1):void {
            this.mass = mass;
            this.velocity.setTo(0, 0);
            this.acceleration.setTo(0, 0);
        }

        /**
         * Reset Listener to defaults
         */
        public function reset():void {
            // Remove from display list if added
            if (parent) {
                parent.removeChild(this);
            }

            // Reset properties
            DisplayObjectUtil.reset(this);
        }

        // #endregion Pooling
        // #region Class

        // Properties of the body
        public var mass:Number;
        public var velocity:Point = new Point();
        public var acceleration:Point = new Point();

        /**
         * Constructor for the Body class.
         * @param mass The mass of the body.
         */
        public function Body(mass:Number = 1) {
            _init(mass);
        }

        /**
         * Update the body physics.
         * @param world The physics world this body belongs to.
         * @param dt The time delta for the update.
         */
        public function update(world:World, dt:Number):void {
            // Apply gravity
            acceleration.x = world.gravity.x * mass;
            acceleration.y = world.gravity.y * mass;

            // Apply acceleration
            velocity.x += acceleration.x * dt;
            velocity.y += acceleration.y * dt;

            // Update position
            x += velocity.x * dt * world.ppm;
            y += velocity.y * dt * world.ppm;

            // Check for collisions or other physics interactions here
        }

        // ######################################################
        // #endregion Class
        // ######################################################
    }
}