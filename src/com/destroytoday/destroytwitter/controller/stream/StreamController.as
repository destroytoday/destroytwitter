package com.destroytoday.destroytwitter.controller.stream
{
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.model.StreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.components.Alert;

	public class StreamController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var model:StreamModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			signalBus.accountSelected.add(accountSelectedHandler);
		}
		
		public function enableAwayMode():void
		{
			model.awayMode = true;
			
			alertController.addMessage(null, "Your streams are now paused.");
		}
		
		public function disableAwayMode():void
		{
			model.awayMode = false;
		}
		
		public function toggleAwayMode():void
		{
			if (model.awayMode)
			{
				disableAwayMode();
			}
			else
			{
				enableAwayMode();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function accountSelectedHandler(module:AccountModule):void
		{
			model.awayMode = false;
		}
	}
}