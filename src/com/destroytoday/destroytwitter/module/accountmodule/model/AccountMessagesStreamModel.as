package com.destroytoday.destroytwitter.module.accountmodule.model
{
	import com.destroytoday.destroytwitter.model.BaseModel;
	import com.destroytoday.destroytwitter.model.vo.StreamStatusVO;
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.vo.StatusVO;

	public class AccountMessagesStreamModel implements IAccountStreamModel
	{
		public var account:AccountModule;
		
		public var inboxLoader:XMLLoader;
		
		public var sentLoader:XMLLoader;
		
		// ------------------------------------------------------------
		// 
		// Properties
		// 
		// ------------------------------------------------------------
		
		protected var _itemList:Array = [];
		
		protected var _prevNewestInboxID:String;
		
		protected var _newestInboxID:String;
		
		protected var _sinceInboxID:String;
		
		protected var _maxInboxID:String;
		
		protected var _oldestInboxID:String;
		
		protected var _prevNewestSentID:String;
		
		protected var _newestSentID:String;
		
		protected var _sinceSentID:String;
		
		protected var _maxSentID:String;
		
		protected var _oldestSentID:String;
		
		protected var _count:int = 20;
		
		protected var _numUnread:int;
		
		public function AccountMessagesStreamModel(account:AccountModule)
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
		
		public function get prevNewestInboxID():String
		{
			return _prevNewestInboxID;
		}
		
		public function get newestInboxID():String
		{
			return _newestInboxID;
		}
		
		public function set newestInboxID(value:String):void
		{
			if (value == _newestInboxID) return;
			
			_prevNewestInboxID = _newestInboxID;
			_newestInboxID = value;
		}
		
		public function get sinceInboxID():String
		{
			return _sinceInboxID;
		}
		
		public function set sinceInboxID(value:String):void
		{
			if (value == _sinceInboxID) return;
			
			_sinceInboxID = value;
		}
		
		public function get oldestInboxID():String
		{
			return _oldestInboxID;
		}
		
		public function set oldestInboxID(value:String):void
		{
			if (value == _oldestInboxID) return;
			
			_oldestInboxID = value;
		}
		
		public function get maxInboxID():String
		{
			return _maxInboxID;
		}
		
		public function set maxInboxID(value:String):void
		{
			if (value == _maxInboxID) return;
			
			_maxInboxID = value;
		}
		
		public function get prevNewestSentID():String
		{
			return _prevNewestSentID;
		}
		
		public function get newestSentID():String
		{
			return _newestSentID;
		}
		
		public function set newestSentID(value:String):void
		{
			if (value == _newestSentID) return;
			
			_prevNewestSentID = _newestSentID;
			_newestSentID = value;
		}
		
		public function get sinceSentID():String
		{
			return _sinceSentID;
		}
		
		public function set sinceSentID(value:String):void
		{
			if (value == _sinceSentID) return;
			
			_sinceSentID = value;
		}
		
		public function get oldestSentID():String
		{
			return _oldestSentID;
		}
		
		public function set oldestSentID(value:String):void
		{
			if (value == _oldestSentID) return;
			
			_oldestSentID = value;
		}
		
		public function get maxSentID():String
		{
			return _maxSentID;
		}
		
		public function set maxSentID(value:String):void
		{
			if (value == _maxSentID) return;
			
			_maxSentID = value;
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
			if (value == _numUnread) return;
			
			var delta:int = Math.max(0, value - numUnread);
			
			_numUnread = value;
			
			account.signalBus.messagesStreamNumUnreadChanged.dispatch(account, _numUnread, delta);
		}
	}
}