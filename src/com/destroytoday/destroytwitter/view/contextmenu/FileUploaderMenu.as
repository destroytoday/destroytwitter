package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class FileUploaderMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var uploadFile:NativeMenuItem;
		
		public var posterous:NativeMenuItem;
		
		public var twitgoo:NativeMenuItem;

		public var imgly:NativeMenuItem;

		public var pikchur:NativeMenuItem;
	
		public var twitpic:NativeMenuItem;

		public var yfrog:NativeMenuItem;

		public var tweetphoto:NativeMenuItem;

		public var imgur:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FileUploaderMenu()
		{
			super(
				<menu>
					<item name="uploadFile" label="Upload file..." keyEquivalent="u" />
					<separator />
					<item name="posterous" label="Posterous" />
					<item name="twitgoo" label="Twitgoo" />
					<item name="imgly" label="img.ly" />
					<item name="tweetphoto" label="Plixi" />
					<item name="imgur" label="Imgur" />
					<item name="pikchur" label="Pikchur" />
					<item name="twitpic" label="Twitpic" />
					<item name="yfrog" label="yFrog" />
				</menu>
			);
		}
	}
}