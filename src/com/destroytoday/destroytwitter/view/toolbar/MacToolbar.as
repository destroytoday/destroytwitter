package com.destroytoday.destroytwitter.view.toolbar
{
	import com.destroytoday.desktop.NativeMenuPlus;
	import com.destroytoday.util.NativeMenuUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.ui.Keyboard;

	public class MacToolbar
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var applicationMenu:NativeMenu;
			
			public var aboutItem:NativeMenuItem;
		
			public var preferencesItem:NativeMenuItem;
		
		public var fileMenu:NativeMenu;
		
			public var newStatusItem:NativeMenuItem;
			
			public var uploadFileItem:NativeMenuItem;

			public var reloadThemeItem:NativeMenuItem;
		
		public var editMenu:NativeMenu;
		
		public var streamMenu:StreamMenu;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MacToolbar()
		{
			//--------------------------------------
			//  Application menu
			//--------------------------------------
			applicationMenu = NativeApplication.nativeApplication.menu.getItemAt(0).submenu;
			
			aboutItem = applicationMenu.getItemAt(0);
			aboutItem.label = "About DestroyTwitter";
			preferencesItem = applicationMenu.addItemAt(new NativeMenuItem("Preferences..."), 2);
			preferencesItem.keyEquivalentModifiers = [Keyboard.COMMAND];
			preferencesItem.keyEquivalent = ',';
			
			applicationMenu.addItemAt(new NativeMenuItem("", true), 3);
			
			//--------------------------------------
			//  File menu
			//--------------------------------------
			fileMenu = NativeApplication.nativeApplication.menu.getItemAt(1).submenu;
			
			newStatusItem = fileMenu.addItemAt(new NativeMenuItem("New Tweet..."), 0);
			newStatusItem.keyEquivalentModifiers = [Keyboard.COMMAND];
			newStatusItem.keyEquivalent = 't';
			
			fileMenu.addItemAt(new NativeMenuItem("", true), 1);
			
			uploadFileItem = fileMenu.addItemAt(new NativeMenuItem("Upload File..."), 2);
			uploadFileItem.keyEquivalentModifiers = [Keyboard.COMMAND];
			uploadFileItem.keyEquivalent = 'u';
			
			fileMenu.addItemAt(new NativeMenuItem("", true), 3);
			
			reloadThemeItem = fileMenu.addItemAt(new NativeMenuItem("Reload Current Theme"), 4);
			reloadThemeItem.keyEquivalentModifiers = [Keyboard.COMMAND, Keyboard.SHIFT, Keyboard.ALTERNATE];
			reloadThemeItem.keyEquivalent = 'r';
			
			fileMenu.addItemAt(new NativeMenuItem("", true), 5);
			
			//--------------------------------------
			//  Edit menu
			//--------------------------------------
			editMenu = NativeApplication.nativeApplication.menu.getItemAt(2).submenu;
			
			//--------------------------------------
			//  Stream menu
			//--------------------------------------
			streamMenu = new StreamMenu();
			NativeApplication.nativeApplication.menu.addItemAt(new NativeMenuItem('Stream'), 3).submenu = streamMenu;
		}
	}
}