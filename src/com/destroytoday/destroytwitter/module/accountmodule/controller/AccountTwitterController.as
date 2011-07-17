package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.base.BaseAccountActor;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.util.StringUtil;

	public class AccountTwitterController extends BaseAccountActor
	{
		public function AccountTwitterController(module:AccountModule)
		{
			super(module);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function updateStatus(status:String, inReplyToStatusID:String = null):void
		{
			module.twitterModel.tweetLoader = module.twitter.updateStatus(module.infoModel.accessToken, status, inReplyToStatusID);
			
			module.twitter.updatedStatus.add(updatedStatusHandler);
			module.twitter.updatedStatusError.add(updatedStatusErrorHandler);
		}
		
		public function retweetStatus(statusID:String):void
		{
			module.twitterModel.tweetLoader = module.twitter.retweetStatus(module.infoModel.accessToken, statusID);
		
			module.twitter.retweetedStatus.add(retweetedStatusHandler);
			module.twitter.retweetedStatusError.add(retweetedStatusErrorHandler);
		}
		
		public function sendMessage(recipient:*, message:String):void
		{
			module.twitterModel.tweetLoader = module.twitter.sendMessage(module.infoModel.accessToken, message, recipient);
			
			module.twitter.sentMessage.add(sentMessageHandler);
			module.twitter.sentMessageError.add(sentMessageErrorHandler);
		}
		
		public function cancelTweet():void
		{
			if (module.twitterModel.tweetLoader)
			{
				module.twitterModel.tweetLoader.cancel();
				
				module.twitterModel.tweetLoader = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function updatedStatusHandler(loader:XMLLoader, status:StatusVO):void
		{
			if (loader == module.twitterModel.tweetLoader) {
				module.twitterModel.tweetLoader = null;
				
				module.databaseController.updateStatus(module, status);
				
				module.signalBus.statusUpdated.dispatch(status);
			}
		}
		
		protected function updatedStatusErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			if (loader == module.twitterModel.tweetLoader) {
				module.twitterModel.tweetLoader = null;
				
				message = code + " " + type + ": " + message;
				
				module.signalBus.statusUpdatedError.dispatch(message);
			}
		}
		
		protected function retweetedStatusHandler(loader:XMLLoader, status:StatusVO):void
		{
			if (loader == module.twitterModel.tweetLoader) {
				module.twitterModel.tweetLoader = null;
				
				module.databaseController.updateStatus(module, status);
				
				module.signalBus.retweetedStatus.dispatch(status);
			}
		}
		
		protected function retweetedStatusErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			if (loader == module.twitterModel.tweetLoader) {
				module.twitterModel.tweetLoader = null;
				
				message = code + " " + type + ": " + message;
				
				module.signalBus.retweetedStatusError.dispatch(message);
			}
		}
		
		protected function sentMessageHandler(loader:XMLLoader, message:DirectMessageVO):void
		{
			if (loader == module.twitterModel.tweetLoader) {
				module.twitterModel.tweetLoader = null;
				
				module.databaseController.updateMessage(module, message);
				
				module.signalBus.messageSent.dispatch(message);
			}
		}
		
		protected function sentMessageErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			if (loader == module.twitterModel.tweetLoader) {
				module.twitterModel.tweetLoader = null;
				
				message = code + " " + type + ": " + message;
				
				module.signalBus.messageSentError.dispatch(message);
			}
		}
	}
}