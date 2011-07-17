package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountSearchStreamController;
	import com.destroytoday.destroytwitter.view.workspace.HomeCanvas;
	import com.destroytoday.destroytwitter.view.workspace.SearchCanvas;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import org.osflash.signals.Signal;
	
	public class SearchCanvasMediator extends BaseStreamCanvasMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SearchCanvasMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			state = WorkspaceState.SEARCH;
			
			updateStartedSignal = signalBus.searchStreamUpdateStarted;
			updatedSignal = signalBus.searchStreamUpdated;
			updatedErrorSignal = signalBus.searchStreamUpdatedError;
			numUnreadChangedSignal = signalBus.searchStreamNumUnreadChanged;
			updatedStatusReadListSignal = signalBus.searchStatusReadListUpdated;
			
			signalBus.searchKeywordChanged.add(keywordChangedHandler);
			signalBus.fontTypeChanged.add(fontTypeChangedHandler);
			
			view.input.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDownHandler);
			view.input.actionsButton.addEventListener(MouseEvent.CLICK, actionsMenuClickHandler);
			view.input.textfield.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			
			super.onRegister();

			view.input.fontType = preferencesController.getPreference(PreferenceType.FONT_TYPE);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		private function get view():SearchCanvas
		{
			return viewComponent as SearchCanvas;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		override protected function accountSelectedHandler(account:AccountModule):void
		{
			super.accountSelectedHandler(account);
			
			if (account)
			{
				controller = account.searchController;
				view.input.text = account.searchModel.currentKeyword;
			}
			else
			{
				controller = null;
			}
		}
		
		protected function keyboardDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				(controller as AccountSearchStreamController).searchKeyword(view.input.text);
			}
		}
		
		protected function actionsMenuClickHandler(event:MouseEvent):void
		{
			var point:Point = view.input.actionsButton.localToGlobal(new Point(view.input.actionsButton.width * 0.5 - 1.0, view.input.actionsButton.height * 0.5 + 7.0));
		
			contextMenuController.displaySearchHistoryMenu(view.stage, point.x, point.y);
		}
		
		protected function keywordChangedHandler(keyword:String):void
		{
			view.input.text = keyword;
		}
		
		protected function focusInHandler(event:FocusEvent):void
		{
			workspaceController.setState(WorkspaceState.SEARCH);
		}
		
		override protected function fontTypeChangedHandler(fontType:String):void {
			super.fontTypeChangedHandler(fontType);
			
			view.input.fontType = fontType;
		}

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			super.stylesheetChangedHandler(stylesheet);
			
			styleController.applyTextInputStyle(view.input);
			styleController.applyBitmapButtonStyle(view.input.actionsButton);
		}
	}
}