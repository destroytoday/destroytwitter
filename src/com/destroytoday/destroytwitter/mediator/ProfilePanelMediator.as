package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.constants.LinkType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.LinkController;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.ProfilePanelController;
	import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
	import com.destroytoday.destroytwitter.view.drawer.ProfilePanel;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.events.MouseEvent;

	public class ProfilePanelMediator extends BaseMediator
	{

		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------

		[Inject]
		public var contextMenuController:ContextMenuController;

		[Inject]
		public var controller:ProfilePanelController;

		[Inject]
		public var drawerController:DrawerController;

		[Inject]
		public var linkController:LinkController;

		[Inject]
		public var preferencesController:PreferencesController;

		[Inject]
		public var view:ProfilePanel;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		protected var relationship:RelationshipVO;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ProfilePanelMediator()
		{
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		override public function onRegister():void
		{
			super.onRegister();

			controller.startedGetUser.add(startedGetUserHandler);
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerOpenedForProfile.add(drawerOpenedForProfileHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);
			signalBus.gotProfileUser.add(gotProfileUserHandler);
			signalBus.gotProfileUserError.add(gotProfileUserErrorHandler);
			signalBus.gotRelationship.add(gotRelationshipHandler);
			signalBus.followed.add(followedHandler);
			signalBus.unfollowed.add(unfollowedHandler);

			view.actionsButton.addEventListener(MouseEvent.CLICK, actionsButtonClickHandler);
			view.textfield.addEventListener(TextEvent.LINK, textfieldLinkHandler);
			view.heightChanged.add(heightChangedHandler);
		}

		protected function actionsButtonClickHandler(event:MouseEvent):void
		{
			displayMenu();
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		protected function displayMenu():void
		{
			var point:Point = view.actionsButton.localToGlobal(new Point(view.actionsButton.width * 0.5 - 1.0, view.actionsButton.height * 0.5 + 7.0));

			contextMenuController.displayProfilePanelMenu(view.stage, point.x, point.y, view.data, relationship);
		}

		protected function drawerClosedHandler():void
		{
			relationship = null;

			view.height = 0.0;

			controller.cancelGetUser();

			view.spinner.displayed = false;
		}

		protected function drawerOpenedForProfileHandler(screenName:String):void
		{
			view.data = null;

			controller.getUser(screenName);
		}

		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		protected function drawerOpenedHandler(state:String):void
		{
			if (state == DrawerState.PROFILE)
			{
				view.fontType = preferencesController.getPreference(PreferenceType.FONT_TYPE);

				view.visible = true;
			}
			else
			{
				view.visible = false;
			}
		}

		protected function followedHandler(user:UserVO):void
		{
		}

		protected function gotProfileUserErrorHandler(error:String):void
		{
			drawerController.close();
		}

		protected function gotProfileUserHandler(user:SQLUserVO):void
		{
			view.spinner.displayed = false;
			view.data = user;
		}

		protected function gotRelationshipHandler(relationship:RelationshipVO):void
		{
			this.relationship = relationship;

			displayMenu();
		}

		protected function heightChangedHandler(height:Number):void
		{
			drawerController.updatePosition();
		}

		protected function startedGetUserHandler():void
		{
			view.spinner.displayed = true;
		}

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.ProfileTextField'));
			styleController.applyBitmapButtonStyle(view.actionsButton);
		}

		protected function textfieldLinkHandler(event:TextEvent):void
		{
			if (event.text.indexOf(LinkType.SEARCH) != -1)
			{
				drawerController.close();
			}

			linkController.openLink(event.text);
		}

		protected function unfollowedHandler(user:UserVO):void
		{
		}
	}
}