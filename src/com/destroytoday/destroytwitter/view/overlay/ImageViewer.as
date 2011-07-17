package com.destroytoday.destroytwitter.view.overlay
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.ProgressSpinner;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.util.BoundsUtil;
	import com.gskinner.motion.GTween;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class ImageViewer extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var content:ImageViewerContent;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _displayed:Boolean;
		
		protected var fittedBounds:Rectangle;
		
		protected var bounds:Rectangle = new Rectangle();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ImageViewer()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			content = addChild(new ImageViewerContent()) as ImageViewerContent;
			
			content.center = 0.0;
			content.middle = -content.bitmap.y;
			
			alpha = 0.0;
			visible = false;
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
			
			TweenManager.to(this, {alpha: (_displayed) ? 1.0 : 0.0}, 0.75, null, (_displayed) ? null : fadeOutCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function load(request:URLRequest):void
		{
			content.loader.load(request);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			bounds.width = width;
			bounds.height = height - content.bitmap.y * 2.0;
			
			if (content.isLoaded)
			{
				fittedBounds = BoundsUtil.getBoundsFitWithin(content.bounds, bounds, false, fittedBounds);
				
				content.width = fittedBounds.width;
				content.height = fittedBounds.height;
			}
			
			super.updateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function fadeOutCompleteHandler(tween:GTween):void
		{
			TweenManager.disposeTween(tween);
			
			if (content.bitmap.bitmapData) 
			{
				content.bitmap.bitmapData.dispose();
				content.bitmap.bitmapData = null;
			}
		}
	}
}