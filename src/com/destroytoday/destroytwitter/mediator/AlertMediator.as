package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.AlertModel;
	import com.destroytoday.destroytwitter.view.components.Alert;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	public class AlertMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var controller:AlertController;
		
		[Inject]
		public var model:AlertModel;
		
		[Inject]
		public var view:Alert;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AlertMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(view, MouseEvent.CLICK, clickHandler, MouseEvent);
			
			signalBus.alertChanged.add(alertChangedHandler);
			signalBus.alertClosed.add(alertClosedHandler);
			
			if (model.summary)
			{
				alertChangedHandler(model.summary);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function clickHandler(event:MouseEvent):void
		{
			controller.close();
		}
		
		protected function alertChangedHandler(summary:String):void
		{
			view.y = (accountModel.currentAccount) ? 27.0 : 0.0;
			view.text = summary;
			view.displayed = true;
		}
		
		protected function alertClosedHandler():void
		{
			view.displayed = false;
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view, stylesheet.getStyle('.Alert'));
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.AlertTextField'));
			
			//view.textfield.styleSheet = view.textfield.styleSheet;
		}
	}
}