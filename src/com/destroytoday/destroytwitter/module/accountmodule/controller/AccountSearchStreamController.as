package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RefreshRateType;
	import com.destroytoday.destroytwitter.constants.StreamState;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.model.AccountSearchStreamModel;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.vo.SearchStatusVO;
	import com.destroytoday.util.StringUtil;
	
	import flash.data.SQLResult;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class AccountSearchStreamController extends BaseAccountStreamController
	{
		public function AccountSearchStreamController(module:AccountModule)
		{
			stream = StreamType.SEARCH;

			updateStartedSignal = module.signalBus.searchStreamUpdateStarted;
			updatedSignal = module.signalBus.searchStreamUpdated;
			updatedErrorSignal = module.signalBus.searchStreamUpdatedError;
			updatedStatusReadListSignal = module.signalBus.searchStatusReadListUpdated;

			module.signalBus.searchRefreshRateChanged.add(refreshRateChangedHandler);
			module.twitter.gotSearchTimeline.add(gotSearchTimelineHandler);
			module.twitter.gotSearchTimelineError.add(gotTimelineErrorHandler);

			super(module);
		}

		override protected function get model():BaseAccountStreamModel
		{
			return module.searchModel;
		}

		override public function start():void
		{
			if (timer.delay == 999)
				timer.delay = RefreshRateType.valueEnum[module.preferencesController.getPreference(PreferenceType.SEARCH_REFRESH_RATE)];

			super.start();
		}

		override protected function getTimeline(sinceID:String = null, maxID:String = null):XMLLoader
		{
			return ((model as AccountSearchStreamModel).currentKeyword) ? module.twitter.getSearchTimeline(module.infoModel.accessToken, (model as AccountSearchStreamModel).currentKeyword, sinceID, maxID, 200) : null;
		}

		override protected function getStreamStatusesBeforeID(beforeID:String):void
		{
			module.databaseController.getSearchStreamStatusesBeforeID(module, beforeID, getOlderHandler, errorHandler);
		}

		override protected function getStreamStatusesAfterID(afterID:String):void
		{
			module.databaseController.getSearchStreamStatusesAfterID(module, afterID, getNewerHandler, errorHandler);
		}

		override protected function getNumStatusesAfterID(afterID:String):int
		{
			return module.databaseController.getNumSearchStatusesAfterID(module, afterID);
		}

		public function searchKeyword(keyword:String):void
		{
			var model:AccountSearchStreamModel = this.model as AccountSearchStreamModel;

			var index:int = model.keywordList.indexOf(keyword);

			if (index != -1)
			{
				model.keywordList.splice(index, 1);
			}

			if (keyword || model.keywordList.length > 0)
			{
				model.keywordList.unshift(keyword);
			}

			if (model.keywordList.length > 10)
				model.keywordList.length = 10;

			module.preferencesController.setString(PreferenceType.SEARCH_KEYWORD_LIST, model.keywordList.join(','));
			module.databaseController.deleteSearchStatuses(module);

			model.itemList = [];
			model.oldestID = null;
			model.newestID = null;

			module.signalBus.searchKeywordChanged.dispatch(model.currentKeyword);
			updatedSignal.dispatch(module, StreamState.DISABLED, model.itemList, null);

			module.signalBus.searchStreamNumUnreadChanged.dispatch(module, 0, 0);

			if (keyword)
			{
				loadMostRecent();
			}
			else
			{
				model.sinceID = null;
				model.maxID = null;

				if (model.loader)
				{
					model.loader.cancel();

					model.loader = null;
				}
			}
		}

		public function clearHistory():void
		{
			(model as AccountSearchStreamModel).keywordList.length = 0;

			searchKeyword('');
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function gotSearchTimelineHandler(loader:XMLLoader, statusList:Vector.<SearchStatusVO>):void
		{
			if (loader == model.loader)
			{
				model.loader = null;

				if (statusList.length > 0)
				{
					model.oldestID = StringUtil.min(model.oldestID || statusList[0].id, statusList[statusList.length - 1].id);
					model.newestID = StringUtil.max(model.newestID, statusList[0].id);

					module.databaseController.updateSearchStatusList(module, statusList, updateStatusListCallbackHandler);
				}
				else
				{
					updateStatusListCallbackHandler(null);
				}
			}
		}

		override protected function updateStatusListCallbackHandler(resultList:Vector.<SQLResult>):void
		{
			if (module.streamModel.awayMode) return;
			
			if (model.sinceID)
			{
				module.databaseController.getSearchStreamStatusesSinceID(module, model.sinceID, refreshHandler, errorHandler);
			}
			else if (model.maxID)
			{
				module.databaseController.getSearchStreamStatusesBeforeID(module, model.maxID, loadOlderHandler, errorHandler);
			}
			else
			{
				module.databaseController.getSearchStreamStatuses(module, mostRecentHandler, errorHandler);
			}
		}
	}
}