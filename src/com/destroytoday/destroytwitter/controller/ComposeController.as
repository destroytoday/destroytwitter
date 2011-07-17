package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ComposeModel;
	import com.destroytoday.destroytwitter.model.ImageServiceModel;
	import com.destroytoday.destroytwitter.model.PreferencesModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.GenericLoaderError;
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.constants.ImageServiceType;
	import com.destroytoday.twitteraspirin.constants.URLShortenerType;
	import com.destroytoday.twitteraspirin.image.IImageService;
	import com.destroytoday.twitteraspirin.urlshortening.BitlyURLShortener;
	import com.destroytoday.twitteraspirin.urlshortening.IURLShortener;
	import com.destroytoday.twitteraspirin.urlshortening.IsGdURLShortener;
	import com.destroytoday.twitteraspirin.urlshortening.JmpURLShortener;
	import com.destroytoday.twitteraspirin.urlshortening.TinyURLShortener;
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class ComposeController
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
		public var alertController:AlertController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var preferencesModel:PreferencesModel;
		
		[Inject]
		public var imageServiceModel:ImageServiceModel;
		
		[Inject]
		public var model:ComposeModel;
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var bitly:BitlyURLShortener = new BitlyURLShortener("destroytoday", "R_5d6ad138abf85ab3caaafb7340b1c4c8");

		public var jmp:JmpURLShortener = new JmpURLShortener("destroytoday", "R_5d6ad138abf85ab3caaafb7340b1c4c8");

		public var isgd:IsGdURLShortener = new IsGdURLShortener();
		
		public var tinyurl:TinyURLShortener = new TinyURLShortener();

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var shortenURLLoader:StringLoader;
		
		protected var _uploadFile:File;

		protected var browseFile:File = new File();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ComposeController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			twitter.shortenedURL.add(urlShortenedHandler);
			twitter.shortenedURLError.add(urlShortenedErrorHandler);
			twitter.uploadedFile.add(fileUploadedHandler);
			twitter.uploadedFileError.add(fileUploadedErrorHandler);
			
			browseFile.addEventListener(Event.SELECT, uploadFileSelectHandler);
		}

        public function storeMessage(message:String):void
		{
			model.previousMessage = message;
		}
		
		public function emptyMessage():void
		{
			model.previousMessage = null;
		}
		
		public function restoreMessage():void
		{
			if (model.previousMessage) signalBus.composeRestored.dispatch(model.previousMessage);
		}
		
		public function shortenURL(url:String):void
		{
			var service:IURLShortener;
			
			switch (preferencesModel.file.getString(PreferenceType.URL_SHORTENER))
			{
				case URLShortenerType.JMP:
					service = jmp;
					break;
				case URLShortenerType.BITLY:
					service = bitly;
					break;
				case URLShortenerType.ISGD:
					service = isgd;
					break;
				case URLShortenerType.TINYURL:
					service = tinyurl;
					break;
			}
			
			shortenURLLoader = twitter.shortenURL(service, url);
			
			signalBus.urlShorteningStarted.dispatch();
		}
		
		public function cancelShortenURL():void
		{
			if (shortenURLLoader) shortenURLLoader.cancel();
		}
		
		public function browseFilesForUpload():void
		{
			var typeFilter:Array;
			
			/*switch (preferencesModel.file.getString(PreferenceName.FILE_UPLOADER))
			{
			}*/ //TODO
			
			browseFile.browse(typeFilter);
		}
		
		public function uploadFile(file:File):void
		{
			var service:IImageService;
			
			switch (preferencesModel.file.getString(PreferenceType.IMAGE_SERVICE))
			{
				case ImageServiceType.POSTEROUS:
					service = imageServiceModel.posterous;
					break;
				case ImageServiceType.TWITGOO:
					service = imageServiceModel.twitgoo;
					break;
				case ImageServiceType.IMGLY:
					service = imageServiceModel.imgly;
					break;
				case ImageServiceType.PLIXI:
					service = imageServiceModel.tweetphoto;
					break;
				case ImageServiceType.IMGUR:
					service = imageServiceModel.imgur;
					break;
				/*case ImageServiceType.PIKCHUR:
					service = imageServiceModel.pikchur;
					break;*/
				case ImageServiceType.TWITPIC:
					service = imageServiceModel.twitpic;
					break;
				case ImageServiceType.YFROG:
					service = imageServiceModel.yfrog;
					break;
			}
			
			_uploadFile = twitter.uploadFile(accountModel.currentAccount.infoModel.accessToken, service, file, model.message);
			
			signalBus.fileUploadingStarted.dispatch(file);
		}
		
		public function cancelUploadFile():void
		{
			if (_uploadFile) twitter.cancelFileUpload(_uploadFile);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function urlShortenedHandler(loader:StringLoader, originalURL:String, shortenedURL:String):void
		{
			shortenURLLoader = null;
			
			signalBus.urlShortened.dispatch(originalURL, shortenedURL);
		}
		
		protected function urlShortenedErrorHandler(loader:StringLoader, code:int, message:String):void
		{
			shortenURLLoader = null;
			
			if (message != GenericLoaderError.CANCEL) alertController.addMessage(AlertSourceType.COMPOSE, message, 5000);
			
			signalBus.urlShortenedError.dispatch(code, message);
		}
		
		protected function uploadFileSelectHandler(event:Event):void
		{
			uploadFile(browseFile);
		}
		
		protected function fileUploadedHandler(file:File, url:String):void
		{
			_uploadFile = null;
			
			signalBus.fileUploaded.dispatch(url);
		}
		
		protected function fileUploadedErrorHandler(file:File, code:int, message:String):void
		{
			_uploadFile = null;
			
			if (message != GenericLoaderError.CANCEL) alertController.addMessage(AlertSourceType.COMPOSE, message, 5000);
			
			signalBus.fileUploadedError.dispatch(code, message);
		}
	}
}