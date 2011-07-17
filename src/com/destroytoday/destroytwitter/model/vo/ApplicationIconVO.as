package com.destroytoday.destroytwitter.model.vo
{
	import flash.display.Bitmap;

	public class ApplicationIconVO
	{
		public var path:String;
		
		public var bitmap:Bitmap;
		
		public function ApplicationIconVO(path:String, bitmap:Bitmap)
		{
			this.path = path;
			this.bitmap = bitmap;
		}
		
		public function toString():String
		{
			return path;
		}
	}
}