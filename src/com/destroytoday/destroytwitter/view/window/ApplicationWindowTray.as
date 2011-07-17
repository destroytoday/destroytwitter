package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.components.IconButton;
	import com.destroytoday.destroytwitter.view.components.ProgressSpinner;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	public class ApplicationWindowTray extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var textfield:TextFieldPlus;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ApplicationWindowTray()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;

			textfield.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0);
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.x = 4.0;
			textfield.y = 5.0;
			
			height = 25.0;
		}
	}
}