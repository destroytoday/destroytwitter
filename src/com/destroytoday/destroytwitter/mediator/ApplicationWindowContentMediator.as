package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.controller.StyleController;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowContent;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ApplicationWindowContentMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var styleController:StyleController;
		
		[Inject]
		public var view:ApplicationWindowContent;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ApplicationWindowContentMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			view.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, nativeDragEnterHandler);
			view.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, nativeDragDropHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function nativeDragEnterHandler(event:NativeDragEvent):void
		{
			if (event.clipboard && event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var fileList:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
		
				if (fileList && fileList.length == 1 && fileList[0] is File && (fileList[0] as File).extension == 'dtwt')
				{
					NativeDragManager.acceptDragDrop(view);
				}
			}
		}
		
		protected function nativeDragDropHandler(event:NativeDragEvent):void
		{
			var fileList:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			if (fileList.length == 1 && (fileList[0] as File).extension == 'dtwt')
			{
				var file:File = fileList[0];
				
				styleController.convertTheme(file.nativePath);
			}
		}
	}
}