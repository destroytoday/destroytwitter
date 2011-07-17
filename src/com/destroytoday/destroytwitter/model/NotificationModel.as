package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.constants.LoadState;
	
	import flash.media.Sound;

	public class NotificationModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var playSoundOnLoad:Boolean;
		
		protected var _sound:Sound;
		
		protected var _soundName:String;
		
		protected var _soundLoadState:String = LoadState.UNLOADED;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NotificationModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get sound():Sound
		{
			return _sound;
		}
		
		public function set sound(value:Sound):void
		{
			if (value == _sound) return;
			
			_sound = value;
		}
		
		public function get soundName():String
		{
			return _soundName;
		}
		
		public function set soundName(value:String):void
		{
			if (value == _soundName) return;
			
			_soundName = value;
		}
		
		public function get soundLoadState():String
		{
			return _soundLoadState;
		}
		
		public function set soundLoadState(value:String):void
		{
			if (value == _soundLoadState) return;
			
			_soundLoadState = value;
		}
	}
}