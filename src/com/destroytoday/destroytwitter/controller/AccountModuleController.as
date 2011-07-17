package com.destroytoday.destroytwitter.controller
{
	import com.adobe.images.PNGEncoder;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ApplicationModel;
	import com.destroytoday.destroytwitter.model.CacheModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.twitteraspirin.vo.XAuthTokenVO;
	import com.destroytoday.util.FileUtil;

	import flash.display.BitmapData;

	import org.robotlegs.core.IInjector;

	public class AccountModuleController
	{

		[Inject]
		public var injector:IInjector;

		[Inject]
		public var signalBus:ApplicationSignalBus;

		[Inject]
		public var databaseController:DatabaseController;

		[Inject]
		public var applicationModel:ApplicationModel;

		[Inject]
		public var cacheModel:CacheModel;

		[Inject]
		public var model:AccountModuleModel;

		[Inject]
		public var twitter:TwitterAspirin;

		private var tempPassword:String;

		public function AccountModuleController()
		{
		}

		public function setupListeners():void
		{
			twitter.gotXAuthAccessToken.add(gotAccessTokenHandler);
			twitter.gotXAuthAccessTokenError.add(gotAccessTokenErrorHandler);
			twitter.verifiedOAuthAccessToken.add(verifiedAccessTokenHandler);
			twitter.verifiedOAuthAccessTokenError.add(verifiedAccessTokenErrorHandler);
		}

		public function importAccounts():void
		{
			var accessToken:XAuthTokenVO;

			var accountList:Array = databaseController.getAccountList();

			if (accountList && accountList.length > 0)
			{
				for each (var row:Object in accountList)
				{
					var account:AccountModule = injector.instantiate(AccountModule);

					accessToken = new XAuthTokenVO();

					accessToken.id = row.id;
					accessToken.screenName = row.screenName;

					var accessTokenPair:Array = String(row.accessToken).split("/");

					accessToken.key = accessTokenPair[0];
					accessToken.secret = accessTokenPair[1];

					account.setup(accessToken, null, null, row.active);

					addAccount(account, row.active);
					if (applicationModel.debugMode && row.active)
						verifyAccount(account);
				}
			}

			model.accountsImported = true;

			signalBus.accountsImported.dispatch();
		}

		public function selectLastUsedAccount():void
		{
			var account:AccountModule = getAccountByID(cacheModel.lastUsedAccountID);

			if (account && !isAccountActive(account))
			{
				account = null;
			}

			if (!account && model.activeAccountList.length > 0)
			{
				account = model.activeAccountList[0];
			}

			selectAccount(account);
		}

		public function isAccountActive(account:AccountModule):Boolean
		{
			if (model.activeAccountList.indexOf(account) != -1)
			{
				return true;
			}

			return false;
		}

		public function login(username:String, password:String):void
		{
			tempPassword = password;

			twitter.getXAuthAccessToken(username, password);

			signalBus.accountLoginStarted.dispatch(username);
		}

		public function verifyAccount(account:AccountModule):void
		{
			twitter.verifyOAuthAccessToken(account.infoModel.accessToken);

			signalBus.accountVerifyStarted.dispatch(account);
		}

		public function addAccount(account:AccountModule, active:Boolean = false):void
		{
			/*if (!account.infoModel.password)
			   {
			   active = false;
			 }*/

			if (active)
			{
				activateAccount(account);
			}
			else
			{
				deactivateAccount(account);
			}
		}

		public function removeAccount(account:AccountModule):void
		{
			var index:int = model.inactiveAccountList.indexOf(account);

			if (index != -1)
			{
				model.inactiveAccountList.splice(index, 1);

				databaseController.removeAccount(account);
			}
		}

		public function activateAccount(account:AccountModule):void
		{
			var index:int = model.inactiveAccountList.indexOf(account);

			if (index != -1)
			{
				model.inactiveAccountList.splice(index, 1);
			}

			account.activate();
			databaseController.updateAccount(account, true);

			model.activeAccountList[model.activeAccountList.length] = account;
		}

		public function deactivateAccount(account:AccountModule):void
		{
			var index:int = model.activeAccountList.indexOf(account);

			if (index != -1)
			{
				model.activeAccountList.splice(index, 1);
			}

			account.deactivate();
			databaseController.updateAccount(account, false);

			model.inactiveAccountList[model.inactiveAccountList.length] = account;
		}

		public function selectAccount(account:AccountModule):void
		{
			model.currentAccount = account;
		}

		public function getAccountByID(id:Number):AccountModule
		{
			for each (var account:AccountModule in model.activeAccountList)
			{
				if (account.infoModel.accessToken.id == id)
				{
					return account;
				}
			}

			for each (account in model.inactiveAccountList)
			{
				if (account.infoModel.accessToken.id == id)
				{
					return account;
				}
			}

			return null;
		}

		public function updateAccountUserInfo(account:AccountModule, user:UserVO):void
		{
			databaseController.updateUser(user, null);

			account.infoModel.user = user;

			signalBus.accountUserInfoUpdated.dispatch(account);
		}

		public function saveAccountIcon(account:AccountModule, bitmapData:BitmapData):void
		{
			FileUtil.save(account.infoModel.path + account.infoModel.accessToken.id + ".png", PNGEncoder.encode(bitmapData));
		}

		protected function gotAccessTokenHandler(accessToken:XAuthTokenVO):void
		{
			var account:AccountModule = getAccountByID(accessToken.id);
			var accountAdded:Boolean = !account;

			if (!account)
			{
				account = injector.instantiate(AccountModule);

				account.setup(accessToken, tempPassword);
				addAccount(account, true);
			}
			else
			{
				account.infoModel.accessToken = accessToken;
			}

			//if (!account.infoModel.password) account.infoModel.password = tempPassword;

			signalBus.accountLoggedIn.dispatch(account);
			selectAccount(account);

			if (!accountAdded)
			{
				activateAccount(account);
			}
		}

		protected function gotAccessTokenErrorHandler(loader:StringLoader, code:int, type:String, message:String):void
		{
			message = code + " " + type + ": " + message;

			signalBus.accountLoggedInError.dispatch(message);
		}

		protected function verifiedAccessTokenHandler(user:UserVO):void
		{
			var account:AccountModule = getAccountByID(user.id);

			updateAccountUserInfo(account, user);

			signalBus.accountVerified.dispatch(account);
		}

		protected function verifiedAccessTokenErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			message = code + " " + type + ": " + message;

			signalBus.accountVerifiedError.dispatch(message);
		}
	}
}