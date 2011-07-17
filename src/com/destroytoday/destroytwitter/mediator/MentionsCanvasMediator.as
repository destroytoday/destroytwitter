package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.workspace.HomeCanvas;
	
	public class MentionsCanvasMediator extends BaseStreamCanvasMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		public function MentionsCanvasMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			state = WorkspaceState.MENTIONS;
			
			updateStartedSignal = signalBus.mentionsStreamUpdateStarted;
			updatedSignal = signalBus.mentionsStreamUpdated;
			updatedErrorSignal = signalBus.mentionsStreamUpdatedError;
			numUnreadChangedSignal = signalBus.mentionsStreamNumUnreadChanged;
			updatedStatusReadListSignal = signalBus.mentionsStatusReadListUpdated;
			
			super.onRegister();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		override protected function accountSelectedHandler(account:AccountModule):void
		{
			super.accountSelectedHandler(account);
			
			controller = (account) ? account.mentionsController : null;
		}
	}
}