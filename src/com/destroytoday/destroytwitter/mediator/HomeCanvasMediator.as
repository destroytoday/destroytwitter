package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.workspace.HomeCanvas;

	public class HomeCanvasMediator extends BaseStreamCanvasMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		public function HomeCanvasMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get view():HomeCanvas
		{
			return viewComponent as HomeCanvas;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			state = WorkspaceState.HOME;
			
			updateStartedSignal = signalBus.homeStreamUpdateStarted;
			updatedSignal = signalBus.homeStreamUpdated;
			updatedErrorSignal = signalBus.homeStreamUpdatedError;
			numUnreadChangedSignal = signalBus.homeStreamNumUnreadChanged;
			updatedStatusReadListSignal = signalBus.homeStatusReadListUpdated;
			
			super.onRegister();
			
			view.keyEnabled = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		override protected function accountSelectedHandler(account:AccountModule):void
		{
			super.accountSelectedHandler(account);

			controller = (account) ? account.homeController : null;
		}
	}
}