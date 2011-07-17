package com.destroytoday.destroytwitter.context 
{
	import asx.array.inject;
	
	import com.destroytoday.destroytwitter.commands.BootstrapCommand;
	import com.destroytoday.destroytwitter.constants.Config;
	import com.destroytoday.destroytwitter.controller.AccountModuleController;
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.controller.AnalyticsController;
	import com.destroytoday.destroytwitter.controller.ApplicationController;
	import com.destroytoday.destroytwitter.controller.CacheController;
	import com.destroytoday.destroytwitter.controller.ClipboardController;
	import com.destroytoday.destroytwitter.controller.ComposeController;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DatabaseController;
	import com.destroytoday.destroytwitter.controller.DebugController;
	import com.destroytoday.destroytwitter.controller.DialogueController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.FilterController;
	import com.destroytoday.destroytwitter.controller.FramerateController;
	import com.destroytoday.destroytwitter.controller.GeneralTwitterController;
	import com.destroytoday.destroytwitter.controller.HotkeyController;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.controller.NotificationController;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.ProfilePanelController;
	import com.destroytoday.destroytwitter.controller.QuickFriendLookupController;
	import com.destroytoday.destroytwitter.controller.StartupController;
	import com.destroytoday.destroytwitter.controller.StyleController;
	import com.destroytoday.destroytwitter.controller.URLPreviewPanelController;
	import com.destroytoday.destroytwitter.controller.UpdateController;
	import com.destroytoday.destroytwitter.controller.UserController;
	import com.destroytoday.destroytwitter.controller.WorkspaceController;
	import com.destroytoday.destroytwitter.controller.stream.HomeStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MentionsStreamController;
	import com.destroytoday.destroytwitter.controller.stream.MessagesStreamController;
	import com.destroytoday.destroytwitter.controller.stream.SearchStreamController;
	import com.destroytoday.destroytwitter.controller.stream.StreamController;
	import com.destroytoday.destroytwitter.mediator.AlertMediator;
	import com.destroytoday.destroytwitter.mediator.ApplicationWindowChromeMediator;
	import com.destroytoday.destroytwitter.mediator.ApplicationWindowContentMediator;
	import com.destroytoday.destroytwitter.mediator.ApplicationWindowTrayMediator;
	import com.destroytoday.destroytwitter.mediator.BaseCanvasGroupMediator;
	import com.destroytoday.destroytwitter.mediator.ComposeMediator;
	import com.destroytoday.destroytwitter.mediator.DialogueElementMediator;
	import com.destroytoday.destroytwitter.mediator.DialogueMediator;
	import com.destroytoday.destroytwitter.mediator.DrawerMediator;
	import com.destroytoday.destroytwitter.mediator.FilterMediator;
	import com.destroytoday.destroytwitter.mediator.FindMediator;
	import com.destroytoday.destroytwitter.mediator.FooterNavigationBarMediator;
	import com.destroytoday.destroytwitter.mediator.HomeCanvasMediator;
	import com.destroytoday.destroytwitter.mediator.ImageViewerController;
	import com.destroytoday.destroytwitter.mediator.ImageViewerMediator;
	import com.destroytoday.destroytwitter.mediator.InfoCanvasGroupMediator;
	import com.destroytoday.destroytwitter.mediator.LoginMediator;
	import com.destroytoday.destroytwitter.mediator.MentionsCanvasMediator;
	import com.destroytoday.destroytwitter.mediator.MessagesCanvasMediator;
	import com.destroytoday.destroytwitter.mediator.NotificationWindowContentMediator;
	import com.destroytoday.destroytwitter.mediator.PreferencesCanvasMediator;
	import com.destroytoday.destroytwitter.mediator.ProfilePanelMediator;
	import com.destroytoday.destroytwitter.mediator.QuickFriendLookupMediator;
	import com.destroytoday.destroytwitter.mediator.SearchCanvasMediator;
	import com.destroytoday.destroytwitter.mediator.SpinnerMediator;
	import com.destroytoday.destroytwitter.mediator.StreamNavigationBarMediator;
	import com.destroytoday.destroytwitter.mediator.TwitterElementMediator;
	import com.destroytoday.destroytwitter.mediator.URLPreviewPanelMediator;
	import com.destroytoday.destroytwitter.mediator.UpdatePanelMediator;
	import com.destroytoday.destroytwitter.mediator.WorkspaceDimmerMediator;
	import com.destroytoday.destroytwitter.mediator.WorkspaceMediator;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.AlertModel;
	import com.destroytoday.destroytwitter.model.ApplicationModel;
	import com.destroytoday.destroytwitter.model.CacheModel;
	import com.destroytoday.destroytwitter.model.ComposeModel;
	import com.destroytoday.destroytwitter.model.ConfigModel;
	import com.destroytoday.destroytwitter.model.ContextMenuModel;
	import com.destroytoday.destroytwitter.model.DatabaseModel;
	import com.destroytoday.destroytwitter.model.DialogueModel;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.model.GeneralTwitterModel;
	import com.destroytoday.destroytwitter.model.ImageServiceModel;
	import com.destroytoday.destroytwitter.model.ImageViewerModel;
	import com.destroytoday.destroytwitter.model.NotificationModel;
	import com.destroytoday.destroytwitter.model.PreferencesModel;
	import com.destroytoday.destroytwitter.model.ProfilePanelModel;
	import com.destroytoday.destroytwitter.model.QuickFriendLookupModel;
	import com.destroytoday.destroytwitter.model.StartupModel;
	import com.destroytoday.destroytwitter.model.StreamModel;
	import com.destroytoday.destroytwitter.model.StyleModel;
	import com.destroytoday.destroytwitter.model.URLPreviewPanelModel;
	import com.destroytoday.destroytwitter.model.UpdateModel;
	import com.destroytoday.destroytwitter.model.UserModel;
	import com.destroytoday.destroytwitter.model.WorkspaceModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.signals.BootstrapSignal;
	import com.destroytoday.destroytwitter.view.components.Alert;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.destroytwitter.view.dimmer.WorkspaceDimmer;
	import com.destroytoday.destroytwitter.view.drawer.Compose;
	import com.destroytoday.destroytwitter.view.drawer.Dialogue;
	import com.destroytoday.destroytwitter.view.drawer.DialogueElement;
	import com.destroytoday.destroytwitter.view.drawer.Drawer;
	import com.destroytoday.destroytwitter.view.drawer.Filter;
	import com.destroytoday.destroytwitter.view.drawer.Find;
	import com.destroytoday.destroytwitter.view.drawer.ProfilePanel;
	import com.destroytoday.destroytwitter.view.drawer.URLPreviewPanel;
	import com.destroytoday.destroytwitter.view.drawer.UpdatePanel;
	import com.destroytoday.destroytwitter.view.login.Login;
	import com.destroytoday.destroytwitter.view.navigation.FooterNavigationBar;
	import com.destroytoday.destroytwitter.view.navigation.StreamNavigationBar;
	import com.destroytoday.destroytwitter.view.notification.NotificationWindowContent;
	import com.destroytoday.destroytwitter.view.overlay.ImageViewer;
	import com.destroytoday.destroytwitter.view.overlay.QuickFriendLookup;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowChrome;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowContent;
	import com.destroytoday.destroytwitter.view.window.ApplicationWindowTray;
	import com.destroytoday.destroytwitter.view.workspace.HomeCanvas;
	import com.destroytoday.destroytwitter.view.workspace.InfoCanvasGroup;
	import com.destroytoday.destroytwitter.view.workspace.MentionsCanvas;
	import com.destroytoday.destroytwitter.view.workspace.MessagesCanvas;
	import com.destroytoday.destroytwitter.view.workspace.PreferencesCanvas;
	import com.destroytoday.destroytwitter.view.workspace.SearchCanvas;
	import com.destroytoday.destroytwitter.view.workspace.StreamCanvasGroup;
	import com.destroytoday.destroytwitter.view.workspace.TwitterElement;
	import com.destroytoday.destroytwitter.view.workspace.Workspace;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class ApplicationContext extends SignalContext 
	{
		public function ApplicationContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true) 
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void 
		{
			var twitter:TwitterAspirin = new TwitterAspirin(Config.CONSUMER_KEY, Config.CONSUMER_SECRET);
			
			injector.mapValue(TwitterAspirin, twitter);
			
			injector.mapSingleton(ApplicationSignalBus);

			injector.mapSingleton(StyleController);
			injector.mapValue(CacheController, CacheController.getInstance());
			injector.mapSingleton(StartupController);
			injector.mapSingleton(UpdateController);
			injector.mapSingleton(AnalyticsController);
			injector.mapSingleton(ClipboardController);
			injector.mapValue(FramerateController, FramerateController.getInstance());
			injector.mapValue(LinkController, LinkController.getInstance());
			injector.mapSingleton(DatabaseController);
			injector.mapSingleton(ApplicationController);
			injector.mapSingleton(DebugController);
			injector.mapSingleton(PreferencesController);
			injector.mapSingleton(AccountModuleController);
			injector.mapSingleton(ContextMenuController);
			injector.mapSingleton(GeneralTwitterController);
			injector.mapSingleton(QuickFriendLookupController);
			injector.mapSingleton(ImageViewerController);
			injector.mapSingleton(AlertController);
			injector.mapSingleton(DrawerController);
			injector.mapSingleton(WorkspaceController);
			injector.mapSingleton(ComposeController);
			injector.mapSingleton(HomeStreamController);
			injector.mapSingleton(MentionsStreamController);
			injector.mapSingleton(SearchStreamController);
			injector.mapSingleton(MessagesStreamController);
			injector.mapSingleton(UserController);
			injector.mapSingleton(DialogueController);
			injector.mapSingleton(ProfilePanelController);
			injector.mapSingleton(FilterController);
			injector.mapSingleton(NotificationController);
			injector.mapSingleton(URLPreviewPanelController);
			injector.mapSingleton(StreamController);
			
			injector.mapSingleton(StyleModel);
			injector.mapSingleton(CacheModel);
			injector.mapSingleton(ConfigModel);
			injector.mapSingleton(ApplicationModel);
			injector.mapSingleton(UpdateModel);
			injector.mapSingleton(PreferencesModel);
			injector.mapSingleton(DatabaseModel);
			injector.mapSingleton(AccountModuleModel);
			injector.mapSingleton(ContextMenuModel);
			injector.mapSingleton(GeneralTwitterModel);
			injector.mapSingleton(AlertModel);
			injector.mapSingleton(DrawerModel);
			injector.mapSingleton(WorkspaceModel);
			injector.mapSingleton(UserModel);
			injector.mapSingleton(ImageServiceModel);
			injector.mapSingleton(ImageViewerModel);
			injector.mapSingleton(DialogueModel);
			injector.mapSingleton(ProfilePanelModel);
			injector.mapSingleton(NotificationModel);
			injector.mapSingleton(ComposeModel);
			injector.mapSingleton(QuickFriendLookupModel);
			injector.mapSingleton(URLPreviewPanelModel);
			injector.mapSingleton(StreamModel);
			injector.mapSingleton(StartupModel);
			
			var hotkeyController:HotkeyController = injector.instantiate(HotkeyController);
			
			hotkeyController.setup();
			mediatorMap.mapView(ApplicationWindowTray, ApplicationWindowTrayMediator);
			mediatorMap.mapView(ApplicationWindowChrome, ApplicationWindowChromeMediator);
			mediatorMap.mapView(ApplicationWindowContent, ApplicationWindowContentMediator);
			mediatorMap.mapView(QuickFriendLookup, QuickFriendLookupMediator);
			mediatorMap.mapView(Login, LoginMediator);
			mediatorMap.mapView(StreamNavigationBar, StreamNavigationBarMediator);
			mediatorMap.mapView(FooterNavigationBar, FooterNavigationBarMediator);
			mediatorMap.mapView(Alert, AlertMediator);
			mediatorMap.mapView(ImageViewer, ImageViewerMediator);
			mediatorMap.mapView(WorkspaceDimmer, WorkspaceDimmerMediator);
			mediatorMap.mapView(Drawer, DrawerMediator);
			mediatorMap.mapView(Compose, ComposeMediator);
			mediatorMap.mapView(Dialogue, DialogueMediator);
			mediatorMap.mapView(Workspace, WorkspaceMediator);
			mediatorMap.mapView(InfoCanvasGroup, BaseCanvasGroupMediator);
			mediatorMap.mapView(StreamCanvasGroup, BaseCanvasGroupMediator);
			mediatorMap.mapView(HomeCanvas, HomeCanvasMediator);
			mediatorMap.mapView(MentionsCanvas, MentionsCanvasMediator);
			mediatorMap.mapView(SearchCanvas, SearchCanvasMediator);
			mediatorMap.mapView(MessagesCanvas, MessagesCanvasMediator);
			mediatorMap.mapView(PreferencesCanvas, PreferencesCanvasMediator);
			mediatorMap.mapView(NotificationWindowContent, NotificationWindowContentMediator);
			mediatorMap.mapView(TwitterElement, TwitterElementMediator);
			mediatorMap.mapView(Filter, FilterMediator);
			mediatorMap.mapView(Find, FindMediator);
			mediatorMap.mapView(ProfilePanel, ProfilePanelMediator);
			mediatorMap.mapView(URLPreviewPanel, URLPreviewPanelMediator);
			mediatorMap.mapView(UpdatePanel, UpdatePanelMediator);
			mediatorMap.mapView(DialogueElement, DialogueElementMediator);
			mediatorMap.mapView(Spinner, SpinnerMediator);
			
			injector.injectInto(LinkController.getInstance());
			injector.injectInto(CacheController.getInstance());
			injector.injectInto(FramerateController.getInstance());
			
			(injector.instantiate(BootstrapCommand) as BootstrapCommand).execute();
		}
	}
}