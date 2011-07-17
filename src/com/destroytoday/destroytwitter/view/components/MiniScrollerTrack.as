package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	
	import flash.display.Graphics;
	
	public class MiniScrollerTrack extends SpritePlus
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _backgroundColor:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyGraphicsFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MiniScrollerTrack()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
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