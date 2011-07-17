package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class ComposeMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var restore:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ComposeMenu()
		{
			super(
				<menu>
					<item name="restore" label="Restore last tweet" />
				</menu>
			);
		}
	}
}