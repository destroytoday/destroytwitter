package com.destroytoday.destroytwitter.manager
{
	import flash.utils.Dictionary;

	public class SingletonManager
	{
		protected static const singletonMap:Dictionary = new Dictionary();
		
		public static function getInstance(clazz:Class):*
		{
			var instance:* = singletonMap[clazz];
			
			if (!instance) instance = singletonMap[clazz] = new clazz();
			
			return instance;
		}
	}
}