package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.controller.AccountModuleController;
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.WorkspaceController;
	import com.destroytoday.destroytwitter.controller.stream.StreamController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.model.StreamModel;
	import com.destroytoday.destroytwitter.model.WorkspaceModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.navigation.BaseNavigationButton;
	import com.destroytoday.destroytwitter.view.navigation.FooterNavigationBar;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.util.FileUtil;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class FooterNavigationBarMediator extends BaseMediator
	{

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var accountController:AccountModuleController;

		[Inject]
		public var accountModel:AccountModuleModel;

		[Inject]
		public var contextMenuController:ContextMenuController;

		[Inject]
		public var cacheController:CacheController;

		[Inject]
		public var drawerController:DrawerController;

		[Inject]
		public var drawerModel:DrawerModel;

		[Inject]
		public var workspaceController:WorkspaceController;
		
		[Inject]
		public var streamController:StreamController;
		
		[Inject]
		public var streamModel:StreamModel;

		[Inject]
		public var workspaceModel:WorkspaceModel;

		[Inject]
		public var view:FooterNavigationBar;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var url:String;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function FooterNavigationBarMediator()
		{
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		override public function onRegister():void
		{
			super.onRegister();

			view.preferencesButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			view.awayButton.addEventListener(MouseEvent.CLICK, awayButtonClickHandler);
			view.tweetButton.addEventListener(MouseEvent.CLICK, tweetButtonClickHandler);

			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);
			signalBus.workspaceStateChanged.add(workspaceStateChanged);
			signalBus.accountSelected.add(accountSelectedHandler);
			signalBus.awayModeChanged.add(awayModeChangedHandler);

			view.iconButton.addEventListener(MouseEvent.CLICK, iconButtonClickHandler);

			if (accountModel.currentAccount)
			{
				accountSelectedHandler(accountModel.currentAccount); // if account is selected prior to mediator instantiation
			}

			workspaceStateChanged(null, workspaceModel.state);
		}

		//--------------------------------------------------------------------------
		//
		//  Helper Methods
		//
		//--------------------------------------------------------------------------

		protected function addIconListeners():void
		{
			CacheController.getInstance().iconLoaded.add(iconLoadedHandler);
			CacheController.getInstance().iconLoadedError.add(iconLoadedErrorHandler);
		}

		protected function removeIconListeners():void
		{
			CacheController.getInstance().iconLoaded.remove(iconLoadedHandler);
			CacheController.getInstance().iconLoadedError.remove(iconLoadedErrorHandler);
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function buttonClickHandler(event:MouseEvent):void
		{
			workspaceController.setState((event.currentTarget as DisplayObject).name);
		}

		protected function awayButtonClickHandler(event:MouseEvent):void
		{
			if (!streamModel.awayMode)
			{
				streamController.enableAwayMode();
			}
			else
			{
				streamController.disableAwayMode();
			}
		}
		
		protected function awayModeChangedHandler(awayMode:Boolean):void
		{
			view.awayButton.selected = awayMode;
		}

		protected function tweetButtonClickHandler(event:MouseEvent):void
		{
			if (drawerModel.opened && (drawerModel.state == DrawerState.COMPOSE || drawerModel.state == DrawerState.COMPOSE_REPLY))
			{
				drawerController.close();
			}
			else
			{
				drawerController.openStatusUpdate();
			}
		}

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view, stylesheet.getStyle('.BaseNavigationBar'));
			styleController.applyNavigationTextButtonStyle(view.preferencesButton);
			styleController.applyNavigationTextButtonStyle(view.awayButton);
			styleController.applyStyle(view.tweetButton, stylesheet.getStyle('.NavigationBitmapButton'));
		}

		protected function drawerOpenedHandler(state:String):void
		{
			switch (state)
			{
				case DrawerState.COMPOSE:
				case DrawerState.COMPOSE_MESSAGE_REPLY:
				case DrawerState.COMPOSE_REPLY:
					view.tweetButton.selected = true;
					break;
			}
		}

		protected function drawerClosedHandler():void
		{
			view.tweetButton.selected = false;
		}

		protected function workspaceStateChanged(oldState:String, newState:String):void
		{
			if (oldState)
			{
				var oldButton:BaseNavigationButton = view.getChildByName(oldState) as BaseNavigationButton;

				if (oldButton)
					oldButton.selected = false;
			}

			var newButton:BaseNavigationButton = view.getChildByName(newState) as BaseNavigationButton;

			if (newButton)
				newButton.selected = true;
		}

		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (account)
			{
				if (account.infoModel.user)
				{
					url = account.infoModel.user.profileImageURL;
				}
				else if (FileUtil.exists(account.infoModel.path + account.infoModel.accessToken.id + ".png"))
				{
					url = FileUtil.getURL(account.infoModel.path + account.infoModel.accessToken.id + ".png");
				}
				else
				{
					url = "http://img.tweetimag.es/i/" + account.infoModel.accessToken.screenName + "_n";
				}

				if (!account.infoModel.user)
				{
					account.infoModel.userChanged.addOnce(accountUserChangedHandler);
				}

				addIconListeners();
				view.iconButton.loadIcon(url, true, false);
			}
			else
			{
				url = null;

				removeIconListeners();
				view.iconButton.unloadIcon();
			}
		}

		protected function accountUserChangedHandler(user:UserVO):void
		{
			url = user.profileImageURL;

			addIconListeners();
			view.iconButton.loadIcon(url, false);
		}

		protected function iconLoadedHandler(url:String, bitmapData:BitmapData):void
		{
			if (url == this.url)
			{
				removeIconListeners();

				if (url.indexOf("file") != 0 && url.indexOf("img.tweetimag.es") == -1)
				{
					accountController.saveAccountIcon(accountModel.currentAccount, bitmapData);
				}

				url = null;
			}
		}

		protected function iconLoadedErrorHandler(url:String):void
		{
			if (url == this.url)
			{
				removeIconListeners();

				trace("error loading account icon");
			}
		}

		protected function iconButtonClickHandler(event:MouseEvent):void
		{
			event.updateAfterEvent();

			var point:Point = view.iconButton.localToGlobal(new Point(view.iconButton.width * 0.5 - 1.0, view.iconButton.height * 0.5 + 7.0));

			contextMenuController.displayAccountIconMenu(view.stage, point.x, point.y);
		}
	}
}