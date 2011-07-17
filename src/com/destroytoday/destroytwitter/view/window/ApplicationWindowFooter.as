package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.display.SpritePlus;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.NativeWindowResize;
	import flash.events.MouseEvent;
	
	public class ApplicationWindowFooter extends DisplayGroup
	{
		[Embed(source="/assets/gripper.png", mimeType="image/png")]
		protected static const GRIPPER_BITMAP:Class;
		
		public var gripper:SpritePlus;
		
		protected var _backgroundColor:uint;
		
		public function ApplicationWindowFooter()
		{
			gripper = addChild(new SpritePlus()) as SpritePlus;
			
			gripper.addChild(new GRIPPER_BITMAP() as Bitmap);
			
			gripper.right = 0.0;
			
			height = 25.0;
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
			
			draw()
		}
		
		protected function draw():void
		{
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(_backgroundColor);
			graphics.drawRoundRectComplex(0.0, 0.0, width, height, 0.0, 0.0, 5.0, 5.0);
			graphics.endFill();
		}
	}
}