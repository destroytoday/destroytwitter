package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalAlignType;
	import com.destroytoday.layouts.VerticalLayout;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.destroytwitter.view.components.TextButton;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.text.TextFieldAutoSize;
	
	public class Filter extends BaseDrawerPanel
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var textfield:LayoutTextField;
		
		public var screenNamesInput:TextInput;

		public var keywordsInput:TextInput;

		public var sourcesInput:TextInput;
		
		public var applyButton:TextButton;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Filter(title:LayoutTextField)
		{
			var layout:VerticalLayout = new VerticalLayout();

			layout.gap = 8.0;
			
			super(title, layout);
			
			textfield = addChild(new LayoutTextField()) as LayoutTextField;
			screenNamesInput = addChild(new TextInput()) as TextInput;
			keywordsInput = addChild(new TextInput()) as TextInput;
			sourcesInput = addChild(new TextInput()) as TextInput;
			applyButton = addChild(new TextButton()) as TextButton;
			
			//textfield.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0, -1, 3.0);
			textfield.htmlText = "<p>Use comma-separated lists to exclude users, keywords, and sources.</p>";
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.x = -3.0;
			textfield.marginTop = -3.0;
			
			screenNamesInput.defaultText = "[users]";
			screenNamesInput.height = 22.0;
			screenNamesInput.textfield.wordWrap = true;
			screenNamesInput.textfield.autoSize = TextFieldAutoSize.LEFT;
			screenNamesInput.textfield.embedFonts = true;
			
			keywordsInput.defaultText = "[keywords]";
			keywordsInput.height = 22.0;
			keywordsInput.textfield.wordWrap = true;
			keywordsInput.textfield.autoSize = TextFieldAutoSize.LEFT;
			keywordsInput.textfield.embedFonts = true;
			
			sourcesInput.defaultText = "[sources]";
			sourcesInput.height = 22.0;
			sourcesInput.textfield.wordWrap = true;
			sourcesInput.textfield.autoSize = TextFieldAutoSize.LEFT;
			sourcesInput.textfield.embedFonts = true;
			
			applyButton.text = "Apply";
			applyButton.align = HorizontalAlignType.RIGHT;
			applyButton.height = 20.0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible) title.htmlText = "<p><span class=\"title\">Filter</span></p>";
		}
		
		public function get enabled():Boolean
		{
			return screenNamesInput.enabled && keywordsInput.enabled && sourcesInput.enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			screenNamesInput.enabled = keywordsInput.enabled = sourcesInput.enabled = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			textfield.width = width;
			screenNamesInput.width = width;
			keywordsInput.width = width;
			sourcesInput.width = width;
			
			_explicitHeight = applyButton.y + applyButton.height + 8.0;
		}
	}
}