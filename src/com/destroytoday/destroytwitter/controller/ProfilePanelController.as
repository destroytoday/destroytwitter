package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ProfilePanelModel;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	
	import flash.data.SQLResult;
	import flash.events.TimerEvent;
	
	import org.osflash.signals.Signal;

	public class ProfilePanelController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var twitter:TwitterAspirin;
		
		[Inject]
		public var model:ProfilePanelModel;
		
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const startedGetUser:Signal = new Signal();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProfilePanelController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			model.getUserTimer.addEventListener(TimerEvent.TIMER_COMPLETE, getUserTimerCompleteHandler);
			twitter.gotUser.add(gotUserHandler);
			twitter.gotUserError.add(gotUserErrorHandler);
			signalBus.promptedProfileRefresh.add(promptedProfileRefreshHandler);
		}
		
		public function getUser(screenName:String, refresh:Boolean = false):void
		{
			cancelGetUser();
			
			if (!refresh)
			{
				model.screenName = screenName;
				
				var user:SQLUserVO = databaseController.getUser(screenName);
				
				if (user)
				{
					signalBus.gotProfileUser.dispatch(user);
					
					model.getUserTimer.reset();
					model.getUserTimer.start();
				}
				else
				{
					refreshUser();
				}
			}
			else
			{
				refreshUser();
			}
		}
		
		protected function refreshUser():void
		{
			model.getUserLoader = twitter.getUser(accountModel.currentAccount.infoModel.accessToken, NaN, model.screenName);
			
			startedGetUser.dispatch();
		}
		
		public function cancelGetUser():void
		{
			model.getUserTimer.reset();
			
			if (model.getUserLoader)
			{
				model.getUserLoader.cancel();
				
				model.getUserLoader = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function getUserTimerCompleteHandler(event:TimerEvent):void
		{
			refreshUser();
		}
		
		protected function gotUserHandler(loader:XMLLoader, user:UserVO):void
		{
			if (model.getUserLoader == loader)
			{
				model.getUserLoader = null;
				
				databaseController.updateUser(user, updateUserHandler);
			}
		}
		
		protected function updateUserHandler(resultList:Vector.<SQLResult>):void
		{
			signalBus.gotProfileUser.dispatch(databaseController.getUser(model.screenName));
		}
		
		protected function gotUserErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			if (model.getUserLoader == loader)
			{
				model.getUserLoader = null;
				
				signalBus.gotProfileUserError.dispatch(type); //TODO
				
				alertController.addMessage(AlertSourceType.PROFILE, message);
			}
		}
		
		protected function promptedProfileRefreshHandler():void
		{
			getUser(model.screenName, true);
		}
	}
}