package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.constants.UnreadFormat;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.model.vo.IStreamVO;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.MouseEvent;
	
	public class StreamElement extends TwitterElement
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _indicatorColor:uint;
		
		protected var borderColor:uint;
		
		protected var _borderUpColor:uint;
		
		protected var _borderSelectedUpColor:uint;
		
		protected var _borderSelectedOverColor:uint;
		
		protected var backgroundColor:uint;
		
		protected var _backgroundUpColor:uint;
		
		protected var _backgroundOverColor:uint;

		/*protected var _replyBackgroundUpColor:uint;

		protected var _replyBackgroundOverColor:uint;*/
		
		protected var _backgroundSelectedUpColor:uint;
		
		protected var _backgroundSelectedOverColor:uint;

		protected var _backgroundUnreadColor:uint;
		
		protected var _selected:Boolean;
		
		protected var _allowSelection:Boolean;
		
		public var n:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamElement()
		{
			userIconButton.x = 8.0;
			userIconButton.y = 8.0;
			
			autoSize = false;
			visible = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set data(value:GeneralTwitterVO):void
		{
			if (value == _data) return;
			
			super.data = value;
			
			if (!value) 
			{
				n = -1;	
			}
			
			dirtyGraphicsFlag = true;
			invalidateProperties();
			validateNow();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value == _selected) return;
					
			_selected = value;
					
			if (_selected && _state == ButtonState.MOUSE_OVER) {
				state = ButtonState.SELECTED_OVER;
			} else if (_selected) {
				state = ButtonState.SELECTED_UP;
			} else if (_state == ButtonState.SELECTED_OVER) {
				state = ButtonState.MOUSE_OVER;
			} else {
				state = ButtonState.MOUSE_UP;
			}
			
			validateNow(); // because we're in the middle of a render
		}
		
		public function get allowSelection():Boolean
		{
			return _allowSelection;
		}
		
		public function set allowSelection(value:Boolean):void
		{
			if (value == _allowSelection) return;
			
			_allowSelection = value;
			
			invalidateProperties();
		}

		public function get indicatorColor():uint
		{
			return _indicatorColor;
		}

		public function set indicatorColor(value:uint):void
		{
			if (value == _indicatorColor) return;
			
			_indicatorColor = value;
			
			invalidateProperties();
		}
		
		public function get borderUpColor():uint
		{
			return _borderUpColor;
		}
		
		public function set borderUpColor(value:uint):void
		{
			if (value == _borderUpColor) return;
			
			_borderUpColor = value;
			
			invalidateProperties();
		}

		public function get borderSelectedUpColor():uint
		{
			return _borderSelectedUpColor;
		}

		public function set borderSelectedUpColor(value:uint):void
		{
			if (value == _borderSelectedUpColor) return;
			
			_borderSelectedUpColor = value;
			
			invalidateProperties();
		}
		
		public function get borderSelectedOverColor():uint
		{
			return _borderSelectedOverColor;
		}
		
		public function set borderSelectedOverColor(value:uint):void
		{
			if (value == _borderSelectedOverColor) return;
			
			_borderSelectedOverColor = value;
			
			invalidateProperties();
		}

		public function get backgroundUpColor():uint
		{
			return _backgroundUpColor;
		}

		public function set backgroundUpColor(value:uint):void
		{
			if (value == _backgroundUpColor) return;
			
			_backgroundUpColor = value;
			
			invalidateProperties();
		}

		public function get backgroundOverColor():uint
		{
			return _backgroundOverColor;
		}

		public function set backgroundOverColor(value:uint):void
		{
			if (value == _backgroundOverColor) return;
			
			_backgroundOverColor = value;
			
			invalidateProperties();
		}
		
		/*public function get replyBackgroundUpColor():uint
		{
			return _replyBackgroundUpColor;
		}

		public function set replyBackgroundUpColor(value:uint):void
		{
			if (value == _replyBackgroundUpColor) return;
			
			_replyBackgroundUpColor = value;
			
			invalidateProperties();
		}

		public function get replyBackgroundOverColor():uint
		{
			return _replyBackgroundOverColor;
		}

		public function set replyBackgroundOverColor(value:uint):void
		{
			if (value == _replyBackgroundOverColor) return;
			
			_replyBackgroundOverColor = value;
			
			invalidateProperties();
		}*/

		public function get backgroundSelectedUpColor():uint
		{
			return _backgroundSelectedUpColor;
		}

		public function set backgroundSelectedUpColor(value:uint):void
		{
			if (value == _backgroundSelectedUpColor) return;
			
			_backgroundSelectedUpColor = value;
			
			invalidateProperties();
		}
		
		public function get backgroundSelectedOverColor():uint
		{
			return _backgroundSelectedOverColor;
		}
		
		public function set backgroundSelectedOverColor(value:uint):void
		{
			if (value == _backgroundSelectedOverColor) return;
			
			_backgroundSelectedOverColor = value;
			
			invalidateProperties();
		}
		
		public function get backgroundUnreadColor():uint
		{
			return _backgroundUnreadColor;
		}
		
		public function set backgroundUnreadColor(value:uint):void
		{
			if (value == _backgroundUnreadColor) return;
			
			_backgroundUnreadColor = value;
			
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		public function dirtyGraphics():void
		{
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}
		
		override public function invalidateProperties():void
		{
			dirtyGraphicsFlag = true;
			
			super.invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dirtyGraphicsFlag) {
				var state:String;
				
				if (!_allowSelection && _state == ButtonState.SELECTED_UP)
				{
					state = ButtonState.MOUSE_UP;
				}
				else if (!_allowSelection && _state == ButtonState.SELECTED_OVER)
				{
					state = ButtonState.MOUSE_OVER;
				}
				else
				{
					state = _state;
				}
				
				switch (state) {
					case ButtonState.MOUSE_UP:
						actionsGroup.visible = false;
						borderColor = _borderUpColor
						backgroundColor = _backgroundUpColor;
						break;
					case ButtonState.MOUSE_OVER:
						actionsGroup.visible = true;
						borderColor = _borderUpColor;
						backgroundColor = _backgroundOverColor;
						break;
					case ButtonState.SELECTED_UP:
						actionsGroup.visible = true;
						borderColor = _borderSelectedUpColor;
						backgroundColor = _backgroundSelectedUpColor;
						break;
					case ButtonState.SELECTED_OVER:
						actionsGroup.visible = true;
						borderColor = _borderSelectedOverColor;
						backgroundColor = _backgroundSelectedOverColor;
						break;
				}
			
				invalidateDisplayListFlag = true;
			}
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			if (dirtyGraphicsFlag) {
				dirtyGraphicsFlag = false;
				
				draw();
			}
		}
		
		protected function draw():void
		{
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.lineStyle(0.0, borderColor, 1.0, _selected, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER);
			
			var selected:Boolean = (!allowSelection) ? false : _selected;
			
			if (!selected) {
				graphics.moveTo(0.0, -1.0);
				graphics.lineTo(width, -1.0);
				graphics.moveTo(0.0, height);
				graphics.lineTo(width, height);
				graphics.lineStyle();
			}
			
			if (_data && _unreadFormat != UnreadFormat.NO_HIGHLIGHT && !(_data as IStreamVO).read && _data.account != _data.userID) {
				graphics.beginFill(_backgroundUnreadColor);
				graphics.drawRect(0.0, 0.0, width - (selected ? 1.0 : 0.0), height - (selected ? 1.0 : 0.0));
				graphics.endFill();
				graphics.lineStyle();
				graphics.beginFill(_indicatorColor);
				//graphics.drawCircle(width - 12.0, height - 12.0, 4.0);
				graphics.moveTo(width - 9.0, height);
				graphics.lineTo(width, height);
				graphics.lineTo(width, height - 9.0);
				graphics.lineTo(width - 9.0, height);
				/*graphics.moveTo(20.0, height - 8.0);
				graphics.lineTo(8.0, height - 8.0);
				graphics.lineTo(8.0, height - 20.0);
				graphics.lineTo(20.0, height - 8.0);*/
				graphics.endFill();
			}
			else
			{
				graphics.beginFill(backgroundColor);
				graphics.drawRect(0.0, 0.0, width - (selected ? 1.0 : 0.0), height - (selected ? 1.0 : 0.0));
				graphics.endFill();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		override protected function mouseOverHandler(event:MouseEvent):void
		{
			state = (_state == ButtonState.SELECTED_UP) ? ButtonState.SELECTED_OVER : ButtonState.MOUSE_OVER;
		}
		
		override protected function mouseOutHandler(event:MouseEvent):void
		{
			state = (_state == ButtonState.SELECTED_OVER) ? ButtonState.SELECTED_UP : ButtonState.MOUSE_UP;
		}
	}
}