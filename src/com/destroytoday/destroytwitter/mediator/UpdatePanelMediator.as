package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DatabaseController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.ProfilePanelController;
	import com.destroytoday.destroytwitter.controller.UpdateController;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.model.vo.UpdateVO;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.drawer.Filter;
	import com.destroytoday.destroytwitter.view.drawer.ProfilePanel;
	import com.destroytoday.destroytwitter.view.drawer.UpdatePanel;
	import com.destroytoday.twitteraspirin.constants.RelationshipType;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class UpdatePanelMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var controller:UpdateController;
		
		[Inject]
		public var view:UpdatePanel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function UpdatePanelMediator()
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
			
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerOpenedForUpdate.add(drawerOpenedForUpdateHandler);
			
			view.downloadButton.addEventListener(MouseEvent.CLICK, downloadClickHandler);
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function drawerOpenedHandler(state:String):void
		{
			view.visible = (state == DrawerState.UPDATE);
		}
		
		protected function drawerOpenedForUpdateHandler(data:UpdateVO):void
		{
			view.data = data;
		}
		
		protected function downloadClickHandler(event:MouseEvent):void
		{
			drawerController.close();
			
			controller.download();
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.UpdateTextField'));
			styleController.applyTextButtonStyle(view.downloadButton);
		}
	}
}