package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class StreamMessageActionsMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var reply:NativeMenuItem;
		
		public var destroy:NativeMenuItem;
		
		public var copyToClipboard:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StreamMessageActionsMenu()
		{
			super(
				<menu>
					<item name="reply" label="Reply..." keyEquivalent="r" />
					<separator />
					<item name="destroy" label="Delete" />
					<separator />
					<item name="copyToClipboard" label="Copy To Clipboard" keyEquivalent="c" />
				</menu>
			);
		}
		
		public function setStatus(isDeleting:Boolean):void
		{
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
	}
}