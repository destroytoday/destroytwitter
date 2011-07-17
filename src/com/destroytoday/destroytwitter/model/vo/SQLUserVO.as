package com.destroytoday.destroytwitter.model.vo
{
	import com.destroytoday.destroytwitter.utils.DateFormatUtil;

	public class SQLUserVO
	{
		public var id:Number;
		
		public var name:String;
		
		public var screenName:String;
		
		public var location:String;
		
		public var description:String;
		
		public var icon:String;
		
		public var url:String;
		
		public var isProtected:Boolean;
		
		public var followersCount:int;
		
		public var friendsCount:int;
		
		public var tweetingSince:String; // populated via the helper
		
		public var favoritesCount:int;

		public var listedCount:int;
		
		public var statusesCount:int;
		
		public function SQLUserVO()
		{
		}
		
		public function set createdAt(value:String):void
		{
			tweetingSince = DateFormatUtil.formatProfileDate(new Date(value));
		}
	}
}