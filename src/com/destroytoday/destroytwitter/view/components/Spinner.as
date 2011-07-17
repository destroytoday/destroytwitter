package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.destroytwitter.controller.FramerateController;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.display.SpritePlus;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quadratic;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Spinner extends SpritePlus
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var spinner:Sprite;
		
		protected var _mask:Shape;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _color:uint;
		
		protected var _displayed:Boolean;
		
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
		
		public function Spinner()
		{
			spinner = addChild(new Sprite()) as Sprite;
			_mask = spinner.addChild(new Shape()) as Shape;
			
			width = 18.0;
			height = 18.0;
			visible = false;
			alpha = 0.0;
			
			var graphics:Graphics = this.graphics;
			
			graphics.beginFill(0xFF0099, 0.0);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
			
			spinner.mask = _mask;
			
			graphics = _mask.graphics;
			
			graphics.beginFill(0xFF0099);
			graphics.moveTo(0.0, 0.0);
			graphics.lineTo(-9.0, -9.0);
			graphics.lineTo(9.0, -9.0);
			graphics.lineTo(9.0, 9.0);
			graphics.lineTo(0.0, 9.0);
			graphics.lineTo(0.0, 0.0);
			graphics.endFill();
			
			spinner.x = 9.0;
			spinner.y = 9.0;
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
			
			var onComplete:Function;
			
			if (!_displayed) {
				FramerateController.getInstance().removeAnimation();
				
				onComplete = hideHandler;
			} else {
				FramerateController.getInstance().addAnimation();
				
				addEventListener(Event.ENTER_FRAME, enterframeHandler);
			}
			
			TweenManager.to(this, {alpha: (_displayed) ? 1.0 : 0.0}, 0.5, null, onComplete);
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			if (value == _color) return;
			
			_color = value;
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			if (dirtyGraphicsFlag)
			{
				dirtyGraphicsFlag = false;
				
				var graphics:Graphics = spinner.graphics;
			
				graphics.clear();
				graphics.beginFill(_color);
				graphics.drawCircle(0.0, 0.0, 9.0);
				graphics.drawCircle(0.0, 0.0, 6.0);
				graphics.endFill();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function enterframeHandler(event:Event):void
		{
			spinner.rotation += 10.0;
		}
		
		protected function hideHandler(tween:GTween):void
		{
			removeEventListener(Event.ENTER_FRAME, enterframeHandler);
			
			TweenManager.disposeTween(tween);
		}
	}
}