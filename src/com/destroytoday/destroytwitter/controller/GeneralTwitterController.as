package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.GeneralTwitterModel;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.components.Alert;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.TwitterAspirin;
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.util.StringUtil;

	public class GeneralTwitterController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var twitter:TwitterAspirin;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var model:GeneralTwitterModel;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GeneralTwitterController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			twitter.favoritedStatus.add(favoritedStatusHandler);
			twitter.favoritedStatusError.add(favoritedStatusErrorHandler);
			twitter.deletedStatus.add(deletedStatusHandler);
			twitter.deletedStatusError.add(deletedStatusErrorHandler);
			twitter.deletedMessage.add(deletedMessageHandler);
			twitter.deletedMessageError.add(deletedMessageErrorHandler);
			twitter.gotRelationship.add(gotRelationshipHandler);
			twitter.gotRelationshipError.add(gotRelationshipErrorHandler);
			twitter.followedUser.add(followedHandler);
			twitter.followedUserError.add(followedErrorHandler);
			twitter.unfollowedUser.add(unfollowedHandler);
			twitter.unfollowedUserError.add(unfollowedErrorHandler);
		}
		
		public function deleteStatus(account:AccountModule, id:String):void
		{
			cancelDeleteStatus(id);
			
			model.loaderHash["ds" + id] = twitter.deleteStatus(account.infoModel.accessToken, id);
		}
		
		public function cancelDeleteStatus(id:String):void
		{
			var loader:XMLLoader = model.loaderHash["ds" + id]
			
			if (loader)
			{
				loader.cancel();
				
				model.loaderHash["ds" + id] = null;
			}
		}
		
		public function isDeletingStatus(id:String):Boolean
		{
			return (model.loaderHash["ds" + id]);
		}
		
		
		public function deleteMessage(account:AccountModule, id:String):void
		{
			cancelDeleteMessage(id);
			
			model.loaderHash["dm" + id] = twitter.deleteMessage(account.infoModel.accessToken, id);
		}
		
		public function cancelDeleteMessage(id:String):void
		{
			var loader:XMLLoader = model.loaderHash["dm" + id]
			
			if (loader)
			{
				loader.cancel();
				
				model.loaderHash["dm" + id] = null;
			}
		}
		public function isDeletingMessage(id:String):Boolean
		{
			return (model.loaderHash["dm" + id]);
		}
		
		public function favoriteStatus(account:AccountModule, id:String):void
		{
			cancelFavoriteStatus(id);
			
			model.loaderHash["fs" + id] = twitter.favoriteStatus(account.infoModel.accessToken, id);
		}
		
		public function cancelFavoriteStatus(id:String):void
		{
			var loader:XMLLoader = model.loaderHash["fs" + id]
			
			if (loader)
			{
				loader.cancel();
				
				model.loaderHash["fs" + id] = null;
			}
		}
		
		public function isFavoriting(id:String):Boolean
		{
			return (model.loaderHash["fs" + id]);
		}
		
		public function getRelationship(account:AccountModule, id:int):void
		{
			cancelCurrentGetRelationship();

			model.loaderHash["gr" + id] = twitter.getUserRelationship(account.infoModel.accessToken, id);
		}
		
		public function cancelGetRelationship(id:int):void
		{
			var loader:XMLLoader = model.loaderHash["gr" + id]
			
			if (loader)
			{
				loader.cancel();
				
				model.loaderHash["gr" + id] = null;
			}
		}
		
		public function cancelCurrentGetRelationship():void
		{
			for (var id:String in model.loaderHash)
			{
				if (id.substr(0.0, 2) == "gr")
				{
					if (model.loaderHash[id])
					{
						(model.loaderHash[id] as XMLLoader).cancel();
						
						model.loaderHash[id] = null;
					}
					
					break;
				}
			}
		}
		
		public function isGettingRelationship(id:int):Boolean
		{
			return (model.loaderHash["gr" + id]);
		}
		
		public function follow(account:AccountModule, id:int):void
		{
			cancelFollow(id);
			cancelUnfollow(id);
			
			model.loaderHash["f" + id] = twitter.followUser(account.infoModel.accessToken, id);
		}
		
		public function cancelFollow(id:int):void
		{
			var loader:XMLLoader = model.loaderHash["f" + id]
			
			if (loader)
			{
				loader.cancel();
				
				model.loaderHash["f" + id] = null;
			}
		}
		
		public function isFollowing(id:int):Boolean
		{
			return (model.loaderHash["f" + id]);
		}
		
		public function unfollow(account:AccountModule, id:int):void
		{
			cancelFollow(id);
			cancelUnfollow(id);
			
			model.loaderHash["uf" + id] = twitter.unfollowUser(account.infoModel.accessToken, id);
		}
		
		public function cancelUnfollow(id:int):void
		{
			var loader:XMLLoader = model.loaderHash["uf" + id]
			
			if (loader)
			{
				loader.cancel();
				
				model.loaderHash["uf" + id] = null;
			}
		}
		
		public function isUnfollowing(id:int):Boolean
		{
			return (model.loaderHash["uf" + id]);
		}
		
		protected function disposeLoader(loader:XMLLoader):void
		{
			for (var id:String in model.loaderHash)
			{
				if (model.loaderHash[id] == loader)
				{
					model.loaderHash[id] = null;
					break;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function deletedStatusHandler(loader:XMLLoader, status:StatusVO):void
		{
			model.loaderHash["ds" + status.id] = null;
			
			databaseController.deleteStatus(status.id);
			alertController.addMessage(null, "Deleted tweet!");
			
			signalBus.deletedStatus.dispatch(status.id);
		}
		
		protected function deletedStatusErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			disposeLoader(loader);

			alertController.addMessage(null, "Error deleting status.");
		}
		
		protected function deletedMessageHandler(loader:XMLLoader, message:DirectMessageVO):void
		{
			model.loaderHash["dm" + message.id] = null;
			
			databaseController.deleteStatus(message.id);
			alertController.addMessage(null, "Deleted message!");
			
			signalBus.deletedMessage.dispatch(message.id);
		}
		
		protected function deletedMessageErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			disposeLoader(loader);

			alertController.addMessage(null, "Error deleting message.");
		}
		
		protected function favoritedStatusHandler(loader:XMLLoader, status:StatusVO):void
		{
			model.loaderHash["fs" + status.id] = null;
			
			alertController.addMessage(null, "Favorited tweet!");
			
			signalBus.favoritedStatus.dispatch(status.id);
		}
		
		protected function favoritedStatusErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			disposeLoader(loader);
			
			alertController.addMessage(null, "Error favoriting status.");
		}
		
		protected function gotRelationshipHandler(loader:XMLLoader, relationship:RelationshipVO):void
		{
			model.loaderHash["gr" + relationship.targetUserID] = null;

			signalBus.gotRelationship.dispatch(relationship);
		}
		
		protected function gotRelationshipErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			disposeLoader(loader);
			
			alertController.addMessage(AlertSourceType.PROFILE, "Error getting relationship: " + message);
			
			signalBus.gotRelationshipError.dispatch();
		}
		
		protected function followedHandler(loader:XMLLoader, user:UserVO):void
		{
			model.loaderHash["f" + user.id] = null;
			
			alertController.addMessage(null, "You are now following " + user.screenName + "!");
			databaseController.addFriend(accountModel.currentAccount, user.id); //TODO - MULTI
			
			signalBus.followed.dispatch(user);
		}
		
		protected function followedErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			disposeLoader(loader);
			
			alertController.addMessage(AlertSourceType.PROFILE, "Error following: " + message);
			
			signalBus.followedError.dispatch();
		}
		
		protected function unfollowedHandler(loader:XMLLoader, user:UserVO):void
		{
			model.loaderHash["uf" + user.id] = null;
			
			alertController.addMessage(null, "You have unfollowed " + user.screenName + "!");
			databaseController.removeFriend(accountModel.currentAccount, user.id); //TODO - MULTI
			
			signalBus.unfollowed.dispatch(user);
		}
		
		protected function unfollowedErrorHandler(loader:XMLLoader, code:int, type:String, message:String):void
		{
			disposeLoader(loader);
			
			alertController.addMessage(AlertSourceType.PROFILE, "Error unfollowing: " + message);
			
			signalBus.unfollowedError.dispatch();
		}
	}
}