package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.DialogueModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.util.StringUtil;
	
	import flash.data.SQLResult;
	import flash.net.Responder;
	
	import org.osflash.signals.Signal;

	public class DialogueController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var twitter:TwitterAspirin;
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var model:DialogueModel;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var statusID:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DialogueController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			twitter.gotStatus.add(gotStatusHandler);
			twitter.gotStatusError.add(gotStatusErrorHandler);
		}
		
		public function getStatus(id:String):void
		{
			model.loader = twitter.getStatus(accountModel.currentAccount.infoModel.accessToken, id);
		}
		
		public function cancelGetStatus():void
		{
			if (model.loader)
			{
				model.loader.cancel();
				
				model.loader = null;
				
				signalBus.getOriginalDialogueStatusCancelled.dispatch();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function gotStatusHandler(loader:XMLLoader, status:StatusVO):void
		{
			statusID = status.id;
			
			model.loader = null;
			
			databaseController.updateStatus(accountModel.currentAccount, status, null, -1, updateStatusCallbackHandler);
		}
		
		protected function updateStatusCallbackHandler(result:Vector.<SQLResult>):void
		{
			var statusList:Array = databaseController.getStatuses(accountModel.currentAccount, statusID);
			
			if (statusList.length > 0)
			{
				signalBus.gotOriginalDialogueStatus.dispatch(statusList[0]);
			}
			else
			{
				signalBus.gotOriginalDialogueStatusError.dispatch("Error occurred");
			}
		}

		protected function gotStatusErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			model.loader = null;
			
			signalBus.gotOriginalDialogueStatusError.dispatch(type); //TODO
		}
	}
}