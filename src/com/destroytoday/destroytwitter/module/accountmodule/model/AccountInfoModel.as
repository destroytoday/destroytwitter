package com.destroytoday.destroytwitter.module.accountmodule.model
{
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.twitteraspirin.vo.XAuthTokenVO;
	
	import flash.filesystem.File;
	
	import org.osflash.signals.Signal;

	public class AccountInfoModel
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		public const userChanged:Signal = new Signal(UserVO);
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _user:UserVO;
		
		protected var _accessToken:XAuthTokenVO;
		
		protected var _active:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AccountInfoModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------

		public function get path():String
		{
			return File.applicationStorageDirectory.nativePath + File.separator + 
					"accounts" + File.separator + accessToken.id + File.separator;
		}
		
		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			if (value == _active) return;
			
			_active = value;
		}

		public function get user():UserVO
		{
			return _user;
		}

		public function set user(value:UserVO):void
		{
			if (value == _user) return;
			
			_user = value;

			userChanged.dispatch(_user);
		}

		public function get accessToken():XAuthTokenVO
		{
			return _accessToken;
		}

		public function set accessToken(value:XAuthTokenVO):void
		{
			if (value == _accessToken) return;
			
			_accessToken = value;
		}
		/*
		public function get password():String
		{
			return EncryptedLocalStoreManager.getItem(accessToken.screenName);
		}
		
		public function set password(value:String):void
		{
			EncryptedLocalStoreManager.setItem(accessToken.screenName, value);
		}*/
	}
}