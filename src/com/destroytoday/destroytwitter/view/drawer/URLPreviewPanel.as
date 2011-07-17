package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.FontType;
	import com.destroytoday.destroytwitter.constants.LinkType;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.model.vo.URLPreviewVO;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.IconButton;
	import com.destroytoday.destroytwitter.view.components.LayoutTextField;
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.layouts.VerticalLayout;
	import com.destroytoday.text.TextFieldPlus;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.util.NumberUtil;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	
	import org.osflash.signals.Signal;
	
	public class URLPreviewPanel extends BaseDrawerPanel
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const heightChanged:Signal = new Signal(Number);
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var textfield:TextFieldPlus;
		
		public var spinner:Spinner;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var fontType:String;
		
		protected var _data:URLPreviewVO;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyDataFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function URLPreviewPanel(title:LayoutTextField)
		{
			super(title);
			
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;
			spinner = addChild(new Spinner()) as Spinner;
			
			textfield.x = -3.0;
			textfield.y = -3.0;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.heightOffset = 4.0;
			
			height = 0.0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible) 
			{
				title.htmlText = "<p><span class=\"title\">URL Preview</span></p>";
				
				spinner.x = -x + title.width + 10.0;
				spinner.y = -y + title.y + 1.0;
			}
		}
		
		public function get data():URLPreviewVO
		{
			return _data;
		}
		
		public function set data(value:URLPreviewVO):void
		{
			if (value == _data) return;

			_data = value;
			
			dirtyDataFlag = true;
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyDataFlag)
			{
				dirtyDataFlag = false;
				
				textfield.width = width - textfield.x;
				
				if (_data)
				{
					var text:String = "";
					
					if (_data.title) text += "<p><span class=\"drawerSubtitle\">" + _data.title + "</span></p>";
					
					text += "<p><a href=\"" + _data.unshortenedURL + "\">" + _data.unshortenedURL + "</a></p>";
					
					if (fontType == FontType.SYSTEM)
					{
						textfield.embedFonts = false;
						
						text = text.replace(/<p>/ig, "<p><span class=\"systemFont\">");
						text = text.replace(/<\/p>/ig, "</span></p>");
					}
					else
					{
						textfield.embedFonts = true;
					}
					
					textfield.htmlText = text
						
					height = Math.round(textfield.height + 6.0);
					
					heightChanged.dispatch(height);
				}
				else
				{
					textfield.htmlText = "";
				}
			}
		}
	}
}