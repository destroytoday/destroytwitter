package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.desktop.KonamiCode;
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.stream.StreamController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.model.WorkspaceModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.toolbar.MacToolbar;
	import com.destroytoday.destroytwitter.view.toolbar.StreamMenu;
	import com.destroytoday.destroytwitter.view.toolbar.SystemTray;
	import com.destroytoday.util.ApplicationUtil;
	import com.destroytoday.util.WindowUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ScreenMouseEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;

	public class HotkeyController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var workspaceController:WorkspaceController;
		
		[Inject]
		public var composeController:ComposeController;
		
		[Inject]
		public var styleController:StyleController;
		
		[Inject]
		public var streamController:StreamController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var workspaceModel:WorkspaceModel;
		
		[Inject]
		public var drawerModel:DrawerModel;
		
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		protected var toolbar:MacToolbar;
		
		protected var systemTray:SystemTray;
		
		protected var konamiCode:KonamiCode;
		
		protected var konamiCodeSound:Sound;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function HotkeyController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setup():void
		{
			konamiCode = new KonamiCode(contextView.stage);
			
			konamiCode.executed.add(konamiCodeExecutedHandler);
			
			signalBus.accountSelected.add(accountSelectedHandler);
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);

			contextView.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			if (ApplicationUtil.mac)
			{
				toolbar = new MacToolbar();
				
				/*for each (var item:NativeMenuItem in toolbar.applicationMenu.items)
				{
					if (item.keyEquivalentModifiers && item.keyEquivalentModifiers.length == 1 && item.keyEquivalentModifiers[0] == Keyboard.COMMAND && item.keyEquivalent == "h")
					{
						item.addEventListener(Event.SELECT, hideSelectedHandler);
						
						break;
					}
				}*/
				
				signalBus.workspaceStateChanged.add(workspaceStateChangedHandler);
				signalBus.awayModeChanged.add(awayModeChangedHandler);
				
				toolbar.applicationMenu.addEventListener(Event.SELECT, applicationMenuSelectHandler);
				toolbar.fileMenu.addEventListener(Event.SELECT, fileMenuSelectHandler);
				toolbar.editMenu.getItemAt(1).addEventListener(Event.SELECT, editCopyHandler);
				toolbar.streamMenu.addEventListener(Event.SELECT, streamMenuSelectHandler);
			}
			else if (ApplicationUtil.pc)
			{
				systemTray = new SystemTray();
				
				systemTray.icon.addEventListener(ScreenMouseEvent.CLICK, systemTrayIconClickHandler);
				systemTray.addEventListener(Event.SELECT, systemTrayMenuSelectHandler);
				contextView.stage.addEventListener(KeyboardEvent.KEY_UP, pcKeyUpHandler);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Helper Methods
		//
		//--------------------------------------------------------------------------

		protected function updateApplicationMenu():void
		{
			toolbar.preferencesItem.enabled = accountModel.currentAccount != null;
		}
		
		protected function updateFileMenu():void
		{
			toolbar.newStatusItem.enabled = accountModel.currentAccount != null && !drawerModel.opened;
			toolbar.uploadFileItem.enabled = accountModel.currentAccount != null && drawerModel.opened && 
				(drawerModel.state == DrawerState.COMPOSE || drawerModel.state == DrawerState.COMPOSE_REPLY || drawerModel.state == DrawerState.COMPOSE_MESSAGE_REPLY);
			toolbar.reloadThemeItem.enabled = accountModel.currentAccount != null;
		}
		
		protected function updateStreamMenu():void
		{
			var currentStreamItemsEnabled:Boolean;
			var streamItemsEnabled:Boolean;
			
			switch (workspaceModel.state)
			{
				case WorkspaceState.HOME:
				case WorkspaceState.MENTIONS:
				case WorkspaceState.SEARCH:
				case WorkspaceState.MESSAGES:
					currentStreamItemsEnabled = true;
					break;
				default:
					currentStreamItemsEnabled = false;
			}
			
			if (accountModel.currentAccount)
			{
				streamItemsEnabled = true;
			}
			else
			{
				currentStreamItemsEnabled = false;
				streamItemsEnabled = false;
			}
			
			toolbar.streamMenu.home.enabled =
			toolbar.streamMenu.mentions.enabled = 
			toolbar.streamMenu.messages.enabled = 
			toolbar.streamMenu.search.enabled = 
			toolbar.streamMenu.enableAwayMode.enabled =
				streamItemsEnabled;
			
			toolbar.streamMenu.refresh.enabled = 
			toolbar.streamMenu.markStreamAsRead.enabled = 
			toolbar.streamMenu.find.enabled = currentStreamItemsEnabled;
			toolbar.streamMenu.configureFilter.enabled = (workspaceModel.state != WorkspaceState.SEARCH && workspaceModel.state != WorkspaceState.MESSAGES);
		}
		
		protected function updateSystemTrayMenu():void
		{
			systemTray.tweet.enabled = accountModel.currentAccount != null && !drawerModel.opened;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function konamiCodeExecutedHandler():void
		{
			contextView.scaleX *= -1; 
			contextView.x -= contextView.width * contextView.scaleX; 
			
			if (!konamiCodeSound)
			{
				konamiCodeSound = new Sound(new URLRequest("/assets/konami.mp3"));
			
				konamiCodeSound.addEventListener(Event.COMPLETE, konamiCodeSoundCompleteHandler);
				konamiCodeSound.addEventListener(IOErrorEvent.IO_ERROR, konamiCodeSoundErrorHandler);
			}
			else
			{
				konamiCodeSound.play();
			}
		}
		
		protected function konamiCodeSoundCompleteHandler(event:Event):void
		{
			konamiCodeSound.play();
		}
		
		protected function konamiCodeSoundErrorHandler(event:IOErrorEvent):void
		{
			konamiCodeSound = null;
		}
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (ApplicationUtil.mac)
			{
				updateApplicationMenu();
				updateFileMenu();
				updateStreamMenu();
			}
			else if (ApplicationUtil.pc)
			{
				updateSystemTrayMenu();
			}
		}
		
		protected function drawerOpenedHandler(state:String):void
		{
			if (ApplicationUtil.mac)
			{
				updateFileMenu();
			}
			else if (ApplicationUtil.pc)
			{
				updateSystemTrayMenu();
			}
		}
		
		protected function drawerClosedHandler():void
		{
			if (ApplicationUtil.mac)
			{
				updateFileMenu();
			}
			else if (ApplicationUtil.pc)
			{
				updateSystemTrayMenu();
			}
		}
		
		protected function workspaceStateChangedHandler(oldState:String, newState:String):void
		{
			updateStreamMenu();
		}
		
		protected function awayModeChangedHandler(enabled:Boolean):void
		{
			toolbar.streamMenu.enableAwayMode.checked = enabled;
		}
		
		protected function applicationMenuSelectHandler(event:Event):void
		{
			var menu:NativeMenu = toolbar.applicationMenu;
			var item:NativeMenuItem = event.target as NativeMenuItem;

			switch (item) {
				case toolbar.preferencesItem:
					workspaceController.setState(WorkspaceState.PREFERENCES);
					break;
			}
		}
		
		protected function fileMenuSelectHandler(event:Event):void
		{
			var menu:NativeMenu = toolbar.fileMenu;
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			switch (item) {
				case toolbar.newStatusItem:
					drawerController.openStatusUpdate();
					break;
				case toolbar.uploadFileItem:
					composeController.browseFilesForUpload();
					break;
				case toolbar.reloadThemeItem:
					styleController.reloadStylesheet();
					break;
			}
		}
		
		protected function hideSelectedHandler(event:Event):void //TODO
		{
			contextView.stage.nativeWindow.visible = false;
		}
		
		protected function editCopyHandler(event:Event):void
		{
			signalBus.hotkeyCopySelected.dispatch();
		}
		
		protected function streamMenuSelectHandler(event:Event):void
		{
			var menu:StreamMenu = toolbar.streamMenu;
			var item:NativeMenuItem = event.target as NativeMenuItem;

			switch (item) {
				case menu.home:
					workspaceController.setState(WorkspaceState.HOME);
					break;
				case menu.mentions:
					workspaceController.setState(WorkspaceState.MENTIONS);
					break;
				case menu.search:
					workspaceController.setState(WorkspaceState.SEARCH);
					break;
				case menu.messages:
					workspaceController.setState(WorkspaceState.MESSAGES);
					break;
				case menu.refresh:
					signalBus.hotkeyStreamRefreshSelected.dispatch();
					break;
				case menu.markStreamAsRead:
					workspaceController.markCurrentStreamStatusesRead();
					break;
				case menu.enableAwayMode:
					streamController.toggleAwayMode();
					break;
				/*case menu.mostRecent:
					signalBus.hotkeyStreamMostRecentSelected.dispatch();
					break;
				case menu.newer:
					signalBus.hotkeyStreamNewerSelected.dispatch();
					break;
				case menu.older:
					signalBus.hotkeyStreamOlderSelected.dispatch();
					break;*/
				case menu.find:
					drawerController.openFind();
					break;
				case menu.configureFilter:
					drawerController.openFilter(workspaceModel.state);
					break;
			}
		}
		
		protected function keyUpHandler(event:KeyboardEvent):void
		{
			if (!event.ctrlKey || !accountModel.currentAccount) return;
			
			if (!event.shiftKey && !event.altKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.TAB:
						workspaceController.selectCanvasRight();
						break;
				}
			}
			else if (!event.altKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.TAB:
						workspaceController.selectCanvasLeft();
						break;
				}
			}
		}
		
		protected function pcKeyUpHandler(event:KeyboardEvent):void
		{
			if (!event.ctrlKey || !accountModel.currentAccount) return;
			
			if (event.shiftKey && !event.altKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.F:
						if (workspaceModel.state == WorkspaceState.HOME ||
							workspaceModel.state == WorkspaceState.MENTIONS)
							drawerController.openFilter(workspaceModel.state);
						break;
					case Keyboard.A:
						streamController.toggleAwayMode();
						break;
				}
			}
			else if (event.shiftKey && event.altKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.R:
						styleController.reloadStylesheet();
						break;
				}
			}
			else if (!event.shiftKey && !event.altKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.COMMA:
						workspaceController.setState(WorkspaceState.PREFERENCES);
						break;
					case Keyboard.NUMBER_1:
						workspaceController.setState(WorkspaceState.HOME);
						break;
					case Keyboard.NUMBER_2:
						workspaceController.setState(WorkspaceState.MENTIONS);
						break;
					case Keyboard.NUMBER_3:
						workspaceController.setState(WorkspaceState.SEARCH);
						break;
					case Keyboard.NUMBER_4:
						workspaceController.setState(WorkspaceState.MESSAGES);
						break;
					case Keyboard.C:
						signalBus.hotkeyCopySelected.dispatch();
						break;
					case Keyboard.T:
						drawerController.openStatusUpdate();
						break;
					case Keyboard.R:
						signalBus.hotkeyStreamRefreshSelected.dispatch();
						break;
					case Keyboard.K:
						workspaceController.markCurrentStreamStatusesRead();
						break;
					case Keyboard.F:
						if (workspaceModel.state == WorkspaceState.HOME ||
							workspaceModel.state == WorkspaceState.MENTIONS ||
							workspaceModel.state == WorkspaceState.MESSAGES ||
							workspaceModel.state == WorkspaceState.SEARCH)
								drawerController.openFind();
						break;
					case Keyboard.U:
						if (drawerModel.opened && 
							(drawerModel.state == DrawerState.COMPOSE || 
							drawerModel.state == DrawerState.COMPOSE_REPLY || 
							drawerModel.state == DrawerState.COMPOSE_MESSAGE_REPLY))
						{
							composeController.browseFilesForUpload();
						}
						break;
					case Keyboard.Q:
						WindowUtil.closeAll(true);
						break;
				}
			}
		}
		
		protected function systemTrayIconClickHandler(event:ScreenMouseEvent):void
		{
			NativeApplication.nativeApplication.activate(contextView.stage.nativeWindow);
		}
		
		protected function systemTrayMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			switch (item)
			{
				case systemTray.tweet:
					NativeApplication.nativeApplication.activate(contextView.stage.nativeWindow);
					drawerController.openStatusUpdate();
					break;
				case systemTray.restore:
					NativeApplication.nativeApplication.activate(contextView.stage.nativeWindow);
					break;
				case systemTray.exit:
					WindowUtil.closeAll(true);
					break;
			}
		}
	}
}