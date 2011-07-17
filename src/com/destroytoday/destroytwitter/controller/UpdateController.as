package com.destroytoday.destroytwitter.controller {
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import com.destroytoday.destroytwitter.constants.Config;
	import com.destroytoday.destroytwitter.model.UpdateModel;
	import com.destroytoday.destroytwitter.model.vo.UpdateVO;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.util.ApplicationUtil;
	
	import flash.events.ErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class UpdateController {

		[Inject]
		public var analyticsController:AnalyticsController;

		[Inject]
		public var model:UpdateModel;

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var signalBus:ApplicationSignalBus;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var timer:Timer = new Timer(3600000.0);

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function UpdateController() {

		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function addListeners():void {
			model.updater.updateURL = Config.UPDATE_URL;
			model.updater.isNewerVersionFunction = isNewerVersion;

			signalBus.startupCompleted.add(startupCompletedHandler);

			model.updater.addEventListener(UpdateEvent.INITIALIZED, initializedHandler);
			model.updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, updateStatusHandler, false, 1);

			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}

		public function check():void {
			model.updater.cancelUpdate();
			model.updater.checkNow();

			timer.reset();
			timer.start();
		}

		public function download():void {
			model.updater.downloadUpdate();
		}

		protected function initializedHandler(event:UpdateEvent):void {
			if (model.cache.data['firstRun'] == null) {
				model.cache.data['firstRun'] = false;

				analyticsController.trackAction("Application", "Install", Capabilities.os);
			}

			if (model.updater.isFirstRun) {
				analyticsController.trackAction("Application", "Update", model.updater.previousVersion + " to " + model.updater.currentVersion);
			}

			model.updater.checkNow();
		}

		protected function isNewerVersion(older:String, newer:String):Boolean //TODO - write unit test
		{
			var ns:Namespace = model.updater.updateDescriptor.namespace();
			
			older = ApplicationUtil.version;
			newer = model.updater.updateDescriptor.ns::versionLabel;

			var olderList:Array = older.split('p');
			var newerList:Array = newer.split('p');
			
			older = olderList[0];
			newer = newerList[0];
			
			var olderSuffix:Number = (olderList.length > 1) ? Number(olderList[1]) : 0.0;
			var newerSuffix:Number = (newerList.length > 1) ? Number(newerList[1]) : 0.0;
			
			if (older.indexOf('b') == -1 && older.indexOf('r') == -1 && older.indexOf('c') == -1) older = older + "000";
			if (newer.indexOf('b') == -1 && newer.indexOf('r') == -1 && newer.indexOf('c') == -1) newer = newer + "000";
			
			older = older.replace(/[\.a]/g, '');
			older = older.replace(/[brc]/g, '0');

			newer = newer.replace(/[\.a]/g, '');
			newer = newer.replace(/[brc]/g, '0');
			
			var olderVersion:Number = Number(older);
			var newerVersion:Number = Number(newer);

			if (olderSuffix) olderVersion = olderVersion - 1000.0 + olderSuffix;
			if (newerSuffix) newerVersion = newerVersion - 1000.0 + newerSuffix;

			return newerVersion > olderVersion;
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function startupCompletedHandler():void {
			setTimeout(model.updater.initialize, 2000.0);
		}

		protected function timerHandler(event:TimerEvent):void {
			check();
		}

		protected function updateStatusHandler(event:StatusUpdateEvent):void {
			event.preventDefault();

			if (event.available) {
				var data:UpdateVO = new UpdateVO();

				data.versionFrom = ApplicationUtil.version;
				data.versionTo = event.version;
				data.summary = event.details[0][1];

				model.data = data;
			} else {
				timer.reset();
				timer.start();
			}
		}
	}
}
