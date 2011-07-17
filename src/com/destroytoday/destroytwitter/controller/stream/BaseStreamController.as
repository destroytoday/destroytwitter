package com.destroytoday.destroytwitter.controller.stream
{
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.BaseAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.IAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.IAccountStreamModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;

	public class BaseStreamController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BaseStreamController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		protected function get controller():IAccountStreamController
		{
			return null; //MUST override
		}

		protected function get model():IAccountStreamModel
		{
			return null; //MUST override
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			// MUST override
		}
		
		public function refresh():void
		{
			controller.loadMostRecent(true);
		}
		
		public function getMostRecent():void
		{
			controller.getMostRecent();
		}
		
		public function getNumUnread():int
		{
			return model.numUnread;
		}
		
		public function markStatusRead(numReadStatuses:int = 1):void
		{
			model.numUnread -= numReadStatuses; //TODO - use timer (maybe)
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function tweetsPerPageChangedHandler(account:AccountModule, tweetsPerPage:int):void
		{
			model.count = tweetsPerPage;
			
			if (controller.state) controller.loadMostRecent();
		}
	}
}