package com.destroytoday.destroytwitter.controller {
	import com.destroytoday.destroytwitter.constants.LinkLayerType;
	import com.destroytoday.destroytwitter.constants.LinkType;
	import com.destroytoday.destroytwitter.constants.PlatformType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.controller.stream.SearchStreamController;
	import com.destroytoday.destroytwitter.mediator.ImageViewerController;
	import com.destroytoday.destroytwitter.model.ImageServiceModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.util.StringUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;

	public class LinkController {

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var clipboardController:ClipboardController;

		[Inject]
		public var contextView:DisplayObjectContainer;

		[Inject]
		public var drawerController:DrawerController;

		[Inject]
		public var imageServiceModel:ImageServiceModel;

		[Inject]
		public var imageViewerController:ImageViewerController;

		[Inject]
		public var preferencesController:PreferencesController;

		[Inject]
		public var searchController:SearchStreamController;

		[Inject]
		public var signalBus:ApplicationSignalBus;

		[Inject]
		public var workspaceController:WorkspaceController;

		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		static protected var _instance:LinkController;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var isShiftDown:Boolean;
		
		protected var isAltDown:Boolean;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function LinkController() {
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public static function getInstance():LinkController {
			if (!_instance) {
				_instance = new LinkController();
			}
			
			return _instance;
		}
		
		public function addListeners():void {
			contextView.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			contextView.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		public function normalizeLink(url:String):String {
			var eventLength:int = "event:".length;

			if (url.substr(0.0, eventLength) == "event:")
				url = url.substr(eventLength);

			var parameters:Array = url.split(',');
			var type:String = parameters[0];
			var request:URLRequest;
			var url:String;

			switch (type) {
				case LinkType.EXTERNAL:
					parameters.splice(0, 1);

					url = parameters.join(",");

					if (url.substr(0.0, 7.0) != "http://" && url.substr(0.0, 8.0) != "https://" && url.substr(0.0, 6.0) != "ftp://") {
						url = "http://" + url;
					}
					break;
				case LinkType.USER:
					var screenName:String = parameters[1];

					url = "http://twitter.com/" + screenName;
					break;
				case LinkType.DIALOGUE:
					url = "http://twitter.com/" + parameters[3] + "/statuses/" + parameters[4];
					break;
				case LinkType.SEARCH:
				case LinkType.HASHTAG:
					url = "http://search.twitter.com/search?q=" + escape(parameters[1]);
					break;
			}

			return url;
		}

		public function openLink(url:String, isShiftDown:Boolean = false, isAltDown:Boolean = false):void {
			var parameters:Array = url.split(',');
			var type:String = parameters[0];
			var request:URLRequest;
			var url:String;

			switch (type) {
				case LinkType.EXTERNAL:
					parameters.splice(0, 1);
					
					url = parameters.join(",");

					if (url.substr(0.0, 7.0) != "http://" && url.substr(0.0, 8.0) != "https://" && url.substr(0.0, 6.0) != "ftp://") {
						url = "http://" + url;
					}

					if (this.isShiftDown || isShiftDown) {
						clipboardController.copyText(url);

						break;
					}
					else if (this.isAltDown || isAltDown)
					{
						drawerController.openURLPreview(url);
						
						break;
					}

					if (!(preferencesController.getPreference(PreferenceType.IMAGE_PLATFORM) == PlatformType.APPLICATION && openImage(url)))
					{
						request = new URLRequest(url);

						request.requestHeaders = [new URLRequestHeader("Referer", "http://destroytwitter.com")];

						if (preferencesController.getPreference(PreferenceType.LINK_LAYER) == LinkLayerType.BACKGROUND) NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, applicationDeactivateHandler);

						navigateToURL(request);
					}
					break;
				case LinkType.IMAGE:
					url = parameters[1];

					openImage(url);

					break;
				case LinkType.USER:
					var screenName:String = parameters[1];

					openProfile(screenName);

					break;
				case LinkType.DIALOGUE:
					drawerController.openDialogue(parameters[2], parameters[4]);

					break;
				case LinkType.SEARCH:
				case LinkType.HASHTAG:
					workspaceController.setState(WorkspaceState.SEARCH);
					searchController.searchKeyword(parameters[1]);
					/*request = new URLRequest("http://search.twitter.com/search");
					   var params:URLVariables = new URLVariables();

					   params['q'] = parameters[1];
					   request.data = params;

					 navigateToURL(request);*/
					break;
			}
		}

		public function openProfile(screenName:String):void {
			if (preferencesController.getPreference(PreferenceType.USER_PROFILE_PLATFORM) == PlatformType.APPLICATION) {
				drawerController.openProfile(screenName);
			} else {
				navigateToURL(new URLRequest("http://twitter.com/" + screenName));
			}
		}
		
		public function openImage(url:String):Boolean
		{
			var request:URLRequest;
			
			if ((request = imageServiceModel.twitpic.parseGetImageRequest(url)) || (request = imageServiceModel.yfrog.parseGetImageRequest(url)) || (request = imageServiceModel.imgly.parseGetImageRequest(url)) || (request = imageServiceModel.twitgoo.parseGetImageRequest(url)) || (request = imageServiceModel.tweetphoto.parseGetImageRequest(url)) || (request = imageServiceModel.imgur.parseGetImageRequest(url)) || (request = imageServiceModel.pikchur.parseGetImageRequest(url)) || (request = imageServiceModel.generic.parseGetImageRequest(url))) 
			{
				imageViewerController.open(request, url);
				
				return true;
			}
			
			return false;
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function mouseDownHandler(event:MouseEvent):void {
			isShiftDown = event.shiftKey;
			isAltDown = event.altKey;
		}
		
		protected function mouseUpHandler(event:MouseEvent):void {
			isShiftDown = false;
			isAltDown = false;
		}

		protected function applicationDeactivateHandler(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, applicationDeactivateHandler);
			
			NativeApplication.nativeApplication.activate(contextView.stage.nativeWindow);
		}
	}
}