package com.destroytoday.destroytwitter.signals {
	import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
	import com.destroytoday.destroytwitter.model.vo.URLPreviewVO;
	import com.destroytoday.destroytwitter.model.vo.UpdateVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;

	public class ApplicationSignalBus
	{
		public const startupCompleted:Signal = new Signal();
		
		//--------------------------------------------------------------------------
		//
		//  Hotkeys
		//
		//--------------------------------------------------------------------------
		
		public const hotkeyCopySelected:Signal = new Signal();
		
		public const hotkeyStreamRefreshSelected:Signal = new Signal();
		
		public const hotkeyStreamMostRecentSelected:Signal = new Signal();
		
		public const hotkeyStreamNewerSelected:Signal = new Signal();
		
		public const hotkeyStreamOlderSelected:Signal = new Signal();
		
		//--------------------------------------------------------------------------
		//
		//  Preferences
		//
		//--------------------------------------------------------------------------

		public const preferencesChanged:Signal = new Signal();
		
		public const homeTweetsPerPageChanged:Signal = new Signal(AccountModule, int);

		public const mentionsPerPageChanged:Signal = new Signal(AccountModule, int);
		
		public const searchPerPageChanged:Signal = new Signal(AccountModule, int);
		
		public const messagesPerPageChanged:Signal = new Signal(AccountModule, int);
		
		public const homeRefreshRateChanged:Signal = new Signal(AccountModule, Number);

		public const mentionsRefreshRateChanged:Signal = new Signal(AccountModule, Number);
		
		public const searchRefreshRateChanged:Signal = new Signal(AccountModule, Number);
		
		public const messagesRefreshRateChanged:Signal = new Signal(AccountModule, Number);

		public const iconTypeChanged:Signal = new Signal(String); // type

		public const fontTypeChanged:Signal = new Signal(String); // type

		public const fontSizeChanged:Signal = new Signal(String); // type
		
		public const userFormatChanged:Signal = new Signal(String); // format

		public const timeFormatChanged:Signal = new Signal(String); // format

		public const unreadFormatChanged:Signal = new Signal(String); // format

		public const allowSelectionChanged:Signal = new Signal(Boolean);
		
		//--------------------------------------------------------------------------
		//
		//  Database
		//
		//--------------------------------------------------------------------------
		
		public const updatedUserIDs:Signal = new Signal();

		public const updatedUser:Signal = new Signal(UserVO);
		
		public const updatedStatusReadList:Signal = new Signal(Vector.<String>); // list of ids
		
		//--------------------------------------------------------------------------
		//
		//  
		//
		//--------------------------------------------------------------------------
		
		public const configPathChanged:Signal = new Signal(String); // path
		
		public const stylesheetChanged:Signal = new Signal(IStyleSheet);
		
		public const accountsImported:Signal = new Signal();
		
		public const accountLoginStarted:Signal = new Signal(String); // username
		
		public const accountLoggedIn:Signal = new Signal(AccountModule); // TODO - value classes?
		
		public const accountLoggedInError:Signal = new Signal(String);
		
		public const accountVerifyStarted:Signal = new Signal(AccountModule);
		
		public const accountVerified:Signal = new Signal(AccountModule);
		
		public const accountVerifiedError:Signal = new Signal(String); // message
		
		public const accountUserInfoUpdated:Signal = new Signal(AccountModule);
		
		public const accountSelected:Signal = new Signal(AccountModule);
		
		public const alertChanged:Signal = new Signal(String); // message;
		
		public const alertClosed:Signal = new Signal();
		
		public const imageViewerOpened:Signal = new Signal(URLRequest);
		
		public const imageViewerClosed:Signal = new Signal();
		
		public const drawerOpened:Signal = new Signal(String); // state
		
		public const drawerOpenedForUpdate:Signal = new Signal(UpdateVO); //details
		
		public const drawerOpenedForStatusUpdate:Signal = new Signal(String); // optional text
		
		public const drawerOpenedForStatusReply:Signal = new Signal(GeneralStatusVO, Boolean); // status to reply to, all
		
		public const drawerOpenedForStatusRetweet:Signal = new Signal(GeneralStatusVO); // status to retweet

		public const drawerOpenedForSecondaryStatusRetweet:Signal = new Signal(GeneralStatusVO); // status to retweet
		
		public const drawerOpenedForMessageReply:Signal = new Signal(GeneralTwitterVO); // status/message to reply to

		public const drawerOpenedForDialogue:Signal = new Signal(String, String); // reply id, original id

		public const drawerOpenedForFind:Signal = new Signal();
		
		public const drawerOpenedForFilter:Signal = new Signal(String); // stream

		public const drawerOpenedForProfile:Signal = new Signal(String); // screenName

		public const drawerOpenedForURLPreview:Signal = new Signal(String); // url
		
		public const drawerClosed:Signal = new Signal();
		
		public const drawerStateChanged:Signal = new Signal(String, String); // oldState, newState

		public const drawerPositionUpdated:Signal = new Signal();
		
		public const gotOriginalDialogueStatus:Signal = new Signal(GeneralStatusVO);
		
		public const gotOriginalDialogueStatusError:Signal = new Signal(String); // message
		
		public const getOriginalDialogueStatusCancelled:Signal = new Signal();
		
		public const workspaceStateChanged:Signal = new Signal(String, String);
		
		public const statusUpdated:Signal = new Signal(StatusVO);
		
		public const statusUpdatedError:Signal = new Signal(String); // error

		public const retweetedStatus:Signal = new Signal(StatusVO);
		
		public const retweetedStatusError:Signal = new Signal(String); // error
		
		public const messageSent:Signal = new Signal(DirectMessageVO);
		
		public const messageSentError:Signal = new Signal(String); // error
		
		public const awayModeChanged:Signal = new Signal(Boolean);
		
		//--------------------------------------------------------------------------
		//
		//  General Twitter
		//
		//--------------------------------------------------------------------------
		
		public const deletedStatus:Signal = new Signal(String); //id

		public const deletedMessage:Signal = new Signal(String); //id

		public const favoritedStatus:Signal = new Signal(String); //id
		
		public const gotRelationship:Signal = new Signal(RelationshipVO);
		
		public const gotRelationshipError:Signal = new Signal();

		public const followed:Signal = new Signal(UserVO);
		
		public const followedError:Signal = new Signal();
		
		public const unfollowed:Signal = new Signal(UserVO);
		
		public const unfollowedError:Signal = new Signal();
		
		public const searchKeywordChanged:Signal = new Signal(String);
		
		public const promptedProfileRefresh:Signal = new Signal();
		
		//--------------------------------------------------------------------------
		//
		//  Overlays
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		// Quick Friend Lookup 
		//--------------------------------------
		
		public const quickFriendLookupPrompted:Signal = new Signal(Number, Number, String); // x, y, positionType

		public const quickFriendLookupDisplayedChanged:Signal = new Signal(Boolean); // displayed
		
		public const quickFriendLookupScreenNameSelected:Signal = new Signal(String); // screenName
		
		//--------------------------------------------------------------------------
		//
		//  Streams
		//
		//--------------------------------------------------------------------------
		
		public const markedStreamStatusesRead:Signal = new Signal(String); // stream
		
		//--------------------------------------
		// Home 
		//--------------------------------------
		
		public const homeStreamUpdated:Signal = new Signal(AccountModule, String, Array, Array);
		
		public const homeStreamUpdateStarted:Signal = new Signal(AccountModule);
		
		public const homeStreamUpdatedError:Signal = new Signal(AccountModule, String); // message
		
		public const homeStreamNumUnreadChanged:Signal = new Signal(AccountModule, int, int); // numUnread

		public const homeStatusReadListUpdated:Signal = new Signal(int);
		
		//--------------------------------------
		// Mentions 
		//--------------------------------------
		
		public const mentionsStreamUpdated:Signal = new Signal(AccountModule, String, Array, Array);
		
		public const mentionsStreamUpdateStarted:Signal = new Signal(AccountModule);
		
		public const mentionsStreamUpdatedError:Signal = new Signal(AccountModule, String); // message
		
		public const mentionsStreamNumUnreadChanged:Signal = new Signal(AccountModule, int, int); // numUnread
		
		public const mentionsStatusReadListUpdated:Signal = new Signal(int);
		
		//--------------------------------------
		// Search 
		//--------------------------------------
		
		public const searchStreamUpdated:Signal = new Signal(AccountModule, String, Array, Array);
		
		public const searchStreamUpdateStarted:Signal = new Signal(AccountModule);
		
		public const searchStreamUpdatedError:Signal = new Signal(AccountModule, String); // message
		
		public const searchStreamNumUnreadChanged:Signal = new Signal(AccountModule, int, int); // numUnread
		
		public const searchStatusReadListUpdated:Signal = new Signal(int);
		
		//--------------------------------------
		// Messages 
		//--------------------------------------
		
		public const messagesStreamUpdated:Signal = new Signal(AccountModule, String, Array, Array);
		
		public const messagesStreamUpdateStarted:Signal = new Signal(AccountModule);
		
		public const messagesStreamUpdatedError:Signal = new Signal(AccountModule, String); // message
		
		public const messagesStreamNumUnreadChanged:Signal = new Signal(AccountModule, int, int); // numUnread
		
		//--------------------------------------------------------------------------
		//
		//  Compose
		//
		//--------------------------------------------------------------------------
		
		public const urlShorteningStarted:Signal = new Signal();
		
		public const urlShortened:Signal = new Signal(String, String); // original URL, shortend URL
		
		public const urlShortenedError:Signal = new Signal(int, String); // code, message
		
		public const fileUploadingStarted:Signal = new Signal(File); // file
		
		public const fileUploaded:Signal = new Signal(String); // url
		
		public const fileUploadedError:Signal = new Signal(int, String); // code, message
		
		public const composeRestored:Signal = new Signal(String); // message
		
		//--------------------------------------------------------------------------
		//
		//  
		//
		//--------------------------------------------------------------------------
		
		public const statusReplyPrompted:Signal = new Signal(StreamStatusVO); //wtf?
		
		//--------------------------------------------------------------------------
		//
		//  Find
		//
		//--------------------------------------------------------------------------
		
		public const foundTerm:Signal = new Signal(String, String, int, int, int); // stream, term, item index, begin text index, end text index

		//--------------------------------------------------------------------------
		//
		//  Profile Panel
		//
		//--------------------------------------------------------------------------
		
		public const gotProfileUser:Signal = new Signal(SQLUserVO);
		
		public const gotProfileUserError:Signal = new Signal(String); // message
		
		//--------------------------------------------------------------------------
		//
		//  URL Preview Panel
		//
		//--------------------------------------------------------------------------
		
		public const gotURLPreview:Signal = new Signal(URLPreviewVO);
		
		public const gotURLPreviewError:Signal = new Signal(String); // message
		
		//--------------------------------------------------------------------------
		//
		//  Preferences
		//
		//--------------------------------------------------------------------------
		
		public const notificationSoundChanged:Signal = new Signal(String);

		public const requestedInstallDebugger:Signal = new Signal();
		
		public const requestedUninstallDebugger:Signal = new Signal();

		public const themeChanged:Signal = new Signal(String);
	}
}