package com.destroytoday.destroytwitter.view.workspace.base
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	
	import flash.geom.Rectangle;
	
	public class BaseCanvasContent extends DisplayGroup
	{
		protected var bounds:Rectangle = new Rectangle();
		
		protected var _measuredHeight:Number = 0.0;
		
		public function BaseCanvasContent(layout:BasicLayout = null)
		{
			super(layout);
		}
		
		override public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}
		
		public function get scrollY():uint
		{
			return bounds.y;
		}
		
		public function set scrollY(value:uint):void
		{
			if (value == bounds.y) return;
			
			bounds.y = value;
			
			scrollRect = bounds;
		}
		
		override protected function measure():void
		{
			super.measure();

			bounds.width = width;
			bounds.height = height;
			scrollRect = bounds;
		}
	}
}