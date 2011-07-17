package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	public class Drawer extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var closeButton:BitmapButton;
		
		public var title:LayoutTextField;

		public var update:UpdatePanel;
		
		public var compose:Compose;
		
		public var dialogue:Dialogue;
		
		public var filter:Filter;
		
		public var find:Find;
		
		public var profile:ProfilePanel;

		public var urlPreview:URLPreviewPanel;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _borderColor:uint;
		
		protected var _backgroundColor:uint;
		
		protected var bounds:Rectangle = new Rectangle();
		
		protected var _opened:Boolean;
		
		protected var _state:String;
		
		protected var contentHeight:Number = 0.0;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Drawer()
		{
			var layout:BasicLayout = new BasicLayout();
			
			layout.setPadding(8.0, 8.0, 8.0, 8.0);
			
			super(layout);
			
			closeButton = addChild(new BitmapButton(new (Asset.CLOSE_BUTTON)())) as BitmapButton;
			title = addChild(new LayoutTextField()) as LayoutTextField;
			update = addChild(new UpdatePanel(title)) as UpdatePanel;
			compose = addChild(new Compose(title)) as Compose;
			dialogue = addChild(new Dialogue(title)) as Dialogue;
			filter = addChild(new Filter(title)) as Filter;
			find = addChild(new Find(title)) as Find;
			profile = addChild(new ProfilePanel(title)) as ProfilePanel;
			urlPreview = addChild(new URLPreviewPanel(title)) as URLPreviewPanel;

			title.autoSize = TextFieldAutoSize.LEFT;
			title.setConstraints(-3.0, -1.0, NaN, NaN);
			compose.visible = false;
			dialogue.visible = false;
			filter.visible = false;
			find.visible = false;
			profile.visible = false;
			urlPreview.visible = false;
			
			update.setConstraints(0.0, 26.0, 0.0, NaN);
			compose.setConstraints(0.0, 26.0, 0.0, NaN);
			dialogue.setConstraints(-8.0, 26.0, -8.0, NaN);
			filter.setConstraints(0.0, 26.0, 0.0, NaN);
			profile.setConstraints(1.0, 26.0, 0.0, NaN);
			urlPreview.setConstraints(1.0, 26.0, 0.0, NaN);
			
			find.x = 8.0;
			find.y = 34.0;
			
			closeButton.setConstraints(NaN, 0.0, 0.0, NaN);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			if (value == _state) return;
			
			_state = value;
			
			invalidateProperties();
		}

		public function get opened():Boolean
		{
			return _opened;
		}

		public function set opened(value:Boolean):void
		{
			invalidateProperties();
			validateNow();
			
			_opened = value;

			TweenManager.to(this, {scrollY: (_opened ? contentHeight : -27.0) - height});
		}

		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			if (value == _borderColor) return;
			
			_borderColor = value;
			
			invalidateProperties();
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			if (value == _backgroundColor) return;
			
			_backgroundColor = value;
			
			invalidateProperties();
		}
		
		public function get scrollY():Number
		{
			return bounds.y;
		}
		
		public function set scrollY(value:Number):void
		{
			if (value == bounds.y) return;
			
			bounds.y = value;
			scrollRect = bounds;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			switch (_state) {
				case DrawerState.UPDATE:
					contentHeight = update.y + update.height;
					break;
				case DrawerState.COMPOSE:
				case DrawerState.COMPOSE_REPLY:
				case DrawerState.COMPOSE_MESSAGE_REPLY:
					contentHeight = compose.y + compose.height + layout.paddingBottom;
					break;
				case DrawerState.DIALOGUE:
					contentHeight = dialogue.y + dialogue.height;
					break;
				case DrawerState.FILTER:
					contentHeight = filter.y + filter.height;
					break;
				case DrawerState.FIND:
					contentHeight = find.y + find.height;
					break;
				case DrawerState.PROFILE:
					contentHeight = profile.y + profile.height;
					break;
				case DrawerState.URL_PREVIEW:
					contentHeight = urlPreview.y + urlPreview.height;
					break;
			}
			
			contentHeight -= 1;

			draw();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			draw();
			
			bounds.width = width;
			bounds.height = height;
			scrollRect = bounds;
		}
		
		protected function draw():void
		{
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(_backgroundColor);
			graphics.drawRect(0.0, 0.0, width, stage.height);
			graphics.lineStyle(0.0, _borderColor, 1.0, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
			graphics.moveTo(0.0, -1.0);
			graphics.lineTo(width, -1.0);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		override protected function addedToStageHandler(event:Event):void
		{
			super.addedToStageHandler(event);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			
			stageResizeHandler(null);
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			scrollY = (_opened ? contentHeight : -27.0) - height;
		}
	}
}