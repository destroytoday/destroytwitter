package com.destroytoday.destroytwitter.model.vo {
	import com.destroytoday.destroytwitter.utils.DateFormatUtil;
	import com.destroytoday.destroytwitter.utils.TwitterTextUtil;

	public class GeneralTwitterVO {
		//--------------------------------------------------------------------------
		//
		//  Account
		//
		//--------------------------------------------------------------------------

		public var account:int;

		// ------------------------------------------------------------
		// 
		// Status
		// 
		// ------------------------------------------------------------

		public var twelveHourDate:String; // populated via the helper

		public var twentyFourHourDate:String; // populated via the helper

		public var userFullName:String;

		// ------------------------------------------------------------
		// 
		// User
		// 
		// ------------------------------------------------------------

		public var userID:int;

		public var userIcon:String;

		public var userScreenName:String;

		protected var _id:String;

		protected var _text:String; // populated via the helper

		protected var textDirtyFlag:Boolean;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function GeneralTwitterVO() {
		}

		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get text():String {
			if (textDirtyFlag) {
				_text = TwitterTextUtil.format(_text);

				textDirtyFlag = false;
			}

			return _text;
		}

		public function set text(value:String):void {
			_text = value;

			textDirtyFlag = true;
		}

		// ------------------------------------------------------------
		// 
		// Helper Methods
		// 
		// ------------------------------------------------------------

		public function set timestamp(value:Number):void {
			var date:Date = new Date();

			date.time = value;

			twelveHourDate = DateFormatUtil.formatTwelveHourDate(date);
			twentyFourHourDate = DateFormatUtil.formatTwentyFourHourDate(date);
		}
	}
}