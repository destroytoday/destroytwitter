package com.destroytoday.destroytwitter.view.navigation
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalBidirectionalLayout;
	import com.destroytoday.layouts.HorizontalLayout;
	import com.destroytoday.layouts.VerticalAlignType;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.geom.Rectangle;
	
	public class BaseNavigationBar extends DisplayGroup
	{
		protected var _border:Boolean;
		
		protected var _borderColor:uint;
		
		protected var _backgroundColor:uint;
		
		protected var bounds:Rectangle = new Rectangle();
		
		protected var dirtyGraphicsFlag:Boolean;
		
		public function BaseNavigationBar()
		{
			var layout:HorizontalBidirectionalLayout = new HorizontalBidirectionalLayout();
			
			super(layout);
			
			layout.verticalAlign = VerticalAlignType.JUSTIFY;
			layout.gap = -1.0;
			layout.setPadding(-1.0, 1.0, -1.0, 1.0);
			
			height = 27.0;
		}
		
		public function get border():Boolean
		{
			return _border;
		}

		public function set border(value:Boolean):void
		{
			if (value == _border) return;
			
			_border = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			if (value == _borderColor) return;
			
			_borderColor = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
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
			
			bounds.width = width;
			bounds.height = height;
			
			scrollRect = bounds;
			
			dirtyGraphicsFlag = true;
		}
		
		override protected function updateDisplayList():void
		{
			if (dirtyGraphicsFlag)
			{
				dirtyGraphicsFlag = false;
				
				var graphics:Graphics = this.graphics;
			
				graphics.clear();
				graphics.beginFill(_backgroundColor);
				graphics.drawRect(0.0, 0.0, width, height);
				graphics.endFill();
				
				if (_border)
				{
					layout.setPadding(-1.0, 1.0, -1.0, 1.0);
					(layout as HorizontalLayout).gap = -1.0;
					
					graphics.lineStyle(0.0, _borderColor, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE);
					graphics.moveTo(0.0, 0.0);
					graphics.lineTo(width, 0.0);
					graphics.moveTo(0.0, height - 1.0);
					graphics.lineTo(width, height - 1.0);
				}
				else
				{
					layout.setPadding(0.0, 0.0, 0.0, 0.0);
					(layout as HorizontalLayout).gap = 0.0;
				}
			}
	
			super.updateDisplayList();
		}
	}
}