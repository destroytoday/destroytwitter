package com.destroytoday.destroytwitter.commands
{
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.controller.StartupController;
	import com.destroytoday.destroytwitter.controller.StyleController;
	import com.destroytoday.destroytwitter.model.CacheModel;
	import com.destroytoday.util.WindowUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class BootstrapCommand extends SignalCommand
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var cacheController:CacheController;
		
		[Inject]
		public var cacheModel:CacheModel;
		
		[Inject]
		public var styleController:StyleController;
		
		[Inject]
		public var startupController:StartupController;
		
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BootstrapCommand()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function execute():void
		{
			contextView.stage.nativeWindow.addEventListener(Event.ACTIVATE, windowActivateHandler);
			
			cacheController.setupListeners();
			cacheController.importLocal();

			var windowBounds:Rectangle = cacheModel.windowBounds;
			
			if (windowBounds) {
				contextView.stage.nativeWindow.x = windowBounds.x;
				contextView.stage.nativeWindow.y = windowBounds.y;
				contextView.stage.nativeWindow.width = windowBounds.width;
				contextView.stage.nativeWindow.height = windowBounds.height;
				
				if (WindowUtil.isOffScreen(contextView.stage.nativeWindow)) {
					WindowUtil.center(contextView.stage.nativeWindow);
				}
			} else {
				contextView.stage.nativeWindow.width = 342.0;
				contextView.stage.nativeWindow.height = 450.0;
				
				WindowUtil.center(contextView.stage.nativeWindow);
			}
			
			styleController.loadStylesheet();
		}
		
		protected function windowActivateHandler(event:Event):void
		{
			contextView.stage.nativeWindow.removeEventListener(Event.ACTIVATE, windowActivateHandler);
			
			startupController.startup();
		}
	}
}