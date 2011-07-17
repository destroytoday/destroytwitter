package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	
	import flash.display.Bitmap;
	
	public class BitmapSpinnerButton extends BitmapButton
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var spinner:Spinner;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _loading:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BitmapSpinnerButton(bitmap:Bitmap)
		{
			super(bitmap);
			
			spinner = addChild(new Spinner()) as Spinner;
			
			spinner.x = (bitmap.width - spinner.width) * 0.5;
			spinner.y = (bitmap.height - spinner.height) * 0.5;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get loading():Boolean
		{
			return _loading;
		}
		
		public function set loading(value:Boolean):void
		{
			if (value == _loading) return;
			
			_loading = value;
			spinner.displayed = _loading;
			
			if (!_loading) 
			{
				state = ButtonState.MOUSE_UP;
				
				validateNow();
				
				bitmap.alpha = 0.0;
			}
			else
			{
				bitmap.alpha = 1.0;
			}
			
			TweenManager.to(bitmap, {alpha: (_loading) ? 0.0 : 1.0}, 0.5);
		}
	}
}