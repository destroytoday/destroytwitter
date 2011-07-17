package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.model.ImageViewerModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	
	import flash.net.URLRequest;

	public class ImageViewerController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var model:ImageViewerModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ImageViewerController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function open(request:URLRequest, originalURL:String):void
		{
			model.url = originalURL;
			
			request.cacheResponse = false;
			request.useCache = false;
			
			model.request = request;
			model.opened = true;
		}
		
		public function close():void
		{
			model.opened = false;
		}
	}
}