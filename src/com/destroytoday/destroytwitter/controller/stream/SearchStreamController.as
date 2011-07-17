package com.destroytoday.destroytwitter.controller.stream
{
	import com.destroytoday.destroytwitter.module.accountmodule.controller.AccountSearchStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.BaseAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.IAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountMentionsStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountSearchStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.IAccountStreamModel;

	public class SearchStreamController extends BaseStreamController
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SearchStreamController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------

		override protected function get controller():IAccountStreamController
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.searchController : null;
		}
		
		override protected function get model():IAccountStreamModel
		{
			return (accountModel.currentAccount) ? accountModel.currentAccount.searchModel : null;
		}
		
		public function getPrevNewestID():String
		{
			return (model as AccountSearchStreamModel).prevNewestID;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function addListeners():void
		{
			signalBus.searchPerPageChanged.add(tweetsPerPageChangedHandler);
		}
		
		public function getKeywordList():Array
		{
			return (model as AccountSearchStreamModel).keywordList;
		}
		
		public function searchKeyword(keyword:String):void
		{
			(controller as AccountSearchStreamController).searchKeyword(keyword);
		}
		
		public function clearHistory():void
		{
			(controller as AccountSearchStreamController).clearHistory();
		}
	}
}