package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.AlertSourceType;
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.controller.AlertController;
	import com.destroytoday.destroytwitter.controller.ContextMenuController;
	import com.destroytoday.destroytwitter.controller.DatabaseController;
	import com.destroytoday.destroytwitter.controller.DialogueController;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.drawer.Dialogue;
	import com.destroytoday.destroytwitter.view.drawer.DialogueElement;
	import com.destroytoday.destroytwitter.view.workspace.TwitterElement;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class DialogueMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var contextMenuController:ContextMenuController;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var databaseController:DatabaseController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var controller:DialogueController;
		
		[Inject]
		public var view:Dialogue;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var prevReplyStatusIDList:Vector.<String> = new Vector.<String>();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DialogueMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		protected function set keyEnabled(value:Boolean):void
		{
			if (value)
			{
				view.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			else
			{
				view.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerOpenedForDialogue.add(drawerOpenedForDialogueHandler);
			signalBus.drawerClosed.add(drawerClosedHandler);
			signalBus.gotOriginalDialogueStatus.add(gotOriginalDialogueStatusHandler);
			signalBus.gotOriginalDialogueStatusError.add(gotOriginalDialogueStatusErrorHandler);
			signalBus.getOriginalDialogueStatusCancelled.add(getOriginalDialogueStatusCancelledHandler);
			signalBus.fontSizeChanged.add(fontSizeChangedHandler);
			signalBus.fontTypeChanged.add(fontTypeChangedHandler);
			
			view.replyStatus.actionsGroup.replyButton.addEventListener(MouseEvent.CLICK, statusReplyButtonClickHandler);
			view.replyStatus.actionsGroup.actionsButton.addEventListener(MouseEvent.CLICK, statusActionsButtonClickHandler);
			view.originalStatus.actionsGroup.replyButton.addEventListener(MouseEvent.CLICK, statusReplyButtonClickHandler);
			view.originalStatus.actionsGroup.actionsButton.addEventListener(MouseEvent.CLICK, statusActionsButtonClickHandler);
			
			view.dirtySize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function drawerOpenedHandler(state:String):void
		{
			if (state == DrawerState.DIALOGUE)
			{
				keyEnabled = true;
				view.visible = true;
			}
			else
			{
				keyEnabled = false;
				view.visible = false;
				
				prevReplyStatusIDList.length = 0;
			}
		}
		
		protected function drawerOpenedForDialogueHandler(replyID:String, originalID:String):void
		{
			controller.cancelGetStatus();
			
			if (prevReplyStatusIDList.indexOf(replyID) == -1)
			{
				prevReplyStatusIDList[prevReplyStatusIDList.length] = replyID;
			}
			else
			{
				prevReplyStatusIDList.length = prevReplyStatusIDList.indexOf(replyID) + 1;
			}
			
			var statusList:Array = databaseController.getStatuses(accountModel.currentAccount, replyID, originalID);
			
			if (statusList.length > 1 && (statusList[0] as GeneralStatusVO).id == replyID)
			{
				view.replyStatus.data = statusList[0];
				view.originalStatus.data = statusList[1];
			}
			else if (statusList.length > 1)
			{
				view.replyStatus.data = statusList[1];
				view.originalStatus.data = statusList[0];
			}
			else
			{
				view.dirtySize();
				
				view.spinner.displayed = true;
				view.replyStatus.data = statusList[0];
				view.originalStatus.data = null;
				
				controller.getStatus(originalID);
			}
		}
		
		protected function drawerClosedHandler():void
		{
			keyEnabled = false;
			controller.cancelGetStatus();
			prevReplyStatusIDList.length = 0;
		}

		protected function keyUpHandler(event:KeyboardEvent):void
		{
			//--------------------------------------
			//  No modifiers
			//--------------------------------------
			if (!event.shiftKey && !event.altKey && !event.ctrlKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.RIGHT:
						if (view.originalStatus.data && (view.originalStatus.data as GeneralStatusVO).inReplyToStatusID)
						{
							drawerController.openDialogue(view.originalStatus.data.id, (view.originalStatus.data as GeneralStatusVO).inReplyToStatusID);
						}
						break;
					case Keyboard.LEFT:
						if (prevReplyStatusIDList.length > 1)
						{
							drawerController.openDialogue(prevReplyStatusIDList[prevReplyStatusIDList.length - 2], view.replyStatus.data.id);
						}
						else
						{
							drawerController.close();
						}
						break;
				}
			}
		}
		
		protected function gotOriginalDialogueStatusHandler(status:GeneralStatusVO):void
		{
			view.spinner.displayed = false;
			view.originalStatus.data = status;
		}
		
		protected function gotOriginalDialogueStatusErrorHandler(message:String):void
		{
			view.spinner.displayed = false;
			
			alertController.addMessage(AlertSourceType.DIALOGUE, message);
		}
		
		protected function getOriginalDialogueStatusCancelledHandler():void
		{
			view.spinner.displayed = false;
		}
		
		protected function statusReplyButtonClickHandler(event:MouseEvent):void
		{
			var data:GeneralStatusVO = ((event.currentTarget as BitmapButton).parent.parent as DialogueElement).data as GeneralStatusVO;
			
			if (event.shiftKey)
			{
				drawerController.openStatusReply(data, true);
			}
			else
			{
				drawerController.openStatusReply(data);
			}
		}

		protected function statusActionsButtonClickHandler(event:MouseEvent):void
		{
			var button:BitmapButton = event.currentTarget as BitmapButton;
			var data:GeneralStatusVO = (button.parent.parent as DialogueElement).data as GeneralStatusVO;
			
			var point:Point = button.localToGlobal(new Point(button.width * 0.5 - 1.0, button.height * 0.5 + 7.0));
			
			contextMenuController.displayStatusActionsMenu(view.stage, point.x, point.y, data);
		}
		
		protected function fontSizeChangedHandler(fontSize:String):void
		{
			view.dirtySize();
		}
		
		protected function fontTypeChangedHandler(fontType:String):void
		{
			view.dirtySize();
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStatusStyle(view.replyStatus);
			styleController.applyStatusStyle(view.originalStatus);
			styleController.applyStyle(view, stylesheet.getStyle('.Dialogue'));
		}
	}
}