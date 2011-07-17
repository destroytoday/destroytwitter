package com.destroytoday.destroytwitter.view.overlay
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.ProgressSpinner;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	
	public class ImageViewerContent extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var closeButton:BitmapButton;
		
		public var progressSpinner:ProgressSpinner;
		
		public var bitmap:Bitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var loader:Loader = new Loader();
		
		protected var _isLoaded:Boolean;
		
		public var bounds:Rectangle = new Rectangle();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ImageViewerContent()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			bitmap = addChild(new Bitmap(null, PixelSnapping.AUTO, true)) as Bitmap;
			progressSpinner = addChild(new ProgressSpinner()) as ProgressSpinner;
			closeButton = addChild(new BitmapButton(new (Asset.CLOSE_BUTTON)())) as BitmapButton;
			
			closeButton.setConstraints(NaN, 0.0, 0.0, NaN);
			bitmap.y = closeButton.height + 8.0;
			
			buttonMode = true;

			loader.contentLoaderInfo.addEventListener(Event.OPEN, loaderOpenHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			bitmap.width = width;
			bitmap.height = height;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function loaderOpenHandler(event:Event):void
		{
			_isLoaded = false;
			
			if (bitmap.bitmapData)
			{
				bitmap.bitmapData.dispose();
				bitmap.bitmapData = null;
			}
			
			bounds.width = width = 0.0;
			bounds.height = height = 0.0;
			
			(parent as ImageViewer).invalidateDisplayList();
			
			closeButton.visible = false;
			
			progressSpinner.x = Math.round((width - progressSpinner.width) * 0.5);
			progressSpinner.y = Math.round((height - progressSpinner.height) * 0.5);
			
			progressSpinner.progress.text = "Retrieving info...";
			progressSpinner.visible = true;
			progressSpinner.displayed = true;
		}
		
		protected function loaderProgressHandler(event:ProgressEvent):void
		{
			if (event.bytesLoaded > event.bytesTotal)
			{
				progressSpinner.progress.text = Math.round(event.bytesLoaded * 0.001) + "kb";
			}
			else if (event.bytesLoaded < event.bytesTotal)
			{
				progressSpinner.progress.text = Math.round((event.bytesLoaded / event.bytesTotal) * 100.0) + "% of " + Math.round(event.bytesTotal * 0.001) + "kb";
			}
			else
			{
				progressSpinner.progress.text = "Retrieving info...";
			}
		}
		
		protected function loaderCompleteHandler(event:Event):void
		{
			_isLoaded = true;
			
			progressSpinner.visible = false;
			progressSpinner.displayed = false;
			closeButton.visible = true;
			
			bitmap.bitmapData = (loader.content as Bitmap).bitmapData;
			
			bounds.width = bitmap.bitmapData.width;
			bounds.height = bitmap.bitmapData.height;// + bitmap.y * 2.0;
			
			(parent as ImageViewer).invalidateDisplayList();
			
			loader.unload();
		}
	}
}