package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.module.accountmodule.controller.BaseAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;

	public class FilterController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var workspaceController:WorkspaceController;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FilterController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get screenNameFilter():Array
		{
			var model:BaseAccountStreamModel = workspaceController.getCurrentAccountStreamModel() as BaseAccountStreamModel;
			
			return (model) ? model.screenNameFilter : null;
		}
		
		public function get keywordFilter():Array
		{
			var model:BaseAccountStreamModel = workspaceController.getCurrentAccountStreamModel() as BaseAccountStreamModel;
			
			return (model) ? model.keywordFilter : null;
		}
		
		public function get sourceFilter():Array
		{
			var model:BaseAccountStreamModel = workspaceController.getCurrentAccountStreamModel() as BaseAccountStreamModel;
			
			return (model) ? model.sourceFilter : null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addScreenName(screenName:String):void
		{
			var controller:BaseAccountStreamController = workspaceController.getCurrentAccountStreamController() as BaseAccountStreamController;
			
			if (controller)
			{
				screenNameFilter[screenNameFilter.length] = screenName;
				
				controller.applyFilters(screenNameFilter, keywordFilter, sourceFilter);
			}
		}
		
		public function addKeyword(keyword:String):void
		{
			var controller:BaseAccountStreamController = workspaceController.getCurrentAccountStreamController() as BaseAccountStreamController;
			
			if (controller)
			{
				keywordFilter[keywordFilter.length] = keyword;
				
				controller.applyFilters(screenNameFilter, keywordFilter, sourceFilter);
			}
		}
		
		public function addSource(source:String):void
		{
			var controller:BaseAccountStreamController = workspaceController.getCurrentAccountStreamController() as BaseAccountStreamController;
			
			if (controller)
			{
				sourceFilter[sourceFilter.length] = source;
				
				controller.applyFilters(screenNameFilter, keywordFilter, sourceFilter);
			}
		}
	}
}