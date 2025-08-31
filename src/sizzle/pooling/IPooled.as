package sizzle.pooling {
    /**
     * An interface for a pooled object
     * A pooled object MUST have a zero argument constructor (or have default values for all constructor args).
     * init will be called with arguments directly after construction.
     */
    public interface IPooled {

        /**
         * Initialise the object after it's taken from the pool
         */
        function init(...rest):void;

        /**
         * Reset an object that is being returned to the pool (recycled)
         */
        function reset():void;
    }
}