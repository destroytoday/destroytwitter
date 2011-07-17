package com.destroytoday.destroytwitter.mediator
{
    import com.destroytoday.destroytwitter.constants.DrawerState;
    import com.destroytoday.destroytwitter.constants.LinkType;
    import com.destroytoday.destroytwitter.constants.PreferenceType;
    import com.destroytoday.destroytwitter.constants.StreamState;
    import com.destroytoday.destroytwitter.constants.UnreadFormat;
    import com.destroytoday.destroytwitter.controller.AlertController;
    import com.destroytoday.destroytwitter.controller.ClipboardController;
    import com.destroytoday.destroytwitter.controller.ContextMenuController;
    import com.destroytoday.destroytwitter.controller.DatabaseController;
    import com.destroytoday.destroytwitter.controller.DrawerController;
    import com.destroytoday.destroytwitter.controller.GeneralTwitterController;
    import com.destroytoday.destroytwitter.controller.LinkController;
    import com.destroytoday.destroytwitter.controller.PreferencesController;
    import com.destroytoday.destroytwitter.controller.WorkspaceController;
    import com.destroytoday.destroytwitter.model.DrawerModel;
    import com.destroytoday.destroytwitter.model.WorkspaceModel;
    import com.destroytoday.destroytwitter.model.vo.GeneralMessageVO;
    import com.destroytoday.destroytwitter.model.vo.GeneralStatusVO;
    import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
    import com.destroytoday.destroytwitter.model.vo.IStreamVO;
    import com.destroytoday.destroytwitter.model.vo.StreamMessageVO;
    import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
    import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
    import com.destroytoday.destroytwitter.module.accountmodule.controller.IAccountStreamController;
    import com.destroytoday.destroytwitter.utils.TwitterTextUtil;
    import com.destroytoday.destroytwitter.view.components.BitmapButton;
    import com.destroytoday.destroytwitter.view.workspace.StreamElement;
    import com.destroytoday.destroytwitter.view.workspace.base.BaseStreamCanvas;
    import com.destroytoday.text.TextFieldPlus;
    import com.destroytoday.util.StringUtil;
    import com.flashartofwar.fcss.stylesheets.IStyleSheet;
    
    import flash.display.NativeMenu;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import flash.ui.ContextMenu;
    import flash.ui.Keyboard;
    import flash.utils.setTimeout;
    
    import org.osflash.signals.Signal;

    public class BaseStreamCanvasMediator extends BaseCanvasMediator
    {

        [Inject]
        public var alertController:AlertController;

        [Inject]
        public var clipboardController:ClipboardController;

        //--------------------------------------------------------------------------
        //
        //  Injections
        //
        //--------------------------------------------------------------------------

        [Inject]
        public var contextMenuController:ContextMenuController;

        [Inject]
        public var databaseController:DatabaseController;

        [Inject]
        public var drawerController:DrawerController;

        [Inject]
        public var drawerModel:DrawerModel;

        [Inject]
        public var generalTwitterController:GeneralTwitterController;

        [Inject]
        public var linkController:LinkController;

        [Inject]
        public var preferencesController:PreferencesController;

        [Inject]
        public var workspaceController:WorkspaceController;

        [Inject]
        public var workspaceModel:WorkspaceModel;

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        protected var controller:IAccountStreamController;

        //--------------------------------------------------------------------------
        //
        //  Flags
        //
        //--------------------------------------------------------------------------

        protected var dirtyShowSelection:Boolean;

        protected var findTextBeginIndex:int;

        protected var findTextEndIndex:int;

        protected var numUnreadChangedSignal:Signal;

        protected var selectedIndex:int = -2;

        protected var state:String;

        protected var updateStartedSignal:Signal;

        protected var updatedErrorSignal:Signal;

        protected var updatedSignal:Signal;

        protected var updatedStatusReadListSignal:Signal;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function BaseStreamCanvasMediator()
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

            view.pageButtonGroup.olderButton.addEventListener(MouseEvent.CLICK, olderButtonClickHandler);
            view.pageButtonGroup.newerButton.addEventListener(MouseEvent.CLICK, newerButtonClickHandler);
            view.pageButtonGroup.mostRecentButton.addEventListener(MouseEvent.CLICK, mostRecentButtonClickHandler);
            view.pageButtonGroup.optionsButton.addEventListener(MouseEvent.CLICK, optionsButtonClickHandler);

            view.title.addEventListener(TextEvent.LINK, titleLinkHandler);
            view.content.addEventListener(Event.ADDED, statusAddedHandler);
            view.content.addEventListener(Event.REMOVED, statusRemovedHandler);
            view.spinner.addEventListener(MouseEvent.CLICK, spinnerClickHandler);
            view.failWhale.addEventListener(MouseEvent.CLICK, failWhaleClickHandler);

            signalBus.accountSelected.add(accountSelectedHandler);
            signalBus.workspaceStateChanged.add(workspaceStateChangedHandler);
            signalBus.drawerOpened.add(drawerOpenedHandler);
            signalBus.drawerClosed.add(drawerClosedHandler);
            signalBus.imageViewerOpened.add(imageViewerOpenedHandler);
            signalBus.imageViewerClosed.add(imageViewerClosedHandler);
            signalBus.hotkeyStreamRefreshSelected.add(hotkeyStreamRefreshSelectedHandler);
            signalBus.hotkeyStreamMostRecentSelected.add(hotkeyStreamMostRecentSelectedHandler);
            signalBus.hotkeyStreamNewerSelected.add(hotkeyStreamNewerSelectedHandler);
            signalBus.hotkeyStreamOlderSelected.add(hotkeyStreamOlderSelectedHandler);
            signalBus.markedStreamStatusesRead.add(markedStreamStatusesReadHandler);
            signalBus.foundTerm.add(foundTermHandler);

            //--------------------------------------
            //  element loops
            //--------------------------------------
            signalBus.iconTypeChanged.add(iconTypeChangedHandler);
            signalBus.fontTypeChanged.add(fontTypeChangedHandler);
            signalBus.fontSizeChanged.add(fontSizeChangedHandler);
            signalBus.userFormatChanged.add(userFormatChangedHandler);
            signalBus.timeFormatChanged.add(timeFormatChangedHandler);
            signalBus.unreadFormatChanged.add(unreadFormatChangedHandler);
            signalBus.allowSelectionChanged.add(allowSelectionChangedHandler);

            updatedSignal.add(streamUpdatedHandler);
            updateStartedSignal.add(streamUpdateStartedHandler);
            updatedErrorSignal.add(streamUpdatedErrorHandler);
            numUnreadChangedSignal.add(numUnreadChangedHandler);
            if (updatedStatusReadListSignal)
                updatedStatusReadListSignal.add(updatedStatusReadListHandler);

            view.selectedIndexChanged.add(selectedIndexChangedHandler);
            view.keyEnabledChanged.add(keyEnabledChangedHandler);
            view.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

            if (accountModel.currentAccount)
            {
                accountSelectedHandler(accountModel.currentAccount);

                updatePreferences();
            }
        }

        //--------------------------------------------------------------------------
        //
        //  Handlers
        //
        //--------------------------------------------------------------------------

        protected function accountSelectedHandler(account:AccountModule):void
        {
            if (account)
            {
                updatePreferences();
            }
            else
            {
                if (view.dataProvider)
                    view.dataProvider.length = 0;

                view.setData(StreamState.DISABLED, view.dataProvider || [], null);
                view.numUnread = 0;
            }
        }

        protected function addFindListeners():void
        {
            view.completedScroll.add(completedScrollHandler);
            view.renderedElements.add(renderedElementsHandler);
        }

        protected function allowSelectionChangedHandler(allowSelection:Boolean):void
        {
            view.allowSelection = allowSelection;
        }

        protected function completedScrollHandler():void
        {
            dirtyShowSelection = true;

            if (view.selectedElement)
            {
                view.selectedElement.textfield.alwaysShowSelection = true;
                view.selectedElement.textfield.setSelection(findTextBeginIndex, findTextEndIndex);
            }
        }

        protected function drawerClosedHandler():void
        {
            if (state == workspaceModel.state)
            {
                if (drawerModel.state == DrawerState.FIND)
                {
                    removeFindListeners();
                    resetShowSelection();
                }

                view.keyEnabled = (state == workspaceModel.state);
            }
        }

        protected function drawerOpenedHandler(state:String):void
        {
            view.keyEnabled = false;

            if (state == DrawerState.FIND)
            {
                addFindListeners();
            }
            else
            {
                removeFindListeners();
            }
        }

        protected function failWhaleClickHandler(event:MouseEvent):void
        {
            mostRecentButtonClickHandler(event);
        }

        protected function fontSizeChangedHandler(fontSize:String):void
        {
            view.fontSize = fontSize;
        }

        protected function fontTypeChangedHandler(fontType:String):void
        {
            view.fontType = fontType;
        }

        protected function foundTermHandler(stream:String, term:String, itemIndex:int, textBeginIndex:int, textEndIndex:int):void
        {
            if (view.name == stream)
            {
                findTextBeginIndex = textBeginIndex;
                findTextEndIndex = textEndIndex;

                resetShowSelection();
                selectedIndex = itemIndex;
                view.selectElementAt(itemIndex);
            }
        }

        protected function hotkeyCopySelectedHandler():void
        {
            if (view.hasSelection && (view.stage.focus == null || (view.stage.focus is TextFieldPlus && (view.stage.focus as TextFieldPlus).selectedText == "")))
            {
                clipboardController.copyText(StringUtil.stripHTML(view.selectedData.text));
            }
        }

        protected function hotkeyStreamMostRecentSelectedHandler():void
        {
            if (workspaceModel.state == state)
            {
                mostRecentButtonClickHandler(null);
            }
        }

        protected function hotkeyStreamNewerSelectedHandler():void
        {
            if (workspaceModel.state == state)
            {
                newerButtonClickHandler(null);
            }
        }

        protected function hotkeyStreamOlderSelectedHandler():void
        {
            if (workspaceModel.state == state)
            {
                olderButtonClickHandler(null);
            }
        }

        protected function hotkeyStreamRefreshSelectedHandler():void
        {
            if (workspaceModel.state == state)
            {
                controller.loadMostRecent(true);
            }
        }

        protected function iconTypeChangedHandler(iconType:String):void
        {
            view.iconType = iconType;
        }

        protected function imageViewerClosedHandler():void
        {
            view.keyEnabled = (state == workspaceModel.state);
        }

        protected function imageViewerOpenedHandler(request:URLRequest):void
        {
            view.keyEnabled = false;
        }

        protected function keyDownHandler(event:KeyboardEvent):void
        {
            if (event.shiftKey)
            {

            }
            else if (event.altKey && !event.ctrlKey)
            {
                switch (event.keyCode)
                {
                    case Keyboard.UP:
                        view.selectPreviousUnreadElement();
                        break;
                    case Keyboard.DOWN:
                        view.selectNextUnreadElement();
                        break;
                }
            }
            else if (!event.altKey && !event.ctrlKey)
            {
                switch (event.keyCode)
                {
                    case Keyboard.UP:
                        view.selectElementAt(view.selectedIndex == -2 ? 0 : view.selectedIndex - 1);
                        break;
                    case Keyboard.DOWN:
                        view.selectElementAt(view.selectedIndex == -2 ? 0 : view.selectedIndex + 1);
                        break;
                    case Keyboard.ESCAPE:
                        view.selectedIndex = -2;
                        break;
                    case Keyboard.HOME:
                        view.selectElementAt(0);
                        break;
                    case Keyboard.END:
                        if (view.dataProvider)
                            view.selectElementAt(view.selectedIndex == -2 ? 0 : view.dataProvider.length - 1);
                        break;
                    case Keyboard.PAGE_UP:
                        view.selectElementAt(view.selectedIndex == -2 ? 0 : view.selectedIndex - Math.ceil(view.numVisibleStatuses));
                        break;
                    case Keyboard.PAGE_DOWN:
                        view.selectElementAt(view.selectedIndex == -2 ? 0 : view.selectedIndex + Math.ceil(view.numVisibleStatuses));
                        break;
                }
            }
        }

        protected function keyEnabledChangedHandler(keyEnabled:Boolean):void
        {
            if (keyEnabled)
            {
                view.selectedIndex = selectedIndex;

                view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                view.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);

                signalBus.hotkeyCopySelected.add(hotkeyCopySelectedHandler);
            }
            else
            {
                selectedIndex = view.selectedIndex;
                view.selectedIndex = -2;

                view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                view.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);

                signalBus.hotkeyCopySelected.remove(hotkeyCopySelectedHandler);
            }
        }

        protected function keyUpHandler(event:KeyboardEvent):void
        {
            if (!view.hasSelection || !view.allowSelection)
                return;

            var url:String;

            //--------------------------------------
            //  No modifiers
            //--------------------------------------
            if (!event.shiftKey && !event.altKey && !event.ctrlKey)
            {
                switch (event.keyCode)
                {
                    case Keyboard.R:
                        if (view.selectedData is GeneralStatusVO)
                        {
                            drawerController.openStatusReply(view.selectedData as GeneralStatusVO);
                        }
                        else if (view.selectedData is GeneralMessageVO)
                        {
                            drawerController.openMessageReply(view.selectedData as GeneralMessageVO);
                        }
                        break;
                    case Keyboard.M:
                        drawerController.openMessageReply(view.selectedData as GeneralTwitterVO);
                        break;
                    case Keyboard.T:
                        if (view.selectedData is GeneralStatusVO)
                        {
                            drawerController.openStatusRetweet(view.selectedData as GeneralStatusVO);
                        }
                        break;
                    case Keyboard.L:
                        if (view.selectedData && (url = TwitterTextUtil.getFirstLink(view.selectedData.text)))
                        {
                            linkController.openLink(LinkType.EXTERNAL + "," + url, false, false);
                        }
                        break;
                    case Keyboard.RIGHT:
                        if (view.selectedData is GeneralStatusVO && (view.selectedData as GeneralStatusVO).inReplyToStatusID)
                        {
                            drawerController.openDialogue(view.selectedData.id, (view.selectedData as GeneralStatusVO).inReplyToStatusID);
                        }
                        break;
                    case Keyboard.F:
                        if (view.selectedData is GeneralStatusVO)
                        {
                            generalTwitterController.favoriteStatus(accountModel.currentAccount, view.selectedData.id);
                        }
                        break;
                    case Keyboard.SPACE:
						if (view.selectedElement)
						{
							var button:BitmapButton = view.selectedElement.actionsGroup.actionsButton;
                        	button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						}
                        break;
                }
            }
			else if (!event.shiftKey && !event.ctrlKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.T:
						if (view.selectedData is GeneralStatusVO)
						{
							drawerController.openSecondaryStatusRetweet(view.selectedData as GeneralStatusVO);
						}
						break;
					case Keyboard.L:
						if (view.selectedData && (url = TwitterTextUtil.getFirstLink(view.selectedData.text)))
						{
							linkController.openLink(LinkType.EXTERNAL + "," + url, false, event.altKey);
						}
						break;
				}
			}
            //--------------------------------------
            //  Shift
            //--------------------------------------
            else if (!event.altKey && !event.ctrlKey)
            {
                switch (event.keyCode)
                {
                    case Keyboard.R:
                        if (view.selectedData is GeneralStatusVO)
                        {
                            drawerController.openStatusReply(view.selectedData as GeneralStatusVO, true);
                        }
                        break;
                    case Keyboard.L:
                        var urlList:Array;

                        if (view.selectedData && (urlList = TwitterTextUtil.getLinkList(view.selectedData.text)))
                        {
                            var delay:Number = 0.0;

                            for each (url in urlList)
                            {
                                setTimeout(linkController.openLink, delay += 100.0, LinkType.EXTERNAL + "," + url, false, false);
                            }
                        }
                        break;
                }
			}
			//--------------------------------------
			//  Alt
			//--------------------------------------
			else if (!event.shiftKey && !event.ctrlKey)
			{
				switch (event.keyCode)
				{
					case Keyboard.T:
						if (view.selectedData is GeneralStatusVO)
						{
							drawerController.openSecondaryStatusRetweet(view.selectedData as GeneralStatusVO);
						}
						break;
				}
			}
        }

        protected function markAllStatusesRead():void
        {
            var numRead:int;
			var status:IStreamVO;
			
			for each (var row:Object in view.dataProvider)
            {
				status = row as IStreamVO;
				
                if (status && !status.read)
                {
                    databaseController.queueStatusRead(status, false);

                    status.read = true;

                    ++numRead;
                }
            }

            if (numRead > 0)
            {
                databaseController.resetStatusTimer();
                databaseController.resetMessageTimer();

                workspaceController.getStreamControllerByName(view.name).markStatusRead(numRead);

                var m:uint = view.content.numChildren;

                for (var i:uint = 0; i < m; ++i)
                {
                    (view.content.getChildAt(i) as StreamElement).invalidateProperties();
                }
            }
        }

        protected function markStatusRead(status:IStreamVO):void
        {
            if (!status.read)
            {
                databaseController.queueStatusRead(status);
                workspaceController.getStreamControllerByName(view.name).markStatusRead();

                status.read = true;
            }
        }

        protected function markedStreamStatusesReadHandler(stream:String):void
        {
            if (stream == state)
            {
                view.scrollTo(0.0);

                markAllStatusesRead();
            }
        }

        protected function mostRecentButtonClickHandler(event:MouseEvent):void
        {
            if (controller.state == StreamState.MOST_RECENT || controller.state == StreamState.REFRESH)
            {
                controller.loadMostRecent(true);
            }
            else
            {
                controller.loadMostRecent();
            }
        }

        protected function mouseDownHandler(event:MouseEvent):void
        {
            workspaceController.setState(state);
        }

        protected function newerButtonClickHandler(event:MouseEvent):void
        {
            var afterID:String = (view.dataProvider.length > 0) ? (view.dataProvider[0] as IStreamVO).id : null;

            controller.getNewer(afterID);
        }

        protected function numUnreadChangedHandler(module:AccountModule, numUnread:int, delta:int):void
        {
            if (module == accountModel.currentAccount)
            {
                view.numUnread = numUnread;
            }
        }

        protected function olderButtonClickHandler(event:MouseEvent):void
        {
            if (view.dataProvider.length > 0)
            {
                var beforeID:String = (view.dataProvider[view.dataProvider.length - 1] as IStreamVO).id;

                controller.getOlder(beforeID);
            }
        }

        protected function optionsButtonClickHandler(event:MouseEvent):void
        {
            var button:BitmapButton = event.currentTarget as BitmapButton;

            var point:Point = button.localToGlobal(new Point(button.width * 0.5 - 1.0, button.height * 0.5 + 7.0));

            contextMenuController.displayStreamOptionsMenu(view.stage, point.x, point.y, view.name);
        }

        protected function removeFindListeners():void
        {
            view.completedScroll.remove(completedScrollHandler);
            view.renderedElements.remove(renderedElementsHandler);
        }

        protected function renderedElementsHandler():void
        {
            if (dirtyShowSelection)
                resetShowSelection();
        }

        protected function resetShowSelection():void
        {
            dirtyShowSelection = false;

            var m:uint = view.content.numChildren;

            for (var i:uint = 0; i < m; ++i)
            {
               (view.content.getChildAt(i) as StreamElement).textfield.alwaysShowSelection = false;
            }
        }

        protected function selectedIndexChangedHandler(selectedIndex:int):void
        {
            if (selectedIndex >= 0)
            {
                //workspaceController.setState(state);

                view.selectedIndex = this.selectedIndex = selectedIndex;

                if (view.selectedData)
                    markStatusRead(view.selectedData);
            }
        }

        protected function spinnerClickHandler(event:MouseEvent):void
        {
            controller.cancel();
        }

        protected function statusActionsButtonClickHandler(event:MouseEvent):void
        {
            var button:BitmapButton = event.currentTarget as BitmapButton;
            var data:IStreamVO = (button.parent.parent as StreamElement).data as IStreamVO;

            var point:Point = button.localToGlobal(new Point(button.width * 0.5 - 1.0, button.height * 0.5 + 7.0));

            if (data is StreamStatusVO)
            {
                contextMenuController.displayStatusActionsMenu(view.stage, point.x, point.y, data as StreamStatusVO);
            }
            else if (data is StreamMessageVO)
            {
                contextMenuController.displayMessageActionsMenu(view.stage, point.x, point.y, data as StreamMessageVO);
            }
        }

        protected function statusAddedHandler(event:Event):void
        {
            if (!(event.target is StreamElement))
                return;

            var status:StreamElement = event.target as StreamElement;

            styleController.applyStreamStatusStyle(status);

            status.addEventListener(MouseEvent.MOUSE_OVER, statusMouseOverHandler);
            status.textfield.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, twitterElementTextMenuPreSelectHandler);
            status.actionsGroup.replyButton.addEventListener(MouseEvent.CLICK, statusReplyButtonClickHandler);
            status.actionsGroup.actionsButton.addEventListener(MouseEvent.CLICK, statusActionsButtonClickHandler);
        }

        protected function statusMouseOverHandler(event:MouseEvent):void
        {
            if (preferencesController.getPreference(PreferenceType.UNREAD_FORMAT) == UnreadFormat.MOUSE_OVER && (event.currentTarget as StreamElement).data)
            {
                markStatusRead((event.currentTarget as StreamElement).data as IStreamVO);
            }
        }

        protected function statusRemovedHandler(event:Event):void
        {
            if (!(event.target is StreamElement))
                return;

            var status:StreamElement = event.target as StreamElement;

            status.removeEventListener(MouseEvent.MOUSE_OVER, statusMouseOverHandler);
            status.textfield.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, twitterElementTextMenuPreSelectHandler);
            status.actionsGroup.actionsButton.removeEventListener(MouseEvent.CLICK, statusActionsButtonClickHandler);
        }

        protected function statusReplyButtonClickHandler(event:MouseEvent):void
        {
            var data:GeneralTwitterVO = ((event.currentTarget as BitmapButton).parent.parent as StreamElement).data as GeneralTwitterVO;

            if (data is GeneralStatusVO && event.shiftKey)
            {
                drawerController.openStatusReply(data as GeneralStatusVO, true);
            }
            else if (data is GeneralStatusVO)
            {
                drawerController.openStatusReply(data as GeneralStatusVO);
            }
            else if (data is GeneralMessageVO)
            {
                drawerController.openMessageReply(data as GeneralMessageVO);
            }
        }

        protected function streamUpdateStartedHandler(module:AccountModule):void
        {
            if (module == accountModel.currentAccount)
            {
                view.pageButtonGroup.displayed = false;
                view.spinner.displayed = true;
                view.failWhale.displayed = false;
            }
        }

        protected function streamUpdatedErrorHandler(module:AccountModule, message:String):void
        {
            if (module == accountModel.currentAccount)
            {
                view.pageButtonGroup.displayed = true;
                view.spinner.displayed = false;

                if (message.indexOf("-1") == -1)
                {
                    view.failWhale.displayed = true;
                } //alertController.addMessage(StringUtil.capitalize(view.name), message);
            }
        }

        protected function streamUpdatedHandler(module:AccountModule, state:String, statusList:Array, newStatusesList:Array):void //TODO
        {
            if (module == accountModel.currentAccount)
            {
                if (!view.keyEnabled && selectedIndex >= 0)
                {
                    selectedIndex = (newStatusesList && selectedIndex + newStatusesList.length < statusList.length) ? selectedIndex + newStatusesList.length : -2;
                }

                view.pageButtonGroup.displayed = true;
                view.spinner.displayed = false;

                view.setData(state, statusList, newStatusesList);
            }
        }

        override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
        {
            super.stylesheetChangedHandler(stylesheet);

            styleController.applyStyle(view.pageButtonGroup.olderButton, stylesheet.getStyle('.BitmapButton'));
            styleController.applyStyle(view.pageButtonGroup.newerButton, stylesheet.getStyle('.BitmapButton'));
            styleController.applyStyle(view.pageButtonGroup.mostRecentButton, stylesheet.getStyle('.BitmapButton'));
            styleController.applyStyle(view.pageButtonGroup.optionsButton, stylesheet.getStyle('.BitmapButton'));
            styleController.applyStyle(view.failWhale, stylesheet.getStyle('.FailWhale'));

            var element:StreamElement;
            var m:uint = view.content.numChildren;

            for (var i:uint = 0; i < m; i++)
            {
                element = view.content.getChildAt(i) as StreamElement;

                styleController.applyStreamStatusStyle(element);
            }
        }

        protected function timeFormatChangedHandler(timeFormat:String):void
        {
            view.timeFormat = timeFormat;
        }

        protected function titleLinkHandler(event:TextEvent):void
        {
            if (event.text == "unread")
            {
                markAllStatusesRead();
            }
        }

        protected function twitterElementTextMenuPreSelectHandler(event:ContextMenuEvent):void
        {
            var request:URLRequest = (event.currentTarget as ContextMenu).link;

            if (request)
                request.url = linkController.normalizeLink(request.url);
        }

        protected function unreadFormatChangedHandler(unreadFormat:String):void
        {
            view.unreadFormat = unreadFormat;
        }

        protected function updatePreferences():void
        {
            view.fontSize = preferencesController.getPreference(PreferenceType.FONT_SIZE);
            view.fontType = preferencesController.getPreference(PreferenceType.FONT_TYPE);
            view.iconType = preferencesController.getPreference(PreferenceType.ICON_TYPE);
            view.userFormat = preferencesController.getPreference(PreferenceType.USER_FORMAT);
            view.timeFormat = preferencesController.getPreference(PreferenceType.TIME_FORMAT);
            view.unreadFormat = preferencesController.getPreference(PreferenceType.UNREAD_FORMAT);
            view.allowSelection = preferencesController.getBoolean(PreferenceType.SELECTION);
        }

        protected function updatedStatusReadListHandler(readCount:int):void
        {
            //view.numUnread -= readCount;

            view.dirtyGraphics();
        }

        protected function userFormatChangedHandler(userFormat:String):void
        {
            view.userFormat = userFormat;
        }

        protected function workspaceStateChangedHandler(oldState:String, newState:String):void
        {
            view.keyEnabled = (newState == state);
        }

        //--------------------------------------------------------------------------
        //
        //  Getters / Setters
        //
        //--------------------------------------------------------------------------

        private function get view():BaseStreamCanvas
        {
            return viewComponent as BaseStreamCanvas;
        }
    }
}