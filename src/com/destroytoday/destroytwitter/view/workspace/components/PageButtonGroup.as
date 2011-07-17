package com.destroytoday.destroytwitter.view.workspace.components
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalLayout;
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.StreamState;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	
	public class PageButtonGroup extends DisplayGroup
	{
		public var olderButton:BitmapButton;
		
		public var newerButton:BitmapButton;
		
		public var mostRecentButton:BitmapButton;
		
		public var optionsButton:BitmapButton;
		
		protected var _displayed:Boolean;
		
		protected var _state:String;
		
		public function PageButtonGroup()
		{
			var layout:HorizontalLayout = new HorizontalLayout();
			
			layout.gap = 1.0;
			
			super(layout);
			
			olderButton = addChild(new BitmapButton(new (Asset.OLDER_PAGE_BUTTON)())) as BitmapButton;
			newerButton = addChild(new BitmapButton(new (Asset.NEWER_PAGE_BUTTON)())) as BitmapButton;
			mostRecentButton = addChild(new BitmapButton(new (Asset.MOSTRECENT_PAGE_BUTTON)())) as BitmapButton;
			optionsButton = addChild(new BitmapButton(new (Asset.SETTINGS_BUTTON)())) as BitmapButton; // rename asset
			
			optionsButton.y = -1.0;
			optionsButton.marginLeft = 2.0;
			
			alpha = 0.0;
			visible = false;
			state = StreamState.DISABLED;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			if (value == _state) return;
			
			_state = value;
			
			olderButton.enabled = true;
			newerButton.enabled = false;
			mostRecentButton.enabled = true;

			switch (_state) {
				case StreamState.REFRESH:
				case StreamState.MOST_RECENT:
					break;
				case StreamState.OLDER:
					newerButton.enabled = true;
					break;
				case StreamState.OLDEST:
					olderButton.enabled = false;
					newerButton.enabled = true;
					break;
				case StreamState.DISABLED:
					olderButton.enabled = false;
					newerButton.enabled = false;
					break;
			}
		}
		
		public function get displayed():Boolean
		{
			return _displayed;
		}
		
		public function set displayed(value:Boolean):void
		{
			if (value == _displayed) return;
			
			_displayed = value;
			mouseChildren = _displayed;

			TweenManager.to(this, {alpha: (_displayed) ? 1.0 : 0.0}, 0.75);
		}
	}
}