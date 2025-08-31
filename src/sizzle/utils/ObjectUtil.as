package sizzle.utils {

    import flash.utils.getQualifiedClassName;

    public class ObjectUtil {

        /**
         * Merge the items from src into dest
         * @param dest      The object to copy to
         * @param src       The object to copy from
         * @param deep      If false will perform a shallow merge, otherwise a deep merge is performed
         **/
        public static function merge(dest:Object, src:Object, deep:Boolean = false):void {
            for (var key:String in src) {
                if (deep && getQualifiedClassName(src[key]) == "Object") {
                    if (dest[key] == undefined || getQualifiedClassName(dest[key]) != "Object") {
                        dest[key] = {};
                    }
                    merge(dest[key], src[key], deep);
                }
                else {
                    dest[key] = src[key];
                }
            }
        }

        /**
         * Combine the objects into a new object and return it. Objects are combines left to right, with later
         * properties overwriting earlier ones.
         * @param objects   The objects to combine
         * @param deep      If the last argument is true or false, this specifies whether to perform a deep copy.
         * @return The combined object
         **/
        public static function combine(...objects):Object {
            var deep:Boolean = false;
            if (objects.length > 0) {
                if (objects[objects.length - 1] is Boolean) {
                    deep = (objects.pop() === true);
                }
            }
            var dest:Object = {};
            for each (var src:Object in objects) {
                merge(dest, src, deep);
            }
            return dest;
        }

        /**
         * Merge the properties from src into dest. Only performs a shallow merge
         * @param dest      The object to copy to
         * @param src       The object to copy from
         **/
        public static function mergeProperties(dest:Object, src:Object):void {
            for (var key:String in src) {
                if (src.hasOwnProperty(key)) {
                    dest[key] = src[key];
                }
            }
        }

        /**
         * Copy an object
         * @param o     The object to copy
         * @param deep  If false will perform a shallow copy, otherwise a deep copy is performed
         * @return The new object
         **/
        public static function copy(o:Object, deep:Boolean = false):Object {
            var c:Object = {};
            merge(c, o, deep);
            return c;
        }
    }
}