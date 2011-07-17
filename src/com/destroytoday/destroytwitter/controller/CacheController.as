package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.model.CacheModel;
	import com.destroytoday.destroytwitter.model.ConfigModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.workspace.StreamElement;
	import com.destroytoday.pool.ObjectPool;
	import com.destroytoday.pool.ObjectWaterpark;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;

	public class CacheController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var configModel:ConfigModel;
		
		[Inject]
		public var model:CacheModel;
		
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const iconLoaded:Signal = new Signal(String, BitmapData); // url, bitmapData
		
		public const iconLoadedError:Signal = new Signal(String); // url
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected static var instance:CacheController;
		
		public var defaultIconBitmapData:BitmapData = (new (Asset.DEFAULT_USER_ICON)() as Bitmap).bitmapData;
		
		protected var cache:SharedObject;
		
		protected var loaderPool:ObjectPool = new ObjectPool(Loader);
		
		protected var iconStatusMap:Object = {};
		
		protected var disposeTimer:Timer = new Timer(1800000.0); //1800000
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function CacheController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function getInstance():CacheController {
			if (!instance) {
				instance = new CacheController();
			}
			
			return instance;
		}
		
		public function setupListeners():void
		{
			signalBus.accountSelected.add(accountSelectedHandler);
			
			disposeTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			disposeTimer.start();
		}
		
		public function importLocal():void
		{
			registerClassAlias("flash.geom.Rectangle", Rectangle);
			
			model.sharedObject = SharedObject.getLocal('cache', configModel.path);
		}
		
		public function getIcon(url:String):BitmapData
		{
			var bitmapData:BitmapData = model.iconMap[url];
			
			incrementIconCount(url);
			
			if (!bitmapData)
			{
				loadIcon(url);
			}
			
			return bitmapData;
		}
		
		public function disposeInactiveElements():void
		{
			//--------------------------------------
			//  BitmapData
			//--------------------------------------
			
			var bitmapData:BitmapData;
			var count:int = 0;
			
			for (var url:String in model.iconCount)
			{
				if (model.iconCount[url] == 0)
				{
					bitmapData = model.iconMap[url];
					
					if (bitmapData) bitmapData.dispose();
					
					delete model.iconCount[url];
					delete model.iconMap[url];
					
					count++;
				}
			}
			
			trace(count, "bitmaps disposed");
			
			//--------------------------------------
			//  StreamElement
			//--------------------------------------
			
			var m:uint = ObjectWaterpark.getPool(StreamElement).numWeakObjects
			
			for (var i:uint = 0; i < m; ++i)
			{
				(ObjectWaterpark.getObject(StreamElement) as StreamElement).nullify();
			}
			
			ObjectWaterpark.getPool(StreamElement).empty();

			trace(m, "stream elements disposed");
		}
		
		public function incrementIconCount(url:String):void
		{
			if (model.iconCount[url] == undefined || model.iconCount[url] == null)
			{
				model.iconCount[url] = 1;
			}
			else
			{
				model.iconCount[url]++;
			}
		}
		
		public function decrementIconCount(url:String):void
		{
			model.iconCount[url]--;
		}
		
		protected function loadIcon(url:String):void
		{
			var loader:Loader = loaderPool.getObject() as Loader;

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadIconCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadIconErrorHandler);
			
			loader.name = url;
			
			loader.load(new URLRequest(url));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			model.lastUsedAccountID = (account) ? account.infoModel.accessToken.id : NaN;
		}
		
		protected function loadIconCompleteHandler(event:Event):void {
			var width:Number, height:Number;
			
			const size:Number = 36.0;

			var loader:Loader = (event.currentTarget as LoaderInfo).loader;
			var bitmap:Bitmap = loader.content as Bitmap;
			var url:String = loader.name;
			var resize:Boolean = true;

			if (bitmap.bitmapData.width > bitmap.bitmapData.height && bitmap.bitmapData.width > size) {
				width = size;
				height = (bitmap.bitmapData.height / bitmap.bitmapData.width) * width;
			} else if (bitmap.bitmapData.height > bitmap.bitmapData.width && bitmap.bitmapData.height > size) {
				height = size;
				width = (bitmap.bitmapData.width / bitmap.bitmapData.height) * height;
			} else if (bitmap.bitmapData.width == bitmap.bitmapData.height && bitmap.bitmapData.width > size) {
				width = size;
				height = size;
			} else {
				width = size;
				height = size;
				
				resize = false;
			}

			var bitmapData:BitmapData;
			
			if (resize) {
				bitmap.width = width;
				bitmap.height = height;
				bitmap.smoothing = true;
				
				bitmapData = new BitmapData(size, size, true, 0x00000000);
				bitmapData.draw (bitmap, bitmap.transform.matrix);
				
				if (bitmap && bitmap.bitmapData) bitmap.bitmapData.dispose();
				
				loader.unload();
			} else {
				bitmapData = bitmap.bitmapData;
			}
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadIconCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadIconErrorHandler);
			
			loaderPool.disposeObject(loader);
			
			model.iconMap[url] = bitmapData;

			iconLoaded.dispatch(url, bitmapData);
		}
		
		protected function loadIconErrorHandler(event:IOErrorEvent):void
		{
			var loader:Loader = (event.currentTarget as LoaderInfo).loader;
			var url:String = loader.name;

			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadIconCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadIconErrorHandler);
			
			loader.unload();
			loaderPool.disposeObject(loader);
			
			iconLoadedError.dispatch(url);
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			disposeInactiveElements();
		}
	}
}