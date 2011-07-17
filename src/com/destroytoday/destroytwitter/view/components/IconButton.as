package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.IBasicLayoutElement;
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.util.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class IconButton extends SpritePlus
	{
		public var bitmap:Bitmap;
		
		public var link:String;
		
		protected var url:String;
		
		public function IconButton()
		{
			bitmap = addChild(new Bitmap(CacheController.getInstance().defaultIconBitmapData, PixelSnapping.AUTO, true)) as Bitmap;
			
			tabEnabled = false;
			buttonMode = true;
			enabled = true;
			
			addEventListener(MouseEvent.CLICK, clickHandler);
		}

		public function get enabled():Boolean
		{
			return mouseEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			mouseEnabled = value;
		}
		
		public function loadIcon(url:String, unload:Boolean = true, presetDefault:Boolean = true):void
		{
			if (url == this.url) return;

			if (unload) unloadIcon();

			this.url = url;
			
			var cache:CacheController = CacheController.getInstance();
			var bitmapData:BitmapData = cache.getIcon(url);
			
			if (bitmapData) {
				//this.url = null;
				
				bitmap.bitmapData = bitmapData;
			} else {
				if (presetDefault) bitmap.bitmapData = cache.defaultIconBitmapData;
				
				cache.iconLoaded.add(iconLoadedHandler);
				cache.iconLoadedError.add(iconLoadedErrorHandler);
			}
		}
		
		public function unloadIcon(dispose:Boolean = true):void
		{
			if (url) {
				var cache:CacheController = CacheController.getInstance();
				
				if (dispose) 
				{
					cache.decrementIconCount(url);
					
					url = null;
				}
				
				cache.iconLoaded.remove(iconLoadedHandler);
				cache.iconLoadedError.remove(iconLoadedErrorHandler);
			}
		}
		
		protected function iconLoadedHandler(url:String, bitmapData:BitmapData):void
		{
			if (this.url == url) {
				unloadIcon(false);
				
				bitmap.bitmapData = bitmapData;
			}
		}
		
		public function iconLoadedErrorHandler(url:String):void
		{
			if (this.url == url) unloadIcon(false);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (link) LinkController.getInstance().openLink(link, event.shiftKey, event.altKey);
		}
	}
}