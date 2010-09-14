package qs.utils
{
	import mx.utils.URLUtil;
	
	public class URLUtils
	{
		public static function getFullURL(baseUrl:String,url:String):String
		{
			return base(baseUrl) + url;
		}
		
		public static function base(url:String):String
		{
			return url.match(/(.*\/).*/)[1];
		}
	}
}