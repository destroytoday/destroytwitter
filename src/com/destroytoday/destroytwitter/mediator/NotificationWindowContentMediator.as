package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.NotificationPosition;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.StreamState;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DatabaseController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.NotificationController;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.stream.HomeStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MentionsStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MessagesStreamController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.model.vo.IStreamVO;
	import com.destroytoday.destroytwitter.model.vo.StreamMessageVO;
	import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.notification.NotificationWindow;
	import com.destroytoday.destroytwitter.view.notification.NotificationWindowContent;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	public class NotificationWindowContentMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var contextMenuController:ContextMenuController;
		
		[Inject]
		public var notificationController:NotificationController;
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var homeStreamController:HomeStreamController;
		
		[Inject]
		public var mentionsStreamController:MentionsStreamController;

		[Inject]
		public var searchStreamController:MentionsStreamController;
		
		[Inject]
		public var messagesStreamController:MessagesStreamController;
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var view:NotificationWindowContent;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NotificationWindowContentMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		protected function get window():NotificationWindow
		{
			return view.stage.nativeWindow as NotificationWindow;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.addEventListener(MouseEvent.CLICK, clickHandler);
			view.closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
			view.status.actionsGroup.replyButton.addEventListener(MouseEvent.CLICK, statusReplyButtonClickHandler);
			view.status.actionsGroup.actionsButton.addEventListener(MouseEvent.CLICK, statusActionsButtonClickHandler);
			
			signalBus.homeStreamUpdated.add(homeStreamUpdatedHandler);
			signalBus.mentionsStreamUpdated.add(mentionsStreamUpdatedHandler);
			signalBus.searchStreamUpdated.add(searchStreamUpdatedHandler);
			signalBus.messagesStreamUpdated.add(messagesStreamUpdatedHandler);
			
			view.stage.nativeWindow.visible = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Helper Methods
		//
		//--------------------------------------------------------------------------
		
		protected function update(account:AccountModule, stream:String, state:String, statusList:Array, newStatusesList:Array):void
		{
			if (account != accountModel.currentAccount) return;
			
			if (state == StreamState.MOST_RECENT || newStatusesList && newStatusesList.length > 0) 
			{
				var newestID:String;
				var unread:int;
				var status:GeneralTwitterVO;
				
				switch (stream)
				{
					case StreamType.HOME:
						newestID = homeStreamController.getPrevNewestID();
						break;
					case StreamType.MENTIONS:
						newestID = mentionsStreamController.getPrevNewestID();
						break;
					case StreamType.SEARCH:
						newestID = searchStreamController.getPrevNewestID();
						break;
					case StreamType.MESSAGES:
						newestID = messagesStreamController.getPrevNewestID();
						break;
				}
				
				if (stream == StreamType.HOME && preferencesController.getPreference(PreferenceType.HOME_NOTIFICATIONS) == ToggleType.DISABLED ||
					stream == StreamType.MENTIONS && preferencesController.getPreference(PreferenceType.MENTIONS_NOTIFICATIONS) == ToggleType.DISABLED ||
					stream == StreamType.SEARCH && preferencesController.getPreference(PreferenceType.SEARCH_NOTIFICATIONS) == ToggleType.DISABLED ||
					stream == StreamType.MESSAGES && preferencesController.getPreference(PreferenceType.MESSAGES_NOTIFICATIONS) == ToggleType.DISABLED)
					return;

				if (newStatusesList) statusList = newStatusesList;

				var __status:GeneralTwitterVO;
				
				for each (var _status:Object in statusList)
				{
					if (_status is GeneralTwitterVO)
					{
						__status = _status as GeneralTwitterVO;
					}
					else
					{
						continue;
					}
					
					if (__status.id <= newestID || (__status as IStreamVO).read) break;
					
					if (!(__status as IStreamVO).read && __status.userID != account.infoModel.accessToken.id)
					{
						if (!status) status = __status;

						++unread;
					}
				}
				
				switch (stream)
				{
					case StreamType.HOME:
						view.homeStreamNumUnread += unread;
						break;
					case StreamType.MENTIONS:
						view.mentionsStreamNumUnread += unread;
						break;
					case StreamType.SEARCH:
						view.searchStreamNumUnread += unread;
						break;
					case StreamType.MESSAGES:
						view.messagesStreamNumUnread += unread;
						break;
				}
				
				if (unread > 0)
				{
					notificationController.playSound();
					
					view.status.data = status;
					
					window.position = preferencesController.getPreference(PreferenceType.NOTIFICATION_POSITION);
					
					window.displayed = true;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function clickHandler(event:MouseEvent):void
		{
			databaseController.queueStatusRead(view.status.data);
			
			NativeApplication.nativeApplication.activate(contextView.stage.nativeWindow);
			
			window.displayed = false;
		}
		
		protected function closeButtonClickHandler(event:MouseEvent):void
		{
			trace("close");
			event.stopPropagation();
			
			window.displayed = false;
		}
		
		protected function homeStreamUpdatedHandler(account:AccountModule, state:String, statusList:Array, newStatusesList:Array):void
		{
			setTimeout(update, 1000.0, account, StreamType.HOME, state, statusList, newStatusesList);
		}
		
		protected function mentionsStreamUpdatedHandler(account:AccountModule, state:String, statusList:Array, newStatusesList:Array):void
		{
			setTimeout(update, 1000.0, account, StreamType.MENTIONS, state, statusList, newStatusesList);
		}
		
		protected function searchStreamUpdatedHandler(account:AccountModule, state:String, statusList:Array, newStatusesList:Array):void
		{
			setTimeout(update, 1000.0, account, StreamType.SEARCH, state, statusList, newStatusesList);
		}
		
		protected function messagesStreamUpdatedHandler(account:AccountModule, state:String, statusList:Array, newStatusesList:Array):void
		{
			setTimeout(update, 1000.0, account, StreamType.MESSAGES, state, statusList, newStatusesList);
		}
		
		protected function statusReplyButtonClickHandler(event:MouseEvent):void
		{
			if (view.status.data is GeneralStatusVO && event.shiftKey)
			{
				drawerController.openStatusReply(view.status.data as GeneralStatusVO, true);
			}
			else if (view.status.data is GeneralStatusVO)
			{
				drawerController.openStatusReply(view.status.data as GeneralStatusVO);
			}
			else if (view.status.data is GeneralMessageVO)
			{
				drawerController.openMessageReply(view.status.data as GeneralMessageVO);
			}
			
			NativeApplication.nativeApplication.activate(contextView.stage.nativeWindow);
		}

		protected function statusActionsButtonClickHandler(event:MouseEvent):void
		{
			var button:BitmapButton = event.currentTarget as BitmapButton;
			
			var point:Point = button.localToGlobal(new Point(button.width * 0.5 - 1.0, button.height * 0.5 + 7.0));

			if (view.status.data is StreamStatusVO)
			{
				contextMenuController.displayStatusActionsMenu(view.stage, point.x, point.y, view.status.data as StreamStatusVO);
			}
			else if (view.status.data is StreamMessageVO)
			{
				contextMenuController.displayMessageActionsMenu(view.stage, point.x, point.y, view.status.data as StreamMessageVO);
			}
		}

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.NotificationTextField'));
			styleController.applyStyle(view, stylesheet.getStyle('.NotificationWindow'));
			styleController.applyStyle(view.closeButton, stylesheet.getStyle('.BitmapButton'));
		}
	}
}