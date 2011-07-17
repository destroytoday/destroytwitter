package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	
	import flash.display.Bitmap;
	
	public class BitmapProgressButton extends BitmapButton
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var progressSpinner:ProgressSpinner;
		
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
		
		public function BitmapProgressButton(bitmap:Bitmap)
		{
			super(bitmap);
			
			progressSpinner = addChild(new ProgressSpinner()) as ProgressSpinner;
			
			progressSpinner.x = (bitmap.width - progressSpinner.spinner.width) * 0.5;
			progressSpinner.y = (bitmap.height - progressSpinner.spinner.height) * 0.5;
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
			progressSpinner.displayed = _loading;
			
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