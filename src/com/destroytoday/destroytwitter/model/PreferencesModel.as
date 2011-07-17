package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.constants.BooleanType;
	import com.destroytoday.destroytwitter.constants.FontSizeType;
	import com.destroytoday.destroytwitter.constants.FontType;
	import com.destroytoday.destroytwitter.constants.IconType;
	import com.destroytoday.destroytwitter.constants.LinkLayerType;
	import com.destroytoday.destroytwitter.constants.NotificationPosition;
	import com.destroytoday.destroytwitter.constants.PlatformType;
	import com.destroytoday.destroytwitter.constants.RefreshRateType;
	import com.destroytoday.destroytwitter.constants.RetweetFormatType;
	import com.destroytoday.destroytwitter.constants.SpellCheckLanguageType;
	import com.destroytoday.destroytwitter.constants.TimeFormatType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.constants.TweetsPerPage;
	import com.destroytoday.destroytwitter.constants.UnreadFormat;
	import com.destroytoday.destroytwitter.constants.UserFormatType;
	import com.destroytoday.destroytwitter.constants.WindowControlType;
	import com.destroytoday.filesystem.PreferencesFile;
	import com.destroytoday.twitteraspirin.constants.ImageServiceType;
	import com.destroytoday.twitteraspirin.constants.URLShortenerType;
	
	import flash.filesystem.File;

	public class PreferencesModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected const notificationSoundPath:String = File.applicationDirectory.nativePath + File.separator + "assets" + File.separator + "sounds" + File.separator;

		public const booleanOptionList:Array = [BooleanType.TRUE, BooleanType.FALSE];
		public const notificationSoundOptionList:Array = 
			[
				"none",
				"Basso",
				"Block",
				"Funk",
				"Marimba",
				"Purr",
				"Sosumi"
			];
		public const themeOptionList:Array = 
			[
				"default"
			];
		public const notificationPositionOptionList:Array = [NotificationPosition.TOP, NotificationPosition.BOTTOM];
		public const imageServiceOptionList:Array = 
			[
				ImageServiceType.IMGLY,
				//ImageServiceType.PIKCHUR,
				ImageServiceType.POSTEROUS,
				ImageServiceType.PLIXI,
				ImageServiceType.IMGUR,
				ImageServiceType.TWITGOO,
				ImageServiceType.TWITPIC,
				ImageServiceType.YFROG
			];
		public const urlShortenerOptionList:Array = 
			[
				URLShortenerType.BITLY,
				URLShortenerType.ISGD,
				URLShortenerType.JMP,
				URLShortenerType.TINYURL
			]
		public const answerOptionList:Array = [BooleanType.YES, BooleanType.NO];
		public const windowControlTypeOptionList:Array = [WindowControlType.CLOSE_EXIT_MINIMIZE_SYSTEM_TRAY, WindowControlType.CLOSE_SYSTEM_TRAY_MINIMIZE_TASKBAR];
		public const iconOptionList:Array = [IconType.NONE, IconType.SMALL, IconType.LARGE];
		public const fontOptionList:Array = [FontType.DEFAULT, FontType.SYSTEM];
		public const fontSizeOptionList:Array = [FontSizeType.SMALL, FontSizeType.MEDIUM, FontSizeType.LARGE];
		public const unreadFormatOptionList:Array = [UnreadFormat.NO_HIGHLIGHT, UnreadFormat.MOUSE_OVER, UnreadFormat.SELECT];
		public const linkLayerOptionList:Array = [LinkLayerType.FOREGROUND, LinkLayerType.BACKGROUND];
		public const platformOptionList:Array = [PlatformType.APPLICATION, PlatformType.DEFAULT_BROWSER];
		public const refreshRateOptionList:Array = 
			[
				RefreshRateType.NEVER,
				RefreshRateType.THIRTY_SECONDS,
				RefreshRateType.MINUTE,
				RefreshRateType.TWO_MINUTES,
				RefreshRateType.FIVE_MINUTES,
				RefreshRateType.TEN_MINUTES,
				RefreshRateType.THIRTY_MINUTES,
				RefreshRateType.HOUR
			];
		public const tweetsPerPageOptionList:Array = 
			[
				TweetsPerPage.TWENTY,
				TweetsPerPage.THIRTY,
				TweetsPerPage.FORTY,
				TweetsPerPage.FIFTY,
				TweetsPerPage.ONE_HUNDRED,
				TweetsPerPage.TWO_HUNDRED
			];
		public const spellCheckLanguageOptionList:Array = 
			[
				SpellCheckLanguageType.DANISH,
				SpellCheckLanguageType.DUTCH,
				SpellCheckLanguageType.ENGLISH,
				SpellCheckLanguageType.FINNISH,
				SpellCheckLanguageType.FRENCH,
				SpellCheckLanguageType.GERMAN,
				SpellCheckLanguageType.ITALIAN,
				SpellCheckLanguageType.POLISH,
				SpellCheckLanguageType.PORTUGUESE,
				SpellCheckLanguageType.RUSSIAN,
				SpellCheckLanguageType.SPANISH,
				SpellCheckLanguageType.SWEDISH
			];
		public const timeFormatOptionList:Array = [TimeFormatType.TWELVE_HOUR, TimeFormatType.TWENTYFOUR_HOUR];
		public const toggleOptionList:Array = [ToggleType.ENABLED, ToggleType.DISABLED];
		public const userFormatOptionList:Array = [UserFormatType.USERNAME, UserFormatType.FULLNAME];
		
		public const allRetweetFormatOptionList:Array = 
			[
				RetweetFormatType.ARROW, 
				RetweetFormatType.RT, 
				RetweetFormatType.VIA,
				RetweetFormatType.NATIVE
			];
		
		protected var retweetFormatOptionList:Array = new Array();

		protected var secondaryRetweetFormatOptionList:Array = new Array();
		
		protected var _file:PreferencesFile;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PreferencesModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get file():PreferencesFile
		{
			return _file;
		}
		
		public function set file(value:PreferencesFile):void
		{
			if (value == _file) return;
			
			_file = value;
		}
		
		public function getRetweetFormatOptionList(secondaryRetweetFormat:String):Array
		{
			retweetFormatOptionList.length = 0;
			
			for each (var option:String in allRetweetFormatOptionList)
			{
				if (option != secondaryRetweetFormat)
				{
					retweetFormatOptionList[retweetFormatOptionList.length] = option;
				}
			}
			
			return retweetFormatOptionList;
		}
		
		public function getSecondaryRetweetFormatOptionList(primaryRetweetFormat:String):Array
		{
			secondaryRetweetFormatOptionList.length = 0;
			
			for each (var option:String in allRetweetFormatOptionList)
			{
				if (option != primaryRetweetFormat)
				{
					secondaryRetweetFormatOptionList[secondaryRetweetFormatOptionList.length] = option;
				}
			}
			
			return secondaryRetweetFormatOptionList;
		}
	}
}