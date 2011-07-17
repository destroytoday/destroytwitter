package com.destroytoday.destroytwitter.module.accountmodule.model
{
	import com.destroytoday.destroytwitter.model.BaseModel;
	import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.vo.StatusVO;

	public class BaseAccountStreamModel implements IAccountStreamModel
	{
		// ------------------------------------------------------------
		// 
		// Mapped instances
		// 
		// ------------------------------------------------------------
		
		public var account:AccountModule;
		
		public var loader:XMLLoader;
		
		// ------------------------------------------------------------
		// 
		// Properties
		// 
		// ------------------------------------------------------------
		
		protected var _itemList:Array = [];
		
		protected var _prevNewestID:String = null;
		
		protected var _newestID:String = null;
		
		protected var _sinceID:String;
		
		protected var _maxID:String;
		
		protected var _oldestID:String;
		
		protected var _count:int = 20;
		
		protected var _numUnread:int;
		
		protected var _screenNameFilter:Array = [];
		
		protected var _keywordFilter:Array = [];
		
		protected var _sourceFilter:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BaseAccountStreamModel(account:AccountModule)
		{
			this.account = account;
		}
		
		// ------------------------------------------------------------
		// 
		// Getters / Setters
		// 
		// ------------------------------------------------------------
		
		public function get itemList():Array
		{
			return _itemList;
		}
		
		public function set itemList(value:Array):void
		{
			_itemList = value;
		}
		
		public function get prevNewestID():String
		{
			return _prevNewestID;
		}
		
		public function get newestID():String
		{
			return _newestID;
		}

		public function set newestID(value:String):void
		{
			if (value == _newestID) return;

			_prevNewestID = _newestID;
			_newestID = value;
		}
		
		public function get sinceID():String
		{
			return _sinceID;
		}
		
		public function set sinceID(value:String):void
		{
			if (value == _sinceID) return;
			
			_sinceID = value;
		}
		
		public function get oldestID():String
		{
			return _oldestID;
		}
		
		public function set oldestID(value:String):void
		{
			if (value == _oldestID) return;
			
			_oldestID = value;
		}
		
		public function get maxID():String
		{
			return _maxID;
		}
		
		public function set maxID(value:String):void
		{
			if (value == _maxID) return;
			
			_maxID = value;
		}
		
		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			if (value == _count) return;
			
			_count = value;
		}
		
		public function get numUnread():uint
		{
			return _numUnread;
		}
		
		public function set numUnread(value:uint):void
		{
			_numUnread = value;
		}
		
		public function get screenNameFilter():Array
		{
			return _screenNameFilter;
		}
		
		public function set screenNameFilter(value:Array):void
		{
			_screenNameFilter = value;
		}
		
		public function get keywordFilter():Array
		{
			return _keywordFilter;
		}
		
		public function set keywordFilter(value:Array):void
		{
			_keywordFilter = value;
		}
		
		public function get sourceFilter():Array
		{
			return _sourceFilter;
		}
		
		public function set sourceFilter(value:Array):void
		{
			_sourceFilter = value;
		}
	}
}