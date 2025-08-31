package sizzle.utils {
    function assert(condition:*, message:String = ""):void {
        CONFIG::Debug {
            if (!condition) {
                throw new Error("Assertion failed: " + message);
            }
        }
    }
}