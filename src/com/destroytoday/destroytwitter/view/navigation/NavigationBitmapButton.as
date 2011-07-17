package com.destroytoday.destroytwitter.view.navigation
{
	import com.destroytoday.destroytwitter.constants.ButtonState;
	import com.destroytoday.destroytwitter.constants.Font;
	import com.destroytoday.destroytwitter.manager.TextFormatManager;
	import com.destroytoday.text.TextFieldPlus;
	import com.destroytoday.util.ColorUtil;
	
	import flash.display.Bitmap;
	import flash.text.TextFieldAutoSize;

	public class NavigationBitmapButton extends BaseNavigationButton
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		protected var _bitmap:Bitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _bitmapUpColor:uint;

		protected var _bitmapOverColor:uint;
		
		protected var _bitmapSelectedUpColor:uint;

		protected var _bitmapSelectedOverColor:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NavigationBitmapButton(bitmap:Bitmap)
		{
			this.bitmap = bitmap;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get bitmapUpColor():uint
		{
			return _bitmapUpColor;
		}

		public function set bitmapUpColor(value:uint):void
		{
			if (value == _bitmapUpColor) return;
			
			_bitmapUpColor = value;
			
			invalidateProperties();
		}
		
		public function get bitmapOverColor():uint
		{
			return _bitmapOverColor;
		}

		public function set bitmapOverColor(value:uint):void
		{
			if (value == _bitmapOverColor) return;
			
			_bitmapOverColor = value;
			
			invalidateProperties();
		}

		public function get bitmapSelectedUpColor():uint
		{
			return _bitmapSelectedUpColor;
		}

		public function set bitmapSelectedUpColor(value:uint):void
		{
			if (value == _bitmapSelectedUpColor) return;
			
			_bitmapSelectedUpColor = value;
			
			invalidateProperties();
		}
		
		public function get bitmapSelectedOverColor():uint
		{
			return _bitmapSelectedOverColor;
		}

		public function set bitmapSelectedOverColor(value:uint):void
		{
			if (value == _bitmapSelectedOverColor) return;
			
			_bitmapSelectedOverColor = value;
			
			invalidateProperties();
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function set bitmap(value:Bitmap):void
		{
			if (value == _bitmap) return;
			
			if (_bitmap) removeChild(_bitmap);
			
			_bitmap = addChild(value) as Bitmap;
			_bitmap.x = 1.0;
			width = _bitmap.width + 2.0;
			
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			var color:uint;
			
			switch (_state) {
				case ButtonState.MOUSE_OVER:
					color = _bitmapOverColor;
					break;
				case ButtonState.SELECTED_UP:
					color = _bitmapSelectedUpColor;
					break;
				case ButtonState.SELECTED_OVER:
					color = _bitmapSelectedOverColor;
					break;
				default:
					color = _bitmapUpColor;
			}
			
			ColorUtil.apply(_bitmap, color);
		}
	}
}