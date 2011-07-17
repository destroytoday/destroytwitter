package com.destroytoday.destroytwitter.view.overlay
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.TextFieldVirtualList;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	import com.destroytoday.text.TextFieldPlus;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quadratic;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import org.osflash.signals.Signal;
	
	public class QuickFriendLookup extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const displayedChanged:Signal = new Signal(Boolean);
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var title:TextFieldPlus;
		
		public var closeButton:BitmapButton;
		
		public var input:TextInput;
		
		public var list:TextFieldVirtualList;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _backgroundColor:uint;
		
		protected var _displayed:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyGraphicsFlag:Boolean;
		
		protected var dirtyDisplayedFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function QuickFriendLookup()
		{
			super();

			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			input = addChild(new TextInput()) as TextInput;
			list = addChild(new TextFieldVirtualList()) as TextFieldVirtualList;
			title = addChild(new TextFieldPlus()) as TextFieldPlus;
			closeButton = addChild(new BitmapButton(new (Asset.CLOSE_BUTTON)())) as BitmapButton;
			
			//--------------------------------------
			//  set properties
			//--------------------------------------
			layout.setPadding(8.0, 8.0, 8.0, 8.0);
			closeButton.setConstraints(NaN, -2.0, 0.0, NaN);
			input.setConstraints(0.0, 20.0, 0.0, NaN);
			list.setConstraints(0.0, 50.0, 0.0, 0.0);
			
			input.textfield.embedFonts = true;
			input.textfield.restrict = "A-Za-z0-9_";
			input.height = 22.0;

			title.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 14.0);
			title.autoSize = TextFieldAutoSize.LEFT;
			title.text = "Friend Lookup";
			title.x = 5.0;
			title.y = 6.0;
			
			width = 180.0;
			height = 136.0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
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
		
		public function get displayed():Boolean
		{
			return _displayed;
		}
		
		public function set displayed(value:Boolean):void
		{
			if (value == _displayed) return;
			
			_displayed = value;
			
			dirtyDisplayedFlag = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (dirtyDisplayedFlag)
			{
				input.enabled = _displayed;
				
				if (_displayed)
				{
					input.text = "";
					input.focus();
				}
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			if (dirtyGraphicsFlag)
			{
				dirtyGraphicsFlag = false;
				
				var graphics:Graphics = this.graphics;

				graphics.clear();
				graphics.beginFill(_backgroundColor, 0.85);
				graphics.drawRoundRect(0.0, 0.0, width, height, 12.0, 12.0);
				graphics.endFill();
			}
			
			if (dirtyDisplayedFlag)
			{
				dirtyDisplayedFlag = false;
				
				var values:Object = {alpha: (_displayed) ? 1.0 : 0.0};
				var onComplete:Function;
				
				if (_displayed)
				{
					y += 15.0;
					
					values['y'] = y - 15.0;
				}
				else
				{
					onComplete = fadeOutCompleteHandler;
				}
				
				TweenManager.to(this, values, 0.25, Quadratic.easeOut, onComplete);
				
				displayedChanged.dispatch(_displayed);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function fadeOutCompleteHandler(tween:GTween):void
		{
			TweenManager.disposeTween(tween);
			
			list.dataProvider = null;
		}
	}
}