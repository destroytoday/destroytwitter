package com.destroytoday.destroytwitter.model.vo
{
	import com.destroytoday.destroytwitter.utils.DateFormatUtil;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;

	public class StreamStatusVO extends GeneralStatusVO implements IStreamVO
	{
		protected var _read:Boolean;
		
		public function StreamStatusVO()
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