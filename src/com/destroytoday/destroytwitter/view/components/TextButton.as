package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.IAlignedLayoutElement;
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class TextButton extends SpritePlus implements IAlignedLayoutElement
	{
		public var textfield:TextFieldPlus;
		
		protected var _textUpColor:uint;
		
		protected var _textOverColor:uint;
		
		protected var _textDisabledColor:uint;
		
		protected var backgroundColor:uint;
		
		protected var _backgroundUpColor:uint;
		
		protected var _backgroundOverColor:uint;
		
		protected var _backgroundDisabledColor:uint;
		
		protected var _state:String = ButtonState.MOUSE_UP;
		
		protected var _align:String;
		
		public function TextButton()
		{
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;
			
			textfield.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0);
			textfield.autoSize = TextFieldAutoSize.LEFT;

			mouseChildren = false;
			tabEnabled = false;
			buttonMode = true;
			mouseEnabled = true;
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
		
		public function get align():String
		{
			return _align;
		}
		
		public function set align(value:String):void
		{
			_align = value;
		}
		
		public function get text():String
		{
			return textfield.text;
		}
		
		public function set text(value:String):void
		{
			if (value == textfield.text) return;
			
			textfield.text = value;
			
			invalidateSize();
		}
		
		public function get textUpColor():uint
		{
			return _textUpColor;
		}
		
		public function set textUpColor(value:uint):void
		{
			if (value == _textUpColor) return;
			
			_textUpColor = value;
			
			invalidateProperties();
		}
		
		public function get textOverColor():uint
		{
			return _textOverColor;
		}
		
		public function set textOverColor(value:uint):void
		{
			if (value == _textOverColor) return;
			
			_textOverColor = value;
			
			invalidateProperties();
		}
		
		public function get textDisabledColor():uint
		{
			return _textDisabledColor;
		}
		
		public function set textDisabledColor(value:uint):void
		{
			if (value == _textDisabledColor) return;
			
			_textDisabledColor = value;
			
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
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			if (enabled) {
				addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			} else {
				removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
			
			super.mouseEnabled = enabled;
		}
		
		public function get enabled():Boolean
		{
			return mouseEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			mouseEnabled = value;
			
			state = (mouseEnabled) ? ButtonState.MOUSE_UP : ButtonState.DISABLED;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			var graphics:Graphics = this.graphics;
			
			switch (_state) {
				case ButtonState.MOUSE_UP:
					textfield.textColor = _textUpColor;
					backgroundColor = _backgroundUpColor;
					break;
				case ButtonState.MOUSE_OVER:
					textfield.textColor = _textOverColor;
					backgroundColor = _backgroundOverColor;
					break;
				case ButtonState.DISABLED:
					textfield.textColor = _textDisabledColor;
					backgroundColor = _backgroundDisabledColor;
					break;
			}
			
			draw();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			if (!(_explicitWidth < 0 || _explicitWidth >= 0)) width = Math.round(textfield.width + 10.0);
			
			draw();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			textfield.x = Math.round((width - textfield.width) * 0.5) - 1.0;
			textfield.y = Math.round((height - textfield.height) * 0.5);
		}
		
		protected function draw():void
		{
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(backgroundColor);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
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