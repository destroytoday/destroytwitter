package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.display.InvalidationSprite;
	import com.destroytoday.layouts.IBasicLayoutElement;
	import com.destroytoday.destroytwitter.constants.ButtonState;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ApplicationWindowButton extends InvalidationSprite implements IBasicLayoutElement
	{
		public var bitmap:Bitmap;
		
		protected var _mouseUpBitmapData:BitmapData;
		
		protected var _mouseOverBitmapData:BitmapData;
		
		protected var _inactiveBitmapData:BitmapData;
		
		protected var _state:String;
		
		public function ApplicationWindowButton(up:BitmapData, over:BitmapData, inactive:BitmapData)
		{
			bitmap = addChild(new Bitmap(up)) as Bitmap;
				
			_mouseUpBitmapData = up;
			_mouseOverBitmapData = over;
			_inactiveBitmapData = inactive;
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
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			switch (_state) {
				case ButtonState.MOUSE_UP:
					bitmap.bitmapData = (stage.nativeWindow.active) ? _mouseUpBitmapData : _inactiveBitmapData;
					break;
				case ButtonState.MOUSE_OVER:
					bitmap.bitmapData = _mouseOverBitmapData;
					break;
				case ButtonState.INACTIVE:
					bitmap.bitmapData = _inactiveBitmapData;
					break;
			}
		}
	}
}