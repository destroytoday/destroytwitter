package com.destroytoday.destroytwitter.manager
{
	import flash.text.TextFormat;

	public class TextFormatManager
	{
		protected static const textFormatMap:Object = {};
		
		public static function getTextFormat(font:String, size:Number, color:int = -1, leading:Number = NaN, align:String = null):TextFormat 
		{
			var key:String = font + ", " + size + ", " + color + ", " + leading + ", " + align;
			var textFormat:TextFormat = textFormatMap[key];
			
			if (!textFormat) {
				textFormat = textFormatMap[key] = new TextFormat(font, size, (color != -1) ? color : null, null, null, null, null, null, align, null, null, null, (leading < 0 || leading >= 0) ? leading : null);
			}
			
			return textFormat;
		}
	}
}