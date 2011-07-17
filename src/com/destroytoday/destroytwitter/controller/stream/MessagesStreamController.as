package com.destroytoday.destroytwitter.controller.stream
{
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountHomeStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.BaseAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.IAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountMessagesStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.IAccountStreamModel;
	import com.destroytoday.util.StringUtil;

	public class MessagesStreamController extends BaseStreamController
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MessagesStreamController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override protected function get controller():IAccountStreamController
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.messagesController : null;
		}
		
		override protected function get model():IAccountStreamModel
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.messagesModel : null;
		}
		
		public function getPrevNewestID():String
		{
			return StringUtil.max((model as AccountMessagesStreamModel).prevNewestInboxID, (model as AccountMessagesStreamModel).prevNewestSentID);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function addListeners():void
		{
			signalBus.messagesPerPageChanged.add(tweetsPerPageChangedHandler);
		}
	}
}