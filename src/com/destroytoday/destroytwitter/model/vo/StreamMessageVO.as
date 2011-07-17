package com.destroytoday.destroytwitter.model.vo
{
	import com.destroytoday.destroytwitter.utils.DateFormatUtil;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;

	public class StreamMessageVO extends GeneralMessageVO implements IStreamVO
	{
		protected var _read:Boolean;
		
		public function StreamMessageVO()
		{
		}
		
		public function get read():Boolean
		{
			return (account != userID) ? _read : true;
		}
		
		public function set read(value:Boolean):void
		{
			_read = value;
		}
	}
}