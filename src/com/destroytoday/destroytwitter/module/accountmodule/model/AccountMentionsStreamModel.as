package com.destroytoday.destroytwitter.module.accountmodule.model
{
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;

	public class AccountMentionsStreamModel extends BaseAccountStreamModel
	{
		public function AccountMentionsStreamModel(account:AccountModule)
		{
			super(account);
		}
		
		override public function set numUnread(value:uint):void
		{
			if (value == _numUnread) return;
			
			var delta:int = Math.max(0, value - numUnread);
			
			super.numUnread = value;
			
			account.signalBus.mentionsStreamNumUnreadChanged.dispatch(account, _numUnread, delta);
		}
	}
}