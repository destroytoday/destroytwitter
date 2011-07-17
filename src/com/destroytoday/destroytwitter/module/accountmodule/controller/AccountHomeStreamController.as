package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RefreshRateType;
	import com.destroytoday.destroytwitter.constants.StreamState;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	
	import flash.utils.Timer;

	public class AccountHomeStreamController extends BaseAccountStreamController
	{
		public function AccountHomeStreamController(module:AccountModule)
		{
			stream = StreamType.HOME;
			
			updateStartedSignal = module.signalBus.homeStreamUpdateStarted;
			updatedSignal = module.signalBus.homeStreamUpdated;
			updatedErrorSignal = module.signalBus.homeStreamUpdatedError;
			updatedStatusReadListSignal = module.signalBus.homeStatusReadListUpdated;
			
			module.signalBus.homeRefreshRateChanged.add(refreshRateChangedHandler);
			module.signalBus.statusUpdated.add(tweetUpdatedHandler);
			module.signalBus.retweetedStatus.add(tweetUpdatedHandler);
			
			module.twitter.gotHomeTimeline.add(gotTimelineHandler);
			module.twitter.gotHomeTimelineError.add(gotTimelineErrorHandler);
			
			super(module);
		}
		
		override protected function get model():BaseAccountStreamModel
		{
			return module.homeModel;
		}
		
		override public function start():void
		{
			if (timer.delay == 999) timer.delay = RefreshRateType.valueEnum[module.preferencesController.getPreference(PreferenceType.HOME_REFRESH_RATE)];
		
			super.start();
		}
		
		protected function tweetUpdatedHandler(status:StatusVO):void
		{
			if (module.infoModel.accessToken.id == status.user.id)
			{
				module.databaseController.queueStatusRead(status, false);

				if (module.preferencesController.getBoolean(PreferenceType.REFRESH_HOME_AFTER_TWEETING) && module.infoModel.accessToken.id == status.user.id)
				{
					if (_state == StreamState.MOST_RECENT || _state == StreamState.REFRESH) loadMostRecent(true);
				}
			}
		}
	}
}