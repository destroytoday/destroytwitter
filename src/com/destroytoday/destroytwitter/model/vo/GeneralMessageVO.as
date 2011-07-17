package com.destroytoday.destroytwitter.model.vo
{
	import com.destroytoday.destroytwitter.utils.DateFormatUtil;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;

	public class GeneralMessageVO extends GeneralTwitterVO
	{
		//--------------------------------------------------------------------------
		//
		//  Recipient
		//
		//--------------------------------------------------------------------------
		
		public var recipientID:int;
		
		public var recipientFullName:String;
		
		public var recipientScreenName:String;
		
		public var recipientIcon:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GeneralMessageVO()
		{
		}
	}
}