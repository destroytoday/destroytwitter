package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	
	import flash.net.SharedObject;

	public class AccountModuleModel
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		public var accountsImported:Boolean;
		
		protected var _activeAccountList:Vector.<AccountModule> = new Vector.<AccountModule>();
		
		protected var _inactiveAccountList:Vector.<AccountModule> = new Vector.<AccountModule>();
		
		protected var _currentAccount:AccountModule;
		
		public function AccountModuleModel()
		{
		}
		
		public function get activeAccountList():Vector.<AccountModule>
		{
			return _activeAccountList;
		}

		public function set activeAccountList(value:Vector.<AccountModule>):void
		{
			_activeAccountList = value;
		}

		public function get inactiveAccountList():Vector.<AccountModule>
		{
			return _inactiveAccountList;
		}

		public function set inactiveAccountList(value:Vector.<AccountModule>):void
		{
			_inactiveAccountList = value;
		}
		
		public function get currentAccountID():int
		{
			return (_currentAccount) ? _currentAccount.infoModel.accessToken.id : -1;
		}
			
		public function get currentAccount():AccountModule 
		{
			return _currentAccount;
		}

		public function set currentAccount(value:AccountModule):void
		{
			if (_currentAccount && value == _currentAccount) return;
			
			_currentAccount = value;
			trace("account selected:", value);
			signalBus.accountSelected.dispatch(_currentAccount);
		}
	}
}