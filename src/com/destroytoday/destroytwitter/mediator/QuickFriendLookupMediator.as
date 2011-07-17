package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.PositionType;
	import com.destroytoday.destroytwitter.controller.DatabaseController;
	import com.destroytoday.destroytwitter.controller.QuickFriendLookupController;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.view.overlay.QuickFriendLookup;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.data.SQLResult;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	public class QuickFriendLookupMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var controller:QuickFriendLookupController;
		
		[Inject]
		public var view:QuickFriendLookup;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var delayTimer:Timer = new Timer(100.0, 1);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function QuickFriendLookupMediator()
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
			
			signalBus.quickFriendLookupPrompted.add(quickFriendLookupPromptedHandler);
			signalBus.quickFriendLookupDisplayedChanged.add(quickFriendLookupDisplayedChangedHandler);
			signalBus.quickFriendLookupScreenNameSelected.add(quickFriendLookupScreenNameSelectedHandler);
			
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimerCompleteHandler);
			view.closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
			view.input.textfield.addEventListener(Event.CHANGE, inputChangeHandler);
			view.list.textfield.addEventListener(TextEvent.LINK, listClickHandler);
			
			view.alpha = 0.0;
			view.visible = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		// Events 
		//--------------------------------------
		
		protected function delayTimerCompleteHandler(event:TimerEvent):void
		{
			databaseController.getFriends(accountModel.currentAccount, view.input.text, getFriendsResultHandler);
		}
		
		protected function getFriendsResultHandler(result:SQLResult):void
		{
			view.list.dataProvider = (result) ? result.data : [];
		}
		
		protected function inputChangeHandler(event:Event):void
		{
			delayTimer.reset();
			delayTimer.start();
		}
		
		protected function listClickHandler(event:TextEvent):void
		{
			controller.selectScreenName(event.text);
		}
		
		protected function closeButtonClickHandler(event:MouseEvent):void
		{
			controller.hide();
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (!event.shiftKey && !event.ctrlKey && !event.altKey)
			{
				var screenName:String;
				
				switch (event.keyCode)
				{
					case Keyboard.DOWN:
						event.preventDefault();
						view.list.selectElementAt(view.list.selectedIndex + 1);
						break;
					case Keyboard.UP:
						event.preventDefault();
						view.list.selectElementAt(view.list.selectedIndex - 1);
						break;
					case Keyboard.ENTER:
						screenName = view.list.selectedElement || view.input.text;
						break;
					case Keyboard.TAB:
						screenName = (view.list.selectedElement || view.input.text) + " ";
						break;
					case Keyboard.SPACE:
						screenName = view.input.text + " ";
						break;
					case Keyboard.ESCAPE:
						event.stopImmediatePropagation();
						controller.hide();
						break;
					case Keyboard.BACKSPACE:
						if (!view.input.text) 
						{
							event.preventDefault();
							controller.hide();
						}
						break;
				}
				
				if (screenName)
				{
					event.preventDefault();
					controller.selectScreenName(screenName);
				}
			}
		}
		
		protected function stageMouseDownHandler(event:MouseEvent):void
		{
			controller.hide();
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		//--------------------------------------
		// Signals 
		//--------------------------------------
		
		protected function quickFriendLookupPromptedHandler(x:Number, y:Number, positionType:String):void
		{
			switch (positionType)
			{
				case PositionType.ABOVE:
					y -= view.height;
			}
			
			view.x = Math.round(Math.min(x - view.parent.x, view.stage.width - (view.parent.x + view.width)));
			view.y = Math.round(y - view.parent.y);
		}
		
		protected function quickFriendLookupScreenNameSelectedHandler(screenName:String):void
		{
			controller.hide();
		}
		
		protected function quickFriendLookupDisplayedChangedHandler(displayed:Boolean):void
		{
			view.displayed = displayed;
			
			if (displayed)
			{
				view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, int.MAX_VALUE);
				view.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				view.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				
				view.input.text = "";
			}
			else
			{
				view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				view.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				view.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyBitmapButtonStyle(view.closeButton);
			styleController.applyStyle(view.title, stylesheet.getStyle('.QuickFriendLookupTitle'));
			styleController.applyStyle(view.input.textfield, stylesheet.getStyle('.TextInputTextField'));
			styleController.applyStyle(view.input, stylesheet.getStyle('.QuickFriendLookupInput'));
			styleController.applyTextFieldListStyle(view.list);
			styleController.applyStyle(view, stylesheet.getStyle('.QuickFriendLookup'));
			
			view.list.dirtyTextLineHeight();
		}
	}
}