package com.destroytoday.destroytwitter.view.window
{
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.SingletonManager;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.display.DisplayGroup;
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.text.TextFieldPlus;
	import com.destroytoday.util.ApplicationUtil;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ApplicationWindowBar extends DisplayGroup
	{
		// ------------------------------------------------------------
		// 
		// Instances
		// 
		// ------------------------------------------------------------
		
		public var controlGroup:ApplicationWindowButtonGroup;
		
		public var textfield:TextFieldPlus;
		
		// ------------------------------------------------------------
		// 
		// Properties
		// 
		// ------------------------------------------------------------
		
		protected const backgroundGradientColorPair:Array = [0, 0];
		
		protected const backgroundGradientAlphaPair:Array = [1, 1];
		
		protected const backgroundGradientRatioPair:Array = [0x00, 0xFF];
		
		protected const backgroundGradientMatrix:Matrix = new Matrix();
		
		protected var _backgroundGradientStartColor:uint;
		
		protected var _backgroundGradientEndColor:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyGraphicsFlag:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ApplicationWindowBar()
		{
			super(SingletonManager.getInstance(BasicLayout));

			controlGroup = addChild(new ApplicationWindowButtonGroup()) as ApplicationWindowButtonGroup;
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;

			if (ApplicationUtil.mac)
			{
				controlGroup.left = 8.0;
				controlGroup.middle = -1.0;
			}
			else
			{
				controlGroup.right = 5.0;
				controlGroup.middle = 0.0;
			}
			
			textfield.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0);
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.text = "DestroyTwitter";
			
			height = 25.0;
			
			doubleClickEnabled = true;
			
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
		}
		
		// ------------------------------------------------------------
		// 
		// Getters / Setters
		// 
		// ------------------------------------------------------------
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			backgroundGradientMatrix.createGradientBox(100.0, height, Math.PI / 2); //THINK - consider scale9Grid
			
			invalidateSize();
		}
		
		public function get backgroundGradientStartColor():uint
		{
			return _backgroundGradientStartColor;
		}

		public function set backgroundGradientStartColor(value:uint):void
		{
			if (value == _backgroundGradientStartColor) return;
			
			_backgroundGradientStartColor = backgroundGradientColorPair[0] = value;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get backgroundGradientEndColor():uint
		{
			return _backgroundGradientEndColor;
		}
		
		public function set backgroundGradientEndColor(value:uint):void
		{
			if (value == _backgroundGradientEndColor) return;
			
			_backgroundGradientEndColor = backgroundGradientColorPair[1] = value;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		// ------------------------------------------------------------
		// 
		// Methods
		// 
		// ------------------------------------------------------------

		override protected function commitProperties():void
		{
			super.commitProperties();
			
			dirtyGraphicsFlag = true;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			dirtyGraphicsFlag = true;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			textfield.x = int((width - textfield.width) * 0.5);
			textfield.y = int((height - textfield.height) * 0.5);
			
			if (dirtyGraphicsFlag)
			{
				dirtyGraphicsFlag = false;
				
				var graphics:Graphics = this.graphics;
				
				graphics.clear();
				graphics.beginGradientFill(
					GradientType.LINEAR, 
					backgroundGradientColorPair, 
					backgroundGradientAlphaPair, 
					backgroundGradientRatioPair, 
					backgroundGradientMatrix
				);
				graphics.drawRoundRectComplex(0.0, 0.0, width, height, 5.0, 5.0, 0.0, 0.0);
				graphics.endFill();
			}
		}
		
		// ------------------------------------------------------------
		// 
		// Handlers
		// 
		// ------------------------------------------------------------
		
		protected function doubleClickHandler(event:MouseEvent):void
		{
			if (ApplicationUtil.mac)
			{
				stage.nativeWindow.minimize();
			}
			else
			{
				stage.nativeWindow.maximize();
			}
		}
	}
}