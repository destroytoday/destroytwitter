package com.destroytoday.destroytwitter.module.accountmodule.controller
{
	public interface IAccountStreamController
	{
		function get state():String;
		
		function getNumUnread():int;
		
		function getOlder(beforeID:String):void;
		
		function getNewer(afterID:String):void;
		
		function loadOlder():void;
		
		function loadMostRecent(refresh:Boolean = false):void;

		function getMostRecent():void;
		
		function stop():void;

		function cancel():void;
		
		function dispatchUpdatedSignal(newStatusList:Array):void;
	}
}