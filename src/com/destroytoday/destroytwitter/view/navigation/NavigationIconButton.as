package com.destroytoday.destroytwitter.view.navigation
{
	import com.destroytoday.layouts.HorizontalAlignType;
	import com.destroytoday.layouts.IAlignedLayoutElement;
	import com.destroytoday.layouts.IMarginedLayoutElement;
	import com.destroytoday.destroytwitter.view.components.IconButton;
	
	public class NavigationIconButton extends IconButton implements IAlignedLayoutElement, IMarginedLayoutElement
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _align:String = HorizontalAlignType.LEFT;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NavigationIconButton()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get align():String
		{
			return _align;
		}
		
		public function set align(value:String):void
		{
			_align = value;
		}
	}
}