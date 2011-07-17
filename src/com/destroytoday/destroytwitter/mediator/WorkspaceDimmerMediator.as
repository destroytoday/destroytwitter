package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.model.ImageViewerModel;
	import com.destroytoday.destroytwitter.view.dimmer.WorkspaceDimmer;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.MouseEvent;

	public class WorkspaceDimmerMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var imageViewerController:ImageViewerController;
		
		[Inject]
		public var drawerModel:DrawerModel;
		
		[Inject]
		public var imageViewerModel:ImageViewerModel;
		
		[Inject]
		public var view:WorkspaceDimmer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function WorkspaceDimmerMediator()
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
			
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);
			signalBus.imageViewerOpened.add(imageViewerOpenedHandler);
			signalBus.imageViewerClosed.add(imageViewerClosedHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		protected function close():void
		{
			if (!drawerModel.opened && !imageViewerModel.opened)
			{
				view.displayed = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function clickHandler(event:MouseEvent):void
		{
			drawerController.close();
			imageViewerController.close();
		}
		
		protected function drawerOpenedHandler(state:String):void
		{
			view.displayed = (state != DrawerState.FIND);
		}
		
		protected function drawerClosedHandler():void
		{
			close();
		}
		
		protected function imageViewerOpenedHandler(state:String):void
		{
			view.displayed = true;
		}
		
		protected function imageViewerClosedHandler():void
		{
			close();
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view, stylesheet.getStyle('.Dimmer'));
		}
	}
}