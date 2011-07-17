package com.destroytoday.destroytwitter.controller.stream
{
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountHomeStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.BaseAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.IAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountHomeStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.IAccountStreamModel;

	public class HomeStreamController extends BaseStreamController
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function HomeStreamController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override protected function get controller():IAccountStreamController
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.homeController : null;
		}
		
		override protected function get model():IAccountStreamModel
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.homeModel : null;
		}
		
		public function getPrevNewestID():String
		{
			return (model as AccountHomeStreamModel).prevNewestID;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function addListeners():void
		{
			signalBus.homeTweetsPerPageChanged.add(tweetsPerPageChangedHandler);
		}
	}
}