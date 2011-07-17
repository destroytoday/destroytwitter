package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.constants.BooleanType;
	import com.destroytoday.destroytwitter.constants.IconType;
	import com.destroytoday.destroytwitter.constants.PlatformType;
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.constants.RefreshRateType;
	import com.destroytoday.destroytwitter.constants.RetweetFormatType;
	import com.destroytoday.destroytwitter.constants.ScrollType;
	import com.destroytoday.destroytwitter.constants.TimeFormatType;
	import com.destroytoday.destroytwitter.constants.ToggleType;
	import com.destroytoday.destroytwitter.constants.UnreadFormat;
	import com.destroytoday.destroytwitter.constants.UserFormatType;
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.model.vo.PreferenceHeaderVO;
	import com.destroytoday.destroytwitter.model.vo.PreferenceLinkVO;
	import com.destroytoday.destroytwitter.model.vo.PreferenceVO;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvas;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvasContent;
	import com.destroytoday.filesystem.PreferencesFile;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.text.TextFieldAutoSize;
	
	public class PreferencesCanvas extends BaseCanvas
	{
		//--------------------------------------------------------------------------
		//
		//  Links
		//
		//--------------------------------------------------------------------------
		
		protected var _file:PreferencesFile;
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var textfield:TextFieldPlus;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var preferenceList:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyDataFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PreferencesCanvas()
		{
			content = addChild(new BaseCanvasContent()) as BaseCanvasContent;
			textfield = content.addChild(new TextFieldPlus()) as TextFieldPlus;
			
			textfield.multiline = true;
			textfield.wordWrap = true;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.width = 300.0;
			textfield.heightOffset = 6.0;
			
			content.setConstraints(5.0, 35.0, 15.0, 0.0);
			
			title.text = "Preferences";
			name = WorkspaceState.PREFERENCES;
			
			scroller.scrollValueChanged.add(scrollValueChangedHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get file():PreferencesFile
		{
			return _file;
		}
		
		public function set file(value:PreferencesFile):void
		{
			_file = value;

			dirtyDataFlag = true;
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		public function dirtyData():void
		{
			dirtyDataFlag = true;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			scroller.enabled = textfield.height > content.height;
			
			content.scrollY = Math.round(scroller.scrollValue * Math.max(0.0, textfield.height - content.height));
			
			if (dirtyDataFlag)
			{
				dirtyDataFlag = false;
				
				var preference:PreferenceVO;
				var link:PreferenceLinkVO;
				var text:String = "", option:String;
				
				for each (var item:Object in preferenceList)
				{
					if (item is PreferenceVO)
					{
						preference = item as PreferenceVO;
						
						option = _file.getString(preference.type);
						
						text += "<p><span class=\"preference\">" + preference.text + " <a href=\"event:" + preference.type + "\">" + option + "</a></span></p>";
					}
					else if (item is PreferenceLinkVO)
					{
						link = item as PreferenceLinkVO;
						
						text += "<p><span class=\"preference\"><a href=\"event:" + link.type + "\">" + link.text + " </a></span></p>";
					}
					else if (item is PreferenceHeaderVO)
					{
						if (text) text += "<p></p>";
						
						text += "<p><span class=\"subtitle\">" + (item as PreferenceHeaderVO).text + "</span></p>";
					}
					else if (item is String)
					{
						text += "<p><span class=\"preference\">" + item + "</span></p>";
					}
				}

				textfield.htmlText = text;
				
				content.measuredHeight = preferenceList.length * 18.0;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function scrollValueChangedHandler(type:String, scrollValue:Number):void
		{
			if (type != ScrollType.RESIZE) invalidateDisplayList();
		}
	}
}