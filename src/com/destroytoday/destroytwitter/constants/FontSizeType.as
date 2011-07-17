package com.destroytoday.destroytwitter.constants
{
	public class FontSizeType
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		public static const SMALL:String = "small";

		public static const MEDIUM:String = "medium";

		public static const LARGE:String = "large";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FontSizeType()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function getPixels(type:String):int
		{
			var size:int;
			
			switch (type)
			{
				case SMALL:
					size = 11;
					break;
				case MEDIUM:
					size = 13;
					break;
				case LARGE:
					size = 14;
					break;
			}
			
			return size;
		}
	}
}