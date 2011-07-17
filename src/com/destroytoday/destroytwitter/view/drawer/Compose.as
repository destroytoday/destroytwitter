package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.ComposeType;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.constants.TextInputState;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.destroytwitter.view.components.TextButton;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	import com.destroytoday.destroytwitter.view.workspace.TwitterElement;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.layouts.HorizontalAlignType;
	import com.destroytoday.layouts.IBasicLayoutElement;
	import com.destroytoday.layouts.INonLayoutElement;
	import com.destroytoday.layouts.VerticalLayout;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	public class Compose extends BaseDrawerPanel
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var status:TwitterElement;
		
		public var form:ComposeForm;

		public var actionsButton:BitmapButton;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:GeneralTwitterVO;
		
		protected var _enabled:Boolean = true;
		
		protected var _type:String;

		protected var titleText:String = "Tweet";
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtySizeFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Compose(title:LayoutTextField)
		{
			var layout:VerticalLayout = new VerticalLayout();
			
			layout.horizontalAlign = HorizontalAlignType.LEFT;
			layout.gap = 6.0;
			
			super(title, layout);
			
			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			
			status = addChild(new TwitterElement()) as TwitterElement;
			form = addChild(new ComposeForm()) as ComposeForm;
			actionsButton = addChild(new BitmapButton(new (Asset.SETTINGS_BUTTON)())) as BitmapButton;

			//--------------------------------------
			//  set child properties
			//--------------------------------------
			
			status.actionsEnabled = false;
			status.marginBottom = 4.0;
			actionsButton.includeInLayout = false;
			
			data = null;
			
			//--------------------------------------
			//  add listeners
			//--------------------------------------
			
			form.textArea.textfield.addEventListener(Event.CHANGE, textAreaChangeHandler);
			
			textAreaChangeHandler(null);
			validateNow();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
			form.textArea.textfield.tabEnabled = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			if (value == _type) return;
			
			_type = value;
			
			textAreaChangeHandler(null);
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value == _enabled) return;
			
			_enabled = value;
			
			form.textArea.enabled = _enabled;
			form.submitButton.enabled = _enabled;
			textAreaChangeHandler(null);
		}
		
		public function get data():GeneralTwitterVO
		{
			return status.data;
		}
		
		public function set data(value:GeneralTwitterVO):void
		{
			status.data = value;
			
			if (status.data)
			{
				status.includeInLayout = true;
				status.visible = true;
			}
			else
			{
				status.includeInLayout = false;
				status.visible = false;
			}
			
			updateDisplayList();
			measure();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Inavlidation
		//
		//--------------------------------------------------------------------------
		
		override protected function measure():void
		{
			super.measure();
			
			var m:uint = numChildren;
			
			for (var i:uint = m - 1; i >= 0; --i)
			{
				var child:SpritePlus = getChildAt(i) as SpritePlus;
				
				if (child.includeInLayout)
				{
					height = child.y + child.height;
					
					break;
				}
			}
			
			dirtySizeFlag = true;
		}
		
		override protected function updateDisplayList():void
		{
			if (dirtySizeFlag)
			{
				dirtySizeFlag = false;
				
				actionsButton.x = width - 34.0;
				actionsButton.y = -27.0;
			}
			
			status.width = width - 4.0; //FIX
			form.width = width;

			super.updateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function textAreaChangeHandler(event:Event):void
		{
			var type:String;
			var characterCount:int = 140 - form.textArea.textfield.text.length;

			if (_type != ComposeType.DIRECT_MESSAGE && 
				form.textArea.text.substr(0.0, 2).toLowerCase() == "d " &&
				form.textArea.text.length > 2 &&
				TwitterTextUtil.USERNAME_CHARS.indexOf(form.textArea.text.substr(2.0, 1)) != -1)
			{
				type = ComposeType.DIRECT_MESSAGE;
				
				characterCount += form.textArea.text.indexOf(" ", 2.0) + 1;
			}
			else if (form.textArea.text.substr(0.0, 1) == "@" && form.textArea.text.indexOf(" ", 2.0) != -1)
			{
				type = ComposeType.REPLY_STATUS;
			}
			
			if (characterCount >= 0) {
				if (_enabled) form.submitButton.enabled = characterCount < 140;

				if (form.textArea.state == TextInputState.ERROR) {
					form.textArea.state = (stage.focus == form.textArea.textfield) ? TextInputState.FOCUSED : TextInputState.UNFOCUSED;
				}
			} else {
				form.textArea.state = TextInputState.ERROR;
				form.submitButton.enabled = false;
			}
			
			if (_type == ComposeType.DIRECT_MESSAGE || type == ComposeType.DIRECT_MESSAGE || _data && _data is GeneralMessageVO)
			{
				titleText = "Direct Message";
			}
			else if (type == ComposeType.REPLY_STATUS)
			{
				titleText = "Reply Tweet";
			}
			else
			{
				titleText = "Tweet";
			}
			
			title.htmlText = "<p><span class=\"title\">" + titleText + "</a> <span class=\"drawerSubTitle\">" + characterCount + "</span></p>";
		}
	}
}