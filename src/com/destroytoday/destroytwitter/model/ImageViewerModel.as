package com.destroytoday.destroytwitter.model
{
	import flash.net.URLRequest;

	public class ImageViewerModel extends BaseModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var url:String;
		
		public var request:URLRequest;
		
		protected var _opened:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ImageViewerModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get opened():Boolean
		{
			return _opened;
		}
		
		public function set opened(value:Boolean):void
		{
			if (value == _opened) return;
			
			_opened = value;
			
			if (_opened)
			{
				signalBus.imageViewerOpened.dispatch(request);
				
				request = null;
			}
			else
			{
				signalBus.imageViewerClosed.dispatch();
			}
		}
	}
}