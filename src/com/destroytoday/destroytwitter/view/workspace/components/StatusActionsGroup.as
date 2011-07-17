package com.destroytoday.destroytwitter.view.workspace.components
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalLayout;
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	
	import flash.display.Bitmap;
	
	public class StatusActionsGroup extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var replyButton:BitmapButton;
		
		public var actionsButton:BitmapButton;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StatusActionsGroup()
		{
			super(SingletonManager.getInstance(HorizontalLayout));
			
			replyButton = addChild(new BitmapButton(new (Asset.STATUS_REPLY_BUTTON)() as Bitmap)) as BitmapButton;
			actionsButton = addChild(new BitmapButton(new (Asset.SETTINGS_BUTTON)() as Bitmap)) as BitmapButton;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function nullify():void
		{
			_layout = null;
		}
	}
}