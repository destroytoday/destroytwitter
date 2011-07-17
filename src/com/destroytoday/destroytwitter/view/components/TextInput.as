package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.IAlignedLayoutElement;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.constants.TextInputState;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextFieldType;
	
	import mx.utils.StringUtil;
	
	public class TextInput extends SpritePlus
	{
		public var textfield:TextFieldPlus;
		
		protected var _textUnfocusedColor:uint;
		
		protected var _textFocusedColor:uint;
		
		protected var _textDisabledColor:uint;
		
		protected var _textErrorColor:uint;
		
		protected var borderColor:uint;
		
		protected var _borderUnfocusedColor:uint;
		
		protected var _borderFocusedColor:uint;
		
		protected var _borderDisabledColor:uint;
		
		protected var _borderErrorColor:uint;
		
		protected var backgroundColor:uint;
		
		protected var _backgroundUnfocusedColor:uint;
		
		protected var _backgroundFocusedColor:uint;
		
		protected var _backgroundDisabledColor:uint;
		
		protected var _backgroundErrorColor:uint;
		
		protected var _defaultText:String = "";
		
		protected var _state:String = TextInputState.UNFOCUSED;
		
		public function TextInput()
		{
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;

			textfield.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0, -1, 3.0);
			textfield.type = TextFieldType.INPUT;
			
			textfield.x = 3.0;
			textfield.y = 4.0;
			
			textfield.addEventListener(FocusEvent.FOCUS_IN, textfieldFocusInHandler);
			textfield.addEventListener(FocusEvent.FOCUS_OUT, textfieldFocusOutHandler);
		}
		
		public function get enabled():Boolean {
			return textfield.selectable;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value == textfield.selectable) return;
			
			if (!value && stage && stage.focus == textfield) stage.focus = null;

			textfield.selectable = value;
			textfield.mouseEnabled = value;
			textfield.tabEnabled = value;
			textfield.type = (value) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			
			state = (textfield.selectable) ? TextInputState.UNFOCUSED : TextInputState.DISABLED;
		}
		
		public function get text():String
		{
			return textfield.text;
		}
		
		public function set text(value:String):void
		{
			textfield.text = value;
			
			textfield.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get defaultText():String
		{
			return _defaultText;
		}

		public function set defaultText(value:String):void
		{
			if (value == _defaultText) return;
			
			_defaultText = value;
			
			invalidateProperties();
		}

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			_state = value;
			
			invalidateProperties();
		}

		public function get textUnfocusedColor():uint
		{
			return _textUnfocusedColor;
		}

		public function set textUnfocusedColor(value:uint):void
		{
			if (value == _textUnfocusedColor) return;
			
			_textUnfocusedColor = value;
			
			invalidateProperties();
		}

		public function get textFocusedColor():uint
		{
			return _textFocusedColor;
		}

		public function set textFocusedColor(value:uint):void
		{
			if (value == _textFocusedColor) return;
			
			_textFocusedColor = value;
			
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

		public function get textErrorColor():uint
		{
			return _textErrorColor;
		}

		public function set textErrorColor(value:uint):void
		{
			if (value == _textErrorColor) return;
			
			_textErrorColor = value;
			
			invalidateProperties();
		}

		public function get borderUnfocusedColor():uint
		{
			return _borderUnfocusedColor;
		}

		public function set borderUnfocusedColor(value:uint):void
		{
			if (value == _borderUnfocusedColor) return;
			
			_borderUnfocusedColor = value;
			
			invalidateProperties();
		}

		public function get borderFocusedColor():uint
		{
			return _borderFocusedColor;
		}

		public function set borderFocusedColor(value:uint):void
		{
			if (value == _borderFocusedColor) return;
			
			_borderFocusedColor = value;
			
			invalidateProperties();
		}
		
		public function get borderDisabledColor():uint
		{
			return _borderDisabledColor;
		}
		
		public function set borderDisabledColor(value:uint):void
		{
			if (value == _borderDisabledColor) return;
			
			_borderDisabledColor = value;
			
			invalidateProperties();
		}

		public function get borderErrorColor():uint
		{
			return _borderErrorColor;
		}

		public function set borderErrorColor(value:uint):void
		{
			if (value == _borderErrorColor) return;
			
			_borderErrorColor = value;
			
			invalidateProperties();
		}

		public function get backgroundUnfocusedColor():uint
		{
			return _backgroundUnfocusedColor;
		}

		public function set backgroundUnfocusedColor(value:uint):void
		{
			if (value == _backgroundUnfocusedColor) return;
			
			_backgroundUnfocusedColor = value;
			
			invalidateProperties();
		}

		public function get backgroundFocusedColor():uint
		{
			return _backgroundFocusedColor;
		}

		public function set backgroundFocusedColor(value:uint):void
		{
			if (value == _backgroundFocusedColor) return;
			
			_backgroundFocusedColor = value;
			
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

		public function get backgroundErrorColor():uint
		{
			return _backgroundErrorColor;
		}

		public function set backgroundErrorColor(value:uint):void
		{
			if (value == _backgroundErrorColor) return;
			
			_backgroundErrorColor = value;
			
			invalidateProperties();
		}
		
		public function focus(pointer:int = -1):void
		{
			if (pointer == -1) pointer = textfield.length;
			
			stage.focus = textfield;
			textfield.setSelection(pointer, pointer);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			switch (_state) {
				case TextInputState.UNFOCUSED:
					if (_defaultText && StringUtil.trim(textfield.text) == "") textfield.text = _defaultText;
					
					textfield.textColor = _textUnfocusedColor;
					borderColor = _borderUnfocusedColor;
					backgroundColor = _backgroundUnfocusedColor;
					break;
				case TextInputState.FOCUSED:
					if (_defaultText && StringUtil.trim(textfield.text) == _defaultText) textfield.text = "";
					
					textfield.textColor = _textFocusedColor;
					borderColor = _borderFocusedColor;
					backgroundColor = _backgroundFocusedColor;
					break;
				case TextInputState.DISABLED:
					textfield.textColor = _textDisabledColor;
					borderColor = _borderDisabledColor;
					backgroundColor = _backgroundDisabledColor;
					break;
				case TextInputState.ERROR:
					textfield.textColor = _textErrorColor;
					borderColor = _borderErrorColor;
					backgroundColor = _backgroundErrorColor;
					break;
			}
			
			draw();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			draw();
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			textfield.width = width - (textfield.x * 2.0);
			textfield.height = height - textfield.y;
		}
		
		protected function draw():void
		{
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(backgroundColor);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
			graphics.lineStyle(0.0, borderColor, 1.0, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER);
			graphics.drawRect(0.0, 0.0, width - 1.0, height - 1.0);
		}
		
		protected function textfieldFocusInHandler(event:FocusEvent):void
		{
			if (state != TextInputState.ERROR) state = TextInputState.FOCUSED;
		}
		
		protected function textfieldFocusOutHandler(event:FocusEvent):void
		{
			if (state != TextInputState.ERROR) state = TextInputState.UNFOCUSED;
		}
	}
}