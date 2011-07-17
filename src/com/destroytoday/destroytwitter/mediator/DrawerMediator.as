package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
	import com.destroytoday.destroytwitter.view.drawer.Drawer;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowContent;
	import com.destroytoday.destroytwitter.view.workspace.StreamCanvasGroup;
	import com.destroytoday.destroytwitter.view.workspace.Workspace;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;

	public class DrawerMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var controller:DrawerController;
		
		[Inject]
		public var model:DrawerModel;
		
		[Inject]
		public var view:Drawer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DrawerMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		protected function set keyEnabled(value:Boolean):void
		{
			if (value)
			{
				view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
			else
			{
				view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
			
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);
			signalBus.imageViewerOpened.add(imageViewerOpenedHandler);
			signalBus.workspaceStateChanged.add(workspaceStateChangedHandler);
			signalBus.statusReplyPrompted.add(statusReplyPromptedHandler);
			signalBus.quickFriendLookupDisplayedChanged.add(quickFriendLookupDisplayedChangedHandler);
			signalBus.drawerPositionUpdated.add(drawerPositionUpdated);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get streamCanvasGroup():StreamCanvasGroup
		{
			return (view.parent as ApplicationWindowContent).workspace.streamCanvasGroup;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		// Events 
		//--------------------------------------
		
		protected function closeClickHandler(event:MouseEvent):void
		{
			controller.close();
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			//--------------------------------------
			//  No modifiers
			//--------------------------------------
			if (!event.shiftKey && !event.altKey && !event.ctrlKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.ESCAPE:
						controller.close();
						break;
				}
			}
		}
		
		//--------------------------------------
		// Signals 
		//--------------------------------------

		protected function stageResizeForComposeHandler(event:Event):void
		{
			view.x = view.parent.width - view.width;
		}

		protected function stageResizeForCanvasHandler(event:Event):void
		{
			view.x = streamCanvasGroup.selectedCanvas.x - streamCanvasGroup.targetScrollX;
		}
		
		protected function stageResizeForOtherHandler(event:Event):void
		{
			view.x = 0.0;
		}
		
		
		protected function drawerOpenedHandler(state:String):void
		{
			var handler:Function;

			switch (state)
			{
				case DrawerState.COMPOSE:
				case DrawerState.COMPOSE_MESSAGE_REPLY:
				case DrawerState.COMPOSE_REPLY:
					handler = stageResizeForComposeHandler;
					break;
				case DrawerState.UPDATE:
					handler = stageResizeForOtherHandler;
					break;
				default:
					handler = stageResizeForCanvasHandler;
			}
			
			handler(null);
			
			view.stage.addEventListener(Event.RESIZE, handler);
			
			view.state = state;
			view.opened = true;
			keyEnabled = true;
		}
		
		protected function drawerClosedHandler():void
		{
			view.stage.removeEventListener(Event.RESIZE, stageResizeForComposeHandler);
			view.stage.removeEventListener(Event.RESIZE, stageResizeForCanvasHandler);
			view.stage.removeEventListener(Event.RESIZE, stageResizeForOtherHandler);
			
			view.opened = false;
			keyEnabled = false;
		}
		
		protected function drawerPositionUpdated():void
		{
			view.opened = true;
		}
		
		protected function imageViewerOpenedHandler(request:URLRequest):void
		{
			if (model.opened) controller.close();
		}
		
		protected function workspaceStateChangedHandler(oldState:String, newState:String):void
		{
			controller.close();
		}
		
		protected function statusReplyPromptedHandler(data:StreamStatusVO):void
		{
			controller.open(DrawerState.COMPOSE);
		}
		
		protected function quickFriendLookupDisplayedChangedHandler(displayed:Boolean):void
		{
			keyEnabled = !displayed;
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.title, stylesheet.getStyle('.DrawerTitle'));
			styleController.applyStyle(view, stylesheet.getStyle('.Drawer'));
			styleController.applyStyle(view.closeButton, stylesheet.getStyle('.BitmapButton'));
		}
	}
}