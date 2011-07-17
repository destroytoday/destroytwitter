package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.layouts.VerticalLayout;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvasContent;
	
	import flash.display.Graphics;
	
	public class StreamCanvasContent extends BaseCanvasContent
	{
		public function StreamCanvasContent()
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			layout.gap = 1.0;
			
			super(layout);
		}
		
		override public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
	}
}