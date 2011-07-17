package com.destroytoday.destroytwitter.module.accountmodule.model
{
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;

	public class AccountSearchStreamModel extends BaseAccountStreamModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _keywordList:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AccountSearchStreamModel(account:AccountModule)
		{
			super(account);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set numUnread(value:uint):void
		{
			if (value == _numUnread) return;
			
			var delta:int = Math.max(0, value - numUnread);
			
			super.numUnread = value;
			
			account.signalBus.searchStreamNumUnreadChanged.dispatch(account, _numUnread, delta);
		}
		
		public function get currentKeyword():String
		{
			return (_keywordList && _keywordList.length > 0) ? _keywordList[0] : '';
		}
		
		public function get keywordList():Array
		{
			return _keywordList;
		}
		
		public function set keywordList(value:Array):void
		{
			if (value == _keywordList) return;
			
			_keywordList = value;
		}
	}
}