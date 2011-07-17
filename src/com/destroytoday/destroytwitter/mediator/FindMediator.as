package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.controller.WorkspaceController;
	import com.destroytoday.destroytwitter.view.drawer.Find;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;

	public class FindMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var workspaceController:WorkspaceController;
		
		[Inject]
		public var view:Find;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FindMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.input.textfield.addEventListener(KeyboardEvent.KEY_DOWN, nextHandler);
			view.input.textfield.addEventListener(Event.CHANGE, textChangeHandler);
			view.nextButton.addEventListener(MouseEvent.CLICK, nextHandler);

			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerOpenedForFind.add(drawerOpenedForFindHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function drawerOpenedHandler(state:String):void
		{
			if (state == DrawerState.FIND)
			{
				view.visible = true;
			}
			else
			{
				view.visible = false;
			}
		}
		
		protected function drawerOpenedForFindHandler():void
		{
			view.input.text = "";
			view.input.focus();
		}
		
		protected function textChangeHandler(event:Event):void
		{
			workspaceController.resetFindPointer();
		}
		
		protected function nextHandler(event:Event):void
		{
			if ((event is MouseEvent || event is KeyboardEvent && (event as KeyboardEvent).keyCode == Keyboard.ENTER) && view.input.text)
			{
				workspaceController.findNext(view.input.text);
			}
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyTextInputStyle(view.input);
			styleController.applyTextButtonStyle(view.nextButton);
		}
	}
}