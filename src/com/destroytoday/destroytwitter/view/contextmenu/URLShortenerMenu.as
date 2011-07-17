package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class URLShortenerMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var autoShortenURLs:NativeMenuItem;
		
		public var jmp:NativeMenuItem;
		
		public var bitly:NativeMenuItem;

		public var isgd:NativeMenuItem;
	
		public var tinyurl:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function URLShortenerMenu()
		{
			super(
				<menu>
					<item name="autoShortenURLs" label="Auto shorten URLs on paste" />
					<separator />
					<item name="jmp" label="j.mp" />
					<item name="bitly" label="bit.ly" />
					<item name="isgd" label="is.gd" />
					<item name="tinyurl" label="TinyURL" />
				</menu>
			);
		}
	}
}