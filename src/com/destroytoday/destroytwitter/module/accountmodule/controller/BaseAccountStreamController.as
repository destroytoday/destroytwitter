package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.StreamState;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.base.BaseAccountActor;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.utils.FilterUtil;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.util.StringUtil;
	
	import flash.data.SQLResult;
	import flash.errors.SQLError;
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;

	public class BaseAccountStreamController extends BaseAccountActor implements IAccountStreamController
	{
		//--------------------------------------------------------------------------
		//
		//  Signal Redirects
		//
		//--------------------------------------------------------------------------

		protected var updateStartedSignal:Signal;

		protected var updatedErrorSignal:Signal;

		protected var updatedSignal:Signal;

		protected var updatedStatusReadListSignal:Signal;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var timer:Timer = new Timer(999);

		protected var _state:String;

		protected var stream:String;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function BaseAccountStreamController(module:AccountModule)
		{
			super(module);

			timer.addEventListener(TimerEvent.TIMER, timerHandler);

			module.signalBus.updatedStatusReadList.add(updatedStatusReadListHandler);
			module.signalBus.deletedStatus.add(statusDeletedHandler);
			module.signalBus.awayModeChanged.add(awayModeChangedHandler);
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function applyFilters(screenNameFilter:*, keywordFilter:*, sourceFilter:*):void
		{
			if (screenNameFilter is Array && keywordFilter is Array && sourceFilter is Array)
			{
				model.screenNameFilter = screenNameFilter;
				model.keywordFilter = keywordFilter;
				model.sourceFilter = sourceFilter;
			}
			else if (screenNameFilter is String && keywordFilter is String && sourceFilter is String)
			{
				model.screenNameFilter = FilterUtil.formatForSQL(screenNameFilter);
				model.keywordFilter = FilterUtil.formatForSQL(keywordFilter);
				model.sourceFilter = FilterUtil.formatForSQL(sourceFilter);
			}
			else
			{
				return;
			}

			var screenNameFilterType:String, keywordFilterType:String, sourceFilterType:String, filterPreference:String;

			switch (stream)
			{
				case StreamType.HOME:
					filterPreference = PreferenceType.HOME_FILTER;
					screenNameFilterType = PreferenceType.HOME_SCREEN_NAME_FILTER;
					keywordFilterType = PreferenceType.HOME_KEYWORD_FILTER;
					sourceFilterType = PreferenceType.HOME_SOURCE_FILTER;
					break;
				case StreamType.MENTIONS:
					filterPreference = PreferenceType.MENTIONS_FILTER;
					screenNameFilterType = PreferenceType.MENTIONS_SCREEN_NAME_FILTER;
					keywordFilterType = PreferenceType.MENTIONS_KEYWORD_FILTER;
					sourceFilterType = PreferenceType.MENTIONS_SOURCE_FILTER;
					break;
				default:
					return;
			}

			module.preferencesController.setString(filterPreference, ToggleType.ENABLED);
			module.preferencesController.setString(screenNameFilterType, model.screenNameFilter.join(', '));
			module.preferencesController.setString(keywordFilterType, model.keywordFilter.join(', '));
			module.preferencesController.setString(sourceFilterType, model.sourceFilter.join(', '));

			getMostRecent();
		}

		public function cancel():void
		{
			updatedSignal.dispatch(module, _state, model.itemList, null);

			if (model.loader)
				model.loader.cancel();

			start();
		}

		public function dispatchUpdatedSignal(newStatusList:Array):void
		{
			updateNumUnread();

			updatedSignal.dispatch(module, _state, model.itemList, newStatusList);
		}

		public function getMostRecent():void
		{
			module.databaseController.getStreamStatuses(module, stream, mostRecentHandler, errorHandler);
		}

		public function getNewer(afterID:String):void
		{
			var count:int = getNumStatusesAfterID(afterID);

			if (count <= model.count)
			{
				model.sinceID = null;

				loadMostRecent();
			}
			else
			{
				getStreamStatusesAfterID(afterID);
			}
		}

		public function getNumUnread():int
		{
			return model.numUnread;
		}

		public function getOlder(beforeID:String):void
		{
			if (timer.running)
				stop();

			getStreamStatusesBeforeID(beforeID);
		}

		public function loadFilters():void
		{
			var screenNameFilterType:String;
			var keywordFilterType:String;
			var sourceFilterType:String;

			switch (stream)
			{
				case StreamType.HOME:
					screenNameFilterType = PreferenceType.HOME_SCREEN_NAME_FILTER;
					keywordFilterType = PreferenceType.HOME_KEYWORD_FILTER;
					sourceFilterType = PreferenceType.HOME_SOURCE_FILTER;
					break;
				case StreamType.MENTIONS:
					screenNameFilterType = PreferenceType.MENTIONS_SCREEN_NAME_FILTER;
					keywordFilterType = PreferenceType.MENTIONS_KEYWORD_FILTER;
					sourceFilterType = PreferenceType.MENTIONS_SOURCE_FILTER;
					break;
				default:
					return;
			}

			model.screenNameFilter = FilterUtil.formatForSQL(module.preferencesController.getPreference(screenNameFilterType));
			model.keywordFilter = FilterUtil.formatForSQL(module.preferencesController.getPreference(keywordFilterType));
			model.sourceFilter = FilterUtil.formatForSQL(module.preferencesController.getPreference(sourceFilterType));
		}

		public function loadMostRecent(refresh:Boolean = false):void
		{
			if (module.streamModel.awayMode && !refresh) module.streamController.disableAwayMode();
			
			if (!refresh)
			{
				model.sinceID = null;
			}
			model.maxID = null;

			if (model.loader)
				model.loader.cancel();

			model.loader = getTimeline(model.newestID, null);

			if (!model.loader)
				return;

			if (!module.streamModel.awayMode) updateStartedSignal.dispatch(module);

			start();
		}

		public function loadOlder():void
		{
			if (module.streamModel.awayMode) module.streamController.disableAwayMode();
			
			model.sinceID = null;
			model.maxID = null;

			if (model.loader)
				model.loader.cancel();

			model.maxID = model.oldestID;
			model.loader = getTimeline(null, model.oldestID);

			updateStartedSignal.dispatch(module);
		}

		public function start():void
		{
			timer.reset();

			if (timer.delay > 0.0)
			{
				timer.start();
			}
		}

		public function get state():String
		{
			return _state;
		}

		public function stop():void
		{
			if (model.loader)
				model.loader.cancel();

			timer.reset();
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

		protected function getNumStatusesAfterID(afterID:String):int
		{
			return module.databaseController.getNumStatusesAfterID(module, stream, afterID);
		}

		protected function getOlderHandler(result:SQLResult):void
		{
			var _statusList:Array = (result) ? result.data : null;

			if (_statusList && _statusList.length > 0)
			{
				model.itemList = _statusList;

				_state = StreamState.OLDER;

				dispatchUpdatedSignal(null);
			}
			else
			{
				loadOlder();
			}
		}

		protected function getStreamStatusesAfterID(afterID:String):void
		{
			module.databaseController.getStreamStatusesAfterID(module, stream, afterID, getNewerHandler, errorHandler);
		}

		protected function getStreamStatusesBeforeID(beforeID:String):void
		{
			module.databaseController.getStreamStatusesBeforeID(module, stream, beforeID, getOlderHandler, errorHandler);
		}

		protected function getTimeline(sinceID:String = null, maxID:String = null):XMLLoader
		{
			switch (stream)
			{
				case StreamType.HOME:
					return module.twitter.getHomeTimeline(module.infoModel.accessToken, sinceID, maxID, 200);
				case StreamType.MENTIONS:
					return module.twitter.getMentionsTimeline(module.infoModel.accessToken, sinceID, maxID, 200);
			}

			return null;
		}

		protected function gotTimelineErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			if (loader == model.loader)
			{
				model.loader = null;

				message = code + " " + type + ": " + message;

				updatedErrorSignal.dispatch(module, message);
			}
		}

		protected function gotTimelineHandler(loader:XMLLoader, statusList:Vector.<StatusVO>):void
		{
			if (loader == model.loader)
			{
				model.loader = null;

				if (statusList.length > 0)
				{
					model.oldestID = StringUtil.min(model.oldestID || statusList[0].id, statusList[statusList.length - 1].id);
					model.newestID = StringUtil.max(model.newestID, statusList[0].id);

					module.databaseController.updateStatusList(module, statusList, stream, -1, updateStatusListCallbackHandler);
				}
				else
				{
					updateStatusListCallbackHandler(null);
				}
			}
		}

		protected function loadOlderHandler(result:SQLResult):void
		{
			model.itemList = (result && result.data) ? result.data : [];

			_state = (model.itemList.length == 0) ? StreamState.OLDEST : StreamState.OLDER;

			dispatchUpdatedSignal(null);
		}

		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------

		protected function get model():BaseAccountStreamModel
		{
			return null;
		}

		protected function mostRecentHandler(result:SQLResult):void
		{
			_state = StreamState.MOST_RECENT;

			model.itemList = (result && result.data) ? result.data : [];

			model.sinceID = model.newestID;

			dispatchUpdatedSignal(null);
		}

		protected function refreshHandler(result:SQLResult):void
		{
			_state = StreamState.REFRESH;

			var _statusList:Array = (result && result.data) ? result.data : [];

			model.itemList.unshift.apply(this, _statusList);

			if (model.itemList.length > model.count)
				model.itemList.length = model.count;

			model.sinceID = model.newestID;

			dispatchUpdatedSignal(_statusList);
		}

		protected function refreshRateChangedHandler(account:AccountModule, rate:Number):void
		{
			if (account == module)
			{
				timer.delay = rate;

				start();
			}
		}

		protected function statusDeletedHandler(id:String):void
		{
			var status:StreamStatusVO;
			
			for each (var item:Object in model.itemList)
			{
				status = item as StreamStatusVO;
				
				if (status && status.id == id)
				{
					model.itemList.splice(model.itemList.indexOf(status), 1);

					dispatchUpdatedSignal(null);

					break;
				}
			}
		}
		
		protected function awayModeChangedHandler(awayMode:Boolean):void
		{
			if (awayMode && model.loader)
			{
				model.loader.cancel();
			}
			else if (!awayMode && (_state == StreamState.MOST_RECENT || _state == StreamState.REFRESH))
			{
				updateStatusListCallbackHandler(null);
			}
		}

		protected function timerHandler(event:TimerEvent):void
		{
			loadMostRecent(true);
		}

		protected function updateNumUnread():void
		{
			var numUnread:int = 0;

			for each (var status:Object in model.itemList)
			{
				if (status is StreamStatusVO && !(status as StreamStatusVO).read)
					++numUnread;
			}

			model.numUnread = numUnread;
		}

		protected function updateStatusListCallbackHandler(resultList:Vector.<SQLResult>):void
		{
			if (module.streamModel.awayMode) return;

			if (model.sinceID)
			{
				module.databaseController.getStreamStatusesSinceID(module, stream, model.sinceID, refreshHandler, errorHandler);
			}
			else if (model.maxID)
			{
				module.databaseController.getStreamStatusesBeforeID(module, stream, model.maxID, loadOlderHandler, errorHandler);
			}
			else
			{
				module.databaseController.getStreamStatuses(module, stream, mostRecentHandler, errorHandler);
			}
		}

		protected function updatedStatusReadListHandler(statusList:Vector.<String>):void
		{
			var status:StreamStatusVO;
			var readCount:int;

			for each (var item:Object in model.itemList)
			{
				status = item as StreamStatusVO;

				if (status && statusList.indexOf(status.id) != -1 && !status.read)
				{
					status.read = true;

					readCount++;
				}
			}

			if (readCount > 0)
			{
				model.numUnread -= readCount;

				updatedStatusReadListSignal.dispatch(readCount);
			}
		}
	}
}