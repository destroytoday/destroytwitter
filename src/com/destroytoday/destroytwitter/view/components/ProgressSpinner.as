package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	
	public class ProgressSpinner extends SpritePlus
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var spinner:Spinner;
		
		public var progress:Progress;
		
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
		
		public function ProgressSpinner()
		{
			spinner = addChild(new Spinner()) as Spinner;
			progress = addChild(new Progress()) as Progress;
			
			progress.x = spinner.x + spinner.width + 8.0;
			progress.y = 2.0;
			
			width = 100.0;
			height = spinner.height;
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
			
			width = progress.x + progress.width;
			
			spinner.displayed = _displayed;
			progress.displayed = _displayed;
		}
	}
}