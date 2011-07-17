package com.destroytoday.destroytwitter.view.navigation
{
	import com.destroytoday.layouts.HorizontalAlignType;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;

	public class StreamNavigationBar extends BaseNavigationBar
	{
		public var homeButton:NavigationTextButton;
		public var mentionsButton:NavigationTextButton;
		public var searchButton:NavigationTextButton;
		public var messagesButton:NavigationTextButton;
		
		public function StreamNavigationBar()
		{
			homeButton = addChild(new NavigationTextButton()) as NavigationTextButton;
			mentionsButton = addChild(new NavigationTextButton()) as NavigationTextButton;
			messagesButton = addChild(new NavigationTextButton()) as NavigationTextButton;
			searchButton = addChild(new NavigationTextButton()) as NavigationTextButton;
			
			homeButton.text = "Home";
			homeButton.name = WorkspaceState.HOME;
			
			mentionsButton.text = "Mentions";
			mentionsButton.name = WorkspaceState.MENTIONS;
			
			messagesButton.text = "Messages";
			messagesButton.name = WorkspaceState.MESSAGES;
			messagesButton.align = HorizontalAlignType.RIGHT;
			
			searchButton.text = "Search";
			searchButton.name = WorkspaceState.SEARCH;
			searchButton.align = HorizontalAlignType.RIGHT;
		}
	}
}