package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvasGroup;

	public class StreamCanvasGroup extends BaseCanvasGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var homeCanvas:HomeCanvas;
		
		public var mentionsCanvas:MentionsCanvas;
		
		public var searchCanvas:SearchCanvas;
	
		public var messagesCanvas:MessagesCanvas;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamCanvasGroup()
		{
			homeCanvas = addChild(new HomeCanvas()) as HomeCanvas;
			mentionsCanvas = addChild(new MentionsCanvas()) as MentionsCanvas;
			searchCanvas = addChild(new SearchCanvas()) as SearchCanvas;
			messagesCanvas = addChild(new MessagesCanvas()) as MessagesCanvas;
			
			_selectedCanvas = homeCanvas;
		}
	}
}