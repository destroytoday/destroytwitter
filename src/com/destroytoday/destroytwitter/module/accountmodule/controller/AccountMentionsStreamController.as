package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RefreshRateType;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class AccountMentionsStreamController extends BaseAccountStreamController
	{
		public function AccountMentionsStreamController(module:AccountModule)
		{
			stream = StreamType.MENTIONS;

			updateStartedSignal = module.signalBus.mentionsStreamUpdateStarted;
			updatedSignal = module.signalBus.mentionsStreamUpdated;
			updatedErrorSignal = module.signalBus.mentionsStreamUpdatedError;
			updatedStatusReadListSignal = module.signalBus.mentionsStatusReadListUpdated;
			
			module.signalBus.mentionsRefreshRateChanged.add(refreshRateChangedHandler);
			module.twitter.gotMentionsTimeline.add(gotTimelineHandler);
			module.twitter.gotMentionsTimelineError.add(gotTimelineErrorHandler);
			
			super(module);
		}
		
		override protected function get model():BaseAccountStreamModel
		{
			return module.mentionsModel;
		}
		
		override public function start():void
		{
			if (timer.delay == 999) timer.delay = RefreshRateType.valueEnum[module.preferencesController.getPreference(PreferenceType.MENTIONS_REFRESH_RATE)];
			
			super.start();
		}
	}
}