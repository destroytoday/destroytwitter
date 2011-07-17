package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;

	public class WorkspaceModel
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		protected var _state:String = WorkspaceState.HOME;
		
		public function WorkspaceModel()
		{
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

			signalBus.workspaceStateChanged.dispatch(oldState, _state);
		}
	}
}