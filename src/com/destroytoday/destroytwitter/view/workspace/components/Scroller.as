package com.destroytoday.destroytwitter.view.workspace.components
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.constants.ScrollType;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;
	
	public class Scroller extends DisplayGroup
	{
		protected var _scrollValueChanged:Signal = new Signal(String, Number); // type, value
		
		public var thumb:ScrollerThumb;
		
		public var track:ScrollerTrack;
		
		protected var dragBounds:Rectangle = new Rectangle();
		
		protected var _scrollValue:Number = 0.0;
		
		protected var _enabled:Boolean;
		
		public function Scroller()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			track = addChild(new ScrollerTrack()) as ScrollerTrack;
			thumb = addChild(new ScrollerThumb()) as ScrollerThumb;
			
			thumb.setConstraints(0.0, NaN, 0.0, NaN);
			track.setConstraints(0.0, 0.0, 0.0, 0.0);
			
			thumb.height = 100.0;
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (value == _enabled) return;
			
			_enabled = value;
			
			thumb.enabled = _enabled;
			track.enabled = _enabled; //TODO
			
			invalidateProperties();
		}

		public function get scrollValueChanged():Signal
		{
			return _scrollValueChanged;
		}
		
		public function get scrollValue():Number
		{
			return _scrollValue;
		}

		public function set scrollValue(value:Number):void
		{
			if (!(value < 0 || value >= 0)) return;

			setScrollValue(ScrollType.MANUAL, value);
		}
		
		public function setScrollValue(type:String, value:Number):void
		{
			_scrollValue = Math.max(0.0, Math.min(1.0, value));
			
			if (type != ScrollType.DRAG && dragBounds.height > 0.0) {
				thumb.y = Math.round(_scrollValue * dragBounds.height);
				
				//_scrollValue = thumb.y / dragBounds.height;
			}
			
			_scrollValueChanged.dispatch(type, _scrollValue);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			thumb.validateNow(); //validateProperties();
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			dragBounds.height = height - thumb.height;

			thumb.y = Math.round(_scrollValue * dragBounds.height);
		}
		
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			thumb.startDrag(false, dragBounds);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler);
		}
		
		protected function thumbMouseMoveHandler(event:MouseEvent):void
		{
			event.updateAfterEvent();

			setScrollValue(ScrollType.DRAG, thumb.y / dragBounds.height);
		}
		
		protected function thumbMouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, thumbMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMouseMoveHandler);
			
			thumb.stopDrag();
		}
	}
}