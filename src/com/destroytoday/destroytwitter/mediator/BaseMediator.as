package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.controller.StyleController;
	import com.destroytoday.destroytwitter.model.StyleModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class BaseMediator extends Mediator
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var styleController:StyleController;
		
		[Inject]
		public var styleModel:StyleModel;

		public function BaseMediator()
		{
		}
		
		override public function onRegister():void
		{
			signalBus.stylesheetChanged.add(stylesheetChangedHandler);
			
			stylesheetChangedHandler(styleModel.stylesheet);
		}
		
		override public function onRemove():void
		{
			signalBus.stylesheetChanged.remove(stylesheetChangedHandler);
		}

		protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
		}
	}
}