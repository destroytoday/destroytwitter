package com.destroytoday.destroytwitter.view.workspace.components
{
	import com.destroytoday.display.SpritePlus;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	public class ScrollerTrack extends SpritePlus
	{
		protected var _borderColor:uint;
		
		protected var _backgroundColor:uint;
		
		public function ScrollerTrack()
		{
		}
		
		public function get enabled():Boolean
		{
			return mouseEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			mouseEnabled = value;
		}
		
		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			if (value == _borderColor) return;
			
			_borderColor = value;
			
			invalidateProperties();
		}

		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			if (value == _backgroundColor) return;
			
			_backgroundColor = value;
			
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			draw();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			draw();
		}

		protected function draw():void
		{
			var graphics:Graphics = this.graphics;

			graphics.clear();
			graphics.beginFill(_backgroundColor);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
			graphics.lineStyle(0.0, _borderColor, 1.0, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
			graphics.moveTo(0.0, 0.0);
			graphics.lineTo(width - 1.0, 0.0);
			graphics.moveTo(0.0, height - 1.0);
			graphics.lineTo(width - 1.0, height - 1.0);
		}
	}
}