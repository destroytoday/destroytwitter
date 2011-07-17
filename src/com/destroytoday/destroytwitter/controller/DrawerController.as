package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.model.DrawerModel;
	import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.model.vo.URLPreviewVO;
	import com.destroytoday.destroytwitter.model.vo.UpdateVO;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;

	public class DrawerController
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var model:DrawerModel;
		
		public function DrawerController()
		{
		}
		
		public function openStatusUpdate(text:String = null):void
		{
			signalBus.drawerOpenedForStatusUpdate.dispatch(text);
			
			open(DrawerState.COMPOSE);
		}
		
		public function openStatusReply(data:GeneralStatusVO, all:Boolean = false):void
		{
			signalBus.drawerOpenedForStatusReply.dispatch(data, all);
			
			open(DrawerState.COMPOSE_REPLY);
		}
		
		public function openStatusRetweet(data:GeneralStatusVO):void
		{
			signalBus.drawerOpenedForStatusRetweet.dispatch(data);
			
			open(DrawerState.COMPOSE);
		}
		
		public function openSecondaryStatusRetweet(data:GeneralStatusVO):void
		{
			signalBus.drawerOpenedForSecondaryStatusRetweet.dispatch(data);
			
			open(DrawerState.COMPOSE);
		}
		
		public function openMessageReply(data:GeneralTwitterVO):void
		{
			signalBus.drawerOpenedForMessageReply.dispatch(data);
			
			open(DrawerState.COMPOSE_MESSAGE_REPLY);
		}
		
		public function openDialogue(replyID:String, originalID:String):void
		{
			signalBus.drawerOpenedForDialogue.dispatch(replyID, originalID);
			
			open(DrawerState.DIALOGUE);
		}
		
		public function openFind():void
		{
			signalBus.drawerOpenedForFind.dispatch();
			
			open(DrawerState.FIND);
		}
		
		public function openFilter(stream:String):void
		{
			signalBus.drawerOpenedForFilter.dispatch(stream);
			
			open(DrawerState.FILTER);
		}
		
		public function openProfile(screenName:String):void
		{
			signalBus.drawerOpenedForProfile.dispatch(screenName);
			
			open(DrawerState.PROFILE);
		}
		
		public function openURLPreview(url:String):void
		{
			signalBus.drawerOpenedForURLPreview.dispatch(url);
			
			open(DrawerState.URL_PREVIEW);
		}
		
		public function openUpdate(data:UpdateVO):void
		{
			signalBus.drawerOpenedForUpdate.dispatch(data);
			
			open(DrawerState.UPDATE);
		}
		
		public function open(state:String):void
		{
			model.state = state;
			model.opened = true;
		}
		
		public function close():void
		{
			model.opened = false;
		}
		
		public function updatePosition():void
		{
			signalBus.drawerPositionUpdated.dispatch();
		}
		
		public function toggle(state:String):Boolean
		{
			if (model.opened) {
				close();
			} else {
				open(state);
			}
			
			return model.opened;
		}
	}
}