package com.destroytoday.destroytwitter.mediator {
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.WindowControlType;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.model.ApplicationModel;
	import com.destroytoday.destroytwitter.model.CacheModel;
	import com.destroytoday.destroytwitter.model.StartupModel;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowChrome;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowContent;
	import com.destroytoday.util.ApplicationUtil;
	import com.destroytoday.util.WindowUtil;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowResize;
	import flash.display.Screen;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class ApplicationWindowChromeMediator extends BaseMediator {

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var cacheModel:CacheModel;
		
		[Inject]
		public var startupModel:StartupModel;

		[Inject]
		public var view:ApplicationWindowChrome;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var timer:Timer = new Timer(1000.0, 1);
		
		protected var step:int;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ApplicationWindowChromeMediator() {
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		override public function onRegister():void {
			super.onRegister();

			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, applicationActivateHandler);

			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			view.status.addEventListener(Event.ENTER_FRAME, statusEnterframeHandler);
			startupModel.statusChanged.add(statusChangedHandler);
			
			if (ApplicationUtil.mac)
			{
				view.bar.controlGroup.macMinimizeButton.addEventListener(MouseEvent.CLICK, minimizeClickHandler);
				view.bar.controlGroup.macMaximizeButton.addEventListener(MouseEvent.CLICK, maximizeClickHandler);
				view.bar.controlGroup.macCloseButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
			}
			else
			{
				view.bar.controlGroup.pcMinimizeButton.addEventListener(MouseEvent.CLICK, minimizeClickHandler);
				view.bar.controlGroup.pcMaximizeButton.addEventListener(MouseEvent.CLICK, maximizeClickHandler);
				view.bar.controlGroup.pcCloseButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
			}

			signalBus.startupCompleted.addOnce(startupCompletedHandler);

			timerCompleteHandler(null);
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function applicationActivateHandler(event:Event):void {
			/*if (WindowUtil.isOffScreen(contextView.stage.nativeWindow)) {
				WindowUtil.center(contextView.stage.nativeWindow);
			}*/
		}

		protected function startupCompletedHandler():void {
			view.status.visible = false;

			(contextView as BaseDestroyTwitter).addContent();
		}

		protected function statusEnterframeHandler(event:Event):void {
			if (step < 8)
			{
				step++;
			}
			else
			{
				step = 0;
			}
			
			view.status.text = startupModel.status + "...".substr(0, int(step * 0.5));
		}
		
		protected function statusChangedHandler(status:String):void
		{
			step = 0;
			
			view.status.text = status;
			
			view.invalidateDisplayList();
		}
		
		protected function minimizeClickHandler(event:MouseEvent):void
		{
			if (ApplicationUtil.mac)
			{
				view.stage.nativeWindow.minimize();
			}
			else if (preferencesController.getPreference(PreferenceType.WINDOW_CONTROL_TYPE) == WindowControlType.CLOSE_SYSTEM_TRAY_MINIMIZE_TASKBAR)
			{
				view.stage.nativeWindow.minimize();
			}
			else
			{
				view.stage.nativeWindow.visible = false;
			}
		}

		protected function maximizeClickHandler(event:MouseEvent):void
		{
			if (view.stage.nativeWindow.displayState != NativeWindowDisplayState.MAXIMIZED)
			{
				view.stage.nativeWindow.maximize();
			}
			else
			{
				view.stage.nativeWindow.restore();
			}
		}
		
		protected function closeClickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
			
			if (ApplicationUtil.mac)
			{
				view.stage.nativeWindow.visible = false;
			}
			else if (preferencesController.getPreference(PreferenceType.WINDOW_CONTROL_TYPE) == WindowControlType.CLOSE_SYSTEM_TRAY_MINIMIZE_TASKBAR)
			{
				view.stage.nativeWindow.visible = false;
			}
			else
			{
				WindowUtil.closeAll(true);
			}
		}

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void {
			styleController.applyStyle(view.bar, stylesheet.getStyle('.ApplicationWindowBar'));
			styleController.applyStyle(view.bar.textfield, stylesheet.getStyle('.ApplicationWindowBarTextField'));
			styleController.applyStyle(view.footer, stylesheet.getStyle('.ApplicationWindowFooter'));
			styleController.applyStyle(view.status, stylesheet.getStyle('.StartupTextField'));
			styleController.applyStyle(view.background, stylesheet.getStyle('.ApplicationWindowBackground'));

			if (ApplicationUtil.pc) {
				styleController.applyStyle(view.bar.controlGroup.pcCloseButton, stylesheet.getStyle('.ApplicationControlButton'));
				styleController.applyStyle(view.bar.controlGroup.pcMaximizeButton, stylesheet.getStyle('.ApplicationControlButton'));
				styleController.applyStyle(view.bar.controlGroup.pcMinimizeButton, stylesheet.getStyle('.ApplicationControlButton'));
			}
		}

		protected function timerCompleteHandler(event:TimerEvent):void {
			if (event) {
				cacheModel.windowBounds = view.stage.nativeWindow.bounds;
			}

			view.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVE, windowBoundsHandler);
			view.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, windowBoundsHandler);
		}

		protected function windowBoundsHandler(event:NativeWindowBoundsEvent):void {
			view.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.MOVE, windowBoundsHandler);
			view.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.RESIZE, windowBoundsHandler);

			timer.reset();
			timer.start();
		}
	}
}