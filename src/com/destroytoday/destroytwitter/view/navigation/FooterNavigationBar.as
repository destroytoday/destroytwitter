package com.destroytoday.destroytwitter.view.navigation
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.view.components.IconButton;
	import com.destroytoday.layouts.HorizontalAlignType;

	import flash.display.Bitmap;

	public class FooterNavigationBar extends BaseNavigationBar
	{
		public var iconButton:NavigationIconButton;

		public var preferencesButton:NavigationTextButton;

		public var awayButton:NavigationTextButton;

		public var tweetButton:NavigationBitmapButton;

		public function FooterNavigationBar()
		{
			iconButton = addChild(new NavigationIconButton()) as NavigationIconButton;
			preferencesButton = addChild(new NavigationTextButton()) as NavigationTextButton;
			tweetButton = addChild(new NavigationBitmapButton(new (Asset.TWEET_BUTTON) as Bitmap)) as NavigationBitmapButton;
			awayButton = addChild(new NavigationTextButton()) as NavigationTextButton;

			iconButton.marginLeft = 1.0;
			iconButton.marginRight = 1.0;
			iconButton.width = iconButton.bitmap.width = 25.0;
			iconButton.height = iconButton.bitmap.height = 25.0;
			preferencesButton.text = "Preferences";
			preferencesButton.name = WorkspaceState.PREFERENCES;

			awayButton.text = "Away";
			awayButton.align = HorizontalAlignType.RIGHT;
			tweetButton.align = HorizontalAlignType.RIGHT;
		}

		override protected function updateDisplayList():void
		{
			if (dirtyGraphicsFlag)
			{
				var margin:Number, size:Number;

				if (_border)
				{
					margin = 1.0;
					size = 25.0;
				}
				else
				{
					margin = 0.0;
					size = 27.0;
				}

				iconButton.marginLeft = margin;
				iconButton.marginRight = margin;
				iconButton.width = iconButton.bitmap.width = size;
				iconButton.height = iconButton.bitmap.height = size;
			}

			super.updateDisplayList();
		}
	}
}