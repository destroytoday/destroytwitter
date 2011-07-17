package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RefreshRateType;
	import com.destroytoday.destroytwitter.constants.StreamState;
	import com.destroytoday.destroytwitter.model.vo.IStreamVO;
	import com.destroytoday.destroytwitter.model.vo.StreamMessageVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.base.BaseAccountActor;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountMessagesStreamModel;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.util.StringUtil;
	
	import flash.data.SQLResult;
	import flash.errors.SQLError;
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.Timer;

	public class AccountMessagesStreamController extends BaseAccountActor implements IAccountStreamController
	{

		protected var _state:String;

		protected var step:int;

		protected var stream:String;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var timer:Timer = new Timer(999);

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function AccountMessagesStreamController(module:AccountModule)
		{
			super(module);

			timer.addEventListener(TimerEvent.TIMER, timerHandler);

			module.signalBus.messagesRefreshRateChanged.add(refreshRateChangedHandler);
			module.signalBus.deletedMessage.add(messageDeletedHandler);
			module.twitter.gotIncomingMessagesTimeline.add(gotTimelineHandler);
			module.twitter.gotIncomingMessagesTimelineError.add(gotTimelineErrorHandler);
			module.twitter.gotOutgoingMessagesTimeline.add(gotTimelineHandler);
			module.twitter.gotOutgoingMessagesTimelineError.add(gotTimelineErrorHandler);

			module.signalBus.messageSent.add(messageSentHandler);
			module.signalBus.awayModeChanged.add(awayModeChangedHandler);
		}

		public function cancel():void
		{
			module.signalBus.messagesStreamUpdated.dispatch(module, _state, model.itemList, null);

			_cancel();

			start();
		}

		public function dispatchUpdatedSignal(newMessageList:Array):void
		{
			updateNumUnread();

			module.signalBus.messagesStreamUpdated.dispatch(module, _state, model.itemList, newMessageList);
		}

		public function getMostRecent():void
		{
			module.databaseController.getStreamMessages(module, mostRecentHandler, errorHandler);
		}

		public function getNewer(afterID:String):void
		{
			var count:int = module.databaseController.getNumMessagesAfterID(module, afterID);

			if (count <= model.count)
			{
				model.sinceInboxID = null;

				loadMostRecent();
			}
			else
			{
				module.databaseController.getStreamMessagesAfterID(module, afterID, afterID, getNewerHandler, errorHandler);
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function getNumUnread():int
		{
			return model.numUnread;
		}

		public function getOlder(beforeID:String):void
		{
			if (timer.running)
				stop();

			module.databaseController.getStreamMessagesBeforeID(module, beforeID, beforeID, getOlderHandler, errorHandler);
		}

		public function loadMostRecent(refresh:Boolean = false):void
		{
			if (module.streamModel.awayMode && !refresh) module.streamController.disableAwayMode();
			
			step = 0;

			if (!refresh)
			{
				model.sinceInboxID = null;
				model.sinceSentID = null;
			}

			model.maxInboxID = null;
			model.maxSentID = null;

			_cancel();
			
			model.inboxLoader = module.twitter.getIncomingMessagesTimeline(module.infoModel.accessToken, model.newestInboxID, null, 200);
			model.sentLoader = module.twitter.getOutgoingMessagesTimeline(module.infoModel.accessToken, model.newestSentID, null, 200);

			if (!module.streamModel.awayMode) module.signalBus.messagesStreamUpdateStarted.dispatch(module);

			start();
		}

		public function loadOlder():void
		{
			if (module.streamModel.awayMode) module.streamController.disableAwayMode();
			
			step = 0;

			model.sinceInboxID = null;
			model.maxInboxID = null;
			model.sinceSentID = null;
			model.maxSentID = null;

			_cancel();

			model.maxInboxID = model.oldestInboxID;
			model.maxSentID = model.oldestSentID;

			model.inboxLoader = module.twitter.getIncomingMessagesTimeline(module.infoModel.accessToken, null, model.oldestInboxID, 200);
			model.sentLoader = module.twitter.getOutgoingMessagesTimeline(module.infoModel.accessToken, null, model.oldestSentID, 200);

			module.signalBus.messagesStreamUpdateStarted.dispatch(module);
		}

		public function get model():AccountMessagesStreamModel
		{
			return module.messagesModel;
		}

		public function start():void
		{
			if (timer.delay == 999)
				timer.delay = RefreshRateType.valueEnum[module.preferencesController.getPreference(PreferenceType.MESSAGES_REFRESH_RATE)];

			timer.reset();

			if (timer.delay > 0.0)
			{
				timer.start();
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------

		public function get state():String
		{
			return _state;
		}

		public function stop():void
		{
			_cancel();

			timer.reset();
		}

		protected function _cancel():void
		{
			if (model.inboxLoader)
				model.inboxLoader.cancel();
			if (model.sentLoader)
				model.sentLoader.cancel();
		}

		protected function errorHandler(error:SQLError):void
		{
			trace(String(error));
		}

		protected function getNewerHandler(result:SQLResult):void
		{
			model.itemList = (result && result.data) ? result.data : [];

			_state = StreamState.OLDER;

			dispatchUpdatedSignal(null);
		}

		protected function getOlderHandler(result:SQLResult):void
		{
			var _messageList:Array = (result) ? result.data : null;

			if (_messageList && _messageList.length > 0)
			{
				model.itemList = _messageList;

				_state = StreamState.OLDER;

				dispatchUpdatedSignal(null);
			}
			else
			{
				loadOlder();
			}
		}

		protected function gotTimelineErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			if (loader == model.inboxLoader)
			{
				model.inboxLoader = null;

				message = code + " " + type + ": " + message;
trace(loader.data);
				trace("gotTimelineErrorHandler : " + message);

				module.signalBus.messagesStreamUpdatedError.dispatch(module, message);
			}
		}

		protected function gotTimelineHandler(loader:XMLLoader, messageList:Vector.<DirectMessageVO>):void
		{
			if (loader == model.inboxLoader || loader == model.sentLoader)
			{
				if (loader == model.inboxLoader)
				{
					model.inboxLoader = null;

					if (messageList.length > 0)
					{
						model.newestInboxID = StringUtil.max(model.newestInboxID, messageList[0].id);
						model.oldestInboxID = StringUtil.min(model.oldestInboxID, messageList[messageList.length - 1].id);

						module.databaseController.updateMessageList(module, messageList, updateMessageListCallbackHandler);
					}
					else
					{
						updateMessageListCallbackHandler(null);
					}
				}
				else if (loader == model.sentLoader)
				{
					model.sentLoader = null;

					if (messageList.length > 0)
					{
						model.newestSentID = StringUtil.max(model.newestSentID, messageList[0].id);
						model.oldestSentID = StringUtil.min(model.oldestSentID, messageList[messageList.length - 1].id);

						module.databaseController.updateMessageList(module, messageList, updateMessageListCallbackHandler);
					}
					else
					{
						updateMessageListCallbackHandler(null);
					}
				}
			}
		}

		protected function loadOlderHandler(result:SQLResult):void
		{
			model.itemList = (result && result.data) ? result.data : [];

			_state = (model.itemList.length == 0) ? StreamState.OLDEST : StreamState.OLDER;

			dispatchUpdatedSignal(null);
		}

		protected function messageDeletedHandler(id:String):void
		{
			for each (var message:StreamMessageVO in model.itemList)
			{
				if (message.id == id)
				{
					model.itemList.splice(model.itemList.indexOf(message), 1);

					dispatchUpdatedSignal(null);

					break;
				}
			}
		}

		protected function messageSentHandler(message:DirectMessageVO):void
		{
			if (module.infoModel.accessToken.id == message.sender.id)
			{
				if (_state == StreamState.MOST_RECENT || _state == StreamState.REFRESH)
					loadMostRecent(true);
			}
		}
		
		protected function awayModeChangedHandler(awayMode:Boolean):void
		{
			if (awayMode)
			{
				if (model.inboxLoader) model.inboxLoader.cancel();
				if (model.sentLoader) model.sentLoader.cancel();
			}
			else if (!awayMode && (_state == StreamState.MOST_RECENT || _state == StreamState.REFRESH))
			{
				updateMessageListCallbackHandler(null);
			}
		}

		protected function mostRecentHandler(result:SQLResult):void
		{
			_state = StreamState.MOST_RECENT;

			model.itemList = (result && result.data) ? result.data : [];
			model.sinceInboxID = model.newestInboxID;
			model.sinceSentID = model.newestSentID;

			dispatchUpdatedSignal(null);
		}

		protected function processMessageList():void
		{
			if (module.streamModel.awayMode) return;
			
			if (model.sinceInboxID)
			{
				module.databaseController.getStreamMessagesSinceID(module, model.sinceInboxID, model.sinceSentID, refreshHandler, errorHandler);
			}
			else if (model.maxInboxID)
			{
				module.databaseController.getStreamMessagesBeforeID(module, model.maxInboxID, model.maxSentID, loadOlderHandler, errorHandler);
			}
			else
			{
				module.databaseController.getStreamMessages(module, mostRecentHandler, errorHandler);
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function refreshHandler(result:SQLResult):void
		{
			_state = StreamState.REFRESH;

			var _messageList:Array = (result && result.data) ? result.data : [];

			model.itemList.unshift.apply(this, _messageList);

			if (model.itemList.length > model.count)
				model.itemList.length = model.count;

			model.sinceInboxID = model.newestInboxID;
			model.sinceSentID = model.newestSentID;

			dispatchUpdatedSignal(_messageList);
		}

		protected function refreshRateChangedHandler(account:AccountModule, rate:Number):void
		{
			if (account == module)
			{
				timer.delay = rate;

				start();
			}
		}

		protected function timerHandler(event:TimerEvent):void
		{
			loadMostRecent(true);
		}

		protected function updateMessageListCallbackHandler(resultList:Vector.<SQLResult>):void
		{
			if (step == 0)
			{
				++step;
			}
			else
			{
				processMessageList();

				step = 0;
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Helper Methods
		//
		//--------------------------------------------------------------------------

		protected function updateNumUnread():void
		{
			var numUnread:int = 0;

			for each (var message:IStreamVO in model.itemList)
			{
				if (!message.read)
					++numUnread;
			}

			model.numUnread = numUnread;
		}
	}
}