package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	
	import flash.filesystem.File;

	public class ConfigModel
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		protected var _path:String;
		
		public function ConfigModel()
		{
		}

		public function get path():String
		{
			return _path;
		}

		public function set path(value:String):void
		{
			if (value == _path) return;
			
			_path = value;
			
			signalBus.configPathChanged.dispatch(_path);
		}
	}
}