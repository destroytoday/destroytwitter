package com.destroytoday.destroytwitter.utils
{
	import com.adobe.utils.StringUtil;

	public class FilterUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Regex
		//
		//--------------------------------------------------------------------------
		
		protected static const MODULA_REGEX:RegExp = /\%/ig;

		protected static const ESCAPED_MODULA_REGEX:RegExp = /\\%/ig;

		protected static const SINGLE_QUOTES_REGEX:RegExp = /\'/ig;

		protected static const ESCAPED_SINGLE_QUOTES_REGEX:RegExp = /\'\'/ig;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FilterUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function formatForSQL(filter:String):Array
		{
			var filterList:Array = filter.replace(SINGLE_QUOTES_REGEX, '\'\'').split(',');
			var m:uint = filterList.length;
			
			for (var i:uint = 0; i < m; ++i)
			{
				filterList[i] = StringUtil.trim(filterList[i]);
				
				if (!filterList[i])
				{
					filterList.splice(i, 1);
					
					--i;
					--m;
				}
			}

			return filterList;
		}
		
		public static function formatForDisplay(filterList:Array):String
		{
			filterList.sort(Array.CASEINSENSITIVE);
			
			return filterList.join(', ').replace(ESCAPED_SINGLE_QUOTES_REGEX, '\'');
		}
	}
}