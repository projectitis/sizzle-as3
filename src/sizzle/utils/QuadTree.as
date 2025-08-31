package sizzle.utils {
    public class QuadTree {
        public var value:*;
        public var parent:QuadTree;
        public var size:int = 0;
        public var level:int = 0;
        public var v0:QuadTree;
        public var v1:QuadTree;
        public var v2:QuadTree;
        public var v3:QuadTree;

        public function search(x:int, y:int):* {
            // Check if we are at a leaf
            if (size == 1) {
                return value;
            }
            var hx:int = x >> 1;
            var hy:int = y >> 1;
            if (rx == 0) {
                if (ry == 0) {
                    // Top left
                    return v0 ? v0.search(x, y) : null;
                }
                else {
                    // Bottom left
                    return v2 ? v2.search(x, y) : null;
                }
            }
            else {
                if (ry == 0) {
                    // Top right
                    return v1 ? v1.search(x, y) : null;
                }
                else {
                    // Bottom right
                    return v3 ? v3.search(x, y) : null;
                }
            }
        }

    }
}