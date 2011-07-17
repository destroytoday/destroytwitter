package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	
	public class BaseDrawerPanel extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Links
		//
		//--------------------------------------------------------------------------
		
		protected var title:LayoutTextField;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BaseDrawerPanel(title:LayoutTextField, layout:BasicLayout = null)
		{
			this.title = title;
			
			super(layout);
		}
	}
}