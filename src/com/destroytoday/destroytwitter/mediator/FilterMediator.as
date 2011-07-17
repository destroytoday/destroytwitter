package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.constants.BooleanType;
	import com.destroytoday.destroytwitter.constants.DrawerState;
	import com.destroytoday.destroytwitter.constants.PositionType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.StreamType;
	import com.destroytoday.destroytwitter.controller.DrawerController;
	import com.destroytoday.destroytwitter.controller.PreferencesController;
	import com.destroytoday.destroytwitter.controller.QuickFriendLookupController;
	import com.destroytoday.destroytwitter.controller.WorkspaceController;
	import com.destroytoday.destroytwitter.model.QuickFriendLookupModel;
	import com.destroytoday.destroytwitter.module.accountmodule.controller.BaseAccountStreamController;
	import com.destroytoday.destroytwitter.module.accountmodule.model.BaseAccountStreamModel;
	import com.destroytoday.destroytwitter.utils.FilterUtil;
	import com.destroytoday.destroytwitter.view.drawer.Filter;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	public class FilterMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var workspaceController:WorkspaceController;
		
		[Inject]
		public var drawerController:DrawerController;
		
		[Inject]
		public var quickFriendLookupController:QuickFriendLookupController;
		
		[Inject]
		public var quickFriendLookupModel:QuickFriendLookupModel;
		
		[Inject]
		public var view:Filter;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var stream:String;
		
		protected var numScreenNameLines:int;
		
		protected var numKeywordLines:int;
		
		protected var numSourceLines:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FilterMediator()
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
			
			signalBus.drawerOpened.add(drawerOpenedHandler);
			signalBus.drawerOpenedForFilter.add(drawerOpenedForFilterHandler);
			signalBus.drawerClosed.add(drawerClosed);
			
			view.screenNamesInput.textfield.addEventListener(FocusEvent.FOCUS_IN, screenNamesInputFocusHandler);
			view.screenNamesInput.textfield.addEventListener(TextEvent.TEXT_INPUT, screenNamesInputTextChangeHandler);
			view.screenNamesInput.textfield.addEventListener(Event.CHANGE, inputChangeHandler);
			view.screenNamesInput.textfield.addEventListener(KeyboardEvent.KEY_DOWN, applyHandler);
			view.screenNamesInput.textfield.addEventListener(MouseEvent.MOUSE_DOWN, screenNamesMouseDownHandler);
			view.keywordsInput.textfield.addEventListener(KeyboardEvent.KEY_DOWN, applyHandler);
			view.keywordsInput.textfield.addEventListener(Event.CHANGE, inputChangeHandler);
			view.keywordsInput.textfield.addEventListener(FocusEvent.FOCUS_IN, otherInputFocusHandler);
			view.sourcesInput.textfield.addEventListener(Event.CHANGE, inputChangeHandler);
			view.sourcesInput.textfield.addEventListener(KeyboardEvent.KEY_DOWN, applyHandler);
			view.sourcesInput.textfield.addEventListener(FocusEvent.FOCUS_IN, otherInputFocusHandler);
			view.applyButton.addEventListener(MouseEvent.CLICK, applyHandler);
		}
		
		protected function updateLayout():void
		{
			var dirtyFlag:Boolean;
			
			if (view.screenNamesInput.textfield.numLines != numScreenNameLines)
			{
				dirtyFlag = true;
				
				numScreenNameLines = view.screenNamesInput.textfield.numLines;
				view.screenNamesInput.height = (numScreenNameLines == 1) ? 22.0 : Math.round(view.screenNamesInput.textfield.height + 8.0);
			}
			
			if (view.keywordsInput.textfield.numLines != numKeywordLines)
			{
				dirtyFlag = true;
				
				numKeywordLines = view.keywordsInput.textfield.numLines;
				view.keywordsInput.height = (numKeywordLines == 1) ? 22.0 : Math.round(view.keywordsInput.textfield.height + 8.0);
			}
			
			if (view.sourcesInput.textfield.numLines != numSourceLines)
			{
				dirtyFlag = true;
				
				numSourceLines = view.sourcesInput.textfield.numLines;
				view.sourcesInput.height = (numSourceLines == 1) ? 22.0 : Math.round(view.sourcesInput.textfield.height + 8.0);
			}
			
			if (dirtyFlag)
			{
				view.invalidateDisplayList();
				view.validateNow();
				
				drawerController.updatePosition();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function drawerOpenedHandler(state:String):void
		{
			if (state == DrawerState.FILTER)
			{
				view.visible = true;
			}
			else
			{
				view.visible = false;
			}
		}
		
		protected function drawerOpenedForFilterHandler(stream:String):void
		{
			this.stream = stream;
			
			var model:BaseAccountStreamModel = workspaceController.getAccountStreamModelByName(stream) as BaseAccountStreamModel;
			
			if (model)
			{
				view.enabled = true;
				
				var screenNameFilter:String = (model.screenNameFilter) ? FilterUtil.formatForDisplay(model.screenNameFilter) : view.screenNamesInput.defaultText;
				var keywordFilter:String = (model.keywordFilter) ? FilterUtil.formatForDisplay(model.keywordFilter) : view.keywordsInput.defaultText;
				var sourceFilter:String = (model.sourceFilter) ? FilterUtil.formatForDisplay(model.sourceFilter) : view.sourcesInput.defaultText;
				
				view.screenNamesInput.text = (screenNameFilter) ? screenNameFilter : view.screenNamesInput.defaultText;
				view.keywordsInput.text = (keywordFilter) ? keywordFilter : view.keywordsInput.defaultText;
				view.sourcesInput.text = (sourceFilter) ? sourceFilter : view.sourcesInput.defaultText;
				
				updateLayout();
			}
		}
		
		protected function drawerClosed():void
		{
			if (view.enabled)
			{
				view.enabled = false;
			}
		}
		
		protected function inputChangeHandler(event:Event):void
		{
			updateLayout();
		}
		
		protected function applyHandler(event:Event):void
		{
			if (event is MouseEvent || (event as KeyboardEvent).keyCode == Keyboard.ENTER)
			{
				var controller:BaseAccountStreamController = workspaceController.getAccountStreamControllerByName(stream) as BaseAccountStreamController;
				
				if (controller)
				{
					var screenNameFilter:String = (view.screenNamesInput.text != view.screenNamesInput.defaultText) ? view.screenNamesInput.text : "";
					var keywordFilter:String = (view.keywordsInput.text != view.keywordsInput.defaultText) ? view.keywordsInput.text : "";
					var sourceFilter:String = (view.sourcesInput.text != view.sourcesInput.defaultText) ? view.sourcesInput.text : "";

					controller.applyFilters(screenNameFilter, keywordFilter, sourceFilter);
					
					view.enabled = false; //FIX - won't work if before.
					drawerController.close();
				}
			}
		}
		
		protected function screenNamesInputFocusHandler(event:FocusEvent):void
		{
			if (!quickFriendLookupModel.displayed)
			{
				signalBus.quickFriendLookupDisplayedChanged.add(quickFriendLookupDisplayedChangedHandler);
				signalBus.quickFriendLookupScreenNameSelected.add(quickFriendLookupScreenNameSelectedHandler);
				
				if (view.screenNamesInput.text == view.screenNamesInput.defaultText)
				{
					var point:Point = view.screenNamesInput.textfield.localToGlobal(new Point(view.screenNamesInput.x, view.screenNamesInput.y - 32.0));

					quickFriendLookupController.display(point.x, point.y, PositionType.ABOVE);
				}
			}
			else
			{
				quickFriendLookupController.hide();
			}
		}
		
		protected function screenNamesMouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		protected function otherInputFocusHandler(event:FocusEvent):void
		{
			signalBus.quickFriendLookupDisplayedChanged.remove(quickFriendLookupDisplayedChangedHandler);
			signalBus.quickFriendLookupScreenNameSelected.remove(quickFriendLookupScreenNameSelectedHandler);
			
			quickFriendLookupController.hide();
		}
		
		protected function screenNamesInputTextChangeHandler(event:TextEvent):void
		{
			if (event.text == ",")
			{
				var bounds:Rectangle = view.screenNamesInput.textfield.getCharBoundaries(view.screenNamesInput.textfield.caretIndex - 1);
				
				if (bounds)
				{
					bounds.x = Math.min(bounds.x, view.parent.width - 180.0);
					
					var point:Point = view.screenNamesInput.textfield.localToGlobal(new Point(bounds.x, bounds.y));
					
					quickFriendLookupController.display(point.x, point.y, PositionType.ABOVE);
				}
			}
		}
		
		protected function quickFriendLookupDisplayedChangedHandler(displayed:Boolean):void
		{
			if (!displayed)
			{
				signalBus.quickFriendLookupDisplayedChanged.remove(quickFriendLookupDisplayedChangedHandler);
				signalBus.quickFriendLookupScreenNameSelected.remove(quickFriendLookupScreenNameSelectedHandler);
			}
		}
		
		protected function quickFriendLookupScreenNameSelectedHandler(screenName:String):void
		{
			var text:String = screenName;
			
			if (view.screenNamesInput.text == view.screenNamesInput.defaultText) view.screenNamesInput.text = "";
			
			if (view.screenNamesInput.text.length > 0 && view.screenNamesInput.text.substr(view.screenNamesInput.textfield.caretIndex - 1, 1) == ",")
			{
				text = " " + screenName;
			}
			
			view.screenNamesInput.textfield.replaceText(view.screenNamesInput.textfield.caretIndex, view.screenNamesInput.textfield.caretIndex, text);
			updateLayout();
			
			view.stage.focus = view.screenNamesInput.textfield;
		}
		
		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view.textfield, stylesheet.getStyle('.FilterTextField'));
			styleController.applyTextInputStyle(view.screenNamesInput);
			styleController.applyTextInputStyle(view.keywordsInput);
			styleController.applyTextInputStyle(view.sourcesInput);
			styleController.applyTextButtonStyle(view.applyButton);
		}
	}
}