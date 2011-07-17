package com.destroytoday.destroytwitter.controller.stream
{
	import com.destroytoday.destroytwitter.module.accountmodule.controller.BaseAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.IAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountMentionsStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.IAccountStreamModel;

	public class MentionsStreamController extends BaseStreamController
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MentionsStreamController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------

		override protected function get controller():IAccountStreamController
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.mentionsController : null;
		}
		
		override protected function get model():IAccountStreamModel
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.mentionsModel : null;
		}
		
		public function getPrevNewestID():String
		{
			return (model as AccountMentionsStreamModel).prevNewestID;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function addListeners():void
		{
			signalBus.mentionsPerPageChanged.add(tweetsPerPageChangedHandler);
		}
	}
}