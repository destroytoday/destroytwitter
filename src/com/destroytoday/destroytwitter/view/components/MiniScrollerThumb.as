package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.destroytwitter.constants.ButtonState;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class MiniScrollerThumb extends SpritePlus
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _arrowColor:uint;
		
		protected var backgroundColor:uint;
		
		protected var _backgroundUpColor:uint;
		
		protected var _backgroundOverColor:uint;
		
		protected var _backgroundDisabledColor:uint;
		
		protected var _state:String;
		
		protected var dragBounds:Rectangle;
		
		protected var mouseDownY:Number;
		
		protected var _dragging:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyGraphicsFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MiniScrollerThumb()
		{
			tabEnabled = false;
			buttonMode = true;
			enabled = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
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
			
			invalidateDisplayList();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyGraphicsFlag)
			{
				dirtyGraphicsFlag = false;
				
				var graphics:Graphics = this.graphics;
				
				graphics.clear();
				graphics.beginFill(backgroundColor);
				graphics.drawRect(0.0, 0.0, width, height);
				graphics.endFill();
				graphics.lineStyle(0.0, _arrowColor, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE);
				graphics.moveTo (2.0, 4.0);
				graphics.lineTo (3.0, 2.0);
				graphics.lineTo (4.0, 4.0);
				graphics.moveTo (2.0, height - 4.0);
				graphics.lineTo (3.0, height - 2.0);
				graphics.lineTo (4.0, height - 4.0);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
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