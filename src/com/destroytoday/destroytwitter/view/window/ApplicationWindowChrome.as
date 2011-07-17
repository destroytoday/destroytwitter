package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.util.ApplicationUtil;
	import com.destroytoday.util.WindowUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowResize;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	
	public class ApplicationWindowChrome extends DisplayGroup
	{
		public var bar:ApplicationWindowBar;
		
		public var tray:ApplicationWindowTray;
		
		public var footer:ApplicationWindowFooter;
		
		public var status:LayoutTextField;
		
		public var background:ApplicationWindowBackground;
		
		public var shadow:ApplicationWindowShadow;
		
		public const padding:Number = 9.0;
		
		public function ApplicationWindowChrome()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			shadow = addChild(new ApplicationWindowShadow()) as ApplicationWindowShadow;
			background = addChild(new ApplicationWindowBackground()) as ApplicationWindowBackground;
			status = addChild(new LayoutTextField()) as LayoutTextField;
			footer = addChild(new ApplicationWindowFooter()) as ApplicationWindowFooter;
			tray = addChild(new ApplicationWindowTray()) as ApplicationWindowTray;
			bar = addChild(new ApplicationWindowBar()) as ApplicationWindowBar;
			
			status.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0);
			status.autoSize = TextFieldAutoSize.LEFT;
			status.text = "starting up";
			
			bar.setConstraints(padding, NaN, padding, NaN);
			tray.setConstraints(padding, NaN, padding, padding);
			footer.setConstraints(padding, NaN, padding, padding);
			status.center = 0.0;
			status.middle = 0.0;
			background.setConstraints(padding, bar.height, padding, footer.height + padding);
			shadow.setConstraints(0.0, 0.0, 0.0, 0.0);
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, applicationInvokeHandler);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, applicationActivateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, applicationExitingHandler);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, barMouseDownHandler);
			footer.gripper.addEventListener(MouseEvent.MOUSE_DOWN, gripperMouseDownHandler);
		}
		
		override protected function addedToStageHandler(event:Event):void
		{
			super.addedToStageHandler(event);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, windowResizingHandler);
			stage.nativeWindow.addEventListener(Event.CLOSING, windowClosingHandler);
			
			stage.nativeWindow.maxSize = new Point(1314.0, NativeWindow.systemMaxSize.y);
			
			stageResizeHandler(null);
		}
		
		protected function windowResizingHandler(event:NativeWindowBoundsEvent):void
		{
			if (event.afterBounds.height < 300.0) { // TODO - test on Linux
				event.preventDefault();
				
				stage.nativeWindow.height = 300.0;
			}
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
			
			validateNow();
		}
		
		protected function applicationInvokeHandler(event:Event):void
		{
			stage.nativeWindow.visible = true;
			stage.nativeWindow.activate();
		}
		
		protected function applicationActivateHandler(event:Event):void
		{
			stage.nativeWindow.visible = true;
		}
		
		protected function applicationExitingHandler(event:Event):void
		{
			stage.nativeWindow.removeEventListener(Event.CLOSING, windowClosingHandler);
		}
		
		protected function windowClosingHandler(event:Event):void
		{
			event.preventDefault();
			
			stage.nativeWindow.visible = false;
		}
		
		protected function barMouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, barMouseUpHandler);
			
			stage.nativeWindow.startMove();
		}
		
		protected function barMouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, barMouseUpHandler);
			
			var screen:Screen = WindowUtil.getScreen(stage.nativeWindow);
			
			if (screen && stage.nativeWindow.height > screen.visibleBounds.height)
			{
				stage.nativeWindow.height = screen.visibleBounds.bottom - stage.nativeWindow.y;
			}
		}
		
		protected function gripperMouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, gripperMouseUpHandler);
			
			stage.nativeWindow.startResize(NativeWindowResize.BOTTOM_RIGHT);
		}

		protected function gripperMouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, gripperMouseUpHandler);
			
			var closestWindowWidth:Number = 18.0 + Math.round((stage.nativeWindow.width - 18.0) / 324.0) * 324.0;
			
			if (Math.abs(stage.nativeWindow.width - closestWindowWidth) <= 40.0)
			{
				TweenManager.to(stage.nativeWindow, {width: closestWindowWidth}, 0.5);
			}
		}
	}
}