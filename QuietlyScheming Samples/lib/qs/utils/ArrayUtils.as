package qs.utils
{
	public class ArrayUtils
	{
		public static function map(value:Array,mapFunction:Function):Array
		{
			var len:Number = value.length;
			for(var i:Number = 0;i<len;i++)
			{
				value[i] = mapFunction(value[i]);
			}
			return value;
		}
	}
}