package com.destroytoday.destroytwitter.model.vo
{
	public class AlertMessageVO
	{
		public var text:String;
		
		public var startTime:int;
		
		public var duration:int;
		
		public function AlertMessageVO()
		{
		}
		
		public function toString():String
		{
			return "[AlertMessageVO(startTime: " + startTime + ", duration: " + duration + ", text: " + text + ")]";
		}
	}
}