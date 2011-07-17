package com.destroytoday.destroytwitter.model.vo
{
	

	public class PreferenceLinkVO
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var type:String;
		
		public var text:String;

		public var url:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PreferenceLinkVO(type:String, text:String, url:String = null)
		{
			this.type = type;
			this.text = text;
			this.url = url;
		}
	}
}