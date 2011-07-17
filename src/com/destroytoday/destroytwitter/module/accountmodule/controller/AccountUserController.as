package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.vo.UserVO;

	public class AccountUserController
	{
		//--------------------------------------------------------------------------
		//
		//  Links
		//
		//--------------------------------------------------------------------------
		
		protected var account:AccountModule;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AccountUserController(account:AccountModule)
		{
			this.account = account;
			
			account.twitter.gotFriendsIDs.add(gotFriendsIDsHandler);
			account.twitter.gotFriendsIDsError.add(gotFriendsIDsErrorHandler);
			
			account.signalBus.accountSelected.add(accountSelectedHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function updateFriendsIDs():void
		{
			_updateFriendsIDs();
		}
		
		protected function _updateFriendsIDs(cursor:Number = -1):void
		{
			account.userModel.getFriendsIDsLoader = account.twitter.getFriendIDList(account.infoModel.accessToken, account.infoModel.accessToken.id, null, cursor);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (account == this.account && account.infoModel.active)
			{
				account.signalBus.accountSelected.remove(accountSelectedHandler);
				
				updateFriendsIDs();
			}
		}
		
		protected function gotFriendsIDsHandler(loader:XMLLoader, idList:Vector.<int>, prevCursor:Number, nextCursor:Number):void
		{
			if (loader == account.userModel.getFriendsIDsLoader)
			{
				account.userModel.getFriendsIDsLoader = null;
				
				if (idList.length > 0)
				{
					account.databaseController.updateUserIDs(account, idList);
					
					_updateFriendsIDs(nextCursor);
				}
			}
		}
		
		protected function gotFriendsIDsErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			if (loader == account.userModel.getFriendsIDsLoader)
			{
				account.userModel.getFriendsIDsLoader = null;
				
				trace("got friends ids error");
			}
		}
	}
}