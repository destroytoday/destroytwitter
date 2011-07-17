package com.destroytoday.destroytwitter.view.navigation
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.HorizontalAlignType;
	import com.destroytoday.layouts.IAlignedLayoutElement;
	import com.destroytoday.layouts.IMarginedLayoutElement;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.events.MouseEvent;

	public class BaseNavigationButton extends SpritePlus implements IAlignedLayoutElement, IMarginedLayoutElement
	{
		protected var _border:Boolean;
		
		protected var _borderColor:uint;
		
		protected var backgroundColor:uint;
		
		protected var _backgroundUpColor:uint;
		
		protected var _backgroundOverColor:uint;
		
		protected var _backgroundSelectedUpColor:uint;
		
		protected var _backgroundSelectedOverColor:uint;
		
		protected var _state:String = ButtonState.MOUSE_UP;
		
		protected var _selected:Boolean;
		
		protected var _align:String = HorizontalAlignType.LEFT;
		
		protected var dirtyGraphicsFlag:Boolean;
		
		public function BaseNavigationButton()
		{
			tabEnabled = false;
			buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
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
		
		public function get border():Boolean
		{
			return _border;
		}
		
		public function set border(value:Boolean):void
		{
			if (value == _border) return;
			
			_border = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			if (value == _borderColor) return;
			
			_borderColor = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}

		public function get backgroundUpColor():uint
		{
			return _backgroundUpColor;
		}

		public function set backgroundUpColor(value:uint):void
		{
			if (value == _backgroundUpColor) return;
			
			_backgroundUpColor = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		public function get backgroundOverColor():uint
		{
			return _backgroundOverColor;
		}
		
		public function set backgroundOverColor(value:uint):void
		{
			if (value == _backgroundOverColor) return;
			
			_backgroundOverColor = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		public function get backgroundSelectedUpColor():uint
		{
			return _backgroundSelectedUpColor;
		}
		
		public function set backgroundSelectedUpColor(value:uint):void
		{
			if (value == _backgroundSelectedUpColor) return;

			_backgroundSelectedUpColor = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		public function get backgroundSelectedOverColor():uint
		{
			return _backgroundSelectedOverColor;
		}
		
		public function set backgroundSelectedOverColor(value:uint):void
		{
			if (value == _backgroundSelectedOverColor) return;
			
			_backgroundSelectedOverColor = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		public function get align():String
		{
			return _align;
		}
		
		public function set align(value:String):void
		{
			_align = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value == _selected) return;
			
			_selected = value;
			
			state = (_selected) ? ButtonState.SELECTED_UP : ButtonState.MOUSE_UP;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			dirtyGraphicsFlag = true;
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
				case ButtonState.SELECTED_UP:
					backgroundColor = _backgroundSelectedUpColor;
					break;
				case ButtonState.SELECTED_OVER:
					backgroundColor = _backgroundSelectedOverColor;
					break;
			}
			
			dirtyGraphicsFlag = true;
			invalidateDisplayListFlag = true;
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyGraphicsFlag)
			{
				dirtyGraphicsFlag = false;
				
				var graphics:Graphics = this.graphics;
			
				graphics.clear();
				if (_border) graphics.lineStyle(0.0, _borderColor, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE);
				graphics.beginFill(backgroundColor);
				
				if (_border)
				{
					graphics.drawRect(0.0, -1.0, width - 1.0, height + 1.0);
				}
				else
				{
					graphics.drawRect(0.0, 0.0, width, height);
				}
				
				graphics.endFill();
			}
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			state = (_selected) ? ButtonState.SELECTED_OVER : ButtonState.MOUSE_OVER;
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			state = (_selected) ? ButtonState.SELECTED_UP : ButtonState.MOUSE_UP;
		}
	}
}