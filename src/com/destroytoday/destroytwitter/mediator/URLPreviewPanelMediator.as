package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.constants.LinkType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DatabaseController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.ProfilePanelController;
	import com.destroytoday.destroytwitter.controller.URLPreviewPanelController;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.model.vo.URLPreviewVO;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.drawer.Filter;
	import com.destroytoday.destroytwitter.view.drawer.ProfilePanel;
	import com.destroytoday.destroytwitter.view.drawer.URLPreviewPanel;
	import com.destroytoday.twitteraspirin.constants.RelationshipType;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class URLPreviewPanelMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var linkController:LinkController;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var controller:URLPreviewPanelController;
		
		[Inject]
		public var view:URLPreviewPanel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function URLPreviewPanelMediator()
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
			signalBus.drawerOpenedForURLPreview.add(drawerOpenedForURLPreviewHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);
			signalBus.gotURLPreview.add(gotURLPreviewHandler);
			signalBus.gotURLPreviewError.add(gotURLPreviewErrorHandler);
			
			view.heightChanged.add(heightChangedHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function drawerOpenedHandler(state:String):void
		{
			if (state == DrawerState.URL_PREVIEW)
			{
				view.fontType = preferencesController.getPreference(PreferenceType.FONT_TYPE);
				
				view.visible = true;
			}
			else
			{
				view.visible = false;
			}
		}
		
		protected function drawerOpenedForURLPreviewHandler(url:String):void
		{
			view.data = null;
			view.spinner.displayed = true;

			controller.getURLPreview(url);
		}
		
		protected function drawerClosedHandler():void
		{
			view.height = 0.0;
			
			controller.cancelGetURLPreview();
			
			view.spinner.displayed = false;
		}
		
		protected function gotURLPreviewHandler(urlPreview:URLPreviewVO):void
		{
			view.spinner.displayed = false;
			view.data = urlPreview;
		}
		
		protected function gotURLPreviewErrorHandler(error:String):void
		{
			drawerController.close();
		}
		
		protected function heightChangedHandler(height:Number):void
		{
			drawerController.updatePosition();
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.URLPreviewTextField'));
		}
	}
}