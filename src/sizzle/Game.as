package sizzle {

	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import sizzle.Letterbox;
	import sizzle.events.Listener;
	import sizzle.events.Listeners;
	import sizzle.events.Tween;
	import sizzle.events.Tweens;
	import sizzle.events.Timer;
	import sizzle.events.Timers;
	import sizzle.events.Update;
	import sizzle.events.Updates;
	import sizzle.display.Canvas;
	import sizzle.display.Color;
	import sizzle.pooling.PoolManager;
	import sizzle.ui.Console;
	import sizzle.ui.UICanvas;
	import sizzle.ui.WindowMenu;
	import sizzle.utils.ObjectUtil;
	import sizzle.utils.Log;

	/**
	 * Game class manages the game loop and event messaging.
	 **/
	public class Game extends Sprite {

		// The global pool manager
		public var pools:PoolManager;

		// Event listeners
		public var listeners:Listeners;

		// Updates are triggered every frame
		public var updates:Updates;

		// Tween messages are used for animations
		public var tweens:Tweens;

		// Timers trigger delayed callbacks
		public var timers:Timers;

		// Timing variables
		private var _deltaTime:Number = 0;
		private var _deltaTimeMS:int = 0;
		private var _lastTimeMS:int = 0;
		private var _thisTimeMS:int = 0;
		private var _scaledTimeMS:int = 0;
		private var _timeScale:Number = 1;

		// Paused variables
		private var _paused:Boolean = false;
		private var _pauseStartTime:int = 0;

		// Screens size properties
		private var _targetSize:Point;
		private var _maxSize:Point;
		private var _sizeDiff:Point;

		// Canvas the game is drawn on (nothing should be drawn on the stage directly)
		public var canvas:Canvas;

		// Canvas the UI is drawn on (nothing should be drawn on the stage directly). This
		// is always positioned to the top corner of the screen (within the letterbox).
		public var uiCanvas:UICanvas;

		// Letter box over the canvas (if active)
		public var letterbox:Letterbox;

		// Window menu
		public var windowMenu:WindowMenu;

		// Debug console
		CONFIG::debug {
			public var console:Console;
		}

		// Temp vars to optimise memory
		private var _globalMousePos:Point = new Point();

		public function Game(targetSize:Point, maxSize:Point = null) {
			_targetSize = targetSize.clone();
			_maxSize = (maxSize == null) ? targetSize.clone() : maxSize.clone();
			_sizeDiff = new Point((_maxSize.x - _targetSize.x) * 0.5, (_maxSize.y - _targetSize.y) * 0.5);

			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// Make this an option
			// stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

			pools = new PoolManager();
			listeners = new Listeners(pools);
			updates = new Updates(pools);
			tweens = new Tweens(pools);
			timers = new Timers(pools);

			_timeScale = 1;
			_scaledTimeMS = 0;

			canvas = new Canvas(listeners);
			addChild(canvas);

			letterbox = new Letterbox();
			addChild(letterbox);
			letterbox.active = true;

			uiCanvas = new UICanvas(listeners);
			addChild(uiCanvas);
			CONFIG::debug {
				console = new Console(new Color(0x000000, 0.9));
				uiCanvas.addChild(console);
			}

			windowMenu = new WindowMenu();
			uiCanvas.addChild(windowMenu);
			windowMenu.visible = false;

			_paused = true;
			_pauseStartTime = 0;
			pause = false;

			stage.addEventListener(Event.ENTER_FRAME, _update);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _handleKeyboardEvent, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, _handleKeyboardEvent, true);
			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.CONTEXT_MENU, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MIDDLE_CLICK, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL_HORIZONTAL, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, _handleMouseEvent, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, _handleMouseEvent, true);
			stage.nativeWindow.addEventListener(Event.RESIZE, _resized);
			stage.nativeWindow.dispatchEvent(new Event(Event.RESIZE));
		}

		public function destroy():void {
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.removeEventListener(Event.ENTER_FRAME, _update);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, _handleKeyboardEvent, true);
			stage.removeEventListener(KeyboardEvent.KEY_UP, _handleKeyboardEvent, true);
			stage.removeEventListener(MouseEvent.CLICK, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.CONTEXT_MENU, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.DOUBLE_CLICK, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MIDDLE_CLICK, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MOUSE_OUT, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MOUSE_OVER, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL_HORIZONTAL, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.RELEASE_OUTSIDE, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, _handleMouseEvent, true);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, _handleMouseEvent, true);
			stage.nativeWindow.removeEventListener(Event.RESIZE, _resized);
			removeChild(canvas);
			canvas.destroy();
			uiCanvas.removeChild(windowMenu);
			windowMenu.destroy();
			windowMenu = null;
			removeChild(uiCanvas);
			uiCanvas.destroy();
			removeChild(letterbox);
			listeners.clear();
			listeners = null;
			updates.clear();
			updates = null;
			tweens.clear();
			tweens = null;
			timers.clear();
			timers = null;
			pools.clear();
			pools = null;
		}

		/**
		 * Get the current time scale of the game.
		 */
		public function get timeScale():Number {
			return _timeScale;
		}

		/**
		 * Set the time scale of the game.
		 * A value of 1 means normal speed, 0.5 means half speed, etc.
		 */
		public function set timeScale(value:Number):void {
			_timeScale = value;
		}

		/**
		 * Get the current game time in milliseconds.
		 * This takes the time scale into account.
		 */
		public function get time():int {
			return _scaledTimeMS;
		}

		/**
		 * Set the pause state of the game.
		 */
		public function set pause(value:Boolean):void {
			if (_paused == value)
				return;

			if (value) {
				_pauseStartTime = getTimer();
			}
			else {
				// Calculate the amount of pause
				if (_pauseStartTime > 0) {
					var pauseTime:int = getTimer() - _pauseStartTime;

					_pauseStartTime = 0;
				}
				_lastTimeMS = getTimer();
			}
			_paused = value;
		}

		/**
		 * The window has been resized
		 */
		private function _resized(event:Event):void {
			event.stopImmediatePropagation();

			var f:Number = Math.min(stage.stageWidth / _targetSize.x, stage.stageHeight / _targetSize.y);
			canvas.scaleX = canvas.scaleY = f;
			if (uiCanvas.scaleWithGame) {
				uiCanvas.scaleX = uiCanvas.scaleY = f;
			}
			else {
				uiCanvas.scaleX = uiCanvas.scaleY = 1;
			}
			var cw:Number = _maxSize.x * f;
			var ch:Number = _maxSize.y * f;
			var dx:Number = (stage.stageWidth - cw) * 0.5;
			var dy:Number = (stage.stageHeight - ch) * 0.5;
			canvas.x = uiCanvas.x = dx + _sizeDiff.x * f;
			canvas.y = uiCanvas.y = dy + _sizeDiff.y * f;

			var vw:Number = Math.min(stage.stageWidth, cw);
			var vh:Number = Math.min(stage.stageHeight, ch);
			letterbox.update(vw, vh);

			vw /= f;
			vh /= f;
			var b:Rectangle = new Rectangle((_targetSize.x - vw) * 0.5, (_targetSize.y - vh) * 0.5, vw, vh);
			canvas.bounds = b;
			if (uiCanvas.scaleWithGame) {
				uiCanvas.bounds = b;
			}
			else {
				uiCanvas.bounds = new Rectangle((_targetSize.x - vw) * 0.5 * f, (_targetSize.y - vh) * 0.5 * f, vw * f, vh * f);
			}

			listeners.trigger(Listener.RESIZE, {
						canvasX: canvas.bounds.x,
						canvasY: canvas.bounds.y,
						canvasWidth: canvas.bounds.width,
						canvasHeight: canvas.bounds.height,
						windowX: uiCanvas.bounds.x,
						windowY: uiCanvas.bounds.y,
						windowWidth: uiCanvas.bounds.width,
						windowHeight: uiCanvas.bounds.height
					});
		}

		/**
		 * Process keyboard event
		 */
		private function _handleKeyboardEvent(event:KeyboardEvent):void {
			event.stopImmediatePropagation();
			var data:Object = {
					altKey: event.altKey,
					charCode: event.charCode,
					commandKey: event.commandKey,
					controlKey: event.controlKey,
					ctrlKey: event.ctrlKey,
					functionKey: event.functionKey,
					keyCode: event.keyCode,
					keyLocation: event.keyLocation,
					shiftKey: event.shiftKey,
					globalMousePos: _globalMousePos,
					time: _scaledTimeMS
				};
			listeners.trigger(Listener.EVENT_MAP[event.type], data);
		}

		/**
		 * Process mouse event
		 */
		private function _handleMouseEvent(event:MouseEvent):void {
			event.stopImmediatePropagation();
			_globalMousePos.setTo(event.stageX, event.stageY);
			var buttonType:int = Listener.MOUSE_BUTTON_LEFT;
			var eventId:int = 0;
			switch (event.type) {
				case MouseEvent.MIDDLE_CLICK:
					buttonType = Listener.MOUSE_BUTTON_MIDDLE;
					eventId = Listener.MOUSE_CLICK;
					break;
				case MouseEvent.MIDDLE_MOUSE_DOWN:
					buttonType = Listener.MOUSE_BUTTON_MIDDLE;
					eventId = Listener.MOUSE_DOWN;
					break;
				case MouseEvent.MIDDLE_MOUSE_UP:
					buttonType = Listener.MOUSE_BUTTON_MIDDLE;
					eventId = Listener.MOUSE_UP;
					break;
				case MouseEvent.RIGHT_CLICK:
					buttonType = Listener.MOUSE_BUTTON_RIGHT;
					eventId = Listener.MOUSE_CLICK;
					break;
				case MouseEvent.RIGHT_MOUSE_DOWN:
					buttonType = Listener.MOUSE_BUTTON_RIGHT;
					eventId = Listener.MOUSE_DOWN;
					break;
				case MouseEvent.RIGHT_MOUSE_UP:
					buttonType = Listener.MOUSE_BUTTON_RIGHT;
					eventId = Listener.MOUSE_UP;
					break;
				default:
					eventId = Listener.EVENT_MAP[event.type];
			}
			var data:Object = {
					altKey: event.altKey,
					commandKey: event.commandKey,
					controlKey: event.controlKey,
					ctrlKey: event.ctrlKey,
					shiftKey: event.shiftKey,
					clickCount: event.clickCount,
					delta: event.delta,
					movementX: event.movementX,
					movementY: event.movementY,
					x: event.stageX,
					y: event.stageY,
					buttonType: buttonType,
					globalMousePos: _globalMousePos,
					time: _scaledTimeMS
				};
			listeners.trigger(eventId, data);
		}

		/**
		 * The main game loop
		 */
		private function _update(event:Event):void {
			event.stopImmediatePropagation();
			if (_paused)
				return;

			// Timing
			_thisTimeMS = getTimer();
			_deltaTimeMS = uint((_thisTimeMS - _lastTimeMS) * _timeScale);
			_lastTimeMS = _thisTimeMS;
			_deltaTime = _deltaTimeMS * 0.001;
			_scaledTimeMS += _deltaTimeMS;

			// Process canvases
			canvas.processUpdate(_deltaTime);
			uiCanvas.processUpdate(_deltaTime);

			// Process frame updates
			updates.update(_deltaTime);

			// Process timers
			timers.update(_deltaTime);

			// Process tweens
			tweens.update(_deltaTime);
		}

	}

}