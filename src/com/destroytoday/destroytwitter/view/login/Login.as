package com.destroytoday.destroytwitter.view.login
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.dimmer.Dimmer;
	
	public class Login extends DisplayGroup
	{
		public var form:LoginForm;
		
		public var dimmer:Dimmer;
		
		protected var _displayed:Boolean;
		
		public function Login()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			dimmer = addChild(new Dimmer()) as Dimmer;
			form = addChild(new LoginForm()) as LoginForm;
			
			form.center = 0.0;
			form.middle = 0.0;
			
			dimmer.visibleAlpha = 1.0;
			dimmer.setConstraints(0.0, 0.0, 0.0, 0.0);
			
			alpha = 0.0;
			visible = false;
		}
		
		public function get displayed():Boolean
		{
			return _displayed;
		}
		
		public function set displayed(value:Boolean):void
		{
			if (value == _displayed) return;
			
			_displayed = value;

			TweenManager.to(this, {alpha: (_displayed) ? 1.0 : 0.0}, 0.75);
		}
	}
}