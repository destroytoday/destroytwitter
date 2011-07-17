package com.destroytoday.destroytwitter.model.vo
{
	public interface IStreamVO
	{
		function get id():String;
		function get text():String;
		function get read():Boolean;
		
		function set id(value:String):void;
		function set text(value:String):void;
		function set read(value:Boolean):void;
	}
}