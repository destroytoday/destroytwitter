package com.destroytoday.destroytwitter.view.workspace.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.destroytwitter.constants.ButtonState;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ScrollerThumb extends SpritePlus
	{
		protected var _arrowColor:uint;
		
		protected var backgroundColor:uint;
		
		protected var _backgroundUpColor:uint;
		
		protected var _backgroundOverColor:uint;
		
		protected var _backgroundDisabledColor:uint;
		
		protected var _state:String;
		
		protected var dragBounds:Rectangle;
		
		protected var mouseDownY:Number;
		
		protected var _dragging:Boolean;
		
		protected var _arrowBounds:Rectangle = new Rectangle(3.0, 5.0, 8.0, 4.0);
		
		public function ScrollerThumb()
		{
			tabEnabled = false;
			buttonMode = true;
			enabled = false;
		}
		
		public function get dragging():Boolean
		{
			return _dragging;
		}

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			if (value == _state) return;
			
			_state = value;
			
			invalidateProperties();
		}
		
		public function get arrowBounds():Rectangle
		{
			return _arrowBounds;
		}
		
		public function set arrowBounds(value:Rectangle):void
		{
			if (value == _arrowBounds) return;
			
			_arrowBounds = value;
			
			invalidateProperties();
		}
		
		public function get arrowColor():uint
		{
			return _arrowColor;
		}
		
		public function set arrowColor(value:uint):void
		{
			if (value == _arrowColor) return;
			
			_arrowColor = value;
			
			invalidateProperties();
		}

		public function get backgroundUpColor():uint
		{
			return _backgroundUpColor;
		}
		
		public function set backgroundUpColor(value:uint):void
		{
			if (value == _backgroundUpColor) return;
			
			_backgroundUpColor = value;
			
			invalidateProperties();
		}
		
		public function get backgroundOverColor():uint
		{
			return _backgroundOverColor;
		}
		
		public function set backgroundOverColor(value:uint):void
		{
			if (value == _backgroundOverColor) return;
			
			_backgroundOverColor = value;
			
			invalidateProperties();
		}
		
		public function get backgroundDisabledColor():uint
		{
			return _backgroundDisabledColor;
		}
		
		public function set backgroundDisabledColor(value:uint):void
		{
			if (value == _backgroundDisabledColor) return;
			
			_backgroundDisabledColor = value;
			
			invalidateProperties();
		}
		
		public function get enabled():Boolean
		{
			return mouseEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			mouseEnabled = value;
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			if (enabled) {
				state = ButtonState.MOUSE_UP;
				
				addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			} else {
				state = ButtonState.DISABLED;
				
				removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
			
			super.mouseEnabled = enabled;
		}
		
		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			_dragging = true;
			dragBounds = bounds;
			mouseDownY = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		override public function stopDrag():void
		{
			_dragging = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			switch (_state) {
				case ButtonState.MOUSE_UP:
					backgroundColor = _backgroundUpColor;
					break;
				case ButtonState.MOUSE_OVER:
					backgroundColor = _backgroundOverColor;
					break;
				case ButtonState.DISABLED:
					backgroundColor = _backgroundDisabledColor;
			}
			
			draw();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			draw();
		}

		protected function draw():void
		{
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(backgroundColor);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
			graphics.lineStyle(0.0, _arrowColor, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
			graphics.moveTo (_arrowBounds.x, _arrowBounds.bottom);
			graphics.lineTo (_arrowBounds.x + _arrowBounds.width * 0.5, _arrowBounds.y);
			graphics.lineTo (_arrowBounds.right, _arrowBounds.bottom);
			graphics.moveTo (_arrowBounds.x, height - _arrowBounds.bottom);
			graphics.lineTo (_arrowBounds.x + _arrowBounds.width * 0.5, height - _arrowBounds.y);
			graphics.lineTo (_arrowBounds.right, height - _arrowBounds.bottom);
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			state = ButtonState.MOUSE_OVER;
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			state = ButtonState.MOUSE_UP;
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			event.updateAfterEvent();
			
			y = Math.max(dragBounds.y, Math.min(dragBounds.height, parent.mouseY - mouseDownY));
		}
	}
}