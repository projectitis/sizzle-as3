package sizzle.events {

	import sizzle.pooling.IPooled;
	import sizzle.pooling.Pool;

	/**
	 * Update is a callback that fires every frame.
	 */
	public class Update implements IPooled {

		// #region Pooling

		/**
		 * Callback to recycle object back to pool
		 */
		public var onRecycle:Function;

		/**
		 * Initialize the Listener with a callback.
		 * @param eventId   The ID of the event to listen for.
		 * @param callback  The function to call when triggered. Function(eventId:int, data:Object):Boolean
		 *                  The function should return false to stop listening.
		 * @param data      An object to supply when the callback is triggered. Depending on the event type, additional
		 *                  fields may be added to the object.
		 **/
		public function init(...rest):void {
			_remove = false;
			_callback = rest[0] as Function;
		}

		/**
		 * Reset Listener to defaults
		 */
		public function reset():void {
			_callback = null;
		}

		// #endregion Pooling
		// #region Class

		// Next update in the linked list
		public var next:Update;

		// Callback function to be called every frame. Function(dt:Number):Boolean
		// The function should return false to remove itself from the update list.
		private var _callback:Function;

		// This update has been flagged for removal
		private var _remove:Boolean;

		/**
		 * Create a new update with the given callback.
		 * @param callback The function to call every frame. Function(dt:Number):Boolean
		 *                 The function should return false to remove itself from the update list.
		 **/
		public function Update(callback:Function = null) {
			init(callback);
		}

		/**
		 * Push a new update onto the end of the list.
		 * @param update The update to push onto the list.
		 **/
		public function push(update:Update):void {
			if (next == null)
				next = update;
			else
				next.push(update);
		}

		/**
		 * Remove a callback from the list.
		 * @param callback The callback to remove.
		 * @param removeFirstOnly If true, only remove the first occurrence of the callback.
		 * @return The next update in the list after the removed update, or null if this was the last update.
		 **/
		public function remove(callback:Function, removeFirstOnly:Boolean):Update {
			// Remove this callback?
			if (_callback == callback) {
				if ((!removeFirstOnly) && (next != null)) {
					next = next.remove(callback, removeFirstOnly);
				}
				_remove = true;
				return next;
			}
			if (next != null) {
				next = next.remove(callback, removeFirstOnly);
			}
			return this;
		}

		/**
		 * Update this update and all subsequent updates in the list.
		 * @param dt The delta time since the last update.
		 **/
		public function update(dt:Number):Update {
			// If this update is flagged for removal, remove it and continue to the next update.
			if (_remove) {
				var tempNext:Update = next;
				onRecycle(this);
				if (tempNext != null) {
					return tempNext.update(dt);
				}
				return null;
			}

			var remove:Boolean = false;
			if (_callback != null) {
				_remove = (_callback(dt) === false) || _remove;
			}
			if (next != null) {
				next = next.update(dt);
			}
			return this;
		}

		// #endregion Class

	}

}