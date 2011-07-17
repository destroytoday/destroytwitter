package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.model.vo.ApplicationIconVO;
	
	import flash.display.Bitmap;

	public class ApplicationModel
	{
		public const debugMode:Boolean = true;
		
		public var iconList:Vector.<ApplicationIconVO> = new Vector.<ApplicationIconVO>();
		
		public var icons:Array =
			[
				(new (Asset.APPLICATION_ICON_16PX)() as Bitmap).bitmapData,
				(new (Asset.APPLICATION_ICON_32PX)() as Bitmap).bitmapData,
				(new (Asset.APPLICATION_ICON_48PX)() as Bitmap).bitmapData,
				(new (Asset.APPLICATION_ICON_128PX)() as Bitmap).bitmapData
			];
		
		public var highlightedIcons:Array =
			[
				(new (Asset.APPLICATION_ICON_16PX_HIGHLIGHTED)() as Bitmap).bitmapData,
				(new (Asset.APPLICATION_ICON_32PX_HIGHLIGHTED)() as Bitmap).bitmapData,
				(new (Asset.APPLICATION_ICON_48PX_HIGHLIGHTED)() as Bitmap).bitmapData,
				(new (Asset.APPLICATION_ICON_128PX_HIGHLIGHTED)() as Bitmap).bitmapData
			];
		
		public var linuxIcons:Array =
			[
				(new (Asset.APPLICATION_ICON_24PX)() as Bitmap).bitmapData
			];
		
		public var linuxHighlightedIcons:Array =
			[
				(new (Asset.APPLICATION_ICON_24PX_HIGHLIGHTED)() as Bitmap).bitmapData
			];
		
		public function ApplicationModel()
		{
		}
	}
}