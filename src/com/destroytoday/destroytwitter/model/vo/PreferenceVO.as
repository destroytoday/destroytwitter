package com.destroytoday.destroytwitter.model.vo
{
	public class PreferenceVO
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var type:String;
		public var text:String;
		public var options:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PreferenceVO(type:String, text:String, options:Array)
		{
			this.type = type;
			this.text = text;
			this.options = options;
		}
	}
}