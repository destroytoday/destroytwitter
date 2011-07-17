package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.view.components.Alert;
	import com.destroytoday.destroytwitter.view.dimmer.WorkspaceDimmer;
	import com.destroytoday.destroytwitter.view.drawer.Drawer;
	import com.destroytoday.destroytwitter.view.login.Login;
	import com.destroytoday.destroytwitter.view.navigation.FooterNavigationBar;
	import com.destroytoday.destroytwitter.view.navigation.StreamNavigationBar;
	import com.destroytoday.destroytwitter.view.overlay.ImageViewer;
	import com.destroytoday.destroytwitter.view.overlay.QuickFriendLookup;
	import com.destroytoday.destroytwitter.view.workspace.Workspace;
	
	import flash.events.Event;
	
	public class ApplicationWindowContent extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var quickFriendLookup:QuickFriendLookup;
		
		public var loginGroup:Login;
		
		public var streamNavigationBar:StreamNavigationBar;
		
		public var alert:Alert;
		
		public var imageViewer:ImageViewer;
		
		public var drawer:Drawer;
		
		public var dimmer:WorkspaceDimmer;
		
		public var workspace:Workspace;
		
		public var footerNavigationBar:FooterNavigationBar;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var padding:Number = 9.0;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ApplicationWindowContent()
		{
			super(SingletonManager.getInstance(BasicLayout));

			workspace = addChild(new Workspace()) as Workspace;
			dimmer = addChild(new WorkspaceDimmer()) as WorkspaceDimmer;
			drawer = addChild(new Drawer()) as Drawer;
			imageViewer = addChild(new ImageViewer()) as ImageViewer;
			footerNavigationBar = addChild(new FooterNavigationBar()) as FooterNavigationBar;
			streamNavigationBar = addChild(new StreamNavigationBar()) as StreamNavigationBar;
			loginGroup = addChild(new Login()) as Login;
			alert = addChild(new Alert()) as Alert;
			quickFriendLookup = addChild(new QuickFriendLookup()) as QuickFriendLookup;
			
			alert.width = 324.0;
			drawer.width = 324.0;
			
			imageViewer.includeInLayout = false;
			imageViewer.setConstraints(10.0, 37.0, 10.0, 37.0);
			loginGroup.setConstraints(0.0, 0.0, 0.0, 0.0);
			streamNavigationBar.setConstraints(0.0, 0.0, 0.0, NaN);
			footerNavigationBar.setConstraints(0.0, NaN, 0.0, 0.0);
			drawer.setConstraints(NaN, 27.0, NaN, 27.0);
			dimmer.setConstraints(0.0, 0.0, 0.0, 0.0);
			workspace.setConstraints(0.0, 27.0, 0.0, 27.0); // top = nav bar (25) + spacing (1 + 1) ditto for bottom
			
			x = padding;
			y = 25.0;
		}
		
		override protected function addedToStageHandler(event:Event):void
		{
			super.addedToStageHandler(event);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			
			stageResizeHandler(null);
		}

		protected function stageResizeHandler(event:Event):void
		{
			width = stage.stageWidth - (padding * 2.0);
			height = stage.stageHeight - (50.0 + padding);

			validateNow(); //validateDisplayList();
		}
	}
}