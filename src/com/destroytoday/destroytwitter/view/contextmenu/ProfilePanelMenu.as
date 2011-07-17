package com.destroytoday.destroytwitter.view.contextmenu
{
	import com.destroytoday.desktop.NativeMenuPlus;
	import com.destroytoday.twitteraspirin.constants.RelationshipType;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	public class ProfilePanelMenu extends NativeMenuPlus
	{
		//--------------------------------------------------------------------------
		//
		//  Items
		//
		//--------------------------------------------------------------------------
		
		public var relationship:NativeMenuItem;
		
		public var followUnfollow:NativeMenuItem;

		public var blockUnblock:NativeMenuItem;

		public var blockAndReport:NativeMenuItem;

		public var directMessage:NativeMenuItem;

		public var refresh:NativeMenuItem;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProfilePanelMenu()
		{
			super(
				<menu>
					<item name="relationship" label="Relationship" enabled="false" />
					<separator />
					<item name="followUnfollow" label="Follow" />
					<item name="directMessage" label="Direct Message..." />
					<separator />
					<item name="refresh" label="Refresh" />
					<!--<item name="blockUnblock" label="Block" />
					<item name="blockAndReport" label="Block & Report" />
					<separator />-->
				</menu>
			);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function setStatus(isAccount:Boolean, isGettingRelationship:Boolean, isFollowing:Boolean, isUnfollowing:Boolean, isBlocking:Boolean, isUnblocking:Boolean, isReporting:Boolean, _relationship:RelationshipVO = null):void
		{
			if (isAccount) 
			{
				relationship.label = "It's you!";
				followUnfollow.label = "Follow/Unfollow";
				followUnfollow.enabled = false;
				/*blockUnblock.label = "Block/Unblock";
				blockUnblock.enabled = false;
				blockAndReport.label = "Block & Report";
				blockAndReport.enabled = false;*/
				directMessage.enabled = false;
			} 
			else 
			{
				followUnfollow.label = "Follow/Unfollow";
				followUnfollow.enabled = false;
				/*blockUnblock.label = "Block/Unblock";
				blockUnblock.enabled = false;
				blockAndReport.label = "Block & Report";
				blockAndReport.enabled = false;*/
				directMessage.enabled = false;
				
				if (isGettingRelationship)
				{
					relationship.label = "Getting Relationship...";
				}
				else if (isFollowing || isUnfollowing)
				{
					followUnfollow.label = (isFollowing) ? "Following..." : "Unfollowing...";
				}
				/*else if (isBlocking || isUnblocking)
				{
					blockUnblock.label = (isBlocking) ? "Blocking..." : "Unblocking...";
				}
				else if (isReporting)
				{
					blockAndReport.label = "Blocking & Reporting...";
				}*/
				else if (_relationship)
				{
					relationship.label = _relationship.type;
					followUnfollow.label = (_relationship.type == RelationshipType.FOLLOWING || _relationship.type == RelationshipType.MUTUAL) ? "Unfollow" : "Follow";
					followUnfollow.enabled = true;
					//blockUnblock.label = (_relationship.blocking) ? "Unblock" : "Block";
					//blockUnblock.enabled = true;
					//blockAndReport.enabled = !_relationship.blocking;
					directMessage.enabled = (_relationship.type == RelationshipType.MUTUAL);
				}
			}
		}
		
		public function setRelationshipError():void
		{
			relationship.label = "Error Getting Relationship";
			followUnfollow.label = "Follow/Unfollow";
			followUnfollow.enabled = false;
			/*blockUnblock.label = "Block/Unblock";
			blockUnblock.enabled = false;
			blockAndReport.label = "Block & Report";
			blockAndReport.enabled = false;*/
			directMessage.enabled = false;
		}
		
		public function setFollowError():void
		{
			followUnfollow.label = "Error Following";
			followUnfollow.enabled = false;
		}
		
		public function setUnfollowError():void
		{
			followUnfollow.label = "Error Unfollowing";
			followUnfollow.enabled = false;
		}
	}
}