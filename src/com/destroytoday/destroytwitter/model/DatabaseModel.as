package com.destroytoday.destroytwitter.model
{
	import flash.filesystem.File;

	public class DatabaseModel
	{
		public var file:File = new File(File.applicationStorageDirectory.nativePath + File.separator + "database.db"); //TODO
		
		public var isReady:Boolean;
		
		public function DatabaseModel()
		{
		}
	}
}