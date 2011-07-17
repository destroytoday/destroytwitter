package com.destroytoday.destroytwitter.mediator
{
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.UpdateController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.UpdateModel;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowTray;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.ErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	
	import mx.utils.ObjectUtil;

	public class ApplicationWindowTrayMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var updateController:UpdateController;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var updateModel:UpdateModel;
		
		[Inject]
		public var view:ApplicationWindowTray;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ApplicationWindowTrayMediator()
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

			updateModel.updater.addEventListener(UpdateEvent.INITIALIZED, initializedHandler);
			updateModel.updater.addEventListener(ErrorEvent.ERROR, errorHandler);
			updateModel.updater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, checkForUpdateHandler);
			updateModel.updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, updateStatusHandler);
			updateModel.updater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, updateErrorHandler);
			updateModel.updater.addEventListener(UpdateEvent.DOWNLOAD_START, downloadStartHandler);
			updateModel.updater.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			updateModel.updater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, downloadCompleteHandler);
			updateModel.updater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, downloadErrorHandler);
			updateModel.updater.addEventListener(UpdateEvent.BEFORE_INSTALL, beforeInstallHandler);

			view.textfield.addEventListener(MouseEvent.CLICK, textfieldClickHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function beforeInstallHandler(event:UpdateEvent):void
		{
			view.textfield.htmlText = "<p><span class=\"footer\">Installing...</span></p>";
		}
		
		protected function checkForUpdateHandler(event:UpdateEvent):void
		{
			view.textfield.htmlText = "<p><span class=\"footer\">Checking for updates...</span></p>";
		}
		
		protected function downloadCompleteHandler(event:UpdateEvent):void
		{
			view.textfield.htmlText = "<p><span class=\"footer\">Download complete</span></p>";
		}
		
		protected function downloadErrorHandler(event:DownloadErrorEvent):void
		{
			alertController.addMessage(AlertSourceType.UPDATER, "Update error: " + event.text);
			
			view.textfield.htmlText = "";
		}

		protected function downloadStartHandler(event:UpdateEvent):void
		{
			view.textfield.mouseEnabled = false;
			
			view.textfield.htmlText = "<p><span class=\"footer\">Starting download...</span></p>";
		}
		
		protected function errorHandler(event:ErrorEvent):void
		{
			alertController.addMessage(AlertSourceType.UPDATER, "Update error: " + event.text);
			
			view.textfield.htmlText = "";
		}
		
		protected function initializedHandler(event:UpdateEvent):void
		{
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			view.textfield.htmlText = "<p><span class=\"footer\">" + Math.round((event.bytesLoaded / event.bytesTotal) * 100.0) + "% of " + Math.round(event.bytesTotal * 0.001) + "kb</span></p>";
		}
		
		protected function updateErrorHandler(event:StatusUpdateErrorEvent):void
		{
			alertController.addMessage(AlertSourceType.UPDATER, "Update error: " + event.text);
			
			view.textfield.htmlText = "";
		}
		
		protected function updateStatusHandler(event:StatusUpdateEvent):void
		{
			if (event.available)
			{
				view.textfield.mouseEnabled = true;
				
				view.textfield.htmlText = "<p><a href=\"event:available\"><span class=\"footerLink\">Update available</span></a></p>";
			}
			else
			{
				view.textfield.htmlText = "";
			}
		}
		
		protected function textfieldClickHandler(event:MouseEvent):void
		{
			drawerController.openUpdate(updateModel.data);
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.TrayTextField'));
		}
	}
}