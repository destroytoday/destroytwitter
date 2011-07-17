package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.manager.TweenManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class FramerateController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected static var instance:FramerateController;
		
		protected var timer:Timer = new Timer(1000.0, 1);
		
		protected var mouseWheelTimer:Timer = new Timer(1000.0, 1);
		
		protected var isTweening:Boolean;
		
		protected var isScrolling:Boolean;
		
		protected var active:Boolean = true;
		
		protected var targetFramerate:int;
		
		protected var numAnimations:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FramerateController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public static function getInstance():FramerateController
		{
			if (!instance)
			{
				instance = new FramerateController();
			}
			
			return instance;
		}
		
		public function get frameRate():uint
		{
			return contextView.stage.frameRate;
		}
		
		public function set frameRate(value:uint):void
		{
			if (value == contextView.stage.frameRate) return;

			contextView.stage.frameRate = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function startThrottling():void
		{
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, applicationActivateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, applicationDeactivateHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			mouseWheelTimer.addEventListener(TimerEvent.TIMER_COMPLETE, mouseWheelTimerCompleteHandler);
			contextView.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
			TweenManager.getInstance().activeTweensChanged.add(activeTweensChangedHandler);
		}
		
		public function addAnimation():void
		{
			++numAnimations;

			updateFramerate();
		}
		
		public function removeAnimation():void
		{
			--numAnimations;

			updateFramerate();
		}
		
		protected function updateFramerate():void
		{
			timer.reset();
			
			if (isTweening || numAnimations > 0)
			{
				frameRate = 50.0;
				
				targetFramerate = -1;
			}
			else if (active)
			{
				targetFramerate = 24.0;
			}
			else if (isScrolling)
			{
				frameRate = 24.0;
				
				targetFramerate = -1;
			}
			else if (!contextView.stage.nativeWindow.closed && contextView.stage.nativeWindow.visible)
			{
				targetFramerate = 5.0;
			}
			else
			{
				targetFramerate = 1.0;
			}
			
			if (targetFramerate != -1)
			{
				timer.reset();
				timer.start();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function activeTweensChangedHandler(activeTweens:int):void
		{
			isTweening = (activeTweens > 0);
			
			updateFramerate();
		}
		
		protected function timerCompleteHandler(event:TimerEvent):void
		{
			frameRate = targetFramerate;
		}
		
		protected function mouseWheelTimerCompleteHandler(event:TimerEvent):void
		{
			isScrolling = false;
			
			updateFramerate();
		}
		
		protected function applicationActivateHandler(event:Event):void
		{
			active = true;
			
			updateFramerate();
		}
		
		protected function applicationDeactivateHandler(event:Event):void
		{
			active = false;
			
			updateFramerate();
		}
		
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			isScrolling = true;

			if (!mouseWheelTimer.running)
			{
				mouseWheelTimer.reset();
				mouseWheelTimer.start();
				
				updateFramerate();
			}
		}
	}
}