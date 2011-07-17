package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.constants.ScrollType;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.workspace.components.Scroller;
	import com.destroytoday.text.TextFieldPlus;
	import com.gskinner.motion.easing.Quadratic;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	public class TextFieldVirtualList extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var scroller:Scroller;
		
		public var textfield:TextFieldPlus;
		
		public var textfieldMask:Shape;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _dataProvider:Array;
		
		protected var _numVisibleElements:int = 5;
		
		protected var numInvisibleElements:int;
		
		protected var prevTopElementIndex:int;
		
		protected var topElementIndex:int;
		
		protected var scrollBounds:Rectangle = new Rectangle();
		
		protected var _scrollY:Number = 0.0;
		
		protected var textLineHeight:Number = 13.0;
		
		protected var contentHeight:Number = 0.0;
		
		protected var _selectedIndex:int = -2;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyDataProviderFlag:Boolean;
		
		protected var dirtySizeFlag:Boolean;
		
		protected var dirtySelectedIndexFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TextFieldVirtualList()
		{
			super(SingletonManager.getInstance(BasicLayout));
			
			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;
			scroller = addChild(new Scroller()) as Scroller;
			textfieldMask = addChild(new Shape()) as Shape;
			
			//--------------------------------------
			//  set properties
			//--------------------------------------

			var graphics:Graphics = textfieldMask.graphics;
			
			graphics.clear();
			graphics.beginFill(0xFF0099);
			graphics.drawRect(0.0, 0.0, 100.0, 100.0);
			graphics.endFill();
			
			textfield.mask = textfieldMask;
			
			textfield.multiline = true;
			textfield.wordWrap = true;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.heightOffset = 3.0;
			textfield.htmlText = "<p></p>";
			
			scroller.thumb.arrowBounds = new Rectangle(1.0, 2.0, 4.0, 2.0);
			scroller.width = 6.0;
			scroller.setConstraints(NaN, 0.0, 0.0, 0.0);
			scroller.enabled = true;
			
			//--------------------------------------
			//  add listeners
			//--------------------------------------
			
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			scroller.scrollValueChanged.add(scrollValueChangedHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function dirtyTextLineHeight():void
		{
			textLineHeight = textfield.getLineMetrics(0).height;

			invalidateDisplayList();
		}
		
		public function selectElementAt(index:int):void
		{
			if (!dataProvider || dataProvider.length == 0) return;
			
			if (_selectedIndex == -2) index = 0; // if nothing is selected, select the first status
			
			index = Math.max(0, Math.min(dataProvider.length - 1, index));
			
			if (scroller.enabled)
			{
				var y:Number = index * textLineHeight - (textfieldMask.height - textLineHeight) * 0.5;
				var scrollValue:Number = y / (contentHeight - textfieldMask.height);
				
				if (Math.abs(index - _selectedIndex) <= 10) { // if it's a small jump, scroll smoothly
					TweenManager.to(scroller, {scrollValue: scrollValue}, 0.25, Quadratic.easeOut);
				} else {
					scroller.scrollValue = scrollValue;
				}
			}

			selectedIndex = index;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Array):void
		{
			if (value == _dataProvider) return;
			
			_dataProvider = value;
			
			dirtyDataProviderFlag = true;
			invalidateProperties();
		}
		
		public function get scrollY():Number
		{
			return _scrollY;
		}
		
		public function set scrollY(value:Number):void
		{
			if (value == _scrollY) return;
			
			_scrollY = Math.round(value);
			
			textfield.y = -_scrollY;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (value == _selectedIndex) return;
			
			_selectedIndex = value;
			
			dirtySelectedIndexFlag = true;
			invalidateDisplayList();
		}
		
		public function get selectedElement():String
		{
			if (dataProvider && _selectedIndex >= 0 && _selectedIndex < dataProvider.length)
			{
				return dataProvider[_selectedIndex];
			}
			
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dirtyDataProviderFlag)
			{
				invalidateDisplayList();
				
				scroller.scrollValue = 0.0;
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			
			dirtySizeFlag = true;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			if (dirtySizeFlag)
			{
				dirtySizeFlag = false;
				
				textfield.width = width - scroller.width;
				scroller.thumb.height = int(height * .35);
				
				textfieldMask.width = textfield.width;
				textfieldMask.height = scroller.height;
				
				prevTopElementIndex = -1;
			}
			
			if (dirtyDataProviderFlag)
			{
				dirtyDataProviderFlag = false;
				
				scroller.scrollValue = 0.0;
				prevTopElementIndex = -1;
				_selectedIndex = 0;
			}
			
			if (!_dataProvider) {
				textfield.htmlText = "<p></p>";
				
				scroller.enabled = false;
				contentHeight = 0.0;
				
				return;
			}
			
			scroller.enabled = _numVisibleElements < _dataProvider.length;

			numInvisibleElements = Math.max(0, _dataProvider.length - _numVisibleElements);
			
			contentHeight = _dataProvider.length * textLineHeight;
			
			scroller.validateNow();
			
			if (_dataProvider.length == 0) {
				_selectedIndex = -2;
				textfield.htmlText = "<p></p>";
				
				return;
			}
			
			topElementIndex = Math.round(numInvisibleElements * scroller.scrollValue);

			scrollY = textLineHeight * (1 + (numInvisibleElements * scroller.scrollValue) - topElementIndex);

			if (topElementIndex != prevTopElementIndex || dirtySelectedIndexFlag) {
				dirtySelectedIndexFlag = false;
				
				var m:uint = 7;
				
				var text:String = "";
				
				for (var i:uint = 0; i < m; i++) {
					var n:int = Math.round(numInvisibleElements * scroller.scrollValue) + i - 1;

					if (n == _selectedIndex && n > -1 && n < _dataProvider.length) 
					{
						text += "<p><a href=\"event:" + _dataProvider[n] + "\"><span class=\"selected\">" + _dataProvider[n] + "</span></a></p>";
					}
					else if (n > -1 && n < _dataProvider.length)
					{
						text += "<p><a href=\"event:" + _dataProvider[n] + "\">" + _dataProvider[n] + "</a></p>";
					}
					else 
					{
						text += "<p></p>";
					}
				}

				textfield.htmlText = text;
			}

			prevTopElementIndex = topElementIndex;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function scrollValueChangedHandler(type:String, scrollValue:Number):void
		{
			if (type != ScrollType.RESIZE) invalidateDisplayList();
		}
		
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			if (scroller.enabled) {
				scroller.setScrollValue(ScrollType.MOUSE_WHEEL, scroller.scrollValue - (event.delta / (contentHeight * 0.05)));
			}
		}
	}
}