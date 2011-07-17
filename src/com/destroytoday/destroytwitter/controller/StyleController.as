package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.constants.PreferenceType;
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.model.StyleModel;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.destroytwitter.view.components.BitmapButton;
	import com.destroytoday.destroytwitter.view.components.TextButton;
	import com.destroytoday.destroytwitter.view.components.TextFieldVirtualList;
	import com.destroytoday.destroytwitter.view.components.TextInput;
	import com.destroytoday.destroytwitter.view.navigation.NavigationTextButton;
	import com.destroytoday.destroytwitter.view.workspace.StreamElement;
	import com.destroytoday.destroytwitter.view.workspace.TwitterElement;
	import com.destroytoday.util.ApplicationUtil;
	import com.destroytoday.util.ColorUtil;
	import com.destroytoday.util.FileUtil;
	import com.destroytoday.vo.ColorVO;
	import com.flashartofwar.fcss.applicators.StyleApplicator;
	import com.flashartofwar.fcss.stylesheets.FStyleSheet;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.text.TextField;
	
	public class StyleController
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var preferencesController:PreferencesController;
		
		[Inject]
		public var alertController:AlertController;
		
		[Inject]
		public var accountModel:AccountModuleModel;
		
		[Inject]
		public var model:StyleModel;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var styleApplicator:StyleApplicator = new StyleApplicator();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StyleController()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addListeners():void
		{
			signalBus.themeChanged.add(themeChangedHandler);
			
			model.browseFile.addEventListener(Event.SELECT, browseFileSelectHandler);
		}
		
		public function convertTheme(path:String):void
		{
			var theme:XML = new XML(FileUtil.read(path));
			var template:String = FileUtil.read(File.applicationDirectory.nativePath + File.separator + 'com/destroytoday/destroytwitter/styles/conversion.template');

			var regex:RegExp;
			var name:String = String(theme.child('name'));
			var creator:String = String(theme.child('creator'));
			
			if (!name || !creator)
			{
				alertController.addMessage(null, "Error converting theme. Check that both the name and creator properties are set.");
				
				return;
			}
			
			template = template.replace('%name%', name);
			template = template.replace('%creator%', creator);
			template = template.replace('%forVersion%', ApplicationUtil.version);
			
			var tabBackgroundDarker:ColorVO = ColorUtil.getRGB(uint('0x' + theme.colors.tabBackground));
			
			tabBackgroundDarker.red = Math.max(0.0, tabBackgroundDarker.red - 12.0);
			tabBackgroundDarker.green = Math.max(0.0, tabBackgroundDarker.green - 12.0);
			tabBackgroundDarker.blue = Math.max(0.0, tabBackgroundDarker.blue - 12.0);

			tabBackgroundDarker = ColorUtil.getHex(tabBackgroundDarker.red, tabBackgroundDarker.green, tabBackgroundDarker.blue);

			var hex:String = ColorUtil.formatHex(tabBackgroundDarker.hex, '');
			
			while (hex.length < 6)
			{
				hex = '0' + hex;
			}
			
			template = template.replace('%tabBackgroundDarker%', '#' + hex);
			
			for each (var color:XML in theme.colors.children())
			{
				regex = new RegExp('%' + String(color.name()) + '%', 'ig');

				template = template.replace(regex, '#' + String(color));
			}
			
			path = File.applicationStorageDirectory.nativePath + File.separator + 'themes' + File.separator + name + '.css';

			FileUtil.save(path, template);
			
			preferencesController.setString(PreferenceType.THEME, name);
			signalBus.preferencesChanged.dispatch();
		}
		
		public function browseForTheme():void
		{
			model.browseFile.browse(model.browseFilter);
		}
		
		public function reloadStylesheet():void
		{
			loadStylesheet(model.path);
		}
		
		public function loadStylesheet(path:String = null, setPreference:Boolean = false):void
		{
			var stylesheet:IStyleSheet = new FStyleSheet();
			var stream:FileStream = new FileStream();
			var file:File = new File();
			
			model.path = path;
			
			file.nativePath = File.applicationDirectory.nativePath + File.separator + "com/destroytoday/destroytwitter/styles/donottouch.css";
			stream.open(file, FileMode.READ);
			stream.position = 0.0;
			stylesheet.parseCSS(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			
			if (path)
			{
				file.nativePath = path;
			}
			
			if (!path || !file.exists)
			{
				file.nativePath = File.applicationDirectory.nativePath + File.separator + "com/destroytoday/destroytwitter/styles/themes/DestroyToday.css";
			}
			
			stream.open(file, FileMode.READ);
			stream.position = 0.0;

			stylesheet.parseCSS(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			
			var meta:Object = stylesheet.getStyle('#META');

			if (meta.name && meta.creator && meta.forVersion)
			{
				model.stylesheet = stylesheet;
			
				signalBus.stylesheetChanged.dispatch(stylesheet);
				
				if (accountModel.currentAccount)
				{
					preferencesController.setString(PreferenceType.THEME, file.name.substr(0.0, file.name.length - (file.extension.length + 1)), false);
					signalBus.preferencesChanged.dispatch();
				}
			}
			else
			{
				alertController.addMessage(null, "Error switching theme. Check that the name, creator, and forVersion properties are set.");
			}
		}
		
		public function applyStyle(target:Object, styleObject:Object):void
		{
			styleApplicator.applyStyle(target, styleObject);
		}
		
		public function applyBitmapButtonStyle(target:BitmapButton):void
		{
			styleApplicator.applyStyle(target, model.stylesheet.getStyle('.BitmapButton'));
		}
		
		public function applyTextButtonStyle(target:TextButton):void
		{
			styleApplicator.applyStyle(target.textfield, model.stylesheet.getStyle('.TextButtonTextField'));
			styleApplicator.applyStyle(target, model.stylesheet.getStyle('.TextButton'));
		}
		
		public function applyTextInputStyle(target:TextInput):void
		{
			styleApplicator.applyStyle(target.textfield, model.stylesheet.getStyle('.TextInputTextField'));
			styleApplicator.applyStyle(target, model.stylesheet.getStyle('.TextInput'));
		}
		
		public function applyStatusStyle(target:TwitterElement):void
		{
			styleApplicator.applyStyle(target.textfield, model.stylesheet.getStyle('.StatusTextField'));
			styleApplicator.applyStyle(target.info, model.stylesheet.getStyle('.StatusInfoTextField'));
			styleApplicator.applyStyle(target.actionsGroup.replyButton, model.stylesheet.getStyle('.BitmapButton'));
			styleApplicator.applyStyle(target.actionsGroup.actionsButton, model.stylesheet.getStyle('.BitmapButton'));
			
			target.dirtyStyle();
		}
		
		public function applyStreamStatusStyle(target:StreamElement):void
		{
			applyStatusStyle(target);
			styleApplicator.applyStyle(target, model.stylesheet.getStyle('.StreamStatus'));
		}
		
		public function applyNavigationTextButtonStyle(target:NavigationTextButton):void
		{
			styleApplicator.applyStyle(target.textfield, model.stylesheet.getStyle('.TextButtonTextField'));
			styleApplicator.applyStyle(target, model.stylesheet.getStyle('.NavigationTextButton'));

			target.dirtyState();
		}
		
		public function applyTextFieldListStyle(target:TextFieldVirtualList):void
		{
			styleApplicator.applyStyle(target.textfield, model.stylesheet.getStyle('.TextfieldListTextField'));
			styleApplicator.applyStyle(target.scroller.thumb, model.stylesheet.getStyle('.ScrollerThumb'));
			styleApplicator.applyStyle(target.scroller.track, model.stylesheet.getStyle('.ScrollerTrack'));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function themeChangedHandler(theme:String):void
		{
			loadStylesheet(File.applicationStorageDirectory.nativePath + File.separator + 'themes' + File.separator + theme + '.css');
		}
		
		protected function browseFileSelectHandler(event:Event):void
		{
			if (model.browseFile.extension == "css")
			{
				loadStylesheet(model.browseFile.nativePath, true);
			}
			else if (model.browseFile.extension == "dtwt")
			{
				convertTheme(model.browseFile.nativePath);
			}
		}
	}
}