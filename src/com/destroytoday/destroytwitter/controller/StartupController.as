package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.TwitterElementHeight;
	import com.destroytoday.destroytwitter.controller.stream.HomeStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MentionsStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MessagesStreamController;
	import com.destroytoday.destroytwitter.controller.stream.SearchStreamController;
	import com.destroytoday.destroytwitter.controller.stream.StreamController;
	import com.destroytoday.destroytwitter.model.DatabaseModel;
	import com.destroytoday.destroytwitter.model.StartupModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.components.IconButton;
	import com.destroytoday.destroytwitter.view.notification.NotificationWindow;
	import com.destroytoday.destroytwitter.view.notification.NotificationWindowContent;
	import com.destroytoday.destroytwitter.view.workspace.StreamElement;
	import com.destroytoday.pool.ObjectWaterpark;
	import com.destroytoday.async.AsyncLoop;
	import com.destroytoday.async.AsyncLoopAction;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;

	public class StartupController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var styleController:StyleController;
		
		[Inject]
		public var accountModuleController:AccountModuleController;
		
		[Inject]
		public var analyticsController:AnalyticsController;
		
		[Inject]
		public var applicationController:ApplicationController;
		
		[Inject]
		public var notificationController:NotificationController;

		[Inject]
		public var composeController:ComposeController;
		
		[Inject]
		public var databaseController:DatabaseController;

		[Inject]
		public var debugController:DebugController;

		[Inject]
		public var dialogueController:DialogueController;
		
		[Inject]
		public var framerateController:FramerateController;
		
		[Inject]
		public var generalTwitterController:GeneralTwitterController;
		
		[Inject]
		public var homeStreamController:HomeStreamController;
		
		[Inject]
		public var linkController:LinkController;
		
		[Inject]
		public var mentionsStreamController:MentionsStreamController;
		
		[Inject]
		public var searchStreamController:SearchStreamController;
		
		[Inject]
		public var messagesStreamController:MessagesStreamController;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var profilePanelController:ProfilePanelController;
		
		[Inject]
		public var urlPreviewPanelController:URLPreviewPanelController;
		
		[Inject]
		public var updateController:UpdateController;
		
		[Inject]
		public var userController:UserController;
		
		[Inject]
		public var quickFriendLookupController:QuickFriendLookupController;
		
		[Inject]
		public var streamController:StreamController;
		
		[Inject]
		public var databaseModel:DatabaseModel;
		
		[Inject]
		public var model:StartupModel;
		
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Propeties
		//
		//--------------------------------------------------------------------------
		
		protected var asyncLoop:AsyncLoop;
		
		protected var step:int;
		
		protected var numStreamElements:int;

		protected var numStreamMessageElements:int;
		
		protected var elementPool:Vector.<StreamElement> = new Vector.<StreamElement>();

		protected var iconPool:Vector.<IconButton> = new Vector.<IconButton>();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StartupController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function startup():void
		{
			asyncLoop = new AsyncLoop(processElementPreallocation, -1, 10);
			
			asyncLoop.completed.addOnce(prellocatedElementsHandler);
			
			numStreamMessageElements = int(contextView.stage.stageHeight / TwitterElementHeight.MESSAGE_FONT_SIZE_ELEVEN) + 1;
			numStreamElements = (int(contextView.stage.stageHeight / TwitterElementHeight.STATUS_FONT_SIZE_ELEVEN) + 1) * 2 + numStreamMessageElements; // numStreamCanvases
			
			asyncLoop.start();
		}
		
		protected function processElementPreallocation():String
		{
			if (elementPool.length < numStreamElements)
			{
				if (iconPool.length < numStreamMessageElements)
				{
					iconPool[iconPool.length] = ObjectWaterpark.getObject(IconButton) as IconButton;
				}
				
				var element:StreamElement = elementPool[elementPool.length] = ObjectWaterpark.getObject(StreamElement) as StreamElement;
				
				styleController.applyStreamStatusStyle(element);
				
				return AsyncLoopAction.CONTINUE;
			}
			else
			{
				numStreamMessageElements = 0;
				numStreamElements = 0;
			}
			
			if (elementPool.length > 0)
			{
				if (iconPool.length > 0)
				{
					ObjectWaterpark.disposeObject(iconPool.pop());
				}
				
				ObjectWaterpark.disposeObject(elementPool.pop());
				
				return AsyncLoopAction.CONTINUE;
			}
			
			return AsyncLoopAction.BREAK;
		}
		
		protected function processStartup():String
		{
			switch (step)
			{
				case 0:
					styleController.addListeners();
					break;
				case 1:
					quickFriendLookupController.setup();
					/*Console.init(File.applicationStorageDirectory.nativePath + File.separator + "destroytwitter.log");
					Console.clear();
					Console.traceSuccess = true;
					Console.traceError = true;
					Console.traceCancel = true;
					Console.tracePrint = true;*/
					break;
				case 2:
					framerateController.startThrottling();
					break;
				case 3:
					analyticsController.startTracking();
					break;
				case 4:
					updateController.addListeners();
					break;
				case 5:
					applicationController.setupListeners();
					break;
				case 6:
					preferencesController.setup();
					break;
				case 7:
					linkController.addListeners();
					break;
				case 8:
					debugController.addListeners();
					break;
				case 9:
					model.status = "setting up database";
					databaseController.setupStatements();
					break;
				case 10:
					databaseController.createTables();
					break;
				case 11:
					if (!databaseModel.isReady) step--;
					break;
				case 12:
					accountModuleController.setupListeners();
					userController.setupListeners();
					break;
				case 13:
					homeStreamController.addListeners();
					break;
				case 14:
					notificationController.addListeners();
					break;
				case 15:
					mentionsStreamController.addListeners();
					searchStreamController.addListeners();
					messagesStreamController.addListeners();
					break;
				case 16:
					applicationController.importIconList();
					break;
				case 17:
					composeController.addListeners();
					dialogueController.addListeners();
					break;
				case 18:
					generalTwitterController.addListeners();
					break;
				case 19:
					profilePanelController.addListeners();
					urlPreviewPanelController.addListeners();
					streamController.addListeners();
					break;
				case 20:
					var notificationWindowContent:NotificationWindowContent = new NotificationWindow().content;
					
					mediatorMap.createMediator(notificationWindowContent);
					mediatorMap.createMediator(notificationWindowContent.status);
					break;
				case 21:
					model.status = "importing accounts";
					accountModuleController.importAccounts();
					break;
				case 22:
					accountModuleController.selectLastUsedAccount();
					break;
				default:
					asyncLoop.completed.addOnce(startupCompletedHandler);
					return AsyncLoopAction.BREAK;
			}

			step++;
			
			return AsyncLoopAction.CONTINUE;
		}
		
		protected function prellocatedElementsHandler(loop:AsyncLoop):void
		{
			asyncLoop.callback = processStartup;
			
			asyncLoop.start();
		}
		
		protected function startupCompletedHandler(loop:AsyncLoop):void
		{
			signalBus.startupCompleted.dispatch();
		}
	}
}