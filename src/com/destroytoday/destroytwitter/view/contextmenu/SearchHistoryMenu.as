package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class SearchHistoryMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var noHistory:NativeMenuItem;

		public var keyword0:NativeMenuItem;
		
		public var keyword1:NativeMenuItem;
		
		public var keyword2:NativeMenuItem;
		
		public var keyword3:NativeMenuItem;
		
		public var keyword4:NativeMenuItem;
		
		public var keyword5:NativeMenuItem;
		
		public var keyword6:NativeMenuItem;
		
		public var keyword7:NativeMenuItem;
		
		public var keyword8:NativeMenuItem;
		
		public var keyword9:NativeMenuItem;

		public var separator:NativeMenuItem;
		
		public var clearHistory:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SearchHistoryMenu()
		{
			super(
				<menu>
					<item name="noHistory" label="No History" enabled="false" />
					<item name="keyword0" label="Keyword 0" checked="true" />
					<item name="keyword1" label="Keyword 1" />
					<item name="keyword2" label="Keyword 2" />
					<item name="keyword3" label="Keyword 3" />
					<item name="keyword4" label="Keyword 4" />
					<item name="keyword5" label="Keyword 5" />
					<item name="keyword6" label="Keyword 6" />
					<item name="keyword7" label="Keyword 7" />
					<item name="keyword8" label="Keyword 8" />
					<item name="keyword9" label="Keyword 9" />
					<separator name="separator" />
					<item name="clearHistory" label="Clear History" />
				</menu>
			);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setKeywordList(keywordList:Array):void
		{
			removeAllItems();

			if (keywordList.length > 0)
			{
				noHistory.enabled = true;
				noHistory.label = "...";
				
				addItem(noHistory);
				
				var m:uint = keywordList.length;
				
				for (var i:uint = 0; i < m; ++i)
				{
					if (keywordList[i]) addItem(this['keyword' + i]).label = keywordList[i];
				}
				
				addItem(separator);
				addItem(clearHistory).enabled = true;
			}
			else
			{
				noHistory.enabled = false;
				noHistory.label = "No History";
				
				addItem(noHistory);
				addItem(separator);
				addItem(clearHistory).enabled = false;
			}
		}
	}
}