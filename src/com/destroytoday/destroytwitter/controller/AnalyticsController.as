package com.destroytoday.destroytwitter.controller {
	import com.destroytoday.destroytwitter.constants.Config;
	import com.destroytoday.destroytwitter.model.WorkspaceModel;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;

	public class AnalyticsController {

		[Inject]
		public var contextView:DisplayObjectContainer;

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var signalBus:ApplicationSignalBus;

		[Inject]
		public var workspaceModel:WorkspaceModel;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var tracker:GATracker;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function AnalyticsController() {
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function startTracking():void {
			if (Config.GOOGLE_ANALYTICS_ACCOUNT)
				tracker = new GATracker(contextView, Config.GOOGLE_ANALYTICS_ACCOUNT, "AS3");

			signalBus.statusUpdated.add(statusUpdatedHandler);
		}

		public function trackAction(category:String, action:String, label:String = null):void {
			if (tracker)
				tracker.trackEvent(category, action, label);
		}

		public function trackPageView(name:String):void {
			if (tracker)
				tracker.trackPageview(name);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function statusUpdatedHandler(status:StatusVO):void {
			trackAction("Tweeting", "Tweet");
		}
	}
}