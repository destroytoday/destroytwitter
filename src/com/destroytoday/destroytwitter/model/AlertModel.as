package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.model.vo.AlertMessageVO;

	public class AlertModel extends BaseModel
	{
		protected var _messageList:Vector.<AlertMessageVO> = new Vector.<AlertMessageVO>();
		
		protected var _messageHash:Object = {};
		
		protected var _summary:String;
		
		public function AlertModel()
		{
		}
		
		public function get messageList():Vector.<AlertMessageVO>
		{
			return _messageList;
		}
		
		public function get messageHash():Object
		{
			return _messageHash;
		}
		
		public function get summary():String
		{
			return _summary;
		}
		
		public function set summary(value:String):void
		{
			_summary = value;
		}
	}
}