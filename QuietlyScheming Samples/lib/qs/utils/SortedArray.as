package qs.utils
{
	public class SortedArray extends Array
	{
		private var _compareField:String;
		private function _comparator:Function;
		private function _userComparator:Function;
		private var _dirty:Boolean = true;
		
		public function get dirty():Boolean { return _dirty; }
		public function SortedArray(base:Array = null)
		{
			if(base != null)
			{
				var args:Array = base.concat();
				args.unshift(0);
				args.unshift(0);
				splice.apply(this,args);
			}				
			super();
		}
		
		public function set compareField(value:String):void
		{
			_compareField = value;	
		}
		
	}
}