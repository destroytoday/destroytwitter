package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenuItem;
	
	public class StreamOptionsMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var tweetsPerPage:NativeMenuItem;
		
		public var refreshRate:NativeMenuItem;
		
		public var refresh:NativeMenuItem;
		
		public var markAsRead:NativeMenuItem;
		
		public var find:NativeMenuItem;

		public var enableNotifications:NativeMenuItem;
		
		public var enableFilter:NativeMenuItem;

		public var configureFilter:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamOptionsMenu()
		{
			super(
				<menu>
					<menu name="refreshRate" label="Refresh Rate">
						<item label="never" />
						<item label="30 seconds" />
						<item label="1 minute" />
						<item label="2 minutes" />
						<item label="5 minutes" />
						<item label="10 minutes" />
						<item label="30 minutes" />
						<item label="60 minutes" />
					</menu>
					<menu name="tweetsPerPage" label="Tweets Per Page">
						<item label="20" />
						<item label="30" />
						<item label="40" />
						<item label="50" />
						<item label="100" />
						<item label="200" />
					</menu>
					<separator />
					<item name="refresh" label="Refresh" keyEquivalent="r" />
					<item name="markAsRead" label="Mark As Read" keyEquivalent="k" />
					<separator />
					<item name="enableFilter" label="Enable Filter" />
					<item name="configureFilter" label="Configure Filter..." keyEquivalent="f" />
					<item name="find" label="Find..." keyEquivalent="f" />
					<separator />
					<item name="enableNotifications" label="Enable Notifications" />
				</menu>
			);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function set canFilter(canFilter:Boolean):void
		{
			if (canFilter && !enableFilter.menu)
			{
				addItemAt(enableFilter, numItems - 3);
				addItemAt(configureFilter, numItems - 3);
			}
			else if (!canFilter && enableFilter.menu)
			{
				removeItem(enableFilter);
				removeItem(configureFilter);
			}
		}
	}
}