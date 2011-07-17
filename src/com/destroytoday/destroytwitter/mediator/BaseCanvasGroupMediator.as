package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvasGroup;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseStreamCanvas;
	
	import org.robotlegs.mvcs.Mediator;

	public class BaseCanvasGroupMediator extends Mediator
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		public function BaseCanvasGroupMediator()
		{
		}
		
		override public function onRegister():void
		{
			signalBus.workspaceStateChanged.add(workspaceStateChangedHandler);
		}
		
		protected function workspaceStateChangedHandler(oldState:String, newState:String):void
		{
			var view:BaseCanvasGroup = viewComponent as BaseCanvasGroup; //TODO
			var canvas:BaseStreamCanvas = view.getChildByName(newState) as BaseStreamCanvas;
			
			if (canvas) view.selectedCanvas = canvas;
		}
	}
}