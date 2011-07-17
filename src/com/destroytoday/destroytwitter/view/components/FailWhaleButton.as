package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.destroytwitter.manager.TweenManager;
	
	import flash.display.Bitmap;
	
	public class FailWhaleButton extends BitmapButton
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _displayed:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FailWhaleButton(bitmap:Bitmap)
		{
			super(bitmap);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
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