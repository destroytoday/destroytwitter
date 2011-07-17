package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.destroytwitter.manager.TweenManager;
	import com.destroytoday.text.TextFieldPlus;
	
	import flash.text.TextFieldAutoSize;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class Progress extends SpritePlus
	{
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
		
		/*public var retrievesURL:Boolean;
		
		protected var _bytesLoaded:Number;
		
		protected var _bytesTotal:Number;
		
		protected var kilobytes:Number;*/
		
		protected var _text:String;
		
		protected var _displayed:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Flags
		//
		//--------------------------------------------------------------------------
		
		protected var dirtyTextFlag:Boolean;
		
		/*protected var dirtyBytesLoadedFlag:Boolean;
		
		protected var dirtyBytesTotalFlag:Boolean;*/
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Progress()
		{
			textfield = addChild(new TextFieldPlus()) as TextFieldPlus;

			textfield.defaultTextFormat = TextFormatManager.getTextFormat(Font.INTERSTATE_REGULAR, 11.0);
			textfield.autoSize = TextFieldAutoSize.LEFT;
			
			visible = false;
			alpha = 0.0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get displayed():Boolean
		{
			return _displayed;
		}
		
		public function set displayed(value:Boolean):void
		{
			if (value == _displayed) return;
			
			_displayed = value;
			
			TweenManager.to(this, {alpha: (_displayed) ? 1.0 : 0.0});
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if (value == _text) return;
			
			_text = value;
			
			dirtyTextFlag = true;
			invalidateDisplayList();
		}
		
		/*public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		public function set bytesLoaded(value:Number):void
		{
			if (value == _bytesLoaded) return;
			
			_bytesLoaded = value;

			dirtyBytesLoadedFlag = true;
			invalidateDisplayList();
		}
		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		public function set bytesTotal(value:Number):void
		{
			if (value == _bytesTotal) return;
			
			_bytesTotal = value;

			dirtyBytesTotalFlag = true;
			invalidateDisplayList();
		}*/
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/*public function reset():void
		{
			bytesLoaded = NaN;
			bytesTotal = NaN;
		}*/
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (dirtyTextFlag)
			{
				dirtyTextFlag = false;
				
				textfield.text = _text;
			}
			
			/*if (dirtyBytesLoadedFlag || dirtyBytesTotalFlag)
			{
				dirtyBytesLoadedFlag = false;
				dirtyBytesTotalFlag = false;
				
				if (_bytesTotal > 0)
				{
					var percent:Number = Math.round((_bytesLoaded / _bytesTotal) * 100.0);
					
					if (retrievesURL && percent == 100.0)
					{
						textfield.autoSize = TextFieldAutoSize.LEFT;
						
						textfield.text = "Retrieving URL...";
					}
					else
					{
						kilobytes = Math.round(_bytesTotal * 0.001);
						
						textfield.text = percent + "% of " + kilobytes + "kb";
					}
				}
				else
				{
					textfield.text = "Retrieving info...";
				}
			}*/
		}
	}
}