package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.VerticalLayout;
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	public class Dialogue extends BaseDrawerPanel
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var spinner:Spinner;
		
		public var replyStatus:DialogueElement;

		public var originalStatus:DialogueElement;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _borderColor:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtySizeFlag:Boolean;
		
		protected var dirtyGraphicsFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Dialogue(title:LayoutTextField)
		{
			var layout:VerticalLayout = new VerticalLayout();

			layout.paddingTop = -8.0;
			layout.gap = 1.0;
			
			super(title, layout);
			
			replyStatus = addChild(new DialogueElement()) as DialogueElement;
			originalStatus = addChild(new DialogueElement()) as DialogueElement;
			spinner = addChild(new Spinner()) as Spinner;
			
			replyStatus.visible = false;
			originalStatus.visible = false;
			spinner.includeInLayout = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible) title.htmlText = "<p><span class=\"title\">Dialogue</span></p>";
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
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		public function dirtySize():void
		{
			dirtySizeFlag = true;
			
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtySizeFlag)
			{
				spinner.x = title.width + 10.0;
				spinner.y = -y + title.y + 1.0;

				height = replyStatus.height + originalStatus.height;
			}
			
			if (dirtyGraphicsFlag || dirtySizeFlag)
			{
				dirtyGraphicsFlag = false;
				dirtySizeFlag = false;
				
				var graphics:Graphics = this.graphics;

				graphics.clear();
				graphics.lineStyle(0.0, _borderColor, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
				graphics.moveTo(0.0, replyStatus.y + replyStatus.height - 1.0);
				graphics.lineTo(width, replyStatus.y + replyStatus.height - 1.0);
			}
			
			invalidateSizeFlag = false;
			invalidateDisplayListFlag = false;
		}
	}
}