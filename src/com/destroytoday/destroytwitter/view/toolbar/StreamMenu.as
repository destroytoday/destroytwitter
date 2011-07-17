package com.destroytoday.destroytwitter.view.toolbar
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenuItem;
	
	public class StreamMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var home:NativeMenuItem;
		
		public var mentions:NativeMenuItem;

		public var search:NativeMenuItem;
		
		public var messages:NativeMenuItem;
		
		public var refresh:NativeMenuItem;

		public var markStreamAsRead:NativeMenuItem;

		public var enableAwayMode:NativeMenuItem;
		
		public var mostRecent:NativeMenuItem;
		
		public var newer:NativeMenuItem;
		
		public var older:NativeMenuItem;
		
		public var find:NativeMenuItem;

		public var configureFilter:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamMenu()
		{
			super(
				<menu>
					<item name="home" label="Home..." keyEquivalentModifiers="command" keyEquivalent="1" />
					<item name="mentions" label="Mentions..." keyEquivalentModifiers="command" keyEquivalent="2" />
					<item name="search" label="Search..." keyEquivalentModifiers="command" keyEquivalent="3" />
					<item name="messages" label="Messages..." keyEquivalentModifiers="command" keyEquivalent="4" />
					<separator />
					<item name="refresh" label="Refresh" keyEquivalentModifiers="command" keyEquivalent="r" />
					<item name="markStreamAsRead" label="Mark As Read" keyEquivalentModifiers="command" keyEquivalent="k" />
					<separator />
					<item name="configureFilter" label="Configure Filter..." keyEquivalentModifiers="command,shift" keyEquivalent="f" />
					<item name="find" label="Find..." keyEquivalentModifiers="command" keyEquivalent="f" />
					<separator />
					<item name="enableAwayMode" label="Enable Away Mode" keyEquivalentModifiers="command,shift" keyEquivalent="a" />
				</menu>
			);
			
			/*
			<item name="mostRecent" label="Most Recent" keyEquivalentModifiers="command,shift" keyEquivalent="]" />
			<item name="newer" label="Newer" keyEquivalentModifiers="command" keyEquivalent="]" />
			<item name="older" label="Older" keyEquivalentModifiers="command" keyEquivalent="[" />
			*/
		}
	}
}