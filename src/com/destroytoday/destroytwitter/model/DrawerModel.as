package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;

	public class DrawerModel
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		protected var _opened:Boolean;
		
		protected var _state:String;
		
		protected var _status:GeneralStatusVO;
		
		public function DrawerModel()
		{
		}
		
		public function get opened():Boolean
		{
			return _opened;
		}

		public function set opened(value:Boolean):void
		{
			if (!value && value == _opened) return;
			
			_opened = value;
			
			if (_opened) {
				signalBus.drawerOpened.dispatch(_state);
			} else {
				signalBus.drawerClosed.dispatch();
			}
		}

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			if (value == _state) return;
			
			var oldState:String = _state;
			_state = value;
			
			signalBus.drawerStateChanged.dispatch(oldState, _state);
		}
	}
}