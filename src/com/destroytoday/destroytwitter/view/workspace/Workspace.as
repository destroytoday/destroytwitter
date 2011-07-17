package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalAlignType;
	import com.destroytoday.layouts.VerticalLayout;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Workspace extends DisplayGroup
	{
		public var streamCanvasGroup:StreamCanvasGroup;
		
		public var infoCanvasGroup:InfoCanvasGroup;
		
		protected var bounds:Rectangle = new Rectangle();
		
		protected var _selectedIndex:int;
		
		public function Workspace()
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			layout.horizontalAlign = HorizontalAlignType.JUSTIFY;
			
			super(layout);
			
			streamCanvasGroup = addChild(new StreamCanvasGroup()) as StreamCanvasGroup;
			infoCanvasGroup = addChild(new InfoCanvasGroup()) as InfoCanvasGroup;
			
			scrollY = 0.0;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if (value == _selectedIndex) return;
			
			_selectedIndex = value;
			
			TweenManager.to(this, {scrollY: _selectedIndex * height});
		}

		public function get scrollY():Number
		{
			return bounds.y;
		}

		public function set scrollY(value:Number):void
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
		
		override protected function addedToStageHandler(event:Event):void
		{
			super.addedToStageHandler(event);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			
			stageResizeHandler(null);
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			scrollY = selectedIndex * height;
		}
	}
}