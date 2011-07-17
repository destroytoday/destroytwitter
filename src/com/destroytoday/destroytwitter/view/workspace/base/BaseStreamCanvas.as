package com.destroytoday.destroytwitter.view.workspace.base
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.FontSizeType;
	import com.destroytoday.destroytwitter.constants.ScrollType;
	import com.destroytoday.destroytwitter.constants.StreamState;
	import com.destroytoday.destroytwitter.constants.TwitterElementHeight;
	import com.destroytoday.destroytwitter.constants.TwitterElementType;
	import com.destroytoday.destroytwitter.constants.UnreadFormat;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.model.vo.IStreamVO;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.FailWhaleButton;
	import com.destroytoday.destroytwitter.view.workspace.MessagesCanvas;
	import com.destroytoday.destroytwitter.view.workspace.StreamCanvasContent;
	import com.destroytoday.destroytwitter.view.workspace.StreamElement;
	import com.destroytoday.destroytwitter.view.workspace.components.PageButtonGroup;
	import com.destroytoday.pool.ObjectWaterpark;
	import com.destroytoday.util.DisplayObjectUtil;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quadratic;
	
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;
	
	public class BaseStreamCanvas extends BaseCanvas
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const selectedIndexChanged:Signal = new Signal(int);
		
		public const keyEnabledChanged:Signal = new Signal(Boolean);
		
		public const completedScroll:Signal = new Signal();
		
		public const renderedElements:Signal = new Signal();
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var failWhale:FailWhaleButton;
		
		public var pageButtonGroup:PageButtonGroup;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _elementHeight:Number = 0.0;
		
		protected var _dataProvider:Array;
		
		protected var scrollTween:GTween;
		
		protected var _state:String;
		
		protected var numNewElements:int;
		
		protected var _numVisibleElements:Number;
		
		protected var numInvisibleElements:Number;
		
		protected var topStatusIndex:int;
		
		protected var prevTopStatusIndex:int = -1;
		
		protected var _selectedIndex:int = -2; // -1 is the top buffer status
		
		protected var _numUnread:int;
		
		protected var _keyEnabled:Boolean;
		
		protected var _fontType:String;
		
		protected var _fontSize:String;

		protected var _iconType:String;
		
		protected var _timeFormat:String;
		
		protected var _userFormat:String;

		protected var _unreadFormat:String;

		protected var _allowSelection:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyHeightFlag:Boolean;
		
		protected var dirtyDataFlag:Boolean;
		
		protected var dirtySelectedFlag:Boolean;
		
		protected var dirtyFontTypeFlag:Boolean;
		
		protected var dirtyFontSizeFlag:Boolean;

		protected var dirtyIconTypeFlag:Boolean;
		
		protected var dirtyTimeFormatFlag:Boolean;
		
		protected var dirtyUserFormatFlag:Boolean;

		protected var dirtyUnreadFormatFlag:Boolean;

		protected var dirtyAllowSelectionFlag:Boolean;
		
		protected var dirtyKeyEnabledFlag:Boolean;
		
		protected var dirtyScrollFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BaseStreamCanvas()
		{
			pageButtonGroup = addChild(new PageButtonGroup()) as PageButtonGroup;
			failWhale = addChild(new FailWhaleButton(new (Asset.FAIL_WHALE)() as Bitmap)) as FailWhaleButton;
			content = addChild(new StreamCanvasContent()) as StreamCanvasContent;
			
			DisplayObjectUtil.sendToBack(pageButtonGroup);
			pageButtonGroup.setConstraints(NaN, 10.0, 6.0, NaN);
			failWhale.setConstraints(NaN, 7.0, 78.0, NaN);
			content.setConstraints(0.0, 35.0, 15.0, 0.0);
			
			failWhale.alpha = 0.0;
			failWhale.visible = false;
			failWhale.displayed = false;
			
			scroller.track.addEventListener(MouseEvent.MOUSE_DOWN, scrollerTrackMouseDownHandler);
			
			scroller.scrollValueChanged.add(scrollValueChangedHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			dirtyHeightFlag = true;
		}
		
		public function get keyEnabled():Boolean
		{
			return _keyEnabled;
		}
		
		public function set keyEnabled(value:Boolean):void
		{
			if (value == _keyEnabled) return;
					
			_keyEnabled = value;
					
			if (_keyEnabled) {
				stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			} else {
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			
			dirtyKeyEnabledFlag = true;
			invalidateProperties();
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if (value == _selectedIndex) return;
			
			_selectedIndex = value;

			dirtySelectedFlag = true;
			invalidateProperties();
			
			selectedIndexChanged.dispatch(_selectedIndex);
		}
		
		public function get selectedData():IStreamVO
		{
			return (hasSelection) ? _dataProvider[_selectedIndex] : null;
		}
		
		public function get selectedElement():StreamElement
		{
			var realIndex:int = 1 + _selectedIndex - topStatusIndex;
			
			return (hasSelection && realIndex >= 0 && realIndex < content.numChildren) ? content.getChildAt(realIndex) as StreamElement : null;
		}
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		public function get numVisibleStatuses():int
		{
			return _numVisibleElements;
		}
		
		public function get hasSelection():Boolean
		{
			return _selectedIndex >= 0 && _selectedIndex < _dataProvider.length;
		}
		
		public function get numUnread():int
		{
			return _numUnread;
		}
		
		public function set numUnread(value:int):void
		{
			_numUnread = value;
			
			if (_unreadFormat != UnreadFormat.NO_HIGHLIGHT && value > 0)
			{
				titleText = "<a href=\"event:unread\"><span class=\"unread\">" + value + "</span></a>";
			}
			else
			{
				titleText = "";
			}
		}
		
		/*public function get elementHeight():Number
		{
			return _elementHeight;
		}
		
		public function set elementHeight(value:Number):void
		{
			if (value == _elementHeight) return;
			
			_elementHeight = value;
			
			invalidateDisplayList();
		}*/
		
		public function get fontSize():String
		{
			return _fontSize;
		}
		
		public function set fontSize(value:String):void
		{
			if (value == _fontSize) return;
			
			_fontSize = value;
			
			dirtyFontSizeFlag = true;
			dirtyHeightFlag = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get fontType():String
		{
			return _fontType;
		}
		
		public function set fontType(value:String):void
		{
			if (value == _fontType) return;
			
			_fontType = value;
			
			dirtyFontTypeFlag = true;
			invalidateProperties();
		}
		
		public function get iconType():String
		{
			return _iconType;
		}
		
		public function set iconType(value:String):void
		{
			if (value == _iconType) return;
			
			_iconType = value;
			
			dirtyIconTypeFlag = true;
			invalidateProperties();
		}
		
		public function get timeFormat():String
		{
			return _timeFormat;
		}
		
		public function set timeFormat(value:String):void
		{
			if (value == _timeFormat) return;
			
			_timeFormat = value;
			
			dirtyTimeFormatFlag = true;
			invalidateProperties();
		}
		
		public function get userFormat():String
		{
			return _userFormat;
		}
		
		public function set userFormat(value:String):void
		{
			if (value == _userFormat) return;
			
			_userFormat = value;
			
			dirtyUserFormatFlag = true;
			invalidateProperties();
		}
		
		public function get unreadFormat():String
		{
			return _unreadFormat;
		}
		
		public function set unreadFormat(value:String):void
		{
			if (value == _unreadFormat) return;
			
			_unreadFormat = value;
			numUnread = _numUnread; // refresh count
			
			dirtyUnreadFormatFlag = true;
			invalidateProperties();
		}
		
		public function get allowSelection():Boolean
		{
			return _allowSelection;
		}
		
		public function set allowSelection(value:Boolean):void
		{
			if (value == _allowSelection) return;
			
			_allowSelection = value;
			
			dirtyAllowSelectionFlag = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function setData(state:String, statusList:Array, newStatusesList:Array):void
		{
			_state = state;
			_dataProvider = statusList;
			numNewElements = (newStatusesList) ? newStatusesList.length : 0;
			_selectedIndex = (_selectedIndex != -2 && newStatusesList) ? _selectedIndex + numNewElements : -2;
			
			if (_selectedIndex > _dataProvider.length - 1) _selectedIndex = -2;
			
			dirtyDataFlag = true;
			
			pageButtonGroup.state = _state;
			
			invalidateDisplayList();
		}
		
		public function selectPreviousUnreadElement():void
		{
			if (_selectedIndex <= 0 || !dataProvider || dataProvider.length == 0) return;
			
			var m:uint = dataProvider.length;
			
			for (var i:int = _selectedIndex; i >= 0; --i)
			{
				if (i < dataProvider.length && !(dataProvider[i] as IStreamVO).read)
				{
					selectElementAt(i);
					break;
				}
			}
		}
		
		public function selectNextUnreadElement():void
		{
			if (!dataProvider || dataProvider.length == 0 || _selectedIndex >= dataProvider.length - 1) return;
			
			var m:uint = dataProvider.length;
			
			for (var i:int = _selectedIndex; i < m; ++i)
			{
				if (i >= 0 && !(dataProvider[i] as IStreamVO).read)
				{
					selectElementAt(i);
					break;
				}
			}
		}
		
		public function selectElementAt(index:int):void
		{
			if (!dataProvider || dataProvider.length == 0) return;

			//if (_selectedIndex == -2) index = 0; // if nothing is selected, select the first status
			
			index = Math.max(0, Math.min(dataProvider.length - 1, index));
			
			if (scrollTween && scrollTween.position < 0.2) return;

			var y:Number = index * (_elementHeight + 1.0) - (content.height - _elementHeight) * 0.5;
			var scrollValue:Number = y / (content.measuredHeight - content.height);

			if (Math.abs(index - _selectedIndex) <= 10) { // if it's a small jump, scroll smoothly
				scrollTo(scrollValue, false);
			} else {
				scroller.scrollValue = scrollValue;
			}

			selectedIndex = index;
			
			if (!scrollTween && completedScroll.numListeners > 0)
			{
				validateNow();
				
				completedScroll.dispatch();
			}
		}
		
		public function scrollTo(value:Number, allowOverride:Boolean = true):void
		{
			scrollTween = TweenManager.to(scroller, {scrollValue: value}, 0.35, Quadratic.easeOut, (!allowOverride ? scrollTweenCompleteHandler : null));
		
			if (allowOverride) scrollTween = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		/*override public function invalidateDisplayList():void
		{
			if (this is MessagesCanvas && !invalidateDisplayListFlag)
			{
				trace("whaaa");
			}
			super.invalidateDisplayList();
		}*/
		
		public function dirtyGraphics():void
		{
			var element:StreamElement;
			var m:uint = content.numChildren;
			
			for (var i:uint = 0; i < m; i++) {
				element = content.getChildAt(i) as StreamElement;
				
				element.dirtyGraphics();
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			var i:uint, m:uint;
			var element:StreamElement;
			
			if (dirtyScrollFlag)
			{
				dirtyScrollFlag = false;

				if (stage.focus)
				{
					for (i = 0, m = content.numChildren; i < m; i++) {
						element = content.getChildAt(i) as StreamElement;
						
						if (stage.focus == element.textfield) stage.focus = null;
					}
				}
			}
			
			if (dirtySelectedFlag) {
				m = content.numChildren;
				
				for (i = 0; i < m; i++) {
					element = content.getChildAt(i) as StreamElement;
					
					element.selected = (element.n == _selectedIndex);
				}
				
				dirtySelectedFlag = false;
			}
			
			if (dirtyFontTypeFlag || dirtyFontSizeFlag || dirtyIconTypeFlag || dirtyTimeFormatFlag || dirtyUserFormatFlag || dirtyUnreadFormatFlag || dirtyAllowSelectionFlag)
			{
				m = content.numChildren;
				
				for (i = 0; i < m; i++) {
					element = content.getChildAt(i) as StreamElement;
					
					if (dirtyFontTypeFlag) element.fontType = _fontType;
					if (dirtyFontSizeFlag) element.fontSize = _fontSize;
					if (dirtyIconTypeFlag) element.iconType = _iconType;
					if (dirtyTimeFormatFlag) element.timeFormat = _timeFormat;
					if (dirtyUserFormatFlag) element.userFormat = _userFormat;
					if (dirtyUnreadFormatFlag) element.unreadFormat = _unreadFormat;
					if (dirtyAllowSelectionFlag) element.allowSelection = _allowSelection;
				}
				
				dirtyFontTypeFlag = false;
				dirtyIconTypeFlag = false;
				dirtyTimeFormatFlag = false;
				dirtyUserFormatFlag = false;
				dirtyUnreadFormatFlag = false;
				dirtyAllowSelectionFlag = false;
			}
			
			if (dirtyFontSizeFlag)
			{
				dirtyFontSizeFlag = false;
				
				if (_fontSize == FontSizeType.SMALL && !(this is MessagesCanvas))
				{
					_elementHeight = TwitterElementHeight.STATUS_FONT_SIZE_ELEVEN;
				}
				else if (_fontSize == FontSizeType.SMALL)
				{
					_elementHeight = TwitterElementHeight.MESSAGE_FONT_SIZE_ELEVEN;
				}
				else if (_fontSize == FontSizeType.MEDIUM && !(this is MessagesCanvas))
				{
					_elementHeight = TwitterElementHeight.STATUS_FONT_SIZE_THIRTEEN;
				}
				else if (_fontSize == FontSizeType.MEDIUM)
				{
					_elementHeight = TwitterElementHeight.MESSAGE_FONT_SIZE_THIRTEEN;
				}
				else if (_fontSize == FontSizeType.LARGE)
				{
					_elementHeight = TwitterElementHeight.FONT_SIZE_FOURTEEN;
				}
			}
			
			if (dirtyKeyEnabledFlag)
			{
				dirtyKeyEnabledFlag = false;
				
				keyEnabledChanged.dispatch(_keyEnabled);
			}

			if (_dataProvider && !invalidateDisplayListFlag) refresh();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (!_dataProvider) {
				scroller.enabled = false;
				content.measuredHeight = 0.0;
				
				return;
			}

			if (dirtyHeightFlag || dirtyDataFlag)
			{
				dirtyHeightFlag = false;
				
				_numVisibleElements = (scroller.height / (_elementHeight + 1.0));
				scroller.enabled = _numVisibleElements < _dataProvider.length;
				content.measuredHeight = (_elementHeight + 1.0) * _dataProvider.length - 1.0;
				
				var numUsedStatuses:int = Math.ceil(_numVisibleElements) + 2; // + 2 for buffer
				var numPrevUsedStatuses:int = content.numChildren;
				
				var element:StreamElement;
				var i:uint, m:uint;
				
				if (numUsedStatuses > numPrevUsedStatuses) 
				{
					m = numUsedStatuses - numPrevUsedStatuses;

					for (i = 0; i < m; i++) {
						element = content.addChild(ObjectWaterpark.getObject(StreamElement) as StreamElement) as StreamElement;
						
						element.type = (this is MessagesCanvas) ? TwitterElementType.MESSAGE : TwitterElementType.STATUS;
						element.fontType = _fontType;
						element.fontSize = _fontSize;
						element.iconType = _iconType;
						element.userFormat = _userFormat;
						element.timeFormat = _timeFormat;
						element.unreadFormat = _unreadFormat;
						element.allowSelection = _allowSelection;
						
						element.addEventListener(MouseEvent.MOUSE_DOWN, statusMouseDownHandler);
					}
				} 
				else if (numUsedStatuses < numPrevUsedStatuses) 
				{
					m = numPrevUsedStatuses - numUsedStatuses;
					
					for (i = 0; i < m; i++) {
						element = content.removeChildAt(content.numChildren - 1) as StreamElement;
						
						element.removeEventListener(MouseEvent.MOUSE_DOWN, statusMouseDownHandler);
						
						ObjectWaterpark.disposeObject(element);
					}
				}
				
				numInvisibleElements = Math.max(0, _dataProvider.length - _numVisibleElements);
				prevTopStatusIndex = -1; // instead of a force flag
				
				content.validateNow();
				scroller.validateNow();
				
				if (dirtyDataFlag) {
					if (_state == StreamState.REFRESH && scroller.scrollValue == 0.0) { // roll in
						scroller.scrollValue = numNewElements / (_dataProvider.length - _numVisibleElements);
						
						scrollTo(0.0);
					} else if (_state != StreamState.REFRESH) { // reset
						//unselectTweet ();
						
						scroller.scrollValue = 0.0;
					} else { // match previous scroll position
						scroller.scrollValue += numNewElements / (_dataProvider.length - _numVisibleElements);
					}
					
					dirtyDataFlag = false;
				}
				
				refresh();
			}
		}
		
		protected function refresh():void //TODO rename
		{
			var i:uint, m:uint;
			var element:StreamElement;
			
			if (_dataProvider.length == 0) {
				m = content.numChildren;
				
				for (i = 0; i < m; i++) {
					element = content.getChildAt(i) as StreamElement;
					
					element.data = null;
				}
				
				return;
			}
			
			topStatusIndex = Math.round(numInvisibleElements * scroller.scrollValue);
			
			content.scrollY = (_elementHeight + 1) * (1 + (numInvisibleElements * scroller.scrollValue) - topStatusIndex);

			if (topStatusIndex != prevTopStatusIndex) { // add force for resizing
				m = content.numChildren;
				
				for (i = 0; i < m; i++) {
					element = content.getChildAt(i) as StreamElement;
					
					var n:int = Math.round(numInvisibleElements * scroller.scrollValue) + i - 1;
					
					if (n > -1 && n < _dataProvider.length) {
						element.n = n;
						
						element.data = _dataProvider[n] as GeneralTwitterVO;
					} else {
						element.data = null; 
					}
					
					element.selected = (element.n == _selectedIndex);
				}
				
				renderedElements.dispatch();
			}
			
			prevTopStatusIndex = topStatusIndex;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function scrollValueChangedHandler(type:String, scrollValue:Number):void
		{
			if (type != ScrollType.RESIZE)
			{
				dirtyScrollFlag = true;
				
				invalidateProperties();
			}
		}
		
		protected function statusMouseDownHandler(event:MouseEvent):void
		{
			selectedIndex = (event.currentTarget as StreamElement).n;
		}
		
		protected function scrollTweenCompleteHandler(tween:GTween):void
		{
			TweenManager.disposeTween(tween);
			
			scrollTween = null;
			
			completedScroll.dispatch();
		}
		
		protected function scrollerTrackMouseDownHandler(event:MouseEvent):void
		{
			if (event.localY < scroller.thumb.y) {
				selectElementAt(_selectedIndex - Math.ceil(_numVisibleElements));
			} else if (event.localY > scroller.thumb.y) {
				selectElementAt(_selectedIndex + Math.ceil(_numVisibleElements));
			}
		}
		
		protected function keyUpHandler(event:KeyboardEvent):void
		{
			if (scrollTween) 
			{
				scrollTween = null;
			}
		}
	}
}