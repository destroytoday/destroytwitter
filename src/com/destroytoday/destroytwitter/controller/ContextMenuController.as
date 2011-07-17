package com.destroytoday.destroytwitter.controller {
	import com.destroytoday.desktop.NativeMenuPlus;
	import com.destroytoday.destroytwitter.constants.BooleanType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RetweetFormatType;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.controller.stream.SearchStreamController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ContextMenuModel;
	import com.destroytoday.destroytwitter.model.PreferencesModel;
	import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.PreferenceVO;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.model.vo.StreamMessageVO;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.contextmenu.StreamMessageActionsMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.StreamOptionsMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.StreamStatusActionsMenu;
	import com.destroytoday.pool.ObjectWaterpark;
	import com.destroytoday.twitteraspirin.constants.ImageServiceType;
	import com.destroytoday.twitteraspirin.constants.RelationshipType;
	import com.destroytoday.twitteraspirin.constants.URLShortenerType;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.util.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenuItem;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;

	public class ContextMenuController 
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var accountController:AccountModuleController;
		
		[Inject]
		public var accountModel:AccountModuleModel;

		[Inject]
		public var clipboardController:ClipboardController;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var preferencesModel:PreferencesModel;

		[Inject]
		public var contextView:DisplayObjectContainer;
		
		[Inject]
		public var generalTwitterController:GeneralTwitterController;

		[Inject]
		public var workspaceController:WorkspaceController;
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var composeController:ComposeController;
		
		[Inject]
		public var filterController:FilterController;
		
		[Inject]
		public var searchStreamController:SearchStreamController;
		
		[Inject]
		public var linkController:LinkController;

		[Inject]
		public var model:ContextMenuModel;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ContextMenuController() {
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function getTwitterElementTextMenu():ContextMenu
		{
			return model.twitterElementTextMenu;
		}
		
		public function getRetweetLabel(format:String):String
		{
			var label:String;
			
			switch (format)
			{
				case RetweetFormatType.ARROW:
					label = "Retweet (>)...";
					break;
				case RetweetFormatType.RT:
					label = "Retweet (RT)...";
					break;
				case RetweetFormatType.VIA:
					label = "Retweet (via)...";
					break;
				case RetweetFormatType.NATIVE:
					label = "Native Retweet...";
					break;
			}
			
			return label;
		}
		
		public function displayStreamOptionsMenu(stage:Stage, x:Number, y:Number, stream:String):void {
			var tweetsPerPagePreference:String, refreshRatePreference:String, notificationsPreference:String, filterPreference:String;
			
			switch (stream)
			{
				case StreamType.HOME:
					tweetsPerPagePreference = PreferenceType.HOME_TWEETS_PER_PAGE;
					refreshRatePreference = PreferenceType.HOME_REFRESH_RATE;
					notificationsPreference = PreferenceType.HOME_NOTIFICATIONS;
					filterPreference = PreferenceType.HOME_FILTER;
					break;
				case StreamType.MENTIONS:
					tweetsPerPagePreference = PreferenceType.MENTIONS_PER_PAGE;
					refreshRatePreference = PreferenceType.MENTIONS_REFRESH_RATE;
					notificationsPreference = PreferenceType.MENTIONS_NOTIFICATIONS;
					filterPreference = PreferenceType.MENTIONS_FILTER;
					break;
				case StreamType.SEARCH:
					tweetsPerPagePreference = PreferenceType.SEARCH_PER_PAGE;
					refreshRatePreference = PreferenceType.SEARCH_REFRESH_RATE;
					notificationsPreference = PreferenceType.SEARCH_NOTIFICATIONS;
					break;
				case StreamType.MESSAGES:
					tweetsPerPagePreference = PreferenceType.MESSAGES_PER_PAGE;
					refreshRatePreference = PreferenceType.MESSAGES_REFRESH_RATE;
					notificationsPreference = PreferenceType.MESSAGES_NOTIFICATIONS;
					break;
			}
			
			model.streamOptionsMenu.checkOnlyLabel(preferencesController.getPreference(tweetsPerPagePreference), model.streamOptionsMenu.tweetsPerPage.submenu.items);
			model.streamOptionsMenu.checkOnlyLabel(preferencesController.getPreference(refreshRatePreference), model.streamOptionsMenu.refreshRate.submenu.items);
			model.streamOptionsMenu.enableNotifications.checked = preferencesController.getBoolean(notificationsPreference);
			model.streamOptionsMenu.enableNotifications.data = notificationsPreference;
			
			model.streamOptionsMenu.canFilter = (filterPreference != null);
			
			if (filterPreference)
			{
				model.streamOptionsMenu.enableFilter.checked = preferencesController.getBoolean(filterPreference);
				model.streamOptionsMenu.enableFilter.data = filterPreference;
			}
			
			model.streamOptionsMenu.addEventListener(Event.SELECT, streamOptionsMenuSelectHandler);
			model.streamOptionsMenu.tweetsPerPage.submenu.addEventListener(Event.SELECT, streamOptionsTweetsPerPageMenuSelectHandler);
			model.streamOptionsMenu.tweetsPerPage.data = tweetsPerPagePreference;
			model.streamOptionsMenu.refreshRate.submenu.addEventListener(Event.SELECT, streamOptionsRefreshRateMenuSelectHandler);
			model.streamOptionsMenu.refreshRate.data = refreshRatePreference;
			model.streamOptionsMenu.data = stream;
			model.streamOptionsMenu.display(stage, x, y);
		}
		
		public function displayStatusActionsMenu(stage:Stage, x:Number, y:Number, data:GeneralStatusVO):void {
			if (data.userID > 0) //TEMP indicator of search result
			{
				var source:String = StringUtil.stripHTML(data.source);
				
				model.statusActionsMenu.filterScreenName.label = "Filter " + data.userScreenName;
				model.statusActionsMenu.filterSource.label = "Filter tweets from " + source;
			}
			
			model.statusActionsMenu.retweet.label = getRetweetLabel(preferencesController.getPreference(PreferenceType.RETWEET_FORMAT));
			model.statusActionsMenu.secondaryRetweet.label = getRetweetLabel(preferencesController.getPreference(PreferenceType.SECONDARY_RETWEET_FORMAT));
			
			model.statusActionsMenu.setStatus(data.userID == accountModel.currentAccountID, generalTwitterController.isDeletingStatus(data.id), generalTwitterController.isFavoriting(data.id), data.userID == 0);
			
			model.statusActionsMenu.addEventListener(Event.SELECT, statusActionsMenuSelectHandler);
			model.statusActionsMenu.data = data;
			model.statusActionsMenu.display(stage, x, y);
		}
		
		public function displayMessageActionsMenu(stage:Stage, x:Number, y:Number, data:StreamMessageVO):void {
			model.messageActionsMenu.setStatus(generalTwitterController.isDeletingMessage(data.id));
			
			model.messageActionsMenu.addEventListener(Event.SELECT, messageActionsMenuSelectHandler);
			model.messageActionsMenu.data = data;
			model.messageActionsMenu.display(stage, x, y);
		}
		
		public function displayURLShortenerMenu(stage:Stage, x:Number, y:Number):void {
			model.urlShortenerMenu.autoShortenURLs.checked = preferencesModel.file.getBoolean(PreferenceType.AUTO_SHORTEN_URLS);

			var item:NativeMenuItem;
			
			switch (preferencesModel.file.getString(PreferenceType.URL_SHORTENER))
			{
				case URLShortenerType.JMP:
					item = model.urlShortenerMenu.jmp;
					break;
				case URLShortenerType.BITLY:
					item = model.urlShortenerMenu.bitly;
					break;
				case URLShortenerType.ISGD:
					item = model.urlShortenerMenu.isgd;
					break;
				case URLShortenerType.TINYURL:
					item = model.urlShortenerMenu.tinyurl;
					break;
			}
			
			model.urlShortenerMenu.checkOnly(item, null, model.urlShortenerMenu.autoShortenURLs);
			
			model.urlShortenerMenu.addEventListener(Event.SELECT, urlShortenerMenuSelectHandler);
			model.urlShortenerMenu.display(stage, x, y);
		}
		
		public function displayFileUploaderMenu(stage:Stage, x:Number, y:Number):void {
			var item:NativeMenuItem;
			
			switch (preferencesModel.file.getString(PreferenceType.IMAGE_SERVICE))
			{
				case ImageServiceType.POSTEROUS:
					item = model.fileUploaderMenu.posterous;
					break;
				case ImageServiceType.TWITGOO:
					item = model.fileUploaderMenu.twitgoo;
					break;
				case ImageServiceType.IMGLY:
					item = model.fileUploaderMenu.imgly;
					break;
				case ImageServiceType.PLIXI:
					item = model.fileUploaderMenu.tweetphoto;
					break;
				case ImageServiceType.IMGUR:
					item = model.fileUploaderMenu.imgur;
					break;
				/*case ImageServiceType.PIKCHUR:
					item = model.fileUploaderMenu.pikchur;
					break;*/
				case ImageServiceType.TWITPIC:
					item = model.fileUploaderMenu.twitpic;
					break;
				case ImageServiceType.YFROG:
					item = model.fileUploaderMenu.yfrog;
					break;
			}
			
			model.fileUploaderMenu.checkOnly(item, null, model.fileUploaderMenu.uploadFile);
			
			model.fileUploaderMenu.addEventListener(Event.SELECT, fileUploaderMenuSelectHandler);
			model.fileUploaderMenu.display(stage, x, y);
		}
		
		public function displayAccountIconMenu(stage:Stage, x:Number, y:Number):void {
			model.accountIconMenu.user.label = accountModel.currentAccount.infoModel.accessToken.screenName;
			
			model.accountIconMenu.addEventListener(Event.SELECT, accountIconMenuSelectHandler);
			model.accountIconMenu.display(stage, x, y);
		}
		
		public function displayPreferenceMenu(stage:Stage, x:Number, y:Number, preference:PreferenceVO):void
		{
			if (preference.type == PreferenceType.THEME)
			{
				preferencesController.updateThemeOptionList();
			}
			
			var numMenuItems:uint = model.preferenceMenu.numItems;
			var numOptions:uint = preference.options.length;
			var m:uint = Math.max(numMenuItems, numOptions);
			var item:NativeMenuItem;
			var option:String;

			for (var i:uint = 0; i < m; ++i)
			{
				if (i < numOptions && i < numMenuItems)
				{
					item = model.preferenceMenu.items[i];
				}
				else if (i < numOptions)
				{
					item = ObjectWaterpark.getObject(NativeMenuItem) as NativeMenuItem;
					
					model.preferenceMenu.addItemAt(item, i);
					
					++numMenuItems;
				}
				else
				{
					item = null;
					
					ObjectWaterpark.disposeObject(model.preferenceMenu.removeItemAt(model.preferenceMenu.numItems - 1));
				}
				
				if (item)
				{
					item.label = String(preference.options[i]).replace('&gt;', '>');
					
					option = String(preference.options[i]);

					item.checked = preferencesController.getPreference(preference.type) == option;
				}
			}
			
			model.preferenceMenu.data = preference;
			model.preferenceMenu.addEventListener(Event.SELECT, preferenceMenuSelectHandler);
			model.preferenceMenu.display(stage, x, y);
		}
		
		public function displayProfilePanelMenu(stage:Stage, x:Number, y:Number, data:SQLUserVO, relationship:RelationshipVO):void {
			var isGettingRelationship:Boolean, isFollowing:Boolean, isUnfollowing:Boolean;
			
			isGettingRelationship = generalTwitterController.isGettingRelationship(data.id);
			
			if (!relationship && !isGettingRelationship)
			{
				isGettingRelationship = true;
				
				signalBus.gotRelationship.add(gotRelationshipHandler);
				signalBus.gotRelationshipError.add(gotRelationshipErrorHandler);
				signalBus.followed.add(followedHandler);
				signalBus.followedError.add(followedErrorHandler);
				signalBus.unfollowed.add(unfollowedHandler);
				signalBus.unfollowedError.add(unfollowedErrorHandler);
				
				generalTwitterController.getRelationship(accountModel.currentAccount, data.id);
			}
			
			isFollowing = generalTwitterController.isFollowing(data.id);
			isUnfollowing = generalTwitterController.isUnfollowing(data.id);

			model.profilePanelMenu.setStatus(
				data.id == accountModel.currentAccountID, 
				isGettingRelationship,
				isFollowing,
				isUnfollowing,
				false,
				false,
				false,
				relationship
			);
			
			model.profilePanelMenu.addEventListener(Event.SELECT, profilePanelMenuSelectHandler);
			model.profilePanelMenu.relationship.data = relationship;
			model.profilePanelMenu.data = data;
			model.profilePanelMenu.display(stage, x, y);
		}
		
		public function displaySearchHistoryMenu(stage:Stage, x:Number, y:Number):void 
		{
			model.searchHistoryMenu.addEventListener(Event.SELECT, searchHistoryMenuSelectHandler);
			model.searchHistoryMenu.setKeywordList(searchStreamController.getKeywordList());
			model.searchHistoryMenu.display(stage, x, y);
		}
		
		public function displayComposeMenu(stage:Stage, x:Number, y:Number):void 
		{
			model.composeMenu.addEventListener(Event.SELECT, composeMenuSelectHandler);
			model.composeMenu.display(stage, x, y);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function menuDeactivateHandler(event:Event):void //TODO
		{
			(event.currentTarget as NativeMenuPlus).data = null;
		}
		
		protected function streamOptionsMenuSelectHandler(event:Event):void {
			var menu:StreamOptionsMenu = model.streamOptionsMenu;
			var item:NativeMenuItem = event.target as NativeMenuItem;
			var data:String = String(menu.data);

			switch (item) {
				case menu.refresh:
					workspaceController.getStreamControllerByName(data).refresh();
					break;
				case menu.markAsRead:
					workspaceController.markStreamStatusesRead(data);
					break;
				case menu.find:
					drawerController.openFind();
					break;
				case menu.enableNotifications:
					preferencesController.setString(String(model.streamOptionsMenu.enableNotifications.data), !(event.target as NativeMenuItem).checked ? ToggleType.ENABLED : ToggleType.DISABLED);
					break;
				case menu.enableFilter:
					preferencesController.setString(String(model.streamOptionsMenu.enableFilter.data), !(event.target as NativeMenuItem).checked ? ToggleType.ENABLED : ToggleType.DISABLED);
					workspaceController.getStreamControllerByName(data).getMostRecent();
					break;
				case menu.configureFilter:
					drawerController.openFilter(data);
					break;
			}
		}
		
		protected function streamOptionsTweetsPerPageMenuSelectHandler(event:Event):void {
			event.stopPropagation();
			
			preferencesController.setString(String(model.streamOptionsMenu.tweetsPerPage.data), (event.target as NativeMenuItem).label);
		}
		
		protected function streamOptionsRefreshRateMenuSelectHandler(event:Event):void {
			event.stopPropagation();
			
			preferencesController.setString(String(model.streamOptionsMenu.refreshRate.data), (event.target as NativeMenuItem).label);
		}

		protected function statusActionsMenuSelectHandler(event:Event):void {
			var menu:StreamStatusActionsMenu = model.statusActionsMenu;
			var item:NativeMenuItem = event.target as NativeMenuItem;
			var data:GeneralStatusVO = menu.data as GeneralStatusVO;
			
			switch (item) {
				case menu.reply:
					drawerController.openStatusReply(data);
					break;
				case menu.replyAll:
					drawerController.openStatusReply(data, true);
					break;
				case menu.directMessage:
					drawerController.openMessageReply(data);
					break;
				case menu.retweet:
					drawerController.openStatusRetweet(data);
					break;
				case menu.secondaryRetweet:
					drawerController.openSecondaryStatusRetweet(data);
					break;
				case menu.favorite:
					generalTwitterController.favoriteStatus(accountModel.currentAccount, data.id);
					break;
				case menu.destroy:
					generalTwitterController.deleteStatus(accountModel.currentAccount, data.id);
					break;
				case menu.filterScreenName:
					filterController.addScreenName(data.userScreenName);
					break;
				case menu.filterSource:
					filterController.addSource(StringUtil.stripHTML(data.source));
					break;
				case menu.openInBrowser:
					navigateToURL(new URLRequest("http://twitter.com/" + data.userScreenName + "/statuses/" + data.id));
					break;
				case menu.copyToClipboard:
					clipboardController.copyText(StringUtil.stripHTML(data.text));
					break;
			}

			menu.data = null;
		}
		
		protected function messageActionsMenuSelectHandler(event:Event):void {
			var menu:StreamMessageActionsMenu = model.messageActionsMenu;
			var item:NativeMenuItem = event.target as NativeMenuItem;
			var data:GeneralMessageVO = menu.data as GeneralMessageVO;

			switch (item) {
				case menu.reply:
					drawerController.openMessageReply(data);
					break;
				case menu.destroy:
					generalTwitterController.deleteMessage(accountModel.currentAccount, data.id);
					break;
				case menu.copyToClipboard:
					clipboardController.copyText(StringUtil.stripHTML(data.text));
					break;
			}
			
			menu.data = null;
		}
		
		protected function urlShortenerMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			switch (item)
			{
				case model.urlShortenerMenu.autoShortenURLs:
					preferencesController.setString(PreferenceType.AUTO_SHORTEN_URLS, (!item.checked ? BooleanType.TRUE : BooleanType.FALSE));
					break;
				case model.urlShortenerMenu.jmp:
					preferencesController.setString(PreferenceType.URL_SHORTENER, URLShortenerType.JMP);
					break;
				case model.urlShortenerMenu.bitly:
					preferencesController.setString(PreferenceType.URL_SHORTENER, URLShortenerType.BITLY);
					break;
				case model.urlShortenerMenu.isgd:
					preferencesController.setString(PreferenceType.URL_SHORTENER, URLShortenerType.ISGD);
					break;
				case model.urlShortenerMenu.tinyurl:
					preferencesController.setString(PreferenceType.URL_SHORTENER, URLShortenerType.TINYURL);
					break;
			}
		}
		
		protected function fileUploaderMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			switch (item)
			{
				case model.fileUploaderMenu.uploadFile:
					composeController.browseFilesForUpload();
					break;
				case model.fileUploaderMenu.posterous:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.POSTEROUS);
					break;
				case model.fileUploaderMenu.twitgoo:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.TWITGOO);
					break;
				case model.fileUploaderMenu.imgly:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.IMGLY);
					break;
				case model.fileUploaderMenu.tweetphoto:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.PLIXI);
					break;
				case model.fileUploaderMenu.imgur:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.IMGUR);
					break;
				/*case model.fileUploaderMenu.pikchur:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.PIKCHUR);
					break;*/
				case model.fileUploaderMenu.twitpic:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.TWITPIC);
					break;
				case model.fileUploaderMenu.yfrog:
					preferencesController.setString(PreferenceType.IMAGE_SERVICE, ImageServiceType.YFROG);
					break;
			}
		}
		
		protected function accountIconMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			switch (item)
			{
				case model.accountIconMenu.logout:
					accountController.deactivateAccount(accountModel.currentAccount);
					accountController.selectAccount(null);
					break;
			}
		}
		
		protected function preferenceMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			var preference:PreferenceVO = (item.menu as NativeMenuPlus).data as PreferenceVO;
			var option:String;
			
			if (item.label.indexOf('>') != -1)
			{
				option = item.label.replace('>', '&gt;');
			}
			else
			{
				option = item.label;
			}

			preferencesController.setString(preference.type, option);
			
			signalBus.preferencesChanged.dispatch();
		}
		
		protected function gotRelationshipHandler(relationship:RelationshipVO):void
		{
			model.profilePanelMenu.relationship.data = relationship;
			
			model.profilePanelMenu.setStatus(
				relationship.targetUserID == accountModel.currentAccountID,
				false, // isGettingRelationship
				false, // isFollowing
				false, // isUnfollowing
				false, // isBlocking
				false, // isUnblocking
				false, // isReporting
				relationship
			);
		}
		
		protected function gotRelationshipErrorHandler():void
		{
			model.profilePanelMenu.setRelationshipError();
		}
		
		protected function followedHandler(user:UserVO):void
		{
			if (model.profilePanelMenu.data && (model.profilePanelMenu.data as SQLUserVO).id == user.id)
			{
				var relationship:RelationshipVO = model.profilePanelMenu.relationship.data as RelationshipVO;
				
				if (relationship.type == RelationshipType.FOLLOWER)
				{
					relationship.type = RelationshipType.MUTUAL;
				}
				else if (relationship.type == RelationshipType.NONE)
				{
					relationship.type = RelationshipType.FOLLOWING;
				}
				
				model.profilePanelMenu.setStatus(
					user.id == accountModel.currentAccountID,
					false, // isGettingRelationship
					false, // isFollowing
					false, // isUnfollowing
					false, // isBlocking
					false, // isUnblocking
					false, // isReporting
					relationship
				);
			}
		}
		
		protected function followedErrorHandler():void
		{
			model.profilePanelMenu.setFollowError();
		}
		
		protected function unfollowedHandler(user:UserVO):void
		{
			if (model.profilePanelMenu.data && (model.profilePanelMenu.data as SQLUserVO).id == user.id)
			{
				var relationship:RelationshipVO = model.profilePanelMenu.relationship.data as RelationshipVO;
				
				if (relationship.type == RelationshipType.MUTUAL)
				{
					relationship.type = RelationshipType.FOLLOWER;
				}
				else if (relationship.type == RelationshipType.FOLLOWING)
				{
					relationship.type = RelationshipType.NONE;
				}
				
				model.profilePanelMenu.setStatus(
					user.id == accountModel.currentAccountID,
					false, // isGettingRelationship
					false, // isFollowing
					false, // isUnfollowing
					false, // isBlocking
					false, // isUnblocking
					false, // isReporting
					relationship
				);
			}
		}
		
		protected function unfollowedErrorHandler():void
		{
			model.profilePanelMenu.setUnfollowError();
		}
		
		protected function profilePanelMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			var data:SQLUserVO = model.profilePanelMenu.data as SQLUserVO;
			
			switch (item)
			{
				case model.profilePanelMenu.followUnfollow:
					if (item.label == "Follow")
					{
						generalTwitterController.follow(accountModel.currentAccount, data.id);
					}
					else
					{
						generalTwitterController.unfollow(accountModel.currentAccount, data.id);
					}
					break;
				case model.profilePanelMenu.directMessage:
					drawerController.openStatusUpdate("D " + data.screenName + " ");
					break;
				case model.profilePanelMenu.refresh:
					signalBus.promptedProfileRefresh.dispatch();
					break;
			}
		}
		
		protected function searchHistoryMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			switch (item)
			{
				case model.searchHistoryMenu.noHistory:
					searchStreamController.searchKeyword('');
					break;
				case model.searchHistoryMenu.clearHistory:
					searchStreamController.clearHistory();
					break;
				default:
					searchStreamController.searchKeyword(item.label);
					break;
			}
		}
		
		protected function composeMenuSelectHandler(event:Event):void
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			switch (item)
			{
				case model.composeMenu.restore:
					composeController.restoreMessage();
					break;
			}
		}
	}
}