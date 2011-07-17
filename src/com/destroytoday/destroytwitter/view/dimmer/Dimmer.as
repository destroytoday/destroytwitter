package com.destroytoday.destroytwitter.view.dimmer
{
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.display.SpritePlus;
	
	import flash.display.Graphics;
	
	public class Dimmer extends SpritePlus
	{
		protected var _backgroundColor:uint;
		
		protected var _displayed:Boolean;
		
		protected var _visibleAlpha:Number = 0.85;
		
		protected var dirtyGraphicsFlag:Boolean;
		
		public function Dimmer()
		{
		}
		
		public function get visibleAlpha():Number
		{
			return _visibleAlpha;
		}

		public function set visibleAlpha(value:Number):void
		{
			if (value == _visibleAlpha) return;
			
			_visibleAlpha = value;
			
			if (visible) alpha = _visibleAlpha;
		}

		public function get displayed():Boolean
		{
			return _displayed;
		}

		public function set displayed(value:Boolean):void
		{
			if (value == _displayed) return;
			
			_displayed = value;

			TweenManager.to(this, {alpha: (_displayed) ? _visibleAlpha : 0.0});
		}

		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			if (value == _backgroundColor) return;
			
			_backgroundColor = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			dirtyGraphicsFlag = true;
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyGraphicsFlag)
			{
				dirtyGraphicsFlag = false;
				
				var graphics:Graphics = this.graphics;
				
				graphics.clear();
				graphics.beginFill(_backgroundColor);
				graphics.drawRect(0.0, 0.0, width, height);
				graphics.endFill();
			}
		}
	}
}