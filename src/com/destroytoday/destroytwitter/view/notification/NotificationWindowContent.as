package com.destroytoday.destroytwitter.view.notification
{
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.workspace.TwitterElement;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.display.Graphics;
	import flash.text.TextFieldAutoSize;
	
	public class NotificationWindowContent extends DisplayGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var closeButton:BitmapButton;
		
		public var textfield:TextFieldPlus;
		
		public var status:TwitterElement;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _backgroundColor:uint;
		
		protected var _homeStreamNumUnread:int;
		
		protected var _mentionsStreamNumUnread:int;
		
		protected var _searchStreamNumUnread:int;
		
		protected var _messagesStreamNumUnread:int;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyGraphicsFlag:Boolean;
		
		protected var dirtyNumUnread:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NotificationWindowContent()
		{
			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;
			status = addChild(new TwitterElement()) as TwitterElement;
			closeButton = addChild(new BitmapButton(new (Asset.CLOSE_BUTTON)())) as BitmapButton;
			
			//--------------------------------------
			//  set properties
			//--------------------------------------
			
			width = 324.0;
			height = 0.0;
			
			textfield.multiline = true;
			textfield.wordWrap = true;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.x = 8.0;
			textfield.y = 6.0;
			textfield.width = width - (textfield.x * 2.0);
			
			status.x = 10.0;
			status.width = 306.0;
			status.actionsAlwaysVisible = true;
			
			closeButton.setConstraints(NaN, 7.0, 8.0, NaN);
			
			visible = false;
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
		
		public function get homeStreamNumUnread():uint
		{
			return _homeStreamNumUnread;
		}
		
		public function set homeStreamNumUnread(value:uint):void
		{
			if (value == _homeStreamNumUnread) return;
			
			_homeStreamNumUnread = value;
			
			dirtyNumUnread = true;
			invalidateDisplayList();
		}
		
		public function get mentionsStreamNumUnread():uint
		{
			return _mentionsStreamNumUnread;
		}
		
		public function set mentionsStreamNumUnread(value:uint):void
		{
			if (value == _mentionsStreamNumUnread) return;
			
			_mentionsStreamNumUnread = value;
			
			dirtyNumUnread = true;
			invalidateDisplayList();
		}
		
		public function get searchStreamNumUnread():uint
		{
			return _searchStreamNumUnread;
		}
		
		public function set searchStreamNumUnread(value:uint):void
		{
			if (value == _searchStreamNumUnread) return;
			
			_searchStreamNumUnread = value;
			
			dirtyNumUnread = true;
			invalidateDisplayList();
		}
		
		public function get messagesStreamNumUnread():uint
		{
			return _messagesStreamNumUnread;
		}
		
		public function set messagesStreamNumUnread(value:uint):void
		{
			if (value == _messagesStreamNumUnread) return;
			
			_messagesStreamNumUnread = value;
			
			dirtyNumUnread = true;
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override public function invalidateSize():void
		{
			super.invalidateSize();
			
			dirtyGraphicsFlag = true;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyNumUnread)
			{
				dirtyNumUnread = false;
				var text:String = "<p><span class=\"notificationTitle\">DestroyTwitter</span></p>";
				
				if (_homeStreamNumUnread > 0)
				{
					text += "<p>" + _homeStreamNumUnread + " home tweet" + (_homeStreamNumUnread > 1 ? "s" : "") + "</p>";
				}
				
				if (_mentionsStreamNumUnread > 0)
				{
					text += "<p>" + _mentionsStreamNumUnread + " mention" + (_mentionsStreamNumUnread > 1 ? "s" : "") + "</p>";
				}
				
				if (_searchStreamNumUnread > 0)
				{
					text += "<p>" + _searchStreamNumUnread + " search result" + (_searchStreamNumUnread > 1 ? "s" : "") + "</p>";
				}
				
				if (_messagesStreamNumUnread > 0)
				{
					text += "<p>" + _messagesStreamNumUnread + " message" + (_messagesStreamNumUnread > 1 ? "s" : "") + "</p>";
				}
				
				textfield.htmlText = text;
				
				status.y = textfield.y + textfield.height + 8.0;
					
				height = Math.round(status.y + status.height + 9.0);
				
				dirtyGraphicsFlag = true;
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
			
			invalidateDisplayListFlag = false;
		}
	}
}