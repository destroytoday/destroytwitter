package com.destroytoday.destroytwitter.controller
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;

	public class ClipboardController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var linkController:LinkController;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ClipboardController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function copyText(text:String):void
		{
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
			
			alertController.addMessage(null, "Copied \"" + text + "\" to the clipboard.");
		}
		
		public function normalize():void
		{
			var text:String = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
			
			if (text)
			{
				var _text:String = linkController.normalizeLink(text);
				
				if (_text != text)
				{
					Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _text);
				}
			}
		}
	}
}