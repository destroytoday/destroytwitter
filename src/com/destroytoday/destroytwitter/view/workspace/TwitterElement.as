package com.destroytoday.destroytwitter.view.workspace
{
    import com.destroytoday.destroytwitter.constants.ButtonState;
    import com.destroytoday.destroytwitter.constants.FontSizeType;
    import com.destroytoday.destroytwitter.constants.FontType;
    import com.destroytoday.destroytwitter.constants.IconType;
    import com.destroytoday.destroytwitter.constants.TimeFormatType;
    import com.destroytoday.destroytwitter.constants.TwitterElementHeight;
    import com.destroytoday.destroytwitter.constants.TwitterElementTextHeight;
    import com.destroytoday.destroytwitter.constants.TwitterElementType;
    import com.destroytoday.destroytwitter.constants.UserFormatType;
    import com.destroytoday.destroytwitter.controller.LinkController;
    import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
    import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
    import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
    import com.destroytoday.destroytwitter.view.components.IconButton;
    import com.destroytoday.destroytwitter.view.drawer.DialogueElement;
    import com.destroytoday.destroytwitter.view.workspace.components.StatusActionsGroup;
    import com.destroytoday.display.SpritePlus;
    import com.destroytoday.pool.ObjectWaterpark;
    import com.destroytoday.text.TextFieldPlus;
    import com.destroytoday.util.StringUtil;
    
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.text.AntiAliasType;
    import flash.text.TextFieldAutoSize;

    public class TwitterElement extends SpritePlus
    {

		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
        public var actionsGroup:StatusActionsGroup;

        public var userIconButton:IconButton;
		
		protected var _recipientIconButton:IconButton;

        public var textfield:TextFieldPlus;

		public var info:TextFieldPlus;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

        protected var _data:GeneralTwitterVO;

        protected var _state:String = ButtonState.MOUSE_UP;
		
		protected var _autoSize:Boolean;
		
		protected var _actionsEnabled:Boolean;
		
		protected var _actionsAlwaysVisible:Boolean;
		
		protected var _userFormat:String;

		protected var _timeFormat:String;

		protected var _unreadFormat:String;
		
		protected var _iconType:String;
		
		protected var _fontType:String;

		protected var _fontSize:String;
		
		protected var _type:String;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtySizeFlag:Boolean;
		
        protected var dirtyStateFlag:Boolean;
		
		protected var dirtyAutoSizeFlag:Boolean;
		
		protected var dirtyTextFlag:Boolean;

		protected var dirtyInfoFlag:Boolean;
		
		protected var dirtyIconFlag:Boolean;
		
		protected var dirtyFontFlag:Boolean;
		
		protected var dirtyGraphicsFlag:Boolean;
		
		protected var dirtyStyleFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

        public function TwitterElement()
        {
			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			
            userIconButton = addChild(new IconButton()) as IconButton;
            textfield = addChild(new TextFieldPlus()) as TextFieldPlus;
            info = addChild(new TextFieldPlus()) as TextFieldPlus;
            actionsGroup = addChild(new StatusActionsGroup()) as StatusActionsGroup;

			//--------------------------------------
			//  set properties
			//--------------------------------------
			
			textfield.antiAliasType = AntiAliasType.ADVANCED;
			textfield.heightOffset = 3.0;
			info.autoSize = TextFieldAutoSize.LEFT;
			actionsGroup.visible = false;
			
			autoSize = true;

            width = 309.0;
            height = 0.0;

			//--------------------------------------
			//  add listeners
			//--------------------------------------
			
            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			textfield.addEventListener(TextEvent.LINK, linkHandler);
			info.addEventListener(TextEvent.LINK, linkHandler);
        }
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get recipientIconButton():IconButton
		{
			if (!_recipientIconButton)
			{
				_recipientIconButton = ObjectWaterpark.getObject(IconButton) as IconButton;
				
				addChild(_recipientIconButton);
				
				dirtyIconFlag = true;
				invalidateDisplayList();
			}
			
			return _recipientIconButton;
		}
		
		public function set recipientIconButton(value:IconButton):void
		{
			if (value != null || !_recipientIconButton) return;
			
			removeChild(_recipientIconButton);
			ObjectWaterpark.disposeObject(_recipientIconButton);
			
			_recipientIconButton = null;
		}
		
		override public function set width(value:Number):void
		{
			if (value != width) dirtySizeFlag = true;
			
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			if (value != height) 
			{
				dirtySizeFlag = true;
				dirtyGraphicsFlag = true;
			}
			
			super.height = value;
		}
		
		public function get iconType():String
		{
			return _iconType;
		}
		
		public function set iconType(value:String):void
		{
			if (value == _iconType) return;
			
			_iconType = value;

			dirtyIconFlag = true;
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

			textfield.embedFonts = (_fontType == FontType.DEFAULT);
			
			dirtyFontFlag = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get fontSize():String
		{
			return _fontSize;
		}
		
		public function set fontSize(value:String):void
		{
			if (value == _fontSize) return;

			_fontSize = value;
			
			dirtyGraphicsFlag = true;
			dirtyFontFlag = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get actionsAlwaysVisible():Boolean
		{
			return _actionsAlwaysVisible;
		}
		
		public function set actionsAlwaysVisible(value:Boolean):void
		{
			if (value == _actionsAlwaysVisible) return;
			
			_actionsAlwaysVisible = value;
			
			dirtyStateFlag = true;
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
			
			dirtyInfoFlag = true;
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
			
			dirtyInfoFlag = true;
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
			
			dirtyGraphicsFlag = true;
			invalidateDisplayList();
		}

        public function get data():GeneralTwitterVO
        {
            return _data;
        }

        public function set data(value:GeneralTwitterVO):void
        {
            if (value == _data)
                return;

            _data = value;
			
            if (_data)
            {
                visible = true;

                userIconButton.link = "user," + _data.userScreenName;

				if (_data is GeneralMessageVO)
				{
					recipientIconButton.link = "user," + (_data as GeneralMessageVO).recipientScreenName;
				}
				else if (_recipientIconButton)
				{
					recipientIconButton = null;
				}
				
				dirtyIconFlag = true;
				dirtyTextFlag = true;
				invalidateProperties();
          
				if (_autoSize)
				{
					dirtySizeFlag = true;
					commitProperties();
					updateDisplayList();
				}
				else
				{
					invalidateDisplayList();
				}
			}
            else
            {
                visible = false;
            }
        }

        public function get state():String
        {
            return _state;
        }

        public function set state(value:String):void
        {
            if (value == _state)
                return;

            _state = value;

            dirtyStateFlag = true;
            invalidateProperties();
        }
		
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		public function set autoSize(value:Boolean):void
		{
			if (value == _autoSize) return;
			
			_autoSize = value;
			
			dirtyAutoSizeFlag = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get actionsEnabled():Boolean
		{
			return _actionsEnabled;
		}
		
		public function set actionsEnabled(value:Boolean):void
		{
			if (value == _actionsEnabled) return;
			
			_actionsEnabled = value;
			
			dirtyStateFlag = true;
			invalidateProperties();
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			if (value == _type) return;
			
			_type = value;
			// should invalidate
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function nullify():void
		{
			_data = null;
			
			actionsGroup.nullify();

			textfield.styleSheet = null;
			info.styleSheet = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------

		public function dirtyStyle():void
		{
			dirtyStyleFlag = true;
			
			invalidateProperties();
		}
		
        override protected function commitProperties():void
        {
            super.commitProperties();
			
			if ((dirtyFontFlag || dirtyTextFlag) && _data)
			{
				if (_fontType == FontType.SYSTEM)
				{
					textfield.htmlText = "<p><span class=\"systemFont\"><font size=\"" + FontSizeType.getPixels(_fontSize) + "\">" + _data.text + "</font></span></p>";
				}
				else
				{
					textfield.htmlText = "<p><font size=\"" + FontSizeType.getPixels(_fontSize) + "\">" + _data.text + "</font></p>";
				}
				
				if (_autoSize)
				{
					textfield.maxHeight = NaN;
					
					dirtySizeFlag = true;
				}
				else
				{
					textfield.maxHeight = TwitterElementTextHeight.getHeight(_fontType, _fontSize);
				}
			}
			
			if ((dirtyTextFlag || dirtyInfoFlag) && _data)
			{
				var displayName:String = (_userFormat == UserFormatType.FULLNAME) ? _data.userFullName : _data.userScreenName;
				var displayTime:String = (_timeFormat == TimeFormatType.TWENTYFOUR_HOUR) ? _data.twentyFourHourDate : _data.twelveHourDate;
				
				var text:String = 
					"<p><span class=\"statusInfo\"><a href=\"event:user," + _data.userScreenName + "\">" + displayName + "</a>";
				
				if (_data is GeneralMessageVO)
				{
					text += " to <a href=\"event:user," + (_data as GeneralMessageVO).recipientScreenName + "\">" + ((_userFormat == UserFormatType.FULLNAME) ? (_data as GeneralMessageVO).recipientFullName : (_data as GeneralMessageVO).recipientScreenName) + "</a>";
				}

				text += " &nbsp; &nbsp;<a href=\"http://twitter.com/" + _data.userScreenName + "/statuses/" + _data.id + "\">" + 
					"<span class=\"statusDate\">" + displayTime + "</span></a>";
				
				if (_data is GeneralStatusVO && (_data as GeneralStatusVO).inReplyToStatusID) 
				{
					text += " &nbsp; &nbsp;<a href=\"event:dialogue," + _data.userScreenName + "," + _data.id + "," + (_data as GeneralStatusVO).inReplyToScreenName + "," + (_data as GeneralStatusVO).inReplyToStatusID + "\">»</a>";
				}
				
				text += "</span></p>";
				
				info.htmlText = text;
				
				dirtyInfoFlag = false;
			}
			
			if (dirtyStyleFlag)
			{
				dirtyStyleFlag = false;

				textfield.styleSheet = textfield.styleSheet;
				info.styleSheet = info.styleSheet;
			}

            if (dirtyStateFlag)
            {
				if (!_actionsAlwaysVisible)
				{
					switch (_state)
					{
						case ButtonState.MOUSE_UP:
							actionsGroup.visible = false;
							break;
						case ButtonState.MOUSE_OVER:
							actionsGroup.visible = _actionsEnabled;
							break;
					}
				}
				else
				{
					actionsGroup.visible = true;
				}
				
				dirtyStateFlag = false;
            }
			
			if (dirtyAutoSizeFlag)
			{
				textfield.autoSize = (_autoSize) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
				
				dirtySizeFlag = true;
				dirtyAutoSizeFlag = false;
			}
        }
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			if (dirtyIconFlag && _data)
			{
				dirtyIconFlag = false;
				
				if (_iconType != IconType.NONE)
				{
					var size:Number = (_iconType == IconType.LARGE) ? 36.0 : 24.0;
					
					userIconButton.x = (this is StreamElement || this is DialogueElement) ? 8.0 : 0.0;
					userIconButton.bitmap.width = size;
					userIconButton.bitmap.height = size;
					userIconButton.visible = true;
					userIconButton.loadIcon(_data.userIcon);
					
					if (_recipientIconButton)
					{
						_recipientIconButton.x = userIconButton.x;
						_recipientIconButton.y = userIconButton.y + size + 8.0;
						_recipientIconButton.bitmap.width = size;
						_recipientIconButton.bitmap.height = size;
						_recipientIconButton.visible = true;
						if (_data is GeneralMessageVO) _recipientIconButton.loadIcon((_data as GeneralMessageVO).recipientIcon);
					}
				}
				else
				{
					userIconButton.visible = false;
					
					userIconButton.unloadIcon();
					
					if (_recipientIconButton) 
					{
						_recipientIconButton.visible = false;	
						
						_recipientIconButton.unloadIcon();
					}
				}
				
				dirtySizeFlag = true;
			}
			
			if (dirtySizeFlag || dirtyFontFlag)
			{
				textfield.x = 
					info.x = (_iconType != IconType.NONE) ? userIconButton.x + userIconButton.width + 6.0 : 5.0;
				textfield.y = userIconButton.y - (_fontType == FontType.DEFAULT ? 3.0 : 5.0);
				textfield.width = width - (textfield.x + 4.0);
				
				if (textfield.autoSize != TextFieldAutoSize.LEFT) textfield.autoSize = TextFieldAutoSize.LEFT;
			}
			
			if (dirtyTextFlag || dirtySizeFlag || dirtyFontFlag)
			{
				info.y = Math.round(textfield.y + textfield.height);
				
				if (_autoSize) 
				{
					height = userIconButton.y + userIconButton.height;
					if (_recipientIconButton) height = recipientIconButton.y + recipientIconButton.height;
					height = Math.max(height, info.y + info.height);
				}
				else if (_fontSize == FontSizeType.SMALL && _type == TwitterElementType.STATUS)
				{
					height = TwitterElementHeight.STATUS_FONT_SIZE_ELEVEN;
				}
				else if (_fontSize == FontSizeType.SMALL)
				{
					height = TwitterElementHeight.MESSAGE_FONT_SIZE_ELEVEN;
				}
				else if (_fontSize == FontSizeType.MEDIUM && _type == TwitterElementType.STATUS)
				{
					height = TwitterElementHeight.STATUS_FONT_SIZE_THIRTEEN;
				}
				else if (_fontSize == FontSizeType.MEDIUM)
				{
					height = TwitterElementHeight.MESSAGE_FONT_SIZE_THIRTEEN;
				}
				else if (_fontSize == FontSizeType.LARGE)
				{
					height = TwitterElementHeight.FONT_SIZE_FOURTEEN;
				}
				
				actionsGroup.x = width - (actionsGroup.replyButton.width + actionsGroup.actionsButton.width + userIconButton.x - 3.0);
				actionsGroup.y = height - (actionsGroup.height + userIconButton.y - 5.0);
				
				dirtyTextFlag = false;
				dirtySizeFlag = false;
				dirtyFontFlag = false;
			}
			
			invalidateDisplayListFlag = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function mouseOverHandler(event:MouseEvent):void
		{
			state = ButtonState.MOUSE_OVER;
		}
		
        protected function mouseOutHandler(event:MouseEvent):void
        {
			state = ButtonState.MOUSE_UP;
        }

		protected function linkHandler(event:TextEvent):void
		{
			LinkController.getInstance().openLink(event.text);
		}
    }
}