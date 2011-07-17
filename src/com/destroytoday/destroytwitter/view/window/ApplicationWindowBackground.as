package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.display.SpritePlus;
	
	import flash.display.Graphics;
	
	public class ApplicationWindowBackground extends SpritePlus
	{
		protected var _backgroundColor:uint;
		
		public function ApplicationWindowBackground()
		{
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			if (value == _backgroundColor) return;
			
			_backgroundColor = value;
			
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			var graphics:Graphics = this.graphics;
		
			graphics.clear();
			graphics.beginFill(_backgroundColor);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
		}
	}
}