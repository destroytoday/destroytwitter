package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.net.XMLLoader;
	
	import flash.utils.Timer;

	public class ProfilePanelModel
	{
		//--------------------------------------------------------------------------
		//
		//  Links
		//
		//--------------------------------------------------------------------------
		
		public var getUserLoader:XMLLoader;
		
		public var getUserTimer:Timer = new Timer(1500.0, 1.0);
		
		public var screenName:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProfilePanelModel()
		{
		}
	}
}