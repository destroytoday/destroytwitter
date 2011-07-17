package com.destroytoday.destroytwitter.view.login
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
	
	import flash.text.TextFieldAutoSize;
	
	public class LoginForm extends DisplayGroup
	{
		public var title:LayoutTextField;
		public var spinner:Spinner;
		public var usernameInput:TextInput;
		public var passwordInput:TextInput;
		public var submitButton:TextButton;
		
		public function LoginForm()
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			layout.horizontalAlign = HorizontalAlignType.LEFT;
			layout.gap = 8.0;
			
			super(layout);
			
			title = addChild(new LayoutTextField()) as LayoutTextField;
			spinner = addChild(new Spinner()) as Spinner;
			usernameInput = addChild(new TextInput()) as TextInput;
			passwordInput = addChild(new TextInput()) as TextInput;
			submitButton = addChild(new TextButton()) as TextButton;
			
			title.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 18.0);
			title.autoSize = TextFieldAutoSize.LEFT;
			title.text = "Login";
			
			title.setMargins(-3.0, -3.0, 0.0, 0.0);
			
			spinner.includeInLayout = false;
			spinner.x = 200.0 - spinner.width;
			
			usernameInput.textfield.embedFonts = true;
			usernameInput.defaultText = "[username]";
			usernameInput.width = 200.0;
			usernameInput.height = 22.0;
			
			passwordInput.textfield.embedFonts = true;
			passwordInput.textfield.displayAsPassword = true;
			passwordInput.defaultText = "[password]";
			passwordInput.width = 200.0;
			passwordInput.height = 22.0;
			
			submitButton.align = HorizontalAlignType.RIGHT;
			submitButton.text = "Submit";
			submitButton.height = 20.0;
			submitButton.enabled = false;

			width = 200.0;
			
			validateNow();
		}
		
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
	}
}