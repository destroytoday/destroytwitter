package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.controller.AccountModuleController;
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.login.Login;
	import com.destroytoday.destroytwitter.view.login.LoginForm;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;

	public class LoginMediator extends BaseMediator
	{
		[Inject]
		public var accountModuleController:AccountModuleController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var view:Login;
		
		public function LoginMediator()
		{
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(view.form.usernameInput.textfield, Event.CHANGE, inputChangeHandler);
			eventMap.mapListener(view.form.passwordInput.textfield, Event.CHANGE, inputChangeHandler);
			eventMap.mapListener(view.form.submitButton, MouseEvent.CLICK, submitHandler);
			
			signalBus.accountLoginStarted.add(accountLoginStartedHandler);
			signalBus.accountLoggedIn.add(accountLoggedInHandler);
			signalBus.accountLoggedInError.add(accountLoggedInErrorHandler);
			signalBus.accountSelected.add(accountSelectedHandler);
			
			if (!accountModel.currentAccount) {
				view.alpha = 1.0;
				view.visible = true;
				view.displayed = true;
			}
		}
		
		protected function inputChangeHandler(event:Event):void
		{
			if (view.form.usernameInput.textfield.text && view.form.passwordInput.textfield.text &&
				view.form.usernameInput.textfield.text != view.form.usernameInput.defaultText &&
				view.form.passwordInput.textfield.text != view.form.passwordInput.defaultText) 
			{
				view.form.usernameInput.addEventListener(KeyboardEvent.KEY_DOWN, submitHandler);
				view.form.passwordInput.addEventListener(KeyboardEvent.KEY_DOWN, submitHandler);
				
				view.form.submitButton.enabled = true;
			} else if (view.form.submitButton.enabled) {
				view.form.usernameInput.removeEventListener(KeyboardEvent.KEY_DOWN, submitHandler);
				view.form.passwordInput.removeEventListener(KeyboardEvent.KEY_DOWN, submitHandler);
				
				view.form.submitButton.enabled = false;
			}
		}
		
		protected function submitHandler(event:Event):void
		{
			if (event is KeyboardEvent && (event as KeyboardEvent).keyCode == Keyboard.ENTER || !(event is KeyboardEvent)) {
				accountModuleController.login(view.form.usernameInput.textfield.text, view.form.passwordInput.textfield.text);
			}
		}
		
		protected function accountLoginStartedHandler(username:String):void
		{
			view.form.usernameInput.enabled = false;
			view.form.passwordInput.enabled = false;
			view.form.submitButton.enabled = false;
			view.form.spinner.displayed = true;
		}
		
		protected function accountLoggedInHandler(account:AccountModule):void
		{
			view.form.spinner.displayed = false;
			view.displayed = false;
		}
		
		protected function accountLoggedInErrorHandler(message:String):void
		{
			alertController.addMessage(AlertSourceType.LOGIN, message, 5000);

			view.form.usernameInput.enabled = true;
			view.form.passwordInput.enabled = true;
			view.form.submitButton.enabled = true;
			view.form.spinner.displayed = false;
		}
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (account) return;
			
			view.displayed = true;
			view.form.usernameInput.text = view.form.usernameInput.defaultText;
			view.form.usernameInput.enabled = true;
			view.form.passwordInput.text = view.form.passwordInput.defaultText;
			view.form.passwordInput.enabled = true;
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.dimmer, stylesheet.getStyle('.Dimmer')); // a bit ghetto
			styleController.applyStyle(view.form.title, stylesheet.getStyle('.LoginTitle'));
			styleController.applyTextInputStyle(view.form.usernameInput);
			styleController.applyTextInputStyle(view.form.passwordInput);
			styleController.applyTextButtonStyle(view.form.submitButton);
		}
	}
}