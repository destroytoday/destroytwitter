package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.IBasicLayoutElement;
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.util.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class BitmapButton extends SpritePlus implements IBasicLayoutElement
	{
		public var bitmap:Bitmap;
		
		protected var _upColor:uint;
		
		protected var _overColor:uint;
		
		protected var _disabledColor:uint;
		
		protected var _state:String = ButtonState.MOUSE_UP;
		
		public function BitmapButton(bitmap:Bitmap)
		{
			this.bitmap = addChild(bitmap) as Bitmap;
			
			tabEnabled = false;
			buttonMode = true;
			enabled = true;
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
		
		public function get upColor():uint
		{
			return _upColor;
		}
		
		public function set upColor(value:uint):void
		{
			if (value == _upColor) return;
			
			_upColor = value;
			
			invalidateProperties();
		}

		public function get overColor():uint
		{
			return _overColor;
		}

		public function set overColor(value:uint):void
		{
			if (value == _overColor) return;
			
			_overColor = value;
			
			invalidateProperties();
		}

		public function get disabledColor():uint
		{
			return _disabledColor;
		}

		public function set disabledColor(value:uint):void
		{
			if (value == _disabledColor) return;
			
			_disabledColor = value;
			
			invalidateProperties();
		}
		
		public function get enabled():Boolean
		{
			return mouseEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			mouseEnabled = value;
			
			_state = (mouseEnabled) ? ButtonState.MOUSE_UP : ButtonState.DISABLED;
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
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			var color:uint;
			
			switch (_state) {
				case ButtonState.MOUSE_UP:
					color = _upColor;
					break;
				case ButtonState.MOUSE_OVER:
					color = _overColor;
					break;
				case ButtonState.DISABLED:
					color = _disabledColor;
					break;
			}
			
			ColorUtil.apply(bitmap, color);
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			state = ButtonState.MOUSE_OVER;
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			state = ButtonState.MOUSE_UP;
		}
	}
}