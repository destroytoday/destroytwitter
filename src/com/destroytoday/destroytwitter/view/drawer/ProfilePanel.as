package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.destroytwitter.constants.Asset;
	import com.destroytoday.destroytwitter.constants.FontType;
	import com.destroytoday.destroytwitter.constants.LinkType;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
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
	
	public class ProfilePanel extends BaseDrawerPanel
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
		
		public var icon:IconButton;
		
		public var textfield:TextFieldPlus;
		
		public var spinner:Spinner;
		
		public var actionsButton:BitmapButton;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var fontType:String;
		
		protected var _data:SQLUserVO;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtySizeFlag:Boolean;
		
		protected var dirtyDataFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProfilePanel(title:LayoutTextField)
		{
			super(title);
			
			icon = addChild(new IconButton()) as IconButton;
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;
			spinner = addChild(new Spinner()) as Spinner;
			actionsButton = addChild(new BitmapButton(new (Asset.SETTINGS_BUTTON)())) as BitmapButton;
			
			icon.width = 36.0;
			icon.height = 36.0;
			
			textfield.x = icon.width + 6.0;
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
				title.htmlText = "<p><span class=\"title\">Profile</span></p>";
				
				spinner.x = -x + title.width + 10.0;
				spinner.y = -y + title.y + 1.0;
			}
		}
		
		public function get data():SQLUserVO
		{
			return _data;
		}
		
		public function set data(value:SQLUserVO):void
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
				
				actionsButton.x = width - 34.0;
				actionsButton.y = -27.0;
			}
			
			if (dirtyDataFlag)
			{
				dirtyDataFlag = false;
				
				textfield.width = width - textfield.x;
				
				if (_data)
				{
					icon.visible = true;
					icon.link = LinkType.IMAGE + "," + _data.icon.replace("_normal\.", ".");
					icon.loadIcon(_data.icon);

					var lineBreak:String = "<p><span class=\"spacer\">&nbsp;</span></p>";
					var name:String = "<p>" + _data.name + "</p>";
					var screenName:String = "<p><span class=\"profileScreenName\">" + _data.screenName + " / " + _data.id + "</span></p>" + lineBreak;
					var location:String = _data.location;
					
					if (location) {
						location = "<p>" + location + "</p>" + lineBreak;
					} else {
						location = "";
					}
					
					var url:String = _data.url;
					
					if (url) {
						url = (url.length > 35) ? url.substr(0, 35) + "..." : url;
						url = "<p><a href=\"" + _data.url + "\">" + url + "</a></p>" + lineBreak;
					} else {
						url = "";
					}
					
					var description:String = _data.description;
					
					if (description) {
						description = "<p>" + description + "</p>" + lineBreak;
					} else {
						description = "";
					}
					
					var gap:String;
					
					if (location || url || description) {
						gap = "<p></p>";
					} else {
						gap = "";
					}
					
					var page:String = 
						"<p><a href=\"http://twitter.com/" + _data.screenName + "\">Twitter page</a>" +
						" / <a href=\"event:" + LinkType.SEARCH + ",from:" + _data.screenName + "\">view tweets</a>" +
						" / <a href=\"event:" + LinkType.SEARCH + ",to:" + _data.screenName + "\">view mentions</a></p>" + lineBreak;
					var friendsCount:String = "<p>" + NumberUtil.insertCommas(_data.friendsCount) + " friends</p>";
					var followersCount:String = "<p>" + NumberUtil.insertCommas(_data.followersCount) + " followers</p>";
					var listedCount:String = "<p>" + NumberUtil.insertCommas(_data.listedCount) + " listed</p>";
		
					/*switch (relationship) {
						case TwitterManager.FRIEND:
							following = "Following each other";
							break;
						case TwitterManager.FOLLOWING:
							following = "Not following you";
							break;
						case TwitterManager.FOLLOWER:
							following = "Following you"; //fix - include account username
							break;
						case TwitterManager.NONE:
							following = "No relationship";
							break;
						case TwitterManager.YOU:
						default:
							following = "";
					}
					
					if (following) following += HTMLFormat.lineBreak (2);*/
					
					var statusesCount:String = "<p>" + NumberUtil.insertCommas(_data.statusesCount) + " tweets</p>" + lineBreak;
					var since:String = "<p>Tweeting since " + _data.tweetingSince + "</p>"; //format
					
					var text:String = 
						name +
						screenName +
						location + 
						url + 
						description +
						//gap +
						page + 
						friendsCount + 
						followersCount +
						listedCount +
						statusesCount +
						since;
						//following +

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
					
					textfield.htmlText =
						text
						
					height = Math.round(textfield.height + 6.0);
					
					heightChanged.dispatch(height);
				}
				else
				{
					icon.visible = false;
					
					textfield.htmlText = "";
				}
			}
		}
	}
}