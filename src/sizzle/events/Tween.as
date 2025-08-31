package sizzle.events {

	import sizzle.pooling.IPooled;
	import sizzle.pooling.Pool;
	import sizzle.easing.*;
	import sizzle.events.TweenProperty;
	import sizzle.utils.Log;

	public class Tween implements IPooled {

		// #region Pooling

		/**
		 * Callback to recycle object back to pool
		 */
		public var onRecycle:Function;

		/**
		 * Initialize the Tween with the provided parameters
		 * @param	clip		The clip to apply the tweens to
		 * @param	args		The properties to tween and their end values
		 * @param	duration	The duration of the tween (seconds)
		 * @param	delay		The delay before the tween starts (seconds)
		 * @param	tween		The easing function to use for the tween
		 * @param	callback	The callback function to call when the tween is finished
		 * @param	callbackArgs	The arguments to pass to the callback function
		 */
		public function init(...rest):void {
			_clip = rest[0];
			_duration = Math.max(0, rest[2]);
			_durationScale = _duration == 0 ? 1 : 1 / _duration;
			_progress = -Math.max(0, rest[3]);
			_tween = (rest[4] != null) ? rest[4] : Quad.easeOut;
			_callback = rest[5] as Function;
			_callbackArgs = rest[6];
			_props = new Vector.<TweenProperty>();
			for (var key:String in rest[1]) {
				_props.push(new TweenProperty(key, rest[1][key]));
			}
			_started = false;
			_finished = false;
		}

		/**
		 * Reset Listener to defaults
		 */
		public function reset():void {
			next = null;
			_callback = null;
			_callbackArgs = null;
			_clip = null;
			_tween = null;
			_props = null;
			_prop = null;
		}

		// #endregion Pooling
		// #region Class

		public var next:Tween;

		private var _clip:Object;
		private var _duration:Number;
		private var _durationScale:Number;
		private var _progress:Number;

		private var _callback:Function;
		private var _callbackArgs:Array;
		private var _tween:Function;
		private var _props:Vector.<TweenProperty>;
		private var _prop:TweenProperty;
		private var _started:Boolean;
		private var _finished:Boolean;

		/**
		 * Create a new Tween
		 * @param	clip		The clip to apply the tweens to
		 * @param	args		The properties to tween and their end values
		 * @param	duration	The duration of the tween (seconds)
		 * @param	delay		The delay before the tween starts (seconds)
		 * @param	tween		The easing function to use for the tween
		 * @param	callback	The callback function to call when the tween is finished
		 * @param	callbackArgs	The arguments to pass to the callback function
		 */
		public function Tween(clip:Object = null, args:Object = null, duration:Number = 0, delay:Number = 0, tween:Function = null, callback:Function = null, callbackArgs:Array = null) {
			init(clip, args, duration, delay, tween, callback, callbackArgs);
			next = null;
		}

		/**
		 * Get the clip that this tween applies to
		 * @return	The clip object
		 */
		public function get clip():Object {
			return _clip;
		}

		/**
		 * Add a new tween to the end of the linked list
		 * @param	tween	The tween to add
		 */
		public function push(tween:Tween):void {
			if (next == null) {
				next = tween;
			}
			else {
				next.push(tween);
			}
		}

		/**
		 * Remove this tween if it matches the specified arguments
		 * @param	clip	The clip to remove tweens from
		 * @param	args	The args to stop tweening (or null to remove all)
		 * @return	The new first tween in the linked list
		 */
		public function remove(clip:Object, args:Object = null):Tween {
			// Remove this tween?
			var remove:Boolean = false;
			if (_clip == clip) {
				// Check if we are finished, because we will be removed anyway
				if (!_finished) {
					// Remove certain arguments only
					if (args != null) {
						remove = removeProperty(args);
					}
					// Remove all args
					else {
						remove = true;
					}
				}
			}
			if (next != null) {
				next = next.remove(clip, args);
			}
			if (remove) {
				var tempNext:Tween = next;
				onRecycle(this);
				return tempNext;
			}
			return this;
		}

		/**
		 * Remove the properties from the tween that match the specified args
		 * @param	args	The args to remove
		 * @return	True if all properties were removed, false if some remain
		 */
		public function removeProperty(args:Object):Boolean {
			var i:int = 0;
			while (i < _props.length) {
				if (args[_props[i].name] != undefined) {
					if (args[_props[i].name] != null) {
						_clip[_props[i].name] = args[_props[i].name];
					}
					_props.splice(i, 1);
				}
				else {
					i++;
				}
			}
			return (_props.length == 0);
		}

		/**
		 * Update each tween. Will perform tweens if the delay time has passed.
		 * Remove the tween automatically once complete
		 * and return the new first tween in the linked list
		 * @param	dt	The delta time since last update (seconds)
		 * @return	The new first tween in the linked list
		 **/
		public function update(dt:Number):Tween {
			_progress += dt;
			if (_progress >= 0) {
				// Initialise beginning values of properties when starting the tween. This
				// takes into account any movement of the clip before the tween starts.
				if (!_started) {
					for each (_prop in _props) {
						_prop.begin = _clip[_prop.name];
					}
					_started = true;
				}
				if (_progress >= _duration) {
					_progress = _duration;
					_finished = true;
				}
				for each (_prop in _props) {
					_clip[_prop.name] = _prop.begin + _tween(_progress * _durationScale) * _prop.change;
				}
				if (_finished) {
					if (_callback != null) {
						if (_callbackArgs != null) {
							_callback.apply(null, _callbackArgs);
						}
						else {
							_callback();
						}
					}
				}
			}
			if (next != null) {
				next = next.update(dt);
			}
			if (_finished) {
				var tempNext:Tween = next;
				onRecycle(this);
				return tempNext;
			}
			return this;
		}

		// #endregion Class

	}

}