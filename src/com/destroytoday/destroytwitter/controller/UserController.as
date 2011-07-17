package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.core.IPromise;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.UserModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.vo.UserListResult;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.vo.ErrorVO;
	
	import flash.utils.setTimeout;

	public class UserController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var twitter:TwitterAspirin;
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var model:UserModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function UserController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setupListeners():void
		{
			signalBus.updatedUserIDs.add(updatedUserIDsHandler);
			
			//twitter.gotUser.add(gotUserHandler);
		}
		
		public function updateEmptyUsers():void
		{
			if (model.getUsersPromise || !accountModel.currentAccount) return;
			
			var idList:Array = databaseController.getEmptyUserList(100);

			if (idList)
			{
				 model.getUsersPromise = twitter.getUserList(accountModel.currentAccount.infoModel.accessToken, idList);
				 
				 model.getUsersPromise.completed.add(gotUsersHandler);
				 model.getUsersPromise.failed.add(gotUsersErrorHandler);
			}
		}
		
		public function updateFriends():void
		{
			accountModel.currentAccount.userController.updateFriendsIDs();
		}
		
		/*public function updateUser(id:int):void
		{
			model.getUserLoader = twitter.getUser(accountModel.currentAccount.infoModel.accessToken, id);
		}*/
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function updatedUserIDsHandler():void
		{
			updateEmptyUsers();
		}

		/*protected function gotUserHandler(loader:XMLLoader, user:UserVO):void
		{
			if (loader == model.getUserLoader)
			{
				model.getUserLoader = null;
				
				databaseController.updateUser(user);
			}
		}*/
		
		protected function gotUsersHandler(promise:IPromise):void
		{
			model.getUsersPromise = null;
			
			databaseController.updateUsers((promise.result as UserListResult).userList);
			
			setTimeout(updateEmptyUsers, 5000.0);
		}
		
		protected function gotUsersErrorHandler(promise:IPromise):void
		{
			model.getUsersPromise = null;
			model.lastUpdate = 0;
			
			var error:ErrorVO = promise.error;
			
			trace(error.code + " " + error.type + ": " + error.message);
		}
	}
}