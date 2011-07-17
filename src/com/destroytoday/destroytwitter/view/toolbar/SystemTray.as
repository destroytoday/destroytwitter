package com.destroytoday.destroytwitter.view.toolbar
{
	import com.destroytoday.desktop.NativeMenuPlus;
	import com.destroytoday.destroytwitter.constants.Asset;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.NativeMenuItem;
	
	public class SystemTray extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var icon:SystemTrayIcon;
		
		public var tweet:NativeMenuItem;
		
		public var restore:NativeMenuItem;
		
		public var exit:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SystemTray()
		{
			super(
				<systemtray>
					<item name="tweet" label="Tweet..." keyEquivalentModifiers="control" keyEquivalent="t" />
					<separator />
					<item name="restore" label="Restore" />
					<item name="exit" label="Exit" keyEquivalentModifiers="control" keyEquivalent="q" />
				</systemtray>
			);
				
			icon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
			
			icon.bitmaps =
				[
					(new (Asset.APPLICATION_ICON_32PX)() as Bitmap).bitmapData
				];
			
			icon.menu = this;
			icon.tooltip = "DestroyTwitter";
		}
	}
}