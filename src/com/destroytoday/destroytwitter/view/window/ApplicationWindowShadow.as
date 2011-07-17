package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.display.Scale9Bitmap;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ApplicationWindowShadow extends SpritePlus
	{
		[Embed(source='/assets/window_shadow.png', mimeType='image/png')]
		protected static const SHADOW_BITMAP:Class;
		
		public var bitmap:Scale9Bitmap;
		
		public function ApplicationWindowShadow()
		{
			bitmap = addChild(new Scale9Bitmap()) as Scale9Bitmap;
			
			bitmap.setup((new SHADOW_BITMAP() as Bitmap).bitmapData, new Rectangle(20.0, 20.0, 24.0, 24.0));
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			bitmap.setSize(width, height);
		}
		
		override protected function addedToStageHandler(event:Event):void
		{
			stage.nativeWindow.addEventListener(Event.ACTIVATE, windowActivateHandler);
			stage.nativeWindow.addEventListener(Event.DEACTIVATE, windowDeactivateHandler);
		}
		
		protected function windowActivateHandler(event:Event):void
		{
			TweenManager.to(this, {alpha: 1.0}, 0.5);
		}
		
		protected function windowDeactivateHandler(event:Event):void
		{
			TweenManager.to(this, {alpha: 0.5}, 0.5);
		}
	}
}