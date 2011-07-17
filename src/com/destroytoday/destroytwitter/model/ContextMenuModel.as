package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.destroytwitter.view.contextmenu.AccountIconMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.ComposeMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.FileUploaderMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.PreferenceMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.ProfilePanelMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.SearchHistoryMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.StreamMessageActionsMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.StreamOptionsMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.StreamStatusActionsMenu;
	import com.destroytoday.destroytwitter.view.contextmenu.URLShortenerMenu;
	import com.destroytoday.twitteraspirin.constants.ImageServiceType;
	import com.destroytoday.util.ApplicationUtil;
	
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;

	public class ContextMenuModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _streamOptionsMenu:StreamOptionsMenu;
		
		protected var _statusActionsMenu:StreamStatusActionsMenu;
		
		protected var _messageActionsMenu:StreamMessageActionsMenu;
		
		protected var _urlShortenerMenu:URLShortenerMenu;

		protected var _fileUploaderMenu:FileUploaderMenu;
		
		protected var _accountIconMenu:AccountIconMenu;

		protected var _preferenceMenu:PreferenceMenu;

		protected var _profilePanelMenu:ProfilePanelMenu;

		protected var _searchHistoryMenu:SearchHistoryMenu;

		protected var _composeMenu:ComposeMenu;
		
		protected var _twitterElementTextMenu:ContextMenu;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ContextMenuModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get streamOptionsMenu():StreamOptionsMenu
		{
			if (!_streamOptionsMenu) {
				_streamOptionsMenu = new StreamOptionsMenu();
				
				if (ApplicationUtil.mac) {
					_streamOptionsMenu.refresh.keyEquivalentModifiers = 
					_streamOptionsMenu.markAsRead.keyEquivalentModifiers = 
					_streamOptionsMenu.find.keyEquivalentModifiers = [Keyboard.COMMAND];
					_streamOptionsMenu.configureFilter.keyEquivalentModifiers = [Keyboard.COMMAND, Keyboard.SHIFT];
				} else {
					_streamOptionsMenu.refresh.keyEquivalentModifiers = 
					_streamOptionsMenu.markAsRead.keyEquivalentModifiers = 
					_streamOptionsMenu.find.keyEquivalentModifiers = [Keyboard.CONTROL];
					_streamOptionsMenu.configureFilter.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT];
				}
			}
			
			return _streamOptionsMenu;
		}
		
		public function get statusActionsMenu():StreamStatusActionsMenu
		{
			if (!_statusActionsMenu) {
				_statusActionsMenu = new StreamStatusActionsMenu();

				if (ApplicationUtil.mac) {
					_statusActionsMenu.copyToClipboard.keyEquivalentModifiers = [Keyboard.COMMAND];
				} else {
					_statusActionsMenu.copyToClipboard.keyEquivalentModifiers = [Keyboard.CONTROL];
				}
			}
			
			return _statusActionsMenu;
		}
		
		public function get messageActionsMenu():StreamMessageActionsMenu
		{
			if (!_messageActionsMenu) {
				_messageActionsMenu = new StreamMessageActionsMenu();
				
				if (ApplicationUtil.mac) {
					_messageActionsMenu.copyToClipboard.keyEquivalentModifiers = [Keyboard.COMMAND];
				} else {
					_messageActionsMenu.copyToClipboard.keyEquivalentModifiers = [Keyboard.CONTROL];
				}
			}
			
			return _messageActionsMenu;
		}
		
		public function get urlShortenerMenu():URLShortenerMenu
		{
			if (!_urlShortenerMenu) {
				_urlShortenerMenu = new URLShortenerMenu();
			}
			
			return _urlShortenerMenu;
		}
		
		public function get fileUploaderMenu():FileUploaderMenu
		{
			if (!_fileUploaderMenu) {
				_fileUploaderMenu = new FileUploaderMenu();
				
				if (ApplicationUtil.mac) {
					_fileUploaderMenu.uploadFile.keyEquivalentModifiers = [Keyboard.COMMAND];
				} else {
					_fileUploaderMenu.uploadFile.keyEquivalentModifiers = [Keyboard.CONTROL];
				}
			}
			
			return _fileUploaderMenu;
		}
		
		public function get accountIconMenu():AccountIconMenu
		{
			if (!_accountIconMenu) {
				_accountIconMenu = new AccountIconMenu();
				
				_accountIconMenu.user.checked = true;
			}
			
			return _accountIconMenu;
		}
		
		public function get preferenceMenu():PreferenceMenu
		{
			if (!_preferenceMenu) {
				_preferenceMenu = new PreferenceMenu();
			}
			
			return _preferenceMenu;
		}
		
		public function get profilePanelMenu():ProfilePanelMenu
		{
			if (!_profilePanelMenu) {
				_profilePanelMenu = new ProfilePanelMenu();
			}
			
			return _profilePanelMenu;
		}
		
		public function get searchHistoryMenu():SearchHistoryMenu
		{
			if (!_searchHistoryMenu) {
				_searchHistoryMenu = new SearchHistoryMenu();
			}
			
			return _searchHistoryMenu;
		}
		
		public function get composeMenu():ComposeMenu
		{
			if (!_composeMenu) {
				_composeMenu = new ComposeMenu();
			}
			
			return _composeMenu;
		}
		
		public function get twitterElementTextMenu():ContextMenu
		{
			if (!_twitterElementTextMenu) {
				_twitterElementTextMenu = new ContextMenu();
			}
			
			return _twitterElementTextMenu;
		}
	}
}