package com.destroytoday.destroytwitter.constants
{
	public class RefreshRateType
	{
		public static const NEVER:String = "never";
		
		public static const THIRTY_SECONDS:String = "30 seconds";

		public static const MINUTE:String = "1 minute";
		
		public static const TWO_MINUTES:String = "2 minutes";
		
		public static const FIVE_MINUTES:String = "5 minutes";

		public static const TEN_MINUTES:String = "10 minutes";

		public static const THIRTY_MINUTES:String = "30 minutes";

		public static const HOUR:String = "60 minutes";
		
		public static const valueEnum:Object = 
			{
				"never": 0,
				"30 seconds": 30000,
				"1 minute": 60000,
				"2 minutes": 120000,
				"5 minutes": 300000,
				"10 minutes": 600000,
				"30 minutes": 1800000,
				"60 minutes": 3600000
			}
			
		public static const nameEnum:Object = 
			{
				"never": "refreshRateNever",
				"30 seconds": "refreshRateThirtySeconds",
				"1 minute": "refreshRateOneMinute",
				"2 minutes": "refreshRateTwoMinutes",
				"5 minutes": "refreshRateFiveMinutes",
				"10 minutes": "refreshRateTenMinutes",
				"30 minutes": "refreshRateThirtyMinutes",
				"60 minutes": "refreshRateSixtyMinutes"
			}
			
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RefreshRateType()
		{
		}
	}
}