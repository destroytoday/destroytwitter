package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.LoadState;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.model.NotificationModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class NotificationController
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
		public var model:NotificationModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NotificationController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			signalBus.accountSelected.add(accountSelectedHandler);
			signalBus.notificationSoundChanged.add(notificationSoundChangedHandler);
		}
		
		public function loadSound(name:String):void
		{
			if (name == model.soundName) 
			{
				if (model.playSoundOnLoad && model.soundLoadState == LoadState.LOADED) playSound();
				
				return;
			}
			
			if (model.soundLoadState == LoadState.LOADING)
			{
				model.sound.close();
			}
			
			model.soundName = name;
			
			if (name == "none") 
			{
				model.soundLoadState = LoadState.UNLOADED;
				
				model.sound = null;
			}
			else
			{
				model.soundLoadState = LoadState.LOADING;
				
				var url:String = "assets/sounds/" + name + ".mp3";
				
				model.sound = new Sound(new URLRequest(url));
				
				model.sound.addEventListener(Event.COMPLETE, soundLoadCompleteHandler, false, 0, true);
				model.sound.addEventListener(IOErrorEvent.IO_ERROR, soundLoadErrorHandler, false, 0, true);
			}
		}
		
		public function playSound():void
		{
			if (model.sound && model.soundLoadState == LoadState.LOADED)
			{
				model.sound.play();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Hanlders
		//
		//--------------------------------------------------------------------------
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (account)
			{
				model.playSoundOnLoad = false;
				
				loadSound(preferencesController.getPreference(PreferenceType.NOTIFICATION_SOUND));
			}
		}
		
		protected function notificationSoundChangedHandler(name:String):void
		{
			model.playSoundOnLoad = true;
			
			loadSound(name);
		}
		
		protected function soundLoadCompleteHandler(event:Event):void
		{
			model.soundLoadState = LoadState.LOADED;
			
			if (model.playSoundOnLoad) playSound();
			trace("sound loaded");
		}
		
		protected function soundLoadErrorHandler(event:Event):void
		{
			model.soundLoadState = LoadState.ERROR;
			
			trace("sound couldn't load!", event);
		}
	}
}