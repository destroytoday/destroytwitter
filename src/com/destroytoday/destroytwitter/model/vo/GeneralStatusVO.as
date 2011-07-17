package com.destroytoday.destroytwitter.model.vo
{
	public class GeneralStatusVO extends GeneralTwitterVO
	{
		// ------------------------------------------------------------
		// 
		// Status
		// 
		// ------------------------------------------------------------
		
		public var source:String;
		
		public var inReplyToStatusID:String;
		
		public var inReplyToScreenName:String;
		
		public var favorited:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GeneralStatusVO()
		{
		}
	}
}