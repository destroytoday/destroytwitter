package com.destroytoday.destroytwitter.utils
{
	import com.destroytoday.destroytwitter.model.vo.GeneralTwitterVO;
	import com.destroytoday.util.StringUtil;

	public class TwitterTextUtil
	{
		public static const URL_REGEX:RegExp = /(?<!@)(\b)((((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp):\/\/)|(www\.))*((([✪a-zA-Z0-9_-]+\.)+(aero|asia|biz|cat|com|coop|edu|gov|int|info|jobs|mobi|museum|name|net|org|pro|tel|travel|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bl|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mf|mg|mh|mil|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw))|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(\/[a-zA-Z0-9\+\&amp;%_\.\/\-\~\-\#\?\:\=,\!\|\(\)\*æøåßÄËÏÖÜÓäëïöüáéíóúñÑ]*)?(\/|\b))/ig;
		public static const EXACT_URL_REGEX:RegExp = /^((((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp):\/\/)|(www\.))*((([✪a-zA-Z0-9_-]+\.)+(aero|asia|biz|cat|com|coop|edu|gov|int|info|jobs|mobi|museum|name|net|org|pro|tel|travel|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bl|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mf|mg|mh|mil|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw))|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(\/[a-zA-Z0-9\+\&amp;%_\.\/\-\~\-\#\?\:\=,\!\|\(\)\*æøåßÄËÏÖÜÓäëïöüáéíóúñÑ]*)?(\/|\b))$/i;
		public static const HTML_ENTITIES:RegExp = /&[A-Z0-9]+;/ig
		public static const USERNAME_CHARS:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
		
		protected static const LINEBREAKS:RegExp = /[\n\r ]+/g;
		protected static const HASHTAG:RegExp = /(?<!\/)\B#([A-Za-z0-9_æøåßÄËÏÖÜÓäãçëïöüáéíóúñÑ\-]+)/ig;
		protected static const SCREENNAME:RegExp = /\B@([A-Za-z0-9_]+)/ig;
		protected static const STOCKTWITS:RegExp = /(\B\$[A-Za-z]+)/ig;
		
		protected static const SCREENNAMES:RegExp = /\B@[A-Za-z0-9_]+/ig;
		
		protected static const GREATER_THAN:RegExp = />/g;
		protected static const LESS_THAN:RegExp = /</g;
		
		public static function replaceHTMLEntities(text:String):String
		{
			return text.replace(HTML_ENTITIES, " ");
		}
		
		public static function replaceIllegalSpellCheckChars(text:String):String
		{
			var matchList:Array = text.match(SCREENNAME);
			var i:uint, m:uint;
			
			matchList = matchList.concat(text.match(HASHTAG));
			matchList = matchList.concat(text.match(STOCKTWITS));
			
			for each (var illegalWord:String in matchList)
			{
				i = text.indexOf(illegalWord);
				m = i + illegalWord.length;
				
				for (i; i < m; i++)
				{
					text = text.substring(0.0, i) + "#" + text.substr(i + 1);
				}
			}

			return text;
		}
		
		public static function format(text:String):String
		{
			if (text.indexOf(">") != -1) text = text.replace(GREATER_THAN, "&gt;");
			if (text.indexOf("<") != -1) text = text.replace(LESS_THAN, "&lt;");
			text = text.replace(LINEBREAKS, " ");
			text = text.replace(URL_REGEX, "$1<a href=\"event:external,$2\"><span class=\"url\">$2</span></a>");
			text = text.replace(SCREENNAME, "<a href=\"event:user,$1\"><span class=\"screenName\">@$1</span></a>");
			text = text.replace(HASHTAG, "<a href=\"event:hashtag,#$1\"><span class=\"hashtag\">#$1</span></a>");
			text = text.replace(STOCKTWITS, "<a href=\"event:stocks,$1\"><span class=\"stockSymbol\">$1</span></a>");
			
			return text;
		}
		
		public static function getFirstLink(text:String):String
		{
			var matchList:Array = StringUtil.stripHTML(text).match(URL_REGEX);

			if (matchList)
			{
				return matchList[0];
			}
			
			return null;
		}
		
		public static function getLinkList(text:String):Array
		{
			var matchList:Array = StringUtil.stripHTML(text).match(URL_REGEX);
			
			if (matchList)
			{
				return matchList;
			}
			
			return null;
		}
		
		public static function getUniqueScreenNameList(data:GeneralTwitterVO, excludeScreenName:String):Array
		{
			var match:Boolean;
			
			var screenNameMatchList:Array = data.text.match(SCREENNAMES);
			var screenNameList:Array = ["@" + excludeScreenName, "@" + data.userScreenName];
			
			var m:uint = screenNameMatchList.length;
			
			for (var i:uint = 0; i < m; ++i)
			{
				var n:uint = screenNameList.length;
				match = true;
				
				for (var j:uint = 0; j < n; ++j)
				{
					if (String(screenNameMatchList[i]).toLowerCase() == String(screenNameList[j]).toLowerCase())
					{
						match = false;
						break;
					}
				}
				
				if (match)
				{
					screenNameList.push.apply(null, screenNameMatchList.splice(i, 1));
					
					--i;
					--m;
				}
			}
			
			screenNameList.shift();
			
			return screenNameList;
		}
	}
}