package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalLayout;
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.destroytwitter.view.components.TextButton;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	
	public class Find extends BaseDrawerPanel
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var input:TextInput;
		
		public var nextButton:TextButton;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Find(title:LayoutTextField)
		{
			var layout:HorizontalLayout = new HorizontalLayout();

			layout.gap = 8.0;
			
			super(title, layout);
			
			input = addChild(new TextInput()) as TextInput;
			nextButton = addChild(new TextButton()) as TextButton;
			
			input.width = 248.0;
			input.height = 22.0;
			input.textfield.embedFonts = true;
			
			nextButton.text = "Search";
			nextButton.height = 22.0;
			
			height = 32.0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible) title.htmlText = "<p><span class=\"title\">Find</span></p>";
		}
	}
}