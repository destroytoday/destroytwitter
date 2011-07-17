package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.layouts.IBasicLayoutElement;
	import com.destroytoday.layouts.IConstrainedLayoutElement;
	import com.destroytoday.layouts.IMarginedLayoutElement;
	import com.destroytoday.text.TextFieldPlus;
	
	public class LayoutTextField extends TextFieldPlus implements IMarginedLayoutElement, IConstrainedLayoutElement
	{
		protected var _marginLeft:Number = 0.0;
		
		protected var _marginTop:Number = 0.0;
		
		protected var _marginRight:Number = 0.0;
		
		protected var _marginBottom:Number = 0.0;
		
		protected var _left:Number;
		
		protected var _top:Number;
		
		protected var _right:Number;
		
		protected var _bottom:Number;
		
		protected var _center:Number;
		
		protected var _middle:Number;
		
		public function LayoutTextField()
		{
		}
		
		public function get marginLeft():Number
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void
		{
			_marginLeft = value;
		}
		
		public function get marginTop():Number
		{
			return _marginTop;
		}
		
		public function set marginTop(value:Number):void
		{
			_marginTop = value;
		}
		
		public function get marginRight():Number
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void
		{
			_marginRight = value;
		}
		
		public function get marginBottom():Number
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void
		{
			_marginBottom = value;
		}
		
		public function get left():Number
		{
			return _left;
		}
		
		public function set left(value:Number):void
		{
			_left = value;
		}
		
		public function get top():Number
		{
			return _top;
		}
		
		public function set top(value:Number):void
		{
			_top = value;
		}
		
		public function get right():Number
		{
			return _right;
		}
		
		public function set right(value:Number):void
		{
			_right = value;
		}
		
		public function get bottom():Number
		{
			return _bottom;
		}
		
		public function set bottom(value:Number):void
		{
			_bottom = value;
		}
		
		public function get center():Number
		{
			return _center;
		}
		
		public function set center(value:Number):void
		{
			_center = value;
		}
		
		public function get middle():Number
		{
			return _middle;
		}
		
		public function set middle(value:Number):void
		{
			_middle = value;
		}
		
		public function setConstraints(left:Number, top:Number, right:Number, bottom:Number):void
		{
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
		}
		
		public function setMargins(left:Number, top:Number, right:Number, bottom:Number):void
		{
			_marginLeft = left;
			_marginTop = top;
			_marginRight = right;
			_marginBottom = bottom;
		}
	}
}