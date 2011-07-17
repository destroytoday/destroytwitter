package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.constants.FontSizeType;
	import com.destroytoday.destroytwitter.constants.FontType;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.BitmapProgressButton;
	import com.destroytoday.destroytwitter.view.components.BitmapSpinnerButton;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.destroytwitter.view.components.TextButton;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.layouts.HorizontalAlignType;
	import com.destroytoday.layouts.VerticalLayout;
	import com.destroytoday.text.GoogleSpellCheck;
	import com.destroytoday.text.SpellCheckHighlighter;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.text.TextFieldAutoSize;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class ComposeForm extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var textArea:TextInput;
		
		public var spinner:Spinner;
		
		public var submitButton:TextButton;
		
		public var linkButton:BitmapSpinnerButton;
		
		public var fileButton:BitmapProgressButton;
		
		//--------------------------------------------------------------------------
		//
		//  Properites
		//
		//--------------------------------------------------------------------------
		
		public var spellCheck:GoogleSpellCheck;
		
		protected var _fontType:String;
		
		protected var _fontSize:String;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtySizeFlag:Boolean;
		
		protected var dirtyFontFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ComposeForm()
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			layout.gap = 8.0;
			
			super(layout);
			
			textArea = addChild(new TextInput()) as TextInput;
			spinner = addChild(new Spinner()) as Spinner;
			submitButton = addChild(new TextButton()) as TextButton;
			linkButton = addChild(new BitmapSpinnerButton(new (Asset.LINK_BUTTON)())) as BitmapSpinnerButton;
			fileButton = addChild(new BitmapProgressButton(new (Asset.FILE_BUTTON)())) as BitmapProgressButton;
			
			spellCheck = new GoogleSpellCheck(textArea.textfield);
			
			spellCheck.language = "en";
			spellCheck.getTextFunction = getText;
				
			spinner.includeInLayout = false;
			spinner.buttonMode = true;
			textArea.textfield.wordWrap = true;
			textArea.height = 76.0;
			submitButton.text = "Submit";
			submitButton.height = 20.0;
			submitButton.align = HorizontalAlignType.RIGHT;
			linkButton.marginTop = -27.0; //ghetto;
			fileButton.x = 31.0;
			
			spellCheck.underlineOffset = -1;
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
		
		public function get fontSize():String
		{
			return _fontSize;
		}
		
		public function set fontSize(value:String):void
		{
			if (value == _fontSize) return;
			
			_fontSize = value;
			
			dirtyFontFlag = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		protected function getText():String
		{
			return TwitterTextUtil.replaceIllegalSpellCheckChars(textArea.text);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function measure():void
		{
			super.measure();
			
			dirtySizeFlag = true;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dirtyFontFlag)
			{
				textArea.textfield.embedFonts = (_fontType == FontType.DEFAULT);
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyFontFlag)
			{
				dirtyFontFlag = false;

				var font:String = FontType.getFont(_fontType);
				var fontSize:Number = FontSizeType.getPixels(_fontSize);
				var leading:Number = (_fontType == FontType.DEFAULT) ? 3.0 : 0.0;
				
				textArea.textfield.defaultTextFormat = TextFormatManager.getTextFormat(font, fontSize, -1, leading);
			}
			
			if (dirtySizeFlag)
			{
				dirtySizeFlag = false;
				
				switch (_fontSize)
				{
					case FontSizeType.SMALL:
						textArea.height = 76.0;
						break;
					case FontSizeType.MEDIUM:
						textArea.height = 105.0;
						break;
					case FontSizeType.LARGE:
						textArea.height = 135.0;
						break;
				}
				
				textArea.width = width;
				spinner.x = submitButton.x - (spinner.width + 8.0);
				spinner.y = submitButton.y + 1.0;
				fileButton.y = linkButton.y - 1.0;
			}
		}
	}
}