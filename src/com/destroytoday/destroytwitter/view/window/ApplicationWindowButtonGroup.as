package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.HorizontalLayout;
	import com.destroytoday.util.ApplicationUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ApplicationWindowButtonGroup extends DisplayGroup
	{
		// ------------------------------------------------------------
		// 
		// Assets
		// 
		// ------------------------------------------------------------
		
		//--------------------------------------
		// Mac 
		//--------------------------------------
		
		[Embed(source="/assets/mac_minimize_over.png", mimeType="image/png")]
		protected static const MAC_MINIMIZE_OVER_BITMAP:Class;
		
		[Embed(source="/assets/mac_minimize_out.png", mimeType="image/png")]
		protected static const MAC_MINIMIZE_UP_BITMAP:Class;
		
		[Embed(source="/assets/mac_maximize_over.png", mimeType="image/png")]
		protected static const MAC_MAXIMIZE_OVER_BITMAP:Class;
		
		[Embed(source="/assets/mac_maximize_out.png", mimeType="image/png")]
		protected static const MAC_MAXIMIZE_UP_BITMAP:Class;
		
		[Embed(source="/assets/mac_close_over.png", mimeType="image/png")]
		protected static const MAC_CLOSE_OVER_BITMAP:Class;
		
		[Embed(source="/assets/mac_close_out.png", mimeType="image/png")]
		protected static const MAC_CLOSE_UP_BITMAP:Class;
		
		[Embed(source="/assets/mac_inactive.png", mimeType="image/png")]
		protected static const MAC_INACTIVE_BITMAP:Class;
		
		//--------------------------------------
		// PC 
		//--------------------------------------
		
		[Embed(source="/assets/images/pc_minimize.png", mimeType="image/png")]
		protected static const PC_MINIMIZE_BITMAP:Class;
		
		[Embed(source="/assets/images/pc_maximize.png", mimeType="image/png")]
		protected static const PC_MAXIMIZE_BITMAP:Class;
		
		[Embed(source="/assets/images/pc_close.png", mimeType="image/png")]
		protected static const PC_CLOSE_BITMAP:Class;
		
		// ------------------------------------------------------------
		// 
		// Instances
		// 
		// ------------------------------------------------------------
		
		public var macMinimizeButton:ApplicationWindowButton;
		
		public var macMaximizeButton:ApplicationWindowButton;
		
		public var macCloseButton:ApplicationWindowButton;
		
		public var pcMinimizeButton:BitmapButton;

		public var pcMaximizeButton:BitmapButton;
		
		public var pcCloseButton:BitmapButton;
		
		// ------------------------------------------------------------
		// 
		// Properties
		// 
		// ------------------------------------------------------------
		
		protected var mouseOver:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ApplicationWindowButtonGroup()
		{
			super(new HorizontalLayout());
			
			if (ApplicationUtil.mac)
			{
				macCloseButton = addChild(new ApplicationWindowButton(
					(new MAC_CLOSE_UP_BITMAP() as Bitmap).bitmapData, 
					(new MAC_CLOSE_OVER_BITMAP() as Bitmap).bitmapData, 
					(new MAC_INACTIVE_BITMAP() as Bitmap).bitmapData)
				) as ApplicationWindowButton;
				macMinimizeButton = addChild(new ApplicationWindowButton(
					(new MAC_MINIMIZE_UP_BITMAP() as Bitmap).bitmapData, 
					(new MAC_MINIMIZE_OVER_BITMAP() as Bitmap).bitmapData, 
					(new MAC_INACTIVE_BITMAP() as Bitmap).bitmapData)
				) as ApplicationWindowButton;
				macMaximizeButton = addChild(new ApplicationWindowButton(
					(new MAC_MAXIMIZE_UP_BITMAP() as Bitmap).bitmapData,
					(new MAC_MAXIMIZE_OVER_BITMAP() as Bitmap).bitmapData, 
					(new MAC_INACTIVE_BITMAP() as Bitmap).bitmapData)
				) as ApplicationWindowButton;
				
				addEventListener(MouseEvent.MOUSE_OVER, macMouseOverHandler);
				addEventListener(MouseEvent.MOUSE_OUT, macMouseOutHandler);
			}
			else
			{
				pcMinimizeButton = addChild(new BitmapButton(new PC_MINIMIZE_BITMAP() as Bitmap)) as BitmapButton;
				pcMaximizeButton = addChild(new BitmapButton(new PC_MAXIMIZE_BITMAP() as Bitmap)) as BitmapButton;
				pcCloseButton = addChild(new BitmapButton(new PC_CLOSE_BITMAP() as Bitmap)) as BitmapButton;
			}
			
			(layout as HorizontalLayout).gap = 4.0;
			
			tabEnabled = false;
			buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		// ------------------------------------------------------------
		// 
		// Invalidation
		// 
		// ------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(0xFF0099, 0.0);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
		}
		
		// ------------------------------------------------------------
		// 
		// Handlers
		// 
		// ------------------------------------------------------------
		
		override protected function addedToStageHandler(event:Event):void
		{
			super.addedToStageHandler(event);
			
			if (ApplicationUtil.mac)
			{
				stage.nativeWindow.addEventListener(Event.ACTIVATE, windowActivateHandler);
				stage.nativeWindow.addEventListener(Event.DEACTIVATE, windowDeactivateHandler);
			}
		}
		
		protected function windowActivateHandler(event:Event):void
		{
			macMinimizeButton.state = macMaximizeButton.state = macCloseButton.state = (mouseOver) ? ButtonState.MOUSE_OVER : ButtonState.MOUSE_UP;
		}
		
		protected function windowDeactivateHandler(event:Event):void
		{
			macMinimizeButton.state = macMaximizeButton.state = macCloseButton.state = ButtonState.INACTIVE;
		}
		
		protected function macMouseOverHandler(event:MouseEvent):void
		{
			mouseOver = true;
			
			macMinimizeButton.state = macMaximizeButton.state = macCloseButton.state = ButtonState.MOUSE_OVER;
		}
		
		protected function macMouseOutHandler(event:MouseEvent):void
		{
			mouseOver = false;
			
			macMinimizeButton.state = macMaximizeButton.state = macCloseButton.state = (stage.nativeWindow.active) ? ButtonState.MOUSE_UP : ButtonState.INACTIVE;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
	}
}