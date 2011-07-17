package com.destroytoday.destroytwitter.constants
{
	public class FontType
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		public static const DEFAULT:String = "default (Interstate Regular)";

		public static const SYSTEM:String = "system (Helvetica, Arial, unicode)";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FontType()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function getFont(type:String):String
		{
			var font:String;
			
			switch (type)
			{
				case FontType.DEFAULT:
					font = Font.INTERSTATE_REGULAR;
					break;
				case FontType.SYSTEM:
					font = Font.SANS;
					break;
			}
			
			return font;
		}
	}
}