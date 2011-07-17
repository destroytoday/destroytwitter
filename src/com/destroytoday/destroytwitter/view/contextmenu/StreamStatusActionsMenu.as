package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class StreamStatusActionsMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var reply:NativeMenuItem;
		
		public var replyAll:NativeMenuItem;
		
		public var directMessage:NativeMenuItem;
		
		public var retweet:NativeMenuItem;

		public var secondaryRetweet:NativeMenuItem;
		
		public var favorite:NativeMenuItem;
		
		public var destroy:NativeMenuItem;

		public var filterScreenName:NativeMenuItem;
		
		public var filterSource:NativeMenuItem;

		public var filterSeparator:NativeMenuItem;
		
		public var openInBrowser:NativeMenuItem;
		
		public var copyToClipboard:NativeMenuItem;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamStatusActionsMenu()
		{
			super(
				<menu>
					<item name="reply" label="Reply..." keyEquivalent="r" />
					<item name="replyAll" label="Reply All..." keyEquivalent="R" />
					<item name="directMessage" label="Direct Message..." keyEquivalent="m" />
					<item name="retweet" label="Retweet..." keyEquivalent="t" />
					<item name="secondaryRetweet" label="Retweet..." keyEquivalentModifiers="alt" keyEquivalent="t" />
					<separator />
					<item name="favorite" label="Favorite" keyEquivalent="f" />
					<item name="destroy" label="Delete" />
					<separator />
					<item name="filterScreenName" label="Filter" />
					<item name="filterSource" label="Filter" />
					<separator name="filterSeparator" />
					<item name="openInBrowser" label="Open In Browser" />
					<item name="copyToClipboard" label="Copy To Clipboard" keyEquivalent="c" />
				</menu>
			);
		}
		
		public function setStatus(isAccountStatus:Boolean, isDeleting:Boolean, isFavoriting:Boolean, isSearchResult:Boolean):void
		{
			if (isAccountStatus) 
			{
				retweet.enabled = false;
				
				if (isDeleting)
				{
					destroy.label = "Deleting...";
					destroy.enabled = false;
				}
				else
				{
					destroy.label = "Delete";
					destroy.enabled = true;
				}
			} 
			else 
			{
				retweet.enabled = true;
				
				destroy.label = "Delete";
				destroy.enabled = false;
			}
			
			if (!isDeleting && isFavoriting)
			{
				favorite.label = "Favoriting...";
				favorite.enabled = false;
			}
			else if (!isDeleting)
			{
				favorite.label = "Favorite";
				favorite.enabled = true;
			}
			else
			{
				favorite.label = "Favorite";
				favorite.enabled = false;
			}
			
			if (isSearchResult && filterScreenName.menu)
			{
				removeItem(destroy);
				removeItem(filterScreenName);
				removeItem(filterSource);
				removeItem(filterSeparator);
			}
			else if (!isSearchResult && !filterScreenName.menu)
			{
				addItemAt(destroy, 6);
				addItemAt(filterScreenName, numItems - 2);
				addItemAt(filterSource, numItems - 2);
				addItemAt(filterSeparator, numItems - 2);
			}
		}
	}
}