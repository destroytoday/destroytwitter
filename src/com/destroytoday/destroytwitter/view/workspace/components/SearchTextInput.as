package com.destroytoday.destroytwitter.view.workspace.components
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.FontType;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	
	import flash.display.Bitmap;
	
	public class SearchTextInput extends TextInput
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var clearButton:BitmapButton;

		public var actionsButton:BitmapButton;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _fontType:String;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyFontFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SearchTextInput()
		{
			actionsButton = addChild(new BitmapButton(new (Asset.STATUS_ACTIONS_BUTTON)() as Bitmap)) as BitmapButton;
			//actionsButton = addChild(new BitmapButton()) as BitmapButton;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get fontType():String
		{
			return _fontType;
		}
		
		public function set fontType(value:String):void
		{
			if (value == _fontType) return;
			
			_fontType = value;
			
			dirtyFontFlag = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dirtyFontFlag)
			{
				textfield.embedFonts = (_fontType == FontType.DEFAULT);
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyFontFlag)
			{
				dirtyFontFlag = false;

				textfield.defaultTextFormat = TextFormatManager.getTextFormat(FontType.getFont(_fontType), 11.0);
			}
			
			textfield.width = width - (textfield.x * 2.0 + 28.0);
			
			actionsButton.x = width - (actionsButton.width + 4.0);
			actionsButton.y = Math.round((height - actionsButton.height) * 0.5);
		}
	}
}