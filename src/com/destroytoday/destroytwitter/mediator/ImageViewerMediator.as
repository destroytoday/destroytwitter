package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.model.ImageViewerModel;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.overlay.ImageViewer;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;

	public class ImageViewerMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var controller:ImageViewerController;
		
		[Inject]
		public var model:ImageViewerModel;
		
		[Inject]
		public var view:ImageViewer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ImageViewerMediator()
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
			
			signalBus.imageViewerOpened.add(imageViewerOpenedHandler);
			signalBus.imageViewerClosed.add(imageViewerClosedHandler);
			
			view.content.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			view.content.addEventListener(MouseEvent.CLICK, clickHandler);
			view.content.closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		// Events 
		//--------------------------------------
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			//--------------------------------------
			//  No modifiers
			//--------------------------------------
			if (!event.shiftKey && !event.altKey && !event.ctrlKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.ESCAPE:
						controller.close();
						break;
				}
			}
		}

		protected function loaderErrorHandler(event:IOErrorEvent):void
		{
			alertController.addMessage(AlertSourceType.IMAGE_VIEWER, "Error loading image");
			
			controller.close();
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (view.content.isLoaded)
			{
				navigateToURL(new URLRequest(model.url));
			}
			else
			{
				view.content.loader.close();
			}
			
			controller.close();
		}
		
		protected function closeButtonClickHandler(event:MouseEvent):void
		{
			event.stopPropagation();
			
			controller.close();
		}
		
		//--------------------------------------
		// Signals 
		//--------------------------------------
		
		protected function imageViewerOpenedHandler(request:URLRequest):void
		{
			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			view.includeInLayout = true;
			view.displayed = true;
			
			view.load(request);
		}
		
		protected function imageViewerClosedHandler():void
		{
			view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			view.displayed = false;
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyBitmapButtonStyle(view.content.closeButton);
			styleController.applyStyle(view.content.progressSpinner.progress.textfield, stylesheet.getStyle('.ProgressTextField'));
		}
	}
}