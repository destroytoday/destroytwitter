package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.stream.BaseStreamController;
	import com.destroytoday.destroytwitter.controller.stream.HomeStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MentionsStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MessagesStreamController;
	import com.destroytoday.destroytwitter.controller.stream.SearchStreamController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.WorkspaceModel;
	import com.destroytoday.destroytwitter.model.vo.IStreamVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.IAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.IAccountStreamModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;
	import com.destroytoday.util.StringUtil;

	public class WorkspaceController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var homeController:HomeStreamController;
		
		[Inject]
		public var mentionsController:MentionsStreamController;
		
		[Inject]
		public var searchController:SearchStreamController;
		
		[Inject]
		public var messagesController:MessagesStreamController;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var model:WorkspaceModel;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var findItemIndex:int;
		
		protected var findBeginTextIndex:int;

		protected var findEndTextIndex:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function WorkspaceController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setState(state:String):void
		{
			model.state = state;
		}
		
		public function selectCanvasLeft():void
		{
			switch (model.state)
			{
				case WorkspaceState.MENTIONS:
					setState(WorkspaceState.HOME);
					break;
				case WorkspaceState.SEARCH:
					setState(WorkspaceState.MENTIONS);
					break;
				case WorkspaceState.MESSAGES:
					setState(WorkspaceState.SEARCH);
					break;
			}
		}
		
		public function selectCanvasRight():void
		{
			switch (model.state)
			{
				case WorkspaceState.HOME:
					setState(WorkspaceState.MENTIONS);
					break;
				case WorkspaceState.MENTIONS:
					setState(WorkspaceState.SEARCH);
					break;
				case WorkspaceState.SEARCH:
					setState(WorkspaceState.MESSAGES);
					break;
			}
		}

		public function selectCanvasUp():void
		{
			switch (model.state)
			{
				case WorkspaceState.PREFERENCES:
					setState(WorkspaceState.HOME);
					break;
			}
		}
		
		public function selectCanvasDown():void
		{
			switch (model.state)
			{
				case WorkspaceState.HOME:
				case WorkspaceState.MENTIONS:
				case WorkspaceState.SEARCH:
				case WorkspaceState.MESSAGES:
					setState(WorkspaceState.PREFERENCES);
					break;
			}
		}
		
		public function getStreamControllerByName(name:String):BaseStreamController
		{
			switch (name)
			{
				case StreamType.HOME:
					return homeController;
				case StreamType.MENTIONS:
					return mentionsController;
				case StreamType.SEARCH:
					return searchController;
				case StreamType.MESSAGES:
					return messagesController;
			}
			
			return null;
		}
		
		public function getCurrentStreamController():BaseStreamController
		{
			switch (model.state)
			{
				case StreamType.HOME:
					return homeController;
				case StreamType.MENTIONS:
					return mentionsController;
				case StreamType.SEARCH:
					return searchController;
				case StreamType.MESSAGES:
					return messagesController;
			}
			
			return null;
		}
		
		public function getAccountStreamControllerByName(stream:String):IAccountStreamController
		{
			var account:AccountModule = accountModel.currentAccount;
			
			if (!accountModel.currentAccount) return null;
			
			switch (stream)
			{
				case StreamType.HOME:
					return accountModel.currentAccount.homeController;
				case StreamType.MENTIONS:
					return accountModel.currentAccount.mentionsController;
				case StreamType.SEARCH:
					return accountModel.currentAccount.searchController;
				case StreamType.MESSAGES:
					return accountModel.currentAccount.messagesController;
			}
			
			return null;
		}
		
		public function getCurrentAccountStreamController():IAccountStreamController
		{
			if (!accountModel.currentAccount) return null;
			
			switch (model.state)
			{
				case StreamType.HOME:
					return accountModel.currentAccount.homeController;
				case StreamType.MENTIONS:
					return accountModel.currentAccount.mentionsController;
				case StreamType.SEARCH:
					return accountModel.currentAccount.searchController;
				case StreamType.MESSAGES:
					return accountModel.currentAccount.messagesController;
			}
			
			return null;
		}
		
		public function getAccountStreamModelByName(stream:String):IAccountStreamModel
		{
			var account:AccountModule = accountModel.currentAccount;
			
			switch (stream)
			{
				case WorkspaceState.HOME:
					return account.homeModel;
				case WorkspaceState.MENTIONS:
					return account.mentionsModel;
				case WorkspaceState.SEARCH:
					return account.searchModel;
				case WorkspaceState.MESSAGES:
					return account.messagesModel;
			}
			
			return null;
		}
		
		public function getCurrentAccountStreamModel():IAccountStreamModel
		{
			if (!accountModel.currentAccount) return null;
			
			var account:AccountModule = accountModel.currentAccount;
			
			switch (model.state)
			{
				case WorkspaceState.HOME:
					return account.homeModel;
				case WorkspaceState.MENTIONS:
					return account.mentionsModel;
				case WorkspaceState.SEARCH:
					return account.searchModel;
				case WorkspaceState.MESSAGES:
					return account.messagesModel;
			}
			
			return null;
		}
		
		public function getNumUnread():int
		{
			var numUnread:int = 0;
			
			if (preferencesController.getBoolean(PreferenceType.HOME_NOTIFICATIONS)) numUnread += homeController.getNumUnread();
			if (preferencesController.getBoolean(PreferenceType.MENTIONS_NOTIFICATIONS)) numUnread += mentionsController.getNumUnread();
			if (preferencesController.getBoolean(PreferenceType.SEARCH_NOTIFICATIONS)) numUnread += searchController.getNumUnread();
			if (preferencesController.getBoolean(PreferenceType.MESSAGES_NOTIFICATIONS)) numUnread += messagesController.getNumUnread();
			
			return numUnread;
		}
		
		public function markCurrentStreamStatusesRead():void
		{
			signalBus.markedStreamStatusesRead.dispatch(model.state);
		}
		
		public function markStreamStatusesRead(stream:String):void
		{
			signalBus.markedStreamStatusesRead.dispatch(stream);
		}
		
		public function resetFindPointer():void
		{
			findItemIndex = 0;
			findBeginTextIndex = 0;
			findEndTextIndex = 0;
		}
		
		public function findNext(term:String):void
		{
			var model:IAccountStreamModel = getCurrentAccountStreamModel();
			
			// pause canvas
			
			term = term.toLowerCase();
			
			if (model && model.itemList)
			{
				var item:IStreamVO;
				var text:String;
				var index:int;
				var match:Boolean;
				
				var m:uint = model.itemList.length;
				var freshSearch:Boolean = findItemIndex == 0 && findBeginTextIndex == 0 && findEndTextIndex == 0;
				
				for (var i:uint = findItemIndex; i < m; ++i)
				{
					item = model.itemList[i];
					text = TwitterTextUtil.replaceHTMLEntities(StringUtil.stripHTML(item.text)).toLowerCase();

					index = text.indexOf(term, findEndTextIndex);
					
					if (index != -1)
					{
						match = true;
						
						break;
					}
					else
					{
						findBeginTextIndex = 0;
						findEndTextIndex = 0;
					}
				}
				
				if (match)
				{
					findItemIndex = i;
					findBeginTextIndex = index;
					findEndTextIndex = index + term.length;
					
					signalBus.foundTerm.dispatch(this.model.state, term, findItemIndex, findBeginTextIndex, findEndTextIndex);
				}
				else
				{
					findItemIndex = 0;
					findBeginTextIndex = 0;
					findEndTextIndex = 0;
					
					if (!freshSearch)
					{
						findNext(term);
					}
					else
					{
						alertController.addMessage(AlertSourceType.FIND, "No matches found for '" + term + "'.");
					}
				}
			}
		}
	}
}