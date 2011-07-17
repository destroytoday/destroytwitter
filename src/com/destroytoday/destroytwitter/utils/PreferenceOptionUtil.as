package com.destroytoday.destroytwitter.utils
{
	public class PreferenceOptionUtil
	{
		protected static const LANGUAGE_LIST:Object = 
			{
				Danish: 'da',
				Dutch: 'nl',
				English: 'en',
				Finnish: 'fi',
				French: 'fr',
				German: 'de',
				Italian: 'it',
				Polish: 'pl',
				Portuguese: 'pt',
				Russian: 'ru',
				Spanish: 'es',
				Swedish: 'sv'
			}
		
		public static function getOptionList(clazz:Class):Array
		{
			var optionList:Array = [];
				
			for each (var option:String in clazz)
			{
				optionList[optionList.length] = option;
			}
			
			return optionList;
		}
		
		public static function getLanguageCode(language:String):String
		{
			return LANGUAGE_LIST[language];
		}
	}
}