package com.destroytoday.destroytwitter.model
{
	public class StreamModel extends BaseModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _awayMode:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get awayMode():Boolean
		{
			return _awayMode;
		}
		
		public function set awayMode(value:Boolean):void
		{
			if (value == _awayMode) return;
			
			_awayMode = value;
			
			signalBus.awayModeChanged.dispatch(_awayMode);
		}
	}
}