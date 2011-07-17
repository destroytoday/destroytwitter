package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.view.workspace.StreamElement;
	import com.destroytoday.destroytwitter.view.workspace.TwitterElement;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.text.TextFieldAutoSize;

	public class TwitterElementMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TwitterElementMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		private function get view():TwitterElement
		{
			return viewComponent as TwitterElement;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();

			signalBus.iconTypeChanged.add(iconTypeChangedHandler);
			signalBus.fontTypeChanged.add(fontTypeChangedHandler);
			signalBus.fontSizeChanged.add(fontSizeChangedHandler);
			signalBus.userFormatChanged.add(userFormatChangedHandler);
			signalBus.timeFormatChanged.add(timeFormatChangedHandler);
			signalBus.accountSelected.add(accountSelectedHandler);
			
			updatePreferences();
		}
		
		protected function updatePreferences():void
		{
			view.fontType = preferencesController.getPreference(PreferenceType.FONT_TYPE);
			view.fontSize = preferencesController.getPreference(PreferenceType.FONT_SIZE);
			view.iconType = preferencesController.getPreference(PreferenceType.ICON_TYPE);
			view.userFormat = preferencesController.getPreference(PreferenceType.USER_FORMAT);
			view.timeFormat = preferencesController.getPreference(PreferenceType.TIME_FORMAT);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function accountSelectedHandler(account:AccountModule):void
		{
			if (account)
			{
				updatePreferences();
			}
		}
		
		protected function iconTypeChangedHandler(iconType:String):void
		{
			view.iconType = iconType;
		}
		
		protected function fontTypeChangedHandler(fontType:String):void
		{
			view.fontType = fontType;
		}
		
		protected function fontSizeChangedHandler(fontSize:String):void
		{
			view.fontSize = fontSize;
		}
		
		protected function userFormatChangedHandler(userFormat:String):void
		{
			view.userFormat = userFormat;
		}
		
		protected function timeFormatChangedHandler(timeFormat:String):void
		{
			view.timeFormat = timeFormat;
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStatusStyle(view);
		}
	}
}