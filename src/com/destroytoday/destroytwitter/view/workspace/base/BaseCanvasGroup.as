package com.destroytoday.destroytwitter.view.workspace.base
{
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalLayout;
	import com.destroytoday.layouts.VerticalAlignType;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class BaseCanvasGroup extends DisplayGroup
	{
		protected var _selectedCanvas:BaseCanvas;
		
		protected var _measuredWidth:Number = 0.0;
		
		protected var _targetScrollX:Number = 0.0;
		
		protected var bounds:Rectangle = new Rectangle();
		
		public function BaseCanvasGroup()
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			
			layout.verticalAlign = VerticalAlignType.JUSTIFY;
			
			super(layout);
			
			scrollX = 0.0;
		}
		
		public function get selectedCanvas():BaseCanvas 
		{
			return _selectedCanvas;
		}
		
		public function set selectedCanvas(value:BaseCanvas):void
		{
			if (value == _selectedCanvas) return;
			
			_selectedCanvas = value;
			
			var targetScrollX:Number;

			if (bounds.x > _selectedCanvas.x) { // going left
				targetScrollX = Math.min(_selectedCanvas.x, _measuredWidth - width);
			}
			else if (bounds.x < _selectedCanvas.x + _selectedCanvas.width - width) // going right
			{
				targetScrollX = Math.min(_selectedCanvas.x + _selectedCanvas.width - width, _measuredWidth - width);
			}
			
			if (!isNaN(targetScrollX))
			{
				_targetScrollX = targetScrollX;
				
				TweenManager.to(this, {scrollX: _targetScrollX});
			}
		}
		
		public function get targetScrollX():Number
		{
			return _targetScrollX;
		}

		public function get scrollX():Number
		{
			return bounds.x;
		}

		public function set scrollX(value:Number):void
		{
			if (value == bounds.x) return;
			
			bounds.x = value;
			scrollRect = bounds;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			if (_selectedCanvas && bounds.x > _selectedCanvas.x) {
				bounds.x = _selectedCanvas.x;
			} else if (_selectedCanvas && bounds.x < _selectedCanvas.x + _selectedCanvas.width - width) {
				bounds.x = _selectedCanvas.x + _selectedCanvas.width - width;
			} else if (bounds.x > _measuredWidth - width) {
				bounds.x = _measuredWidth - width;
			}
			
			if (bounds.x < 0) bounds.x = 0.0;
			bounds.width = width;
			bounds.height = height;
			_targetScrollX = bounds.x;
			
			scrollRect = bounds;
		}
		
		override protected function addedToStageHandler(event:Event):void
		{
			super.addedToStageHandler(event);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 1);
			
			stageResizeHandler(null);
			
			if (numChildren > 0) {
				_measuredWidth = numChildren * getChildAt(0).width; //TODO - why doesn't measuredWidth work?
			}
		}

		protected function stageResizeHandler(event:Event):void
		{
			height = stage.stageHeight - 113.0; // window bar (25) + canvas nav bar (25 + spacing) + bottom nav bar (25 + spacing) + footer bar (25) + padding (9)
			
			validateNow();
		}
	}
}