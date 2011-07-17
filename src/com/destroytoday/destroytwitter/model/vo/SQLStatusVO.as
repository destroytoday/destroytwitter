package com.destroytoday.destroytwitter.model.vo
{
	public class SQLStatusVO
	{
		// ------------------------------------------------------------
		// 
		// Status
		// 
		// ------------------------------------------------------------
		
		public var key:integer;
		
		public var createdAt:Date; // populated via the helper
		
		public var id:Number;
		
		public var text:String;
		
		public var source:String;
		
		public var inReplyToStatusID:Number;
		
		public var inReplyToUserID:Number;
		
		public var inReplyToScreenName:String;
		
		public var favorited:Boolean;
		
		// ------------------------------------------------------------
		// 
		// User
		// 
		// ------------------------------------------------------------
		
		public var userID:Number;
		
		public var userScreenName:String;
		
		public var userIcon:String;
		
		public function SQLStatusVO()
		{
		}
		
		// ------------------------------------------------------------
		// 
		// Helper Methods
		// 
		// ------------------------------------------------------------
		
		public function set timestamp(value:String):void
		{
			createdAt = new Date(value);
		}
	}
}