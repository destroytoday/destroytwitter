package com.destroytoday.destroytwitter.model
{
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class StyleModel
	{
		public var browseFile:File = new File();
		
		public var browseFilter:Array = [new FileFilter("DestroyTwitter themes", "*.dtwt;*.css")];
		
		protected var _stylesheet:IStyleSheet;
		
		protected var _path:String;
		
		public function StyleModel()
		{
		}
		
		public function get stylesheet():IStyleSheet
		{
			return _stylesheet;
		}

		public function set stylesheet(value:IStyleSheet):void
		{
			_stylesheet = value;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function set path(value:String):void
		{
			_path = value;
		}
	}
}