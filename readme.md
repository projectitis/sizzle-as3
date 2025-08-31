# Sizzle

Game development framework for Adobe AIR.

## Getting started

Inherit from Game and pass in the target screen size.
Add an update listener and implement the game loop.

```as3
package {
    import sizzle.Game;

    [SWF(width="640", height="480")]
    public class Main extends Game {

        // Entry point
        public function Main():void {
            // Initialise target screen size. This means:
            // - Always display the area within the 640x480 (safe area)
            // - Display additional stage up to 800x600, then letterbox the rest
            super(new Point(640, 480), new Point(800, 600));

            // Listen for updates
            updates.add(update);
        }

        // Loop
        public function update(dt:Number):Boolean {
            // Perform game loop here

            // Keep responding to updates
            return true;
        }

    }
}
```