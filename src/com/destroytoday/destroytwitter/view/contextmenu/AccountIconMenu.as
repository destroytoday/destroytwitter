package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class AccountIconMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var user:NativeMenuItem;
		
		public var logout:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AccountIconMenu()
		{
			super(
				<menu>
					<item name="user" label="[user]" selected="true" />
					<separator />
					<item name="logout" label="Logout" />
				</menu>
			);
		}
	}
}