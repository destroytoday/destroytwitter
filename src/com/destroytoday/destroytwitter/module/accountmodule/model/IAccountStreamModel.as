package com.destroytoday.destroytwitter.module.accountmodule.model
{
	public interface IAccountStreamModel
	{
		function get numUnread():uint;
		
		function set numUnread(value:uint):void;
		
		function set count(value:int):void;
		
		function get itemList():Array;
	}
}