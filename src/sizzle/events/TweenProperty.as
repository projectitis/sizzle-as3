package sizzle.events {

    public class TweenProperty {
        public var name:String;
        private var _begin:Number;
        public var change:Number;
        public var end:Number;

        public function TweenProperty(name:String, end:Number) {
            this.name = name;
            this.end = end;
        }
        public function set begin(value:Number):void {
            this._begin = value;
            this.change = end - _begin;
        }
        public function get begin():Number {
            return _begin;
        }
    }

}