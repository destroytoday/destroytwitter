package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.ApplicationIconType;
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ApplicationModel;
	import com.destroytoday.destroytwitter.model.vo.ApplicationIconVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.util.ApplicationUtil;
	import com.destroytoday.util.FileUtil;
	import com.destroytoday.util.WindowUtil;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class ApplicationController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var workspaceController:WorkspaceController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var model:ApplicationModel;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var loaderMap:Object = new Dictionary();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ApplicationController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setupListeners():void
		{
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, deactivateHandler);
			//NativeApplication.nativeApplication.addEventListener(Event.EXITING, exitingHandler);
		}
		
		public function importIconList():void
		{
			var storageIconsPath:String = File.applicationStorageDirectory.nativePath + File.separator + "icons";
			
			if (!FileUtil.exists(storageIconsPath))
			{
				FileUtil.copy(File.applicationDirectory.nativePath + File.separator + "icons", storageIconsPath);
			}
			
			importIcon(ApplicationIconType.ICON_16);
			importIcon(ApplicationIconType.ICON_16_HIGHLIGHTED);
			importIcon(ApplicationIconType.ICON_24);
			importIcon(ApplicationIconType.ICON_24_HIGHLIGHTED);
			importIcon(ApplicationIconType.ICON_32);
			importIcon(ApplicationIconType.ICON_32_HIGHLIGHTED);
			importIcon(ApplicationIconType.ICON_48);
			importIcon(ApplicationIconType.ICON_48_HIGHLIGHTED);
			importIcon(ApplicationIconType.ICON_128);
			importIcon(ApplicationIconType.ICON_128_HIGHLIGHTED);
		}
		
		protected function importIcon(path:String):void
		{
			var loader:Loader = new Loader();
			
			loaderMap[loader] = path;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, importIconCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, importIconErrorHandler);

			path = FileUtil.getURL(File.applicationStorageDirectory.nativePath + "/icons/" + path);

			loader.load(new URLRequest(path));
		}
		
		protected function depositIcon(path:String):void
		{
			for each (var icon:ApplicationIconVO in model.iconList)
			{
				if (icon.path == path) break;
			}
			
			var bitmapData:BitmapData = icon.bitmap.bitmapData;
			
			switch(path)
			{
				case ApplicationIconType.ICON_16:
				case ApplicationIconType.ICON_32:
				case ApplicationIconType.ICON_48:
				case ApplicationIconType.ICON_128:
					model.icons[model.icons.length] = bitmapData;
					break;
				case ApplicationIconType.ICON_16_HIGHLIGHTED:
				case ApplicationIconType.ICON_32_HIGHLIGHTED:
				case ApplicationIconType.ICON_48_HIGHLIGHTED:
				case ApplicationIconType.ICON_128_HIGHLIGHTED:
					model.highlightedIcons[model.highlightedIcons.length] = bitmapData;
					break;
				case ApplicationIconType.ICON_24:
					model.linuxIcons[model.linuxIcons.length] = bitmapData;
					break;
				case ApplicationIconType.ICON_24_HIGHLIGHTED:
					model.linuxHighlightedIcons[model.linuxHighlightedIcons.length] = bitmapData;
					break;
			}
		}
		
		protected function sortIconList(iconA:ApplicationIconVO, iconB:ApplicationIconVO):int
		{
			if (iconA.path < iconB.path)
			{
				return -1;
			}
			else if (iconA.path > iconB.path)
			{
				return 1;
			}
			
			return 0;
		}
		
		protected function highlightIcon():void
		{
			NativeApplication.nativeApplication.icon.bitmaps = (ApplicationUtil.linux) ? model.linuxHighlightedIcons : model.highlightedIcons;
		}
		
		protected function unhighlightIcon():void
		{
			NativeApplication.nativeApplication.icon.bitmaps = (ApplicationUtil.linux) ? model.linuxIcons : model.icons;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function importIconCompleteHandler(event:Event):void
		{
			var loader:Loader = (event.currentTarget as LoaderInfo).loader;

			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, importIconCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, importIconErrorHandler);
			
			model.iconList[model.iconList.length] = new ApplicationIconVO(String(loaderMap[loader]), loader.content as Bitmap);
			
			delete loaderMap[loader];
			
			if (model.iconList.length == 10)
			{
				model.icons.length = 0;
				model.highlightedIcons.length = 0;
				model.linuxIcons.length = 0;
				model.linuxHighlightedIcons.length = 0;
				
				model.iconList.sort(sortIconList);
				
				depositIcon(ApplicationIconType.ICON_16);
				depositIcon(ApplicationIconType.ICON_16_HIGHLIGHTED);
				depositIcon(ApplicationIconType.ICON_24);
				depositIcon(ApplicationIconType.ICON_24_HIGHLIGHTED);
				depositIcon(ApplicationIconType.ICON_32);
				depositIcon(ApplicationIconType.ICON_32_HIGHLIGHTED);
				depositIcon(ApplicationIconType.ICON_48);
				depositIcon(ApplicationIconType.ICON_48_HIGHLIGHTED);
				depositIcon(ApplicationIconType.ICON_128);
				depositIcon(ApplicationIconType.ICON_128_HIGHLIGHTED);
				
				if (workspaceController.getNumUnread() > 0)
				{
					highlightIcon();
				}
				else
				{
					unhighlightIcon();
				}
			}
		}
		
		protected function importIconErrorHandler(event:IOErrorEvent):void
		{
			var loader:Loader = (event.currentTarget as LoaderInfo).loader;
			trace("error", loaderMap[loader], event.text);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, importIconCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, importIconErrorHandler);
			
			delete loaderMap[loader];
		}
		
		protected function activateHandler(event:Event):void
		{
			signalBus.homeStreamNumUnreadChanged.remove(streamNumUnreadChangedHandler);
			signalBus.mentionsStreamNumUnreadChanged.remove(streamNumUnreadChangedHandler);
			signalBus.messagesStreamNumUnreadChanged.remove(streamNumUnreadChangedHandler);
			signalBus.searchStreamNumUnreadChanged.remove(streamNumUnreadChangedHandler);
			
			unhighlightIcon();
		}
		
		protected function deactivateHandler(event:Event):void
		{
			if (!accountModel.currentAccount) return;
			
			if (preferencesController.getBoolean(PreferenceType.HOME_NOTIFICATIONS)) signalBus.homeStreamNumUnreadChanged.add(streamNumUnreadChangedHandler);
			if (preferencesController.getBoolean(PreferenceType.MENTIONS_NOTIFICATIONS)) signalBus.mentionsStreamNumUnreadChanged.add(streamNumUnreadChangedHandler);
			if (preferencesController.getBoolean(PreferenceType.SEARCH_NOTIFICATIONS)) signalBus.messagesStreamNumUnreadChanged.add(streamNumUnreadChangedHandler);
			if (preferencesController.getBoolean(PreferenceType.MESSAGES_NOTIFICATIONS)) signalBus.searchStreamNumUnreadChanged.add(streamNumUnreadChangedHandler);
		}
		
		protected function exitingHandler(event:Event):void
		{
			//databaseController.cleanup();
		}

		protected function streamNumUnreadChangedHandler(account:AccountModule, numUnread:int, delta:int):void
		{
			if (workspaceController.getNumUnread() > 0)
			{
				highlightIcon();
			}
		}
	}
}