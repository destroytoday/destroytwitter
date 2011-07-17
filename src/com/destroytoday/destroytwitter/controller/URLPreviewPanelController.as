package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ProfilePanelModel;
	import com.destroytoday.destroytwitter.model.URLPreviewPanelModel;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.model.vo.URLPreviewVO;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.GenericLoaderError;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	
	import flash.events.TimerEvent;
	
	import org.osflash.signals.Signal;

	public class URLPreviewPanelController
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
		public var twitter:TwitterAspirin;
		
		[Inject]
		public var model:URLPreviewPanelModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function URLPreviewPanelController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			twitter.unshortenedURL.add(gotURLPreviewHandler);
			twitter.unshortenedURLError.add(gotURLPreviewErrorHandler);
		}
		
		public function getURLPreview(url:String):void
		{
			cancelGetURLPreview();
			
			model.getURLPreviewLoader = twitter.unshortenURL(url);
		}
		
		public function cancelGetURLPreview():void
		{
			if (model.getURLPreviewLoader)
			{
				model.getURLPreviewLoader.cancel();
				
				model.getURLPreviewLoader = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function gotURLPreviewHandler(loader:XMLLoader, shortenedURL:String, unshortenedURL:String, title:String):void
		{
			if (model.getURLPreviewLoader == loader)
			{
				model.getURLPreviewLoader = null;
				
				var urlPreview:URLPreviewVO = new URLPreviewVO();
				
				urlPreview.shortenedURL = shortenedURL;
				urlPreview.unshortenedURL = unshortenedURL;
				urlPreview.title = title;
				
				signalBus.gotURLPreview.dispatch(urlPreview);
			}
		}
		
		protected function gotURLPreviewErrorHandler(loader:XMLLoader, code:int, message:String):void
		{
			if (model.getURLPreviewLoader == loader)
			{
				model.getURLPreviewLoader = null;
				
				signalBus.gotURLPreviewError.dispatch(message); //TODO
				
				if (message != GenericLoaderError.CANCEL) alertController.addMessage(AlertSourceType.URL_PREVIEW, message);
			}
		}
	}
}