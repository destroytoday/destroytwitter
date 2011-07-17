package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.constants.CacheProperty;
	
	import flash.geom.Rectangle;
	import flash.net.SharedObject;

	public class CacheModel
	{
		public var sharedObject:SharedObject;
		
		public var iconMap:Object = {};

		public var iconCount:Object = {};
		
		public function CacheModel()
		{
		}
		
		public function get windowBounds():Rectangle
		{
			return sharedObject.data[CacheProperty.WINDOW_BOUNDS];
		}
		
		public function set windowBounds(value:Rectangle):void
		{
			sharedObject.data[CacheProperty.WINDOW_BOUNDS] = value;
		}
		
		public function get lastUsedAccountID():Number
		{
			return sharedObject.data[CacheProperty.LAST_USED_ACCOUNT_ID];
		}

		public function set lastUsedAccountID(value:Number):void
		{
			sharedObject.data[CacheProperty.LAST_USED_ACCOUNT_ID] = value;
		}
	}
}