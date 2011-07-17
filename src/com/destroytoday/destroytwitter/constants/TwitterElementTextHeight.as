package com.destroytoday.destroytwitter.constants
{
	public class TwitterElementTextHeight
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		public static const SMALL_DEFAULT:Number = 60.0;

		public static const SMALL_SYSTEM:Number = 63.0;
		
		public static const MEDIUM_DEFAULT:Number = 68.0;

		public static const MEDIUM_SYSTEM:Number = 71.0;
		
		public static const LARGE_DEFAULT:Number = 89.0;

		public static const LARGE_SYSTEM:Number = 87.0;
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		public function TwitterElementTextHeight()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function getHeight(font:String, size:String):Number
		{
			if (font == FontType.DEFAULT && size == FontSizeType.SMALL)
			{
				return SMALL_DEFAULT;
			}
			else if (font == FontType.SYSTEM && size == FontSizeType.SMALL)
			{
				return SMALL_SYSTEM;
			}
			else if (font == FontType.DEFAULT && size == FontSizeType.MEDIUM)
			{
				return MEDIUM_DEFAULT;
			}
			else if (font == FontType.SYSTEM && size == FontSizeType.MEDIUM)
			{
				return MEDIUM_SYSTEM;
			}
			else if (font == FontType.DEFAULT && size == FontSizeType.LARGE)
			{
				return LARGE_DEFAULT;
			}
			else if (font == FontType.SYSTEM && size == FontSizeType.LARGE)
			{
				return LARGE_SYSTEM;
			}
			
			return NaN;
		}
	}
}