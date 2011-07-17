package com.destroytoday.destroytwitter.view.notification
{
	import com.destroytoday.destroytwitter.constants.NotificationPosition;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.util.ApplicationUtil;
	import com.gskinner.motion.GTween;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	public class NotificationWindow extends NativeWindow
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const displayedChanged:Signal = new Signal(Boolean);
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var content:NotificationWindowContent;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _bounds:Rectangle = new Rectangle(0.0, 0.0, 324.0);
		
		protected var timer:Timer = new Timer(9000.0, 1);
		
		protected var _displayed:Boolean;
		
		protected var _position:String;
		
		protected var mouseOver:Boolean;
		
		protected var screenBottom:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NotificationWindow()
		{
			//--------------------------------------
			//  set properties
			//--------------------------------------
			
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			
			initOptions.type = NativeWindowType.LIGHTWEIGHT;
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.transparent = true;
			initOptions.maximizable = false;
			initOptions.minimizable = false;
			initOptions.resizable = false;
			
			super(initOptions);
			
			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			
			content = stage.addChild(new NotificationWindowContent()) as NotificationWindowContent;
			
			//--------------------------------------
			//  set properties
			//--------------------------------------
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			title = "DestroyTwitter Notification"
			
			width = 324.0;
			height = 100.0;
			visible = false;
			
			maskHeight = 0.0;
			
			//--------------------------------------
			//  add listeners
			//--------------------------------------
			
			stage.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function get width():Number
		{
			return (closed) ? 0.0 : super.width;
		}
		
		override public function get height():Number
		{
			return (closed) ? 0.0 : super.height;
		}
		
		override public function get visible():Boolean
		{
			return (closed) ? false : super.visible;
		}
		
		public function get displayed():Boolean
		{
			return _displayed;
		}
		
		public function set displayed(value:Boolean):void
		{
			_displayed = value;
			
			content.validateNow();
			
			height = Math.max(height, content.height);
			var maskHeight:Number;
			var onComplete:Function;
			
			if (_displayed)
			{
				var bounds:Rectangle = Screen.mainScreen.visibleBounds;

				x = bounds.right - (width + 40.0);
				
				if (_position == NotificationPosition.TOP)
				{
					y = bounds.top;
				}
				else if (ApplicationUtil.mac)
				{
					screenBottom = Screen.mainScreen.bounds.bottom;
				}
				else
				{
					screenBottom = Screen.mainScreen.visibleBounds.bottom;
				}
				
				visible = true;
				content.visible = true;
				alwaysInFront = true;
				
				maskHeight = content.height;
				
				timer.reset();
				timer.start();
			}
			else
			{
				timer.reset();
				
				maskHeight = 0.0;
				onComplete = hideHandler;
			}

			TweenManager.to(this, {maskHeight: maskHeight}, 0.75, null, onComplete);
			
			displayedChanged.dispatch(visible);
		}
		
		public function get position():String
		{
			return _position;
		}
		
		public function set position(value:String):void
		{
			if (value == _position) return;
			
			_position = value;
		}
		
		public function get maskHeight():Number
		{
			return _bounds.height;
		}
		
		public function set maskHeight(value:Number):void
		{
			_bounds.height = value;
			
			if (_position == NotificationPosition.BOTTOM)
			{
				y = screenBottom - value;
			}
			
			content.scrollRect = _bounds;

			if (value == 0.0) 
			{
				visible = false;
				
				content.homeStreamNumUnread = 0;
				content.mentionsStreamNumUnread = 0;
				content.searchStreamNumUnread = 0;
				content.messagesStreamNumUnread = 0;
				content.status.data = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			mouseOver = true;
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			mouseOver = false;
		}
		
		protected function timerCompleteHandler(event:TimerEvent):void
		{
			if (mouseOver)
			{
				timer.reset();
				timer.start();
			}
			else
			{
				displayed = false;
			}
		}
		
		protected function hideHandler(tween:GTween):void
		{
			alwaysInFront = false;
			
			TweenManager.disposeTween(tween);
		}
	}
}