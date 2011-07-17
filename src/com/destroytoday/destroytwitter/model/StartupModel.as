package com.destroytoday.destroytwitter.model
{
	import org.osflash.signals.Signal;

	public class StartupModel
	{
		public const statusChanged:Signal = new Signal(String);
		
		protected var _status:String = "starting up";
		
		public function StartupModel()
		{
		}
		
		public function get status():String
		{
			return _status;
		}
		
		public function set status(value:String):void
		{
			if (value == _status) return;
			
			_status = value;
			
			statusChanged.dispatch(_status);
		}
	}
}