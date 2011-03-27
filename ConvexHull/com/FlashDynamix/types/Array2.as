class com.FlashDynamix.types.Array2 {
	public static function contains(a:Array, item):Boolean {
		for (var i = 0; i<a.length; i++) {
			if (a[i].valueOf() == item.valueOf()) {
				return true;
			}
		}
		return false;
	}
	public static function remove(a:Array, v):Array{
		for (var i = 0; i<a.length; i++) {
			if (a[i] == v) {
				a.splice(i, 1);
				i--;
			}
		}
		return a;
	}
	public static function removeItems(a:Array, v:Array):Array{
		for(var i=0; i<v.length; i++){
			remove(a, v[i]);
		}
		return a;
	}
	public static function insertAt(idx:Number, c:Array, a:Array):Array {
		var e:Array = c.splice(idx);
		c = c.concat(a);
		return c.concat(e);
	}
	public static function setEmpty(a:Array, empty, val):Array {
		for (var i = 0; i<a.length; i++) {
			if (a[i] == empty) {
				a[i] = val;
			}
		}
		return a;
	}
	public static function removeEmpty(a:Array, empty):Array {
		for (var i = 0; i<a.length; i++) {
			if (a[i] == empty) {
				a.splice(i, 1);
				i--;
			}
		}
		return a;
	}
	public static function addBetween(a:Array, val) {
		for (var i = 1; i<a.length; i++) {
			a.splice(i, 0, val);
			i++;
		}
		return a;
	}
}
