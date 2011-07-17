package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.controller.ClipboardController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.controller.WorkspaceController;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;
	import com.destroytoday.destroytwitter.view.workspace.Workspace;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvas;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.system.TouchscreenType;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.robotlegs.mvcs.Mediator;

	public class WorkspaceMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var clipboardController:ClipboardController;
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var drawerModel:DrawerModel;
		
		[Inject]
		public var controller:WorkspaceController;
		
		[Inject]
		public var view:Workspace;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function WorkspaceMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, applicationDeactivate);
			
			signalBus.workspaceStateChanged.add(workspaceStateChangedHandler);
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			view.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, gestureSwipeHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function applicationDeactivate(event:Event):void
		{
			clipboardController.normalize();
		}
		
		protected function workspaceStateChangedHandler(oldState:String, newState:String):void
		{
			var m:uint = view.numChildren;
			
			for (var i:uint = 0; i < m; ++i) {
				if ((view.getChildAt(i) as DisplayObjectContainer).getChildByName(newState) as BaseCanvas) {
					view.selectedIndex = i;
					
					break;
				}
			}
		}
		
		protected function gestureSwipeHandler(event:TransformGestureEvent):void
		{
			if (drawerModel.opened) return;
			
			if (event.offsetX < 0)
			{
				controller.selectCanvasLeft();
			}
			else if (event.offsetX > 0)
			{
				controller.selectCanvasRight();
			}
			else if (event.offsetY < 0)
			{
				controller.selectCanvasUp();
			}
			else if (event.offsetY > 0)
			{
				controller.selectCanvasDown();
			}
		}
	}
}