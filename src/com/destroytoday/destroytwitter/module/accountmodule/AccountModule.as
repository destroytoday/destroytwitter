package com.destroytoday.destroytwitter.module.accountmodule
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.AnalyticsController;
	import com.destroytoday.destroytwitter.controller.DatabaseController;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.stream.StreamController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.StreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountHomeStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountMentionsStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountMessagesStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountSearchStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountTwitterController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountUserController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountHomeStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountInfoModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountMentionsStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountMessagesStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountSearchStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountTwitterModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountUserModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.twitteraspirin.vo.XAuthTokenVO;
	import com.destroytoday.util.FileUtil;
	
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class AccountModule
	{

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var signalBus:ApplicationSignalBus;

		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var streamModel:StreamModel;
		
		[Inject]
		public var streamController:StreamController;

		[Inject]
		public var twitter:TwitterAspirin;

		[Inject]
		public var analyticsController:AnalyticsController;

		[Inject]
		public var databaseController:DatabaseController;

		[Inject]
		public var preferencesController:PreferencesController;

		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------

		//--------------------------------------
		// Models 
		//--------------------------------------

		public var infoModel:AccountInfoModel;

		public var twitterModel:AccountTwitterModel;

		public var userModel:AccountUserModel;

		public var homeModel:AccountHomeStreamModel;

		public var mentionsModel:AccountMentionsStreamModel;

		public var searchModel:AccountSearchStreamModel;

		public var messagesModel:AccountMessagesStreamModel;

		//--------------------------------------
		// Controllers 
		//--------------------------------------

		public var twitterController:AccountTwitterController;

		public var userController:AccountUserController;

		public var homeController:AccountHomeStreamController;

		public var mentionsController:AccountMentionsStreamController;

		public var searchController:AccountSearchStreamController;

		public var messagesController:AccountMessagesStreamController;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var cache:SharedObject;

		protected var delayTimer:Timer = new Timer(2000.0, 1);

		/*protected var mentionsDelayTimer:Timer = new Timer(1500.0, 1);

		   protected var searchDelayTimer:Timer = new Timer(2000.0, 1);

		 protected var messagesDelayTimer:Timer = new Timer(2500.0, 1);*/

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function AccountModule()
		{
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function setup(accessToken:XAuthTokenVO, password:String = null, user:UserVO = null, active:Boolean = true):void
		{
			cache = SharedObject.getLocal(accessToken.screenName);

			infoModel = new AccountInfoModel();

			infoModel.accessToken = accessToken;
			infoModel.user = user;
			infoModel.active = active;
			//if (password) infoModel.password = password;

			twitterModel = new AccountTwitterModel();
			userModel = new AccountUserModel();
			homeModel = new AccountHomeStreamModel(this);
			mentionsModel = new AccountMentionsStreamModel(this);
			searchModel = new AccountSearchStreamModel(this);
			messagesModel = new AccountMessagesStreamModel(this);

			twitterController = new AccountTwitterController(this);
			userController = new AccountUserController(this);
			homeController = new AccountHomeStreamController(this);
			mentionsController = new AccountMentionsStreamController(this);
			searchController = new AccountSearchStreamController(this);
			messagesController = new AccountMessagesStreamController(this);

			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimerCompleteHandler);
			/*mentionsDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, mentionsDelayTimerCompleteHandler);
			searchDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, searchDelayTimerCompleteHandler);
			messagesDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, messagesDelayTimerCompleteHandler);*/

			infoModel.userChanged.add(userChangedHandler);
		}

		public function activate():void
		{
			infoModel.active = true;

			if (accountModel.accountsImported)
			{
				start();
			}
			else
			{
				signalBus.accountsImported.addOnce(accountsImportedHandler);
			}

			signalBus.accountSelected.add(accountSelectedHandler);

			accountSelectedHandler(accountModel.currentAccount);
		}

		public function deactivate():void
		{
			infoModel.active = false;

			delayTimer.reset();
			/*mentionsDelayTimer.reset();
			searchDelayTimer.reset();
			messagesDelayTimer.reset();*/

			homeController.stop();
			mentionsController.stop();
			searchController.stop();
			messagesController.stop();
		}

		protected function start():void
		{
			delayTimer.reset();
			delayTimer.start();
			/*mentionsDelayTimer.reset();
			mentionsDelayTimer.start();
			searchDelayTimer.reset();
			searchDelayTimer.start();
			messagesDelayTimer.reset();
			messagesDelayTimer.start();*/
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (account == this)
			{
				searchModel.keywordList = preferencesController.getPreference(PreferenceType.SEARCH_KEYWORD_LIST).split(',');
				homeModel.count = int(preferencesController.getPreference(PreferenceType.HOME_TWEETS_PER_PAGE));
				mentionsModel.count = int(preferencesController.getPreference(PreferenceType.MENTIONS_PER_PAGE));
				searchModel.count = int(preferencesController.getPreference(PreferenceType.SEARCH_PER_PAGE));
				messagesModel.count = int(preferencesController.getPreference(PreferenceType.MESSAGES_PER_PAGE));

				homeController.loadFilters();
				mentionsController.loadFilters();
			}
		}

		protected function accountsImportedHandler():void
		{
			start();
		}

		protected function userChangedHandler(user:UserVO):void
		{
			if (cache.data['firstRun'] == null)
			{
				cache.data['firstRun'] = false;
			}
		}

		protected function delayTimerCompleteHandler(event:TimerEvent):void
		{
			homeController.loadMostRecent();
			mentionsController.loadMostRecent();
			searchController.searchKeyword(searchModel.currentKeyword);
			messagesController.loadMostRecent();
		}

		/*protected function mentionsDelayTimerCompleteHandler(event:TimerEvent):void
		{
			mentionsController.loadMostRecent();
		}

		protected function searchDelayTimerCompleteHandler(event:TimerEvent):void
		{
			searchController.searchKeyword(searchModel.currentKeyword);
		}

		protected function messagesDelayTimerCompleteHandler(event:TimerEvent):void
		{
			messagesController.loadMostRecent();
		}*/
	}
}