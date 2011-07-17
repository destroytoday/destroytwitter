package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.model.QuickFriendLookupModel;
	import com.destroytoday.destroytwitter.model.UserModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	
	import flash.utils.getTimer;

	public class QuickFriendLookupController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var userController:UserController;
		
		[Inject]
		public var userModel:UserModel;
		
		[Inject]
		public var model:QuickFriendLookupModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function QuickFriendLookupController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setup():void
		{
			model.displayedChanged = signalBus.quickFriendLookupDisplayedChanged;
		}
		
		public function display(x:Number, y:Number, positionType:String = null):void
		{
			var delta:int = int(new Date().time * 0.001) - userModel.lastUpdate;

			if (delta > 3600000) // 60 minutes
			{
				userController.updateFriends();
				userController.updateEmptyUsers();
			}
			else if (delta > 300000) // 5 minutes
			{
				userController.updateEmptyUsers();
			}
			
			userModel.lastUpdate = new Date().time * 0.001;

			model.displayed = true;
			signalBus.quickFriendLookupPrompted.dispatch(x, y, positionType);
		}
		
		public function hide():void
		{
			model.displayed = false;
		}
		
		public function selectScreenName(screenName:String):void
		{
			signalBus.quickFriendLookupScreenNameSelected.dispatch(screenName);
		}
	}
}