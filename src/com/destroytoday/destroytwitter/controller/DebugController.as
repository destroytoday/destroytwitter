package com.destroytoday.destroytwitter.controller {
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.WorkspaceModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.util.ApplicationUtil;
	import com.destroytoday.util.FileUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;

	public class DebugController {

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var accountModel:AccountModuleModel;

		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var preferencesController:PreferencesController;

		[Inject]
		public var contextView:DisplayObjectContainer;

		[Inject]
		public var workspaceModel:WorkspaceModel;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function DebugController() {
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function addListeners():void {
			contextView.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		
			signalBus.requestedInstallDebugger.add(installDebugger);
			signalBus.requestedUninstallDebugger.add(deleteDebugger);
		}

		public function installDebugger():void
		{
			var path:String = File.applicationDirectory.nativePath + File.separator + "META-INF" + File.separator + "AIR" + File.separator + "debug";
			
			if (!FileUtil.exists(path))
			{
				var installedDebugger:Boolean = true;
				
				try
				{
					FileUtil.save(path, "");
				}
				catch (error:*)
				{
					installedDebugger = false;
				}
				
				if (installedDebugger)
				{
					alertController.addMessage(null, "The debugger has been installed. Please restart. (The debugger must be installed with each update, so don't be alarmed if you see this again)", -1);
				}
				else
				{
					alertController.addMessage(null, "The debugger cannot be installed on your machine.");
					
					preferencesController.setString(PreferenceType.DEBUG_MODE, ToggleType.DISABLED);
				}
			}
		}
		
		public function deleteDebugger():void
		{
			var path:String = File.applicationDirectory.nativePath + File.separator + "META-INF" + File.separator + "AIR" + File.separator + "debug";
			
			if (FileUtil.exists(path))
			{
				FileUtil.trash(path);
			
				alertController.addMessage(null, "The debugger has been uninstalled. Please restart.", -1);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function uncaughtErrorHandler(event:UncaughtErrorEvent):void {
			var message:String;

			alertController.addMessage(null, "A runtime error occurred. You don't have to restart, but you might want to in order to avoid unusual activity. Also, to help debug the issue, you could turn on Debug Mode in Preferences.");

			if (event.error is Error) {
				var error:Error = event.error as Error;

				message = error.name + ", " + error.message + "\n" + error.getStackTrace();
			} else if (event.error is ErrorEvent) {
				var errorEvent:ErrorEvent = event.error as ErrorEvent;

				message = errorEvent.errorID + ", " + errorEvent.text;
			} else {
				message = event.error;
			}

			if (preferencesController.getBoolean(PreferenceType.DEBUG_MODE))
			{
				var request:URLRequest = new URLRequest("http://destroytwitter.com/rte.php");
				var data:URLVariables = new URLVariables();
	
				data['i'] = accountModel.currentAccount.infoModel.accessToken.id;
				data['sn'] = accountModel.currentAccount.infoModel.accessToken.screenName;
				data['m'] = "DestroyTwitter " + ApplicationUtil.version + "\n" + Capabilities.os + " / " + Capabilities.version + "\n" + workspaceModel.state + "\n\n" + event.errorID + " " + message;
	
				request.method = URLRequestMethod.POST;
				request.data = data;
	
				var loader:StringLoader = new StringLoader();
				
				loader.request = request;
				
				loader.load();
			}
		}
	}
}