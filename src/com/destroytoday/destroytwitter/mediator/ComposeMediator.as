package com.destroytoday.destroytwitter.mediator {
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.constants.BooleanType;
	import com.destroytoday.destroytwitter.constants.ComposeType;
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.constants.PositionType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RetweetFormatType;
	import com.destroytoday.destroytwitter.constants.SpellCheckLanguageType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.controller.ClipboardController;
	import com.destroytoday.destroytwitter.controller.ComposeController;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.QuickFriendLookupController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.ComposeModel;
	import com.destroytoday.destroytwitter.model.PreferencesModel;
	import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.utils.PreferenceOptionUtil;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.drawer.Compose;
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.util.StringUtil;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	public class ComposeMediator extends BaseMediator {

		[Inject]
		public var accountModel:AccountModuleModel;

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var alertController:AlertController;

		[Inject]
		public var clipboardController:ClipboardController;

		[Inject]
		public var composeController:ComposeController;

		[Inject]
		public var contextMenuController:ContextMenuController;

		[Inject]
		public var drawerController:DrawerController;

		[Inject]
		public var preferencesController:PreferencesController;

		[Inject]
		public var preferencesModel:PreferencesModel;

		[Inject]
		public var quickFriendLookupController:QuickFriendLookupController;
		
		[Inject]
		public var model:ComposeModel;

		[Inject]
		public var view:Compose;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var copiedText:String;

		protected var quickFriendLookup:Boolean;

		protected var quickFriendLookupDelay:Timer = new Timer(250.0, 1);

		protected var selectionBeginIndex:int;

		protected var selectionEndIndex:int;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ComposeMediator() {
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		override public function onRegister():void {
			super.onRegister();

			quickFriendLookupDelay.addEventListener(TimerEvent.TIMER_COMPLETE, quickFriendLookupDelayHandler);

			view.form.linkButton.addEventListener(MouseEvent.CLICK, linkButtonClickHandler);
			view.form.fileButton.addEventListener(MouseEvent.CLICK, fileButtonClickHandler);
			view.form.spinner.addEventListener(MouseEvent.CLICK, spinnerClickHandler);
			view.form.textArea.textfield.addEventListener(Event.CHANGE, textAreaChangeHandler);
			view.form.textArea.textfield.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			view.form.textArea.textfield.addEventListener(FocusEvent.FOCUS_IN, textAreaFocusInHandler);
			view.form.submitButton.addEventListener(MouseEvent.CLICK, submitHandler);
			view.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterHandler);
			view.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
			view.actionsButton.addEventListener(MouseEvent.CLICK, actionsButtonClickHandler);

			signalBus.drawerStateChanged.add(drawerStateChangedHandler);
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerOpenedForStatusUpdate.add(drawerOpenedForStatusUpdateHandler);
			signalBus.drawerOpenedForStatusReply.add(drawerOpenedForStatusReplyHandler);
			signalBus.drawerOpenedForStatusRetweet.add(drawerOpenedForStatusRetweetHandler);
			signalBus.drawerOpenedForSecondaryStatusRetweet.add(drawerOpenedForSecondaryStatusRetweetHandler);
			signalBus.drawerOpenedForMessageReply.add(drawerOpenedForMessageReplyHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);
			signalBus.statusUpdated.add(statusUpdatedHandler);
			signalBus.statusUpdatedError.add(statusUpdatedErrorHandler);
			signalBus.retweetedStatus.add(retweetedStatusHandler);
			signalBus.retweetedStatusError.add(retweetedStatusErrorHandler);
			signalBus.messageSent.add(messageSentHandler);
			signalBus.messageSentError.add(messageSentErrorHandler);
			signalBus.urlShorteningStarted.add(urlShorteningStartedHandler);
			signalBus.urlShortened.add(urlShortenedHandler);
			signalBus.urlShortenedError.add(urlShortenedErrorHandler);
			signalBus.fileUploadingStarted.add(fileUploadingStartedHandler);
			signalBus.fileUploaded.add(fileUploadedHandler);
			signalBus.fileUploadedError.add(fileUploadedErrorHandler);
			signalBus.fontTypeChanged.add(fontTypeChangedHandler);
			signalBus.fontSizeChanged.add(fontSizeChangedHandler);
			signalBus.composeRestored.add(restoredHandler);

			view.form.fontType = preferencesController.getPreference(PreferenceType.FONT_TYPE);
			view.form.fontSize = preferencesController.getPreference(PreferenceType.FONT_SIZE);
		}

		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------

		protected function set enabled(value:Boolean):void {
			view.enabled = value;

			if (view.enabled) {
				signalBus.quickFriendLookupDisplayedChanged.add(quickFriendLookupDisplayedChangedHandler);
				signalBus.quickFriendLookupScreenNameSelected.add(quickFriendLookupScreenNameSelectedHandler);
			} else {
				signalBus.quickFriendLookupDisplayedChanged.remove(quickFriendLookupDisplayedChangedHandler);
				signalBus.quickFriendLookupScreenNameSelected.remove(quickFriendLookupScreenNameSelectedHandler);
			}

			if (preferencesController.getPreference(PreferenceType.SPELL_CHECK) == ToggleType.DISABLED) {
				view.form.spellCheck.enabled = false;
			} else {
				view.form.spellCheck.enabled = value;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		protected function retweet(status:GeneralStatusVO, secondary:Boolean):void
		{
			view.type = null;
			enabled = true;

			var text:String = StringUtil.stripHTML(status.text).replace(/&lt;/g, '<').replace(/&gt;/g, '>');
			var format:String = preferencesController.getPreference((!secondary) ? PreferenceType.RETWEET_FORMAT : PreferenceType.SECONDARY_RETWEET_FORMAT)

			switch (format) {
				case RetweetFormatType.ARROW:
					view.form.textArea.text = " > @" + status.userScreenName + ": " + text;
					
					view.form.textArea.focus(0);
					break;
				case RetweetFormatType.RT:
					view.form.textArea.text = "RT @" + status.userScreenName + ": " + text;
					
					view.form.textArea.focus(view.form.textArea.text.length);
					break;
				case RetweetFormatType.VIA:
					view.form.textArea.text = text + " /via @" + status.userScreenName;
					
					view.form.textArea.focus(view.form.textArea.text.length);
					break;
				case RetweetFormatType.NATIVE:
					view.form.textArea.text = text;
					
					enabled = false;
					view.form.spinner.displayed = true;
					
					accountModel.currentAccount.twitterController.retweetStatus(status.id);
					break;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function actionsButtonClickHandler(event:MouseEvent):void {
			var button:BitmapButton = event.currentTarget as BitmapButton;

			var point:Point = button.localToGlobal(new Point(button.width * 0.5 - 1.0, button.height * 0.5 + 7.0));

			contextMenuController.displayComposeMenu(view.stage, point.x, point.y);
		}

		protected function dragDropHandler(event:NativeDragEvent):void {
			var fileList:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			if (fileList)
			{
				var file:File = fileList[0] as File;

				composeController.uploadFile(file);
			}
		}

		protected function drawerClosedHandler():void {
			if (view.visible) {
				if (view.form.textArea.text && view.form.textArea.text != view.form.textArea.defaultText)
					composeController.storeMessage(view.form.textArea.text);

				accountModel.currentAccount.twitterController.cancelTweet();
				composeController.cancelShortenURL();
				composeController.cancelUploadFile();

				view.form.textArea.textfield.removeEventListener(TextEvent.TEXT_INPUT, textAreaPasteHandler);

				view.form.linkButton.loading = false;
				view.form.fileButton.loading = false;
				enabled = false;
				view.form.spinner.displayed = false;
				view.form.textArea.textfield.tabEnabled = false;
			}
		}

		protected function drawerOpenedForMessageReplyHandler(status:GeneralTwitterVO):void {
			view.data = status;
			view.type = ComposeType.DIRECT_MESSAGE;

			view.form.textArea.text = "";

			enabled = true;
			view.form.textArea.focus();
		}

		protected function drawerOpenedForStatusReplyHandler(status:GeneralStatusVO, all:Boolean):void {
			view.type = null;
			view.data = status;

			if (all) {
				view.form.textArea.text = TwitterTextUtil.getUniqueScreenNameList(view.data, accountModel.currentAccount.infoModel.accessToken.screenName).join(" ") + " ";
			} else {
				view.form.textArea.text = "@" + view.data.userScreenName + " ";
			}

			enabled = true;
			view.form.textArea.focus();
		}

		protected function drawerOpenedForStatusRetweetHandler(status:GeneralStatusVO):void {
			retweet(status, false);
		}
		
		protected function drawerOpenedForSecondaryStatusRetweetHandler(status:GeneralStatusVO):void {
			retweet(status, true);
		}

		protected function drawerOpenedForStatusUpdateHandler(text:String):void {
			view.type = null;
			
			if (text)
			{
				view.form.textArea.text = text;
			}
			else
			{
				view.form.textArea.text = "";
			}

			enabled = true;
			view.form.textArea.focus();
		}

		protected function drawerOpenedHandler(state:String):void {
			switch (state) {
				case DrawerState.COMPOSE:
				case DrawerState.COMPOSE_REPLY:
				case DrawerState.COMPOSE_MESSAGE_REPLY:
					view.visible = true;
					view.form.spellCheck.language = PreferenceOptionUtil.getLanguageCode(preferencesController.getPreference(PreferenceType.SPELL_CHECK_LANGUAGE));

					quickFriendLookup = preferencesController.getBoolean(PreferenceType.QUICK_FRIEND_LOOKUP);

					view.form.textArea.textfield.addEventListener(TextEvent.TEXT_INPUT, textAreaPasteHandler);
					view.form.textArea.textfield.addEventListener(KeyboardEvent.KEY_DOWN, submitHandler);
					break;
				default:
					view.visible = false;
			}
		}

		protected function drawerStateChangedHandler(oldState:String, newState:String):void {
			view.visible = (newState == DrawerState.COMPOSE || newState == DrawerState.COMPOSE_REPLY || newState == DrawerState.COMPOSE_MESSAGE_REPLY);

			if (newState != DrawerState.COMPOSE_REPLY && newState != DrawerState.COMPOSE_MESSAGE_REPLY)
				view.data = null;
		}
		
		protected function fileButtonClickHandler(event:MouseEvent):void {
			if (!view.form.fileButton.loading) {
				var point:Point = view.form.fileButton.localToGlobal(new Point(view.form.fileButton.bitmap.width * 0.5 - 1.0, view.form.fileButton.bitmap.height * 0.5 + 7.0));

				contextMenuController.displayFileUploaderMenu(view.stage, point.x, point.y);
			} else {
				view.form.fileButton.loading = false;
				enabled = true;

				composeController.cancelUploadFile();
			}
		}

		protected function fileUploadProgressHandler(event:ProgressEvent):void {
			if (event.bytesLoaded > event.bytesTotal) {
				view.form.fileButton.progressSpinner.progress.text = Math.round(event.bytesLoaded * 0.001) + "kb";
			} else if (event.bytesLoaded < event.bytesTotal) {
				view.form.fileButton.progressSpinner.progress.text = Math.round((event.bytesLoaded / event.bytesTotal) * 100.0) + "% of " + Math.round(event.bytesTotal * 0.001) + "kb";
			} else {
				view.form.fileButton.progressSpinner.progress.text = "Retrieving URL...";
			}
		}

		protected function fileUploadedErrorHandler(code:int, message:String):void {
			view.form.fileButton.loading = false;
			enabled = true;
		}

		protected function fileUploadedHandler(url:String):void {
			view.form.fileButton.loading = false;
			enabled = true;

			selectionBeginIndex = view.form.textArea.textfield.selectionBeginIndex;
			selectionEndIndex = view.form.textArea.textfield.selectionEndIndex;

			view.form.textArea.text = view.form.textArea.text.substring(0.0, view.form.textArea.textfield.selectionBeginIndex) + url + view.form.textArea.text.substring(view.form.textArea.textfield.selectionEndIndex);

			view.form.textArea.focus(selectionBeginIndex + url.length);
		}

		protected function fileUploadingStartedHandler(file:File):void {
			view.form.fileButton.loading = true;
			enabled = false;

			file.addEventListener(ProgressEvent.PROGRESS, fileUploadProgressHandler);
		}

		protected function fontSizeChangedHandler(fontSize:String):void {
			view.form.fontSize = fontSize;
		}

		protected function fontTypeChangedHandler(fontType:String):void {
			view.form.fontType = fontType;
		}

		protected function linkButtonClickHandler(event:MouseEvent):void {
			if (!view.form.linkButton.loading) {
				var point:Point = view.form.linkButton.localToGlobal(new Point(view.form.linkButton.width * 0.5 - 1.0, view.form.linkButton.height * 0.5 + 7.0));

				contextMenuController.displayURLShortenerMenu(view.stage, point.x, point.y);
			} else {
				composeController.cancelShortenURL();
			}
		}

		protected function messageSentErrorHandler(message:String):void {
			alertController.addMessage(AlertSourceType.COMPOSE, message);

			view.form.spinner.displayed = false;
			enabled = true;
			view.form.textArea.focus();
		}

		protected function messageSentHandler(message:DirectMessageVO):void {
			composeController.emptyMessage();
			alertController.addMessage(null, "Your message was sent!");

			view.form.spinner.displayed = false;
			enabled = true;

			view.form.textArea.text = "";

			if (preferencesController.getBoolean(PreferenceType.KEEP_DRAWER_OPEN)) {
				view.form.textArea.focus();
			} else {
				drawerController.close();
			}
		}

		protected function quickFriendLookupDelayHandler(event:TimerEvent):void {
			var bounds:Rectangle = view.form.textArea.textfield.getCharBoundaries(view.form.textArea.textfield.caretIndex - 1);

			if (bounds) {
				bounds.x = Math.min(bounds.x, view.parent.width - 180.0);

				var point:Point = view.form.textArea.textfield.localToGlobal(new Point(bounds.x, bounds.y));

				quickFriendLookupController.display(point.x, point.y, PositionType.ABOVE);
			}
		}

		protected function quickFriendLookupDisplayedChangedHandler(displayed:Boolean):void {
			if (displayed) {
				view.form.textArea.textfield.removeEventListener(KeyboardEvent.KEY_DOWN, submitHandler);
			} else {
				view.stage.focus = view.form.textArea.textfield;

				view.form.textArea.textfield.addEventListener(KeyboardEvent.KEY_DOWN, submitHandler);
			}
		}

		protected function quickFriendLookupScreenNameSelectedHandler(screenName:String):void {
			view.form.textArea.textfield.replaceText(view.form.textArea.textfield.caretIndex, view.form.textArea.textfield.caretIndex, screenName);
			view.form.textArea.focus(view.form.textArea.textfield.caretIndex + screenName.length);
			
			view.form.textArea.textfield.dispatchEvent(new Event(Event.CHANGE));
		}

		protected function restoredHandler(message:String):void {
			view.form.textArea.text = message;
		}

		protected function spinnerClickHandler(event:MouseEvent):void {
			accountModel.currentAccount.twitterController.cancelTweet();

			enabled = true;
			view.form.spinner.displayed = false;
		}

		protected function statusUpdatedHandler(status:StatusVO):void {
			composeController.emptyMessage();
			alertController.addMessage(null, "Your tweet was sent!");

			view.form.spinner.displayed = false;
			enabled = true;

			view.form.textArea.text = "";

			if (preferencesController.getBoolean(PreferenceType.KEEP_DRAWER_OPEN)) {
				if (view.type != ComposeType.STATUS || view.data) {
					view.type = ComposeType.STATUS;
					view.data = null;

					drawerController.updatePosition();
				}

				view.form.textArea.focus();
			} else {
				drawerController.close();
			}
		}
		
		protected function statusUpdatedErrorHandler(message:String):void {
			alertController.addMessage(AlertSourceType.COMPOSE, message);

			view.form.spinner.displayed = false;
			enabled = true;
			view.form.textArea.focus();
		}
		
		protected function retweetedStatusHandler(status:StatusVO):void {
			composeController.emptyMessage();
			alertController.addMessage(null, "Your retweet was sent!");

			view.form.spinner.displayed = false;
			enabled = true;

			view.form.textArea.text = "";

			drawerController.close();
		}
		
		protected function retweetedStatusErrorHandler(message:String):void {
			composeController.emptyMessage();
			alertController.addMessage(AlertSourceType.COMPOSE, message);

			view.form.spinner.displayed = false;
			enabled = true;
			drawerController.close();
		}

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void {
			styleController.applyStatusStyle(view.status);
			styleController.applyTextInputStyle(view.form.textArea);
			styleController.applyTextButtonStyle(view.form.submitButton);
			styleController.applyBitmapButtonStyle(view.form.linkButton);
			styleController.applyBitmapButtonStyle(view.form.fileButton);
			styleController.applyBitmapButtonStyle(view.actionsButton);
			styleController.applyStyle(view.form.fileButton.progressSpinner.progress.textfield, stylesheet.getStyle('.ProgressTextField'));
		}

		protected function submitHandler(event:Event):void {
			if (view.form.submitButton.enabled && ((event is KeyboardEvent && (event as KeyboardEvent).keyCode == Keyboard.ENTER) || event is MouseEvent)) {
				if (event is KeyboardEvent)
					event.preventDefault();

				var isStatusDM:Boolean = view.form.textArea.text.substr(0.0, 2).toLowerCase() == "d " && view.form.textArea.text.indexOf(" ", 2.0) != -1;

				// disabling prior changes type and nulls text
				if (view.type == ComposeType.DIRECT_MESSAGE || view.data is GeneralMessageVO || isStatusDM) {
					var recipient:*;
					var text:String;

					if (isStatusDM) {
						var spaceIndex:int = view.form.textArea.text.indexOf(" ", 2.0);

						recipient = view.form.textArea.text.substring(2.0, spaceIndex);
						text = view.form.textArea.text.substr(spaceIndex + 1);
					} else {
						recipient = (!(view.data is GeneralMessageVO) || view.data.userID != accountModel.currentAccountID) ? view.data.userID : (view.data as GeneralMessageVO).recipientID;
						text = view.form.textArea.text;
					}

					accountModel.currentAccount.twitterController.sendMessage(recipient, text);
				} else if (!view.data || view.data is GeneralStatusVO) {
					accountModel.currentAccount.twitterController.updateStatus(view.form.textArea.textfield.text, (view.data ? view.data.id : null));
				}

				enabled = false;
				view.form.spinner.displayed = true;
			}
		}

		protected function textAreaFocusInHandler(event:FocusEvent):void {
			clipboardController.normalize();
		}

		protected function textAreaPasteHandler(event:TextEvent):void {
			if (preferencesController.getBoolean(PreferenceType.AUTO_SHORTEN_URLS) && event.text.length > 28) {
				TwitterTextUtil.EXACT_URL_REGEX.lastIndex = 0;

				if ((event.text.indexOf("http://") == 0 || event.text.indexOf("https://") == 0) && event.text.indexOf(" ") == -1 || TwitterTextUtil.EXACT_URL_REGEX.test(event.text)) {
					event.preventDefault();

					copiedText = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
					selectionBeginIndex = view.form.textArea.textfield.selectionBeginIndex;
					selectionEndIndex = view.form.textArea.textfield.selectionEndIndex;

					composeController.shortenURL(copiedText);
				}
			}
		}

		protected function textAreaChangeHandler(event:Event):void
		{
			model.message = view.form.textArea.text;
		}
		
		protected function textInputHandler(event:TextEvent):void {
			if (!quickFriendLookup)
				return;

			quickFriendLookupDelay.reset();
			
			var prevText:String = view.form.textArea.text.substr(view.form.textArea.textfield.selectionBeginIndex - 1, 1);

			if ((view.form.textArea.textfield.selectionBeginIndex == 0 || (prevText == " " || prevText == "." || prevText == "," || prevText == "?" || prevText == "!" || prevText == "-" || prevText == "—")) && event.text == "@" || event.text == " " && view.form.textArea.text.toLowerCase() == "d") {
				quickFriendLookupDelay.start();
			}
		}

		protected function urlShortenedErrorHandler(code:int, message:String):void {
			view.form.linkButton.loading = false;
			enabled = true;

			view.form.textArea.text = view.form.textArea.text.substring(0.0, selectionBeginIndex) + copiedText + view.form.textArea.text.substring(selectionEndIndex);
		}

		protected function urlShortenedHandler(originalURL:String, shortenedURL:String):void {
			if (!originalURL || !shortenedURL)
			{
				urlShortenedErrorHandler(-1, null);
				
				return;
			}
			
			alertController.addMessage(null, "Shortened URL: " + originalURL);

			view.form.linkButton.loading = false;
			enabled = true;

			view.form.textArea.text = view.form.textArea.text.substring(0.0, selectionBeginIndex) + shortenedURL + view.form.textArea.text.substring(selectionEndIndex);

			view.form.textArea.focus(selectionBeginIndex + shortenedURL.length);
		}

		protected function urlShorteningStartedHandler():void {
			view.form.linkButton.loading = true;
			enabled = false;
		}

		private function dragEnterHandler(event:NativeDragEvent):void {
			if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				if ((event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array).length == 1) {
					NativeDragManager.acceptDragDrop(view);
				}
			}
		}
	}
}