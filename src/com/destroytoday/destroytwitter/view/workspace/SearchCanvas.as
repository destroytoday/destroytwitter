package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseStreamCanvas;
	import com.destroytoday.destroytwitter.view.workspace.components.SearchTextInput;
	
	import flash.events.FocusEvent;

	public class SearchCanvas extends BaseStreamCanvas
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var input:SearchTextInput;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SearchCanvas()
		{
			input = addChild(new SearchTextInput()) as SearchTextInput;
			
			title.text = "Search";
			name = WorkspaceState.SEARCH;
			
			content.setConstraints(0.0, 70.0, 15.0, 0.0);
			scroller.setConstraints(NaN, 70.0, 0.0, 0.0);
			input.setConstraints(8.0, 35.0, 8.0, NaN);
			
			input.textfield.tabEnabled = false;
			input.height = 22.0;
			
			input.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			input.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function focusInHandler(event:FocusEvent):void
		{
			keyEnabled = false;
		}
		
		protected function focusOutHandler(event:FocusEvent):void
		{
			keyEnabled = true;
		}
	}
}