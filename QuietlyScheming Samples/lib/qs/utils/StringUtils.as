package qs.utils
{
	public class StringUtils
	{
		public static function trim(value:String):String
		{
			return value.match(/^\s*(.*?)\s*$/)[1];
		}
	}
}