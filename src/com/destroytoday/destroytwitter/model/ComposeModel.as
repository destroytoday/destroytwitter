package com.destroytoday.destroytwitter.model
{
	public class ComposeModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _previousMessage:String;

		protected var _message:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ComposeModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get previousMessage():String
		{
			return _previousMessage;
		}
		
		public function set previousMessage(value:String):void
		{
			if (value == _previousMessage) return;
			
			_previousMessage = value;
		}
		
		public function get message():String
		{
			return _message;
		}
		
		public function set message(value:String):void
		{
			if (value == _message) return;
			
			_message = value;
		}
	}
}