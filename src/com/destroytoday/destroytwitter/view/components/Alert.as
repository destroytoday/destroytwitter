package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.text.TextFieldPlus;
	import com.gskinner.motion.GTween;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	public class Alert extends SpritePlus
	{
		public var textfield:TextFieldPlus;
		
		protected var _backgroundColor:uint;
		
		protected var bounds:Rectangle = new Rectangle();
		
		protected var _displayed:Boolean;
		
		protected var contentHeight:Number = 0.0;
		
		public function Alert()
		{
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;
			
			textfield.x = 8.0;
			textfield.y = 10.0;
			
			tabEnabled = false;
			buttonMode = true;
			mouseChildren = false;
			
			height = 0.0;
		}
		
		public function get maskHeight():Number
		{
			return bounds.height;
		}

		public function set maskHeight(value:Number):void
		{
			if (value == bounds.height) return;
			
			bounds.height = value;
			
			scrollRect = bounds;
		}

		public function get displayed():Boolean
		{
			return _displayed;
		}

		public function set displayed(value:Boolean):void
		{
			_displayed = value;

			var onComplete:Function;
			
			if (_displayed) {
				visible = true;
			} else {
				onComplete = hideCompleteHandler;
			}
			
			TweenManager.to(this, {maskHeight: (_displayed) ? contentHeight : 0.0}, 0.75, null, onComplete);
		}

		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			if (value == _backgroundColor) return;
			
			_backgroundColor = value;
			
			invalidateSize();
		}
		
		public function get text():String
		{
			return textfield.htmlText;
		}
		
		public function set text(value:String):void
		{
			textfield.width = width - (textfield.x * 2.0);
			textfield.htmlText = value;
			contentHeight = Math.round((textfield.y * 2.0) + textfield.height - 3.0);

			invalidateSize();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			height = Math.max(height, contentHeight);
			
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(_backgroundColor);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
			
			bounds.width = width;
			scrollRect = bounds;
		}
		
		protected function hideCompleteHandler(tween:GTween):void
		{
			TweenManager.disposeTween(tween);
			
			visible = false;
		}
	}
}