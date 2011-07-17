package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.PlatformType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.controller.QuickFriendLookupController;
	import com.destroytoday.destroytwitter.controller.UpdateController;
	import com.destroytoday.destroytwitter.controller.UserController;
	import com.destroytoday.destroytwitter.model.PreferencesModel;
	import com.destroytoday.destroytwitter.model.vo.PreferenceHeaderVO;
	import com.destroytoday.destroytwitter.model.vo.PreferenceLinkVO;
	import com.destroytoday.destroytwitter.model.vo.PreferenceVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.workspace.PreferencesCanvas;
	import com.destroytoday.util.ApplicationUtil;
	import com.destroytoday.util.FileUtil;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.desktop.NativeApplication;
	import flash.events.TextEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;

	public class PreferencesCanvasMediator extends BaseCanvasMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var contextMenuController:ContextMenuController;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var userController:UserController;
		
		[Inject]
		public var updateController:UpdateController;
		
		[Inject]
		public var model:PreferencesModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PreferencesCanvasMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get view():PreferencesCanvas
		{
			return viewComponent as PreferencesCanvas;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();

			view.preferenceList = 
				[
					new PreferenceHeaderVO("Application"),
					(NativeApplication.supportsStartAtLogin ? new PreferenceVO(PreferenceType.OPEN_AT_STARTUP, "Open at startup", model.answerOptionList) : null),
					new PreferenceVO(PreferenceType.ALWAYS_IN_FRONT, "Always in front", model.answerOptionList),
					(ApplicationUtil.pc ? new PreferenceVO(PreferenceType.WINDOW_CONTROL_TYPE, "Window control", model.windowControlTypeOptionList) : null),
					new PreferenceHeaderVO("Tweeting"),
					new PreferenceVO(PreferenceType.QUICK_FRIEND_LOOKUP, "Quick Friend Lookup", model.toggleOptionList),
					new PreferenceVO(PreferenceType.SPELL_CHECK, "Spell check", model.toggleOptionList),
					new PreferenceVO(PreferenceType.SPELL_CHECK_LANGUAGE, "Spell check language", model.spellCheckLanguageOptionList),
					new PreferenceVO(PreferenceType.KEEP_DRAWER_OPEN, "Keep drawer open after tweeting", model.answerOptionList),
					new PreferenceVO(PreferenceType.REFRESH_HOME_AFTER_TWEETING, "Refresh home after tweeting", model.answerOptionList),
					new PreferenceVO(PreferenceType.RETWEET_FORMAT, "Retweet format", model.allRetweetFormatOptionList),
					new PreferenceVO(PreferenceType.SECONDARY_RETWEET_FORMAT, "Secondary retweet format", model.allRetweetFormatOptionList),
					/*"Refresh Rate",
					new PreferenceVO(PreferenceType.HOME_REFRESH_RATE, "Home", model.refreshRateOptionList),
					new PreferenceVO(PreferenceType.MENTIONS_REFRESH_RATE, "Mentions", model.refreshRateOptionList),
					new PreferenceVO(PreferenceType.MESSAGES_REFRESH_RATE, "Messages", model.refreshRateOptionList),*/
					new PreferenceHeaderVO("Stream"),
					new PreferenceVO(PreferenceType.USER_PROFILE_PLATFORM, "Open user profiles in the", model.platformOptionList),
					new PreferenceVO(PreferenceType.IMAGE_PLATFORM, "Open images in the", model.platformOptionList),					
					new PreferenceVO(PreferenceType.LINK_LAYER, "Open links in the", model.linkLayerOptionList),					
					new PreferenceVO(PreferenceType.SELECTION, "Selection", model.toggleOptionList),
					new PreferenceVO(PreferenceType.ICON_TYPE, "Icons", model.iconOptionList),
					new PreferenceVO(PreferenceType.FONT_TYPE, "Font", model.fontOptionList),
					new PreferenceVO(PreferenceType.FONT_SIZE, "Font size", model.fontSizeOptionList),
					new PreferenceVO(PreferenceType.USER_FORMAT, "User format", model.userFormatOptionList),
					new PreferenceVO(PreferenceType.TIME_FORMAT, "Time format", model.timeFormatOptionList),
					new PreferenceVO(PreferenceType.UNREAD_FORMAT, "Unread format", model.unreadFormatOptionList),
					new PreferenceHeaderVO("Notifications"),
					new PreferenceVO(PreferenceType.NOTIFICATION_SOUND, "Sound", model.notificationSoundOptionList),
					new PreferenceVO(PreferenceType.NOTIFICATION_POSITION, "Position", model.notificationPositionOptionList),
					"<span class=\"dimmed\">See individual canvas settings to enable/disable</span>",
					new PreferenceHeaderVO("Themes"),
					new PreferenceVO(PreferenceType.THEME, "Theme", model.themeOptionList),
					new PreferenceLinkVO(PreferenceType.INSTALL_THEME, "Install theme..."),
					new PreferenceLinkVO(PreferenceType.RELOAD_THEME, "Reload current theme"),
					new PreferenceLinkVO(PreferenceType.OPEN_THEMES_DIRECTORY, "Open themes directory...", File.applicationStorageDirectory.nativePath + File.separator + "themes"),
					new PreferenceLinkVO(PreferenceType.OPEN_ICONS_DIRECTORY, "Open icons directory...", File.applicationStorageDirectory.nativePath + File.separator + "icons"),
					new PreferenceHeaderVO("Debug"),
					"Version " + ApplicationUtil.version,
					new PreferenceVO(PreferenceType.DEBUG_MODE, "Debug mode", model.toggleOptionList),
					new PreferenceLinkVO(PreferenceType.CHECK_FOR_UPDATES, "Check for updates"),
					new PreferenceLinkVO(PreferenceType.OPEN_PREFERENCES_DIRECTORY, "Open preferences directory...", File.applicationStorageDirectory.nativePath),
					new PreferenceLinkVO(PreferenceType.FORCE_REFRESH_FRIENDS_LIST, "Force refresh friends list")
				];

			signalBus.accountSelected.add(accountSelectedHandler);
			signalBus.preferencesChanged.add(preferencesChangedHandler);

			if (accountModel.currentAccount)
			{
				accountSelectedHandler(accountModel.currentAccount);
			}
			
			view.textfield.addEventListener(TextEvent.LINK, textfieldLinkHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			view.file = model.file;
		}
		
		protected function preferencesChangedHandler():void
		{
			view.dirtyData();
		}
		
		protected function textfieldLinkHandler(event:TextEvent):void
		{
			var bounds:Rectangle;
			var lineIndex:int = -2;
			var preference:PreferenceVO;
			
			for each (var item:Object in view.preferenceList)
			{
				lineIndex++;
				
				if (item is PreferenceHeaderVO)
				{
					lineIndex++;
				}
				else if (!item)
				{
					lineIndex--;
				}
				
				if (item is PreferenceVO && (item as PreferenceVO).type == event.text)
				{
					preference = item as PreferenceVO;
					
					var index:int = view.textfield.getLineOffset(lineIndex);
					
					index += view.textfield.getLineLength(lineIndex) - 2;

					bounds = view.textfield.getCharBoundaries(index);
					
					if (bounds)
					{
						var point:Point = view.textfield.localToGlobal(new Point(bounds.x + 10.0, bounds.y));
						
						contextMenuController.displayPreferenceMenu(view.stage, point.x, point.y, preference);
					}
					break;
				}
				else if (item is PreferenceLinkVO && (item as PreferenceLinkVO).type == event.text)
				{
					switch ((item as PreferenceLinkVO).type)
					{
						case PreferenceType.INSTALL_THEME:
							styleController.browseForTheme();
							break;
						case PreferenceType.RELOAD_THEME:
							styleController.reloadStylesheet();
							break;
						case PreferenceType.OPEN_THEMES_DIRECTORY:
						case PreferenceType.OPEN_ICONS_DIRECTORY:
						case PreferenceType.OPEN_PREFERENCES_DIRECTORY:
							FileUtil.openWithDefaultApplication((item as PreferenceLinkVO).url);
							break;
						case PreferenceType.CHECK_FOR_UPDATES:
							updateController.check();
							break;
						case PreferenceType.FORCE_REFRESH_FRIENDS_LIST:
							alertController.addMessage(null, "Forcing refresh friends list...");
							userController.updateFriends();
							break;
					}
					
					break;
				}
			}
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			super.stylesheetChangedHandler(stylesheet);
			
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.PreferencesTextField'));
		}
	}
}