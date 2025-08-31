package sizzle.utils {

    import flash.utils.getQualifiedClassName;
    import flash.display.DisplayObject;

    import sizzle.Game;
    import sizzle.display.Color;

    public class Log {

        public static function info(...args):void {
            if (args.length == 0) {
                return;
            }
            trace.apply(null, arrayToStrings(args));
        }

        public static function arrayToStrings(args:Array):Array {
            for (var i:int = 0; i < args.length; i++) {
                if (getQualifiedClassName(args[i]) == "Object") {
                    args[i] = _objectToString(args[i]);
                }
            }
            return args;
        }

        private static function _objectToString(obj:Object):String {
            var str:String = "";
            for (var key:String in obj) {
                var value:String = "";
                if (getQualifiedClassName(obj[key]) == "Object") {
                    value = _objectToString(obj[key]);
                }
                else {
                    value = obj[key];
                }
                str += key + ": " + value + ", ";
            }
            return "{" + str.slice(0, -2) + "}"; // Remove trailing comma and space
        }
    }
}
