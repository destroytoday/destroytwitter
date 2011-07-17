package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.UnreadFormat;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.WorkspaceController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.WorkspaceModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountHomeStreamModel;
	import com.destroytoday.destroytwitter.view.navigation.BaseNavigationButton;
	import com.destroytoday.destroytwitter.view.navigation.NavigationTextButton;
	import com.destroytoday.destroytwitter.view.navigation.StreamNavigationBar;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class StreamNavigationBarMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var workspaceController:WorkspaceController;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var workspaceModel:WorkspaceModel;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var view:StreamNavigationBar;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamNavigationBarMediator()
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
			
			eventMap.mapListener(view.homeButton, MouseEvent.CLICK, buttonClickHandler);
			eventMap.mapListener(view.mentionsButton, MouseEvent.CLICK, buttonClickHandler);
			eventMap.mapListener(view.searchButton, MouseEvent.CLICK, buttonClickHandler);
			eventMap.mapListener(view.messagesButton, MouseEvent.CLICK, buttonClickHandler);
			
			signalBus.accountSelected.add(accountSelectedHandler);
			signalBus.workspaceStateChanged.add(workspaceStateChanged);
			signalBus.homeStreamNumUnreadChanged.add(homeStreamNumUnreadChangedHandler);
			signalBus.mentionsStreamNumUnreadChanged.add(mentionsStreamNumUnreadChangedHandler);
			signalBus.searchStreamNumUnreadChanged.add(searchStreamNumUnreadChangedHandler); //TODO - search
			signalBus.messagesStreamNumUnreadChanged.add(messagesStreamNumUnreadChangedHandler);
			signalBus.unreadFormatChanged.add(unreadFormatChangedHandler);
			
			workspaceStateChanged(null, workspaceModel.state);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Helpers
		//
		//--------------------------------------------------------------------------
		
		protected function updateUnreadHighlights():void
		{
			updateUnreadHighlight(WorkspaceState.HOME);
			updateUnreadHighlight(WorkspaceState.MENTIONS);
			updateUnreadHighlight(WorkspaceState.SEARCH);
			updateUnreadHighlight(WorkspaceState.MESSAGES);
		}
		
		protected function updateUnreadHighlight(stream:String, unread:int = -1):void
		{
			if (preferencesController.getPreference(PreferenceType.UNREAD_FORMAT) == UnreadFormat.NO_HIGHLIGHT)
			{
				unread = 0;
			}
			
			var button:NavigationTextButton = view.getChildByName(stream) as NavigationTextButton;
			
			if (unread == -1) 
			{
				unread = accountModel.currentAccount ? workspaceController.getStreamControllerByName(stream).getNumUnread() : 0;
			}
			
			if (unread > 0)
			{
				button.highlighted = true;
			}
			else
			{
				button.highlighted = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function buttonClickHandler(event:MouseEvent):void
		{
			var state:String = (event.currentTarget as DisplayObject).name;
			
			if (workspaceModel.state == state)
			{
				workspaceController.markStreamStatusesRead(state);
			}
			else
			{
				workspaceController.setState(state);
			}
		}
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			updateUnreadHighlights();
		}
		
		protected function homeStreamNumUnreadChangedHandler(account:AccountModule, numUnread:int, delta:int):void
		{
			if (account == accountModel.currentAccount)
			{
				updateUnreadHighlight(WorkspaceState.HOME, numUnread);
			}
		}
		
		protected function mentionsStreamNumUnreadChangedHandler(account:AccountModule, numUnread:int, delta:int):void
		{
			if (account == accountModel.currentAccount)
			{
				updateUnreadHighlight(WorkspaceState.MENTIONS, numUnread);
			}
		}
		
		protected function searchStreamNumUnreadChangedHandler(account:AccountModule, numUnread:int, delta:int):void
		{
			if (account == accountModel.currentAccount)
			{
				updateUnreadHighlight(WorkspaceState.SEARCH, numUnread);
			}
		}
		
		protected function messagesStreamNumUnreadChangedHandler(account:AccountModule, numUnread:int, delta:int):void
		{
			if (account == accountModel.currentAccount)
			{
				updateUnreadHighlight(WorkspaceState.MESSAGES, numUnread);
			}
		}
		
		protected function workspaceStateChanged(oldState:String, newState:String):void
		{
			if (oldState) {
				var oldButton:BaseNavigationButton = view.getChildByName(oldState) as BaseNavigationButton;

				if (oldButton) oldButton.selected = false;
			}
			
			var newButton:BaseNavigationButton = view.getChildByName(newState) as BaseNavigationButton;
			
			if (newButton) newButton.selected = true;
		}
		
		protected function unreadFormatChangedHandler(format:String):void
		{
			updateUnreadHighlights();
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view, stylesheet.getStyle('.BaseNavigationBar'));
			styleController.applyNavigationTextButtonStyle(view.homeButton);
			styleController.applyNavigationTextButtonStyle(view.mentionsButton);
			styleController.applyNavigationTextButtonStyle(view.searchButton);
			styleController.applyNavigationTextButtonStyle(view.messagesButton);
		}
	}
}