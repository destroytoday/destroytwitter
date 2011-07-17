package com.destroytoday.destroytwitter.model
{
	import air.update.ApplicationUpdater;
	
	import com.destroytoday.destroytwitter.model.vo.UpdateVO;
	
	import flash.net.SharedObject;

	public class UpdateModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public var updater:ApplicationUpdater = new ApplicationUpdater();
		
		public var cache:SharedObject = SharedObject.getLocal('Application');
		
		public var data:UpdateVO;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function UpdateModel()
		{
		}
	}
}
