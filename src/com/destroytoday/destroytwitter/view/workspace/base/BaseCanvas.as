package com.destroytoday.destroytwitter.view.workspace.base
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.constants.ScrollType;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.destroytwitter.view.workspace.components.Scroller;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	public class BaseCanvas extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var title:TextFieldPlus;
		
		public var spinner:Spinner;
		
		public var scroller:Scroller;
		
		public var content:BaseCanvasContent;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _backgroundColor:uint;
		
		protected var _titleText:String;
		
		protected var bounds:Rectangle = new Rectangle();
		
		protected var displayName:String;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyGraphicsFlag:Boolean;
		
		protected var dirtyTitleFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Construction
		//
		//--------------------------------------------------------------------------
		
		public function BaseCanvas()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			
			title = addChild(new TextFieldPlus()) as TextFieldPlus;
			spinner = addChild(new Spinner()) as Spinner;
			scroller = addChild(new Scroller()) as Scroller;
			
			//--------------------------------------
			//  set properties
			//--------------------------------------
			
			title.autoSize = TextFieldAutoSize.LEFT;
			spinner.buttonMode = true;
			
			title.x = 4.0;
			title.y = 7.0;
			
			scroller.width = 14.0;
			
			spinner.setConstraints(NaN, 8.0, 7.0, NaN);
			scroller.setConstraints(NaN, 35.0, 0.0, 0.0);
			
			width = 324.0;
			
			//--------------------------------------
			//  add listeners
			//--------------------------------------
			
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		override public function set name(value:String):void
		{
			super.name = value;
			
			displayName = value.substr(0.0, 1.0).toUpperCase() + value.substr(1.0);
			titleText = "";
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
		
		public function get titleText():String
		{
			return _titleText;
		}
		
		public function set titleText(value:String):void
		{
			if (value == _titleText) return;
			
			_titleText = "<p><span class=\"title\">" + displayName + "</span> " + value + "</p>";
			
			dirtyTitleFlag = true;
			invalidateDisplayList();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			bounds.width = width;
			bounds.height = height;
			scrollRect = bounds;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyTitleFlag)
			{
				dirtyTitleFlag = false;
				
				title.htmlText = _titleText;
			}
			
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
		
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			if (scroller.enabled) {
				scroller.setScrollValue(ScrollType.MOUSE_WHEEL, scroller.scrollValue - (event.delta / (content.measuredHeight * 0.05)));
			}
		}
	}
}