package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;

	public class BaseModel
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		public function BaseModel()
		{
		}
	}
}