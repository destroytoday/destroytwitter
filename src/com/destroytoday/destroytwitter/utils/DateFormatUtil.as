package com.destroytoday.destroytwitter.utils
{
	import mx.formatters.DateFormatter;

	public class DateFormatUtil
	{
		protected static var _profileDateFormatter:DateFormatter;
		
		protected static var _twelveHourDateFormatter:DateFormatter;

		protected static var _twentyFourHourDateFormatter:DateFormatter;
		
		protected static function get profileDateFormatter():DateFormatter
		{
			if (!_profileDateFormatter) {
				_profileDateFormatter = new DateFormatter();
				
				_profileDateFormatter.formatString = "MMMM D, YYYY";
			}
			
			return _profileDateFormatter;
		}
		
		public static function formatProfileDate(date:Date):String
		{
			return profileDateFormatter.format(date);
		}
		
		protected static function get twelveHourDateFormatter():DateFormatter
		{
			if (!_twelveHourDateFormatter) {
				_twelveHourDateFormatter = new DateFormatter();
				
				_twelveHourDateFormatter.formatString = "MMM D &nbsp; &nbsp;L:NN A";
			}
			
			return _twelveHourDateFormatter;
		}

		public static function formatTwelveHourDate(date:Date):String
		{
			return twelveHourDateFormatter.format(date);
		}
		
		protected static function get twentyFourHourDateFormatter():DateFormatter
		{
			if (!_twentyFourHourDateFormatter) {
				_twentyFourHourDateFormatter = new DateFormatter();
				
				_twentyFourHourDateFormatter.formatString = "MMM D &nbsp; &nbsp;J:NN";
			}
			
			return _twentyFourHourDateFormatter;
		}
		
		public static function formatTwentyFourHourDate(date:Date):String
		{
			return twentyFourHourDateFormatter.format(date);
		}
	}
}