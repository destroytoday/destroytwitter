package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.BooleanType;
	import com.destroytoday.destroytwitter.constants.FontSizeType;
	import com.destroytoday.destroytwitter.constants.FontType;
	import com.destroytoday.destroytwitter.constants.IconType;
	import com.destroytoday.destroytwitter.constants.LinkLayerType;
	import com.destroytoday.destroytwitter.constants.NotificationPosition;
	import com.destroytoday.destroytwitter.constants.PlatformType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RefreshRateType;
	import com.destroytoday.destroytwitter.constants.RetweetFormatType;
	import com.destroytoday.destroytwitter.constants.SpellCheckLanguageType;
	import com.destroytoday.destroytwitter.constants.TimeFormatType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.constants.TweetsPerPage;
	import com.destroytoday.destroytwitter.constants.UnreadFormat;
	import com.destroytoday.destroytwitter.constants.UserFormatType;
	import com.destroytoday.destroytwitter.constants.WindowControlType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ConfigModel;
	import com.destroytoday.destroytwitter.model.PreferencesModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.filesystem.PreferencesFile;
	import com.destroytoday.twitteraspirin.constants.ImageServiceType;
	import com.destroytoday.twitteraspirin.constants.URLShortenerType;
	import com.destroytoday.util.FileUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.filesystem.File;
	import flash.net.FileReference;

	public class PreferencesController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var configModel:ConfigModel;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var model:PreferencesModel;
		
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PreferencesController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setup():void
		{
			model.file = new PreferencesFile();
			
			var defaultData:Object = {};
			
			// drawer
			defaultData[PreferenceType.AUTO_SHORTEN_URLS] = BooleanType.TRUE;
			defaultData[PreferenceType.URL_SHORTENER] = URLShortenerType.JMP;
			defaultData[PreferenceType.IMAGE_SERVICE] = ImageServiceType.POSTEROUS;
			
			// application
			defaultData[PreferenceType.OPEN_AT_STARTUP] = BooleanType.NO;
			defaultData[PreferenceType.ALWAYS_IN_FRONT] = BooleanType.NO;
			defaultData[PreferenceType.WINDOW_CONTROL_TYPE] = WindowControlType.CLOSE_EXIT_MINIMIZE_SYSTEM_TRAY;
			
			// tweeting
			defaultData[PreferenceType.QUICK_FRIEND_LOOKUP] = ToggleType.ENABLED;
			defaultData[PreferenceType.SPELL_CHECK] = ToggleType.ENABLED;
			defaultData[PreferenceType.SPELL_CHECK_LANGUAGE] = SpellCheckLanguageType.ENGLISH;
			defaultData[PreferenceType.KEEP_DRAWER_OPEN] = BooleanType.NO;
			defaultData[PreferenceType.REFRESH_HOME_AFTER_TWEETING] = BooleanType.YES;
			
			// refresh rates
			defaultData[PreferenceType.HOME_REFRESH_RATE] = RefreshRateType.TWO_MINUTES;
			defaultData[PreferenceType.MENTIONS_REFRESH_RATE] = RefreshRateType.TWO_MINUTES;
			defaultData[PreferenceType.SEARCH_REFRESH_RATE] = RefreshRateType.FIVE_MINUTES;
			defaultData[PreferenceType.MESSAGES_REFRESH_RATE] = RefreshRateType.TEN_MINUTES;
			
			// tweets per page
			defaultData[PreferenceType.HOME_TWEETS_PER_PAGE] = TweetsPerPage.FORTY;
			defaultData[PreferenceType.MENTIONS_PER_PAGE] = TweetsPerPage.TWENTY;
			defaultData[PreferenceType.SEARCH_PER_PAGE] = TweetsPerPage.TWENTY;
			defaultData[PreferenceType.MESSAGES_PER_PAGE] = TweetsPerPage.TWENTY;
			
			// stream
			defaultData[PreferenceType.USER_PROFILE_PLATFORM] = PlatformType.APPLICATION;
			defaultData[PreferenceType.IMAGE_PLATFORM] = PlatformType.APPLICATION;
			defaultData[PreferenceType.LINK_LAYER] = LinkLayerType.FOREGROUND;
			defaultData[PreferenceType.ICON_TYPE] = IconType.LARGE;
			defaultData[PreferenceType.FONT_TYPE] = FontType.DEFAULT;
			defaultData[PreferenceType.FONT_SIZE] = FontSizeType.SMALL;
			defaultData[PreferenceType.USER_FORMAT] = UserFormatType.USERNAME;
			defaultData[PreferenceType.TIME_FORMAT] = TimeFormatType.TWELVE_HOUR;
			defaultData[PreferenceType.RETWEET_FORMAT] = RetweetFormatType.ARROW;
			defaultData[PreferenceType.SECONDARY_RETWEET_FORMAT] = RetweetFormatType.NATIVE;
			defaultData[PreferenceType.UNREAD_FORMAT] = UnreadFormat.MOUSE_OVER;
			defaultData[PreferenceType.SELECTION] = ToggleType.ENABLED;
			
			// notifications
			defaultData[PreferenceType.NOTIFICATION_SOUND] = "Marimba";
			defaultData[PreferenceType.NOTIFICATION_POSITION] = NotificationPosition.TOP;
			defaultData[PreferenceType.HOME_NOTIFICATIONS] = ToggleType.ENABLED;
			defaultData[PreferenceType.MENTIONS_NOTIFICATIONS] = ToggleType.ENABLED;
			defaultData[PreferenceType.SEARCH_NOTIFICATIONS] = ToggleType.ENABLED;
			defaultData[PreferenceType.MESSAGES_NOTIFICATIONS] = ToggleType.ENABLED;
			
			// filters
			defaultData[PreferenceType.HOME_FILTER] = ToggleType.DISABLED;
			defaultData[PreferenceType.HOME_SCREEN_NAME_FILTER] = '';
			defaultData[PreferenceType.HOME_KEYWORD_FILTER] = '';
			defaultData[PreferenceType.HOME_SOURCE_FILTER] = '';
			defaultData[PreferenceType.MENTIONS_FILTER] = ToggleType.DISABLED;
			defaultData[PreferenceType.MENTIONS_SCREEN_NAME_FILTER] = '';
			defaultData[PreferenceType.MENTIONS_KEYWORD_FILTER] = '';
			defaultData[PreferenceType.MENTIONS_SOURCE_FILTER] = '';
			
			defaultData[PreferenceType.THEME] = 'DestroyToday';
			
			defaultData[PreferenceType.DEBUG_MODE] = ToggleType.DISABLED;
			defaultData[PreferenceType.SEARCH_KEYWORD_LIST] = '';
			
			model.file.defaultData = defaultData;
			
			signalBus.accountSelected.add(accountSelectedHandler);
		}
		
		public function getPreference(type:String):String
		{
			return model.file.getString(type);
		}
		
		public function getBoolean(type:String):Boolean
		{
			return model.file.getBoolean(type);
		}
		
		public function getOptions(type:String):Array
		{
			switch (type)
			{
				case PreferenceType.AUTO_SHORTEN_URLS:
					return model.booleanOptionList;
				case PreferenceType.URL_SHORTENER:
					return model.urlShortenerOptionList;
				case PreferenceType.IMAGE_SERVICE:
					return model.imageServiceOptionList;
				case PreferenceType.NOTIFICATION_SOUND:
					//updateNotificationSoundOptions();
					
					return model.notificationSoundOptionList;
				case PreferenceType.THEME:
					updateThemeOptionList();
					
					return model.themeOptionList;
				case PreferenceType.NOTIFICATION_POSITION:
					return model.notificationPositionOptionList;
				case PreferenceType.WINDOW_CONTROL_TYPE:
					return model.windowControlTypeOptionList;
				case PreferenceType.OPEN_AT_STARTUP:
				case PreferenceType.ALWAYS_IN_FRONT:
				case PreferenceType.KEEP_DRAWER_OPEN:
				case PreferenceType.REFRESH_HOME_AFTER_TWEETING:
					return model.answerOptionList;
				case PreferenceType.SPELL_CHECK_LANGUAGE:
					return model.spellCheckLanguageOptionList;
				case PreferenceType.QUICK_FRIEND_LOOKUP:
				case PreferenceType.SPELL_CHECK:
				case PreferenceType.SELECTION:
				case PreferenceType.HOME_NOTIFICATIONS:
				case PreferenceType.MENTIONS_NOTIFICATIONS:
				case PreferenceType.SEARCH_NOTIFICATIONS:
				case PreferenceType.MESSAGES_NOTIFICATIONS:
				case PreferenceType.HOME_FILTER:
				case PreferenceType.MENTIONS_FILTER:
				case PreferenceType.DEBUG_MODE:
					return model.toggleOptionList;
				case PreferenceType.HOME_REFRESH_RATE:
				case PreferenceType.MENTIONS_REFRESH_RATE:
				case PreferenceType.MESSAGES_REFRESH_RATE:
					return model.refreshRateOptionList;
				case PreferenceType.HOME_TWEETS_PER_PAGE:
				case PreferenceType.MENTIONS_PER_PAGE:
				case PreferenceType.MESSAGES_PER_PAGE:
					return model.tweetsPerPageOptionList;
				case PreferenceType.USER_PROFILE_PLATFORM:
				case PreferenceType.IMAGE_PLATFORM:
					return model.platformOptionList;
				case PreferenceType.ICON_TYPE:
					return model.iconOptionList;
				case PreferenceType.FONT_TYPE:
					return model.fontOptionList;
				case PreferenceType.FONT_SIZE:
					return model.fontSizeOptionList;
				case PreferenceType.USER_FORMAT:
					return model.userFormatOptionList;
				case PreferenceType.TIME_FORMAT:
					return model.timeFormatOptionList;
				case PreferenceType.RETWEET_FORMAT:
					return model.getRetweetFormatOptionList(getPreference(PreferenceType.SECONDARY_RETWEET_FORMAT));
				case PreferenceType.SECONDARY_RETWEET_FORMAT:
					return model.getSecondaryRetweetFormatOptionList(getPreference(PreferenceType.RETWEET_FORMAT));
				case PreferenceType.UNREAD_FORMAT:
					return model.unreadFormatOptionList;
				case PreferenceType.LINK_LAYER:
					return model.linkLayerOptionList;
			}
			
			return null;
		}
		
		public function setString(name:String, value:String, update:Boolean = true):void
		{
			if (value == null) value = '';
			
			model.file.setString(name, value);
			if (update) updatePreference(name, value);
		}
		
		public function updateThemeOptionList():void
		{
			model.themeOptionList.length = 0;
			model.themeOptionList[0] = 'DestroyToday';
			
			if (!FileUtil.exists(File.applicationStorageDirectory.nativePath + File.separator + 'themes'))
			{
				FileUtil.copy(
					File.applicationDirectory.nativePath + File.separator + "com/destroytoday/destroytwitter/styles/themes",
					File.applicationStorageDirectory.nativePath + File.separator + 'themes',
					true
				);
			}
			else if (!FileUtil.exists(File.applicationStorageDirectory.nativePath + File.separator + 'themes' + File.separator + 'DestroyToday.css'))
			{
				FileUtil.copy(
					File.applicationDirectory.nativePath + File.separator + "com/destroytoday/destroytwitter/styles/themes/DestroyToday.css",
					File.applicationStorageDirectory.nativePath + File.separator + 'themes' + File.separator + 'DestroyToday.css',
					true
				);
			}
			
			var fileList:Array = FileUtil.getDirectoryListing(File.applicationStorageDirectory.nativePath + File.separator + 'themes');
			
			for each (var file:File in fileList)
			{
				if (file.extension == 'css' && file.name != 'DestroyToday.css') model.themeOptionList[model.themeOptionList.length] = file.name.substr(0.0, file.name.length - 4);
			}
		}
		
		protected function validatePreference(type:String, option:String):void
		{
			var optionList:Array = getOptions(type);
			
			if (!optionList) return;
			
			if (optionList.indexOf(option) == -1)
			{
				option = model.file.defaultData[type];
				
				setString(type, option);
			}

			updatePreference(type, option);
		}
		
		protected function getUnusedRetweetFormat(secondary:Boolean):String
		{
			var format:String = getPreference((secondary) ? PreferenceType.RETWEET_FORMAT : PreferenceType.SECONDARY_RETWEET_FORMAT);
			
			for each (var option:String in model.allRetweetFormatOptionList)
			{
				if (option != format)
				{
					format = option;
					
					break;
				}
			}

			return format;
		}
		
		protected function updatePreference(type:String, option:String):void
		{
			switch (type)
			{
				case PreferenceType.OPEN_AT_STARTUP:
					try { NativeApplication.nativeApplication.startAtLogin = (option == BooleanType.YES); } catch(e:*) { }
					break;
				case PreferenceType.ALWAYS_IN_FRONT:
					contextView.stage.nativeWindow.alwaysInFront = (option == BooleanType.YES);
					break;
				case PreferenceType.HOME_TWEETS_PER_PAGE:
					signalBus.homeTweetsPerPageChanged.dispatch(accountModel.currentAccount, int(option));
					break;
				case PreferenceType.MENTIONS_PER_PAGE:
					signalBus.mentionsPerPageChanged.dispatch(accountModel.currentAccount, int(option));
					break;
				case PreferenceType.SEARCH_PER_PAGE:
					signalBus.searchPerPageChanged.dispatch(accountModel.currentAccount, int(option));
					break;
				case PreferenceType.MESSAGES_PER_PAGE:
					signalBus.messagesPerPageChanged.dispatch(accountModel.currentAccount, int(option));
					break;
				case PreferenceType.HOME_REFRESH_RATE:
					signalBus.homeRefreshRateChanged.dispatch(accountModel.currentAccount, RefreshRateType.valueEnum[option]);
					break;
				case PreferenceType.MENTIONS_REFRESH_RATE:
					signalBus.mentionsRefreshRateChanged.dispatch(accountModel.currentAccount, RefreshRateType.valueEnum[option]);
					break;
				case PreferenceType.SEARCH_REFRESH_RATE:
					signalBus.searchRefreshRateChanged.dispatch(accountModel.currentAccount, RefreshRateType.valueEnum[option]);
					break;
				case PreferenceType.MESSAGES_REFRESH_RATE:
					signalBus.messagesRefreshRateChanged.dispatch(accountModel.currentAccount, RefreshRateType.valueEnum[option]);
					break;
				case PreferenceType.ICON_TYPE:
					signalBus.iconTypeChanged.dispatch(getPreference(PreferenceType.ICON_TYPE));
					break;
				case PreferenceType.FONT_TYPE:
					signalBus.fontTypeChanged.dispatch(getPreference(PreferenceType.FONT_TYPE));
					break;
				case PreferenceType.FONT_SIZE:
					signalBus.fontSizeChanged.dispatch(getPreference(PreferenceType.FONT_SIZE));
					break;
				case PreferenceType.USER_FORMAT:
					signalBus.userFormatChanged.dispatch(getPreference(PreferenceType.USER_FORMAT));
					break;
				case PreferenceType.TIME_FORMAT:
					signalBus.timeFormatChanged.dispatch(getPreference(PreferenceType.TIME_FORMAT));
					break;
				case PreferenceType.UNREAD_FORMAT:
					signalBus.unreadFormatChanged.dispatch(getPreference(PreferenceType.UNREAD_FORMAT));
					break;
				case PreferenceType.RETWEET_FORMAT:
					if (getPreference(PreferenceType.RETWEET_FORMAT) == getPreference(PreferenceType.SECONDARY_RETWEET_FORMAT))
					{
						setString(PreferenceType.SECONDARY_RETWEET_FORMAT, getUnusedRetweetFormat(false), false);
					}
					break;
				case PreferenceType.SECONDARY_RETWEET_FORMAT:
					if (getPreference(PreferenceType.RETWEET_FORMAT) == getPreference(PreferenceType.SECONDARY_RETWEET_FORMAT))
					{
						setString(PreferenceType.RETWEET_FORMAT, getUnusedRetweetFormat(true), false);
					}
					break;
				case PreferenceType.SELECTION:
					signalBus.allowSelectionChanged.dispatch(getBoolean(PreferenceType.SELECTION));
					break;
				case PreferenceType.NOTIFICATION_SOUND:
					signalBus.notificationSoundChanged.dispatch(getPreference(PreferenceType.NOTIFICATION_SOUND));
					break;
				case PreferenceType.THEME:
					signalBus.themeChanged.dispatch(getPreference(PreferenceType.THEME));
					break;
				case PreferenceType.DEBUG_MODE:
					if (getBoolean(PreferenceType.DEBUG_MODE)) 
					{
						signalBus.requestedInstallDebugger.dispatch();
					}
					else
					{
						signalBus.requestedUninstallDebugger.dispatch();
					}
					break;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (account) //TODO - use account path
			{
				model.file.nativePath = 
					File.applicationStorageDirectory.nativePath + File.separator + 
					"accounts" + File.separator + 
					account.infoModel.accessToken.id + File.separator + 
					account.infoModel.accessToken.id + ".dtpref";
				
				for (var type:String in model.file.preferenceHash)
				{
					validatePreference(type, model.file.preferenceHash[type]);
				}
			}
		}
	}
}