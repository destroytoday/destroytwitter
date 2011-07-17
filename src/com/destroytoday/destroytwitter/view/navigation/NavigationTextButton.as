package com.destroytoday.destroytwitter.view.navigation
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;

	public class NavigationTextButton extends BaseNavigationButton
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var textfield:TextFieldPlus;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _textUpColor:uint;

		protected var _textOverColor:uint;
		
		protected var _textSelectedUpColor:uint;

		protected var _textSelectedOverColor:uint;
		
		protected var _textHighlightedColor:uint;
		
		protected var _highlighted:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NavigationTextButton()
		{
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;

			textfield.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0);
			textfield.embedFonts = true;
			textfield.antiAliasType = AntiAliasType.ADVANCED;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			
			mouseChildren = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
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

		public function get textSelectedUpColor():uint
		{
			return _textSelectedUpColor;
		}

		public function set textSelectedUpColor(value:uint):void
		{
			if (value == _textSelectedUpColor) return;
			
			_textSelectedUpColor = value;
			
			invalidateProperties();
		}
		
		public function get textSelectedOverColor():uint
		{
			return _textSelectedOverColor;
		}

		public function set textSelectedOverColor(value:uint):void
		{
			if (value == _textSelectedOverColor) return;
			
			_textSelectedOverColor = value;
			
			invalidateProperties();
		}

		public function get textHighlightedColor():uint
		{
			return _textHighlightedColor;
		}

		public function set textHighlightedColor(value:uint):void
		{
			if (value == _textHighlightedColor) return;
			
			_textHighlightedColor = value;
			
			invalidateProperties();
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
		
		public function get highlighted():Boolean
		{
			return _highlighted;
		}
		
		public function set highlighted(value:Boolean):void
		{
			if (value == _highlighted) return;
			
			_highlighted = value;
			
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		public function dirtyState():void
		{
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();

			switch (_state) {
				case ButtonState.MOUSE_OVER:
					textfield.textColor = _textOverColor;
					break;
				case ButtonState.SELECTED_UP:
					textfield.textColor = _textSelectedUpColor;
					break;
				case ButtonState.SELECTED_OVER:
					textfield.textColor = _textSelectedOverColor;
					break;
				default:
					textfield.textColor = (_highlighted) ? _textHighlightedColor : _textUpColor;
			}

		}
		
		override protected function measure():void
		{
			super.measure();
			
			width = Math.round(textfield.width + 10.0);
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			textfield.x = Math.round((width - textfield.width) * 0.5) - 1.0;
			textfield.y = Math.round((height - textfield.height) * 0.5);
		}
	}
}