package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.workspace.HomeCanvas;
	
	public class MessagesCanvasMediator extends BaseStreamCanvasMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		public function MessagesCanvasMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			state = WorkspaceState.MESSAGES;
			
			updateStartedSignal = signalBus.messagesStreamUpdateStarted;
			updatedSignal = signalBus.messagesStreamUpdated;
			updatedErrorSignal = signalBus.messagesStreamUpdatedError;
			numUnreadChangedSignal = signalBus.messagesStreamNumUnreadChanged;
			
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
			
			controller = (account) ? account.messagesController : null;
		}
	}
}