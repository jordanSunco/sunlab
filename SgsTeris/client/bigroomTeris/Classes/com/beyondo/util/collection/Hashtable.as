/**
 * Beyondo licenses this file to You under the GNU General Public
 * License, Version 3.0 (the "License");
 * 
 * You may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.gnu.org/licenses/lgpl.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.beyondo.util.collection {
	import com.beyondo.util.Equals;
	
	/**
	 * A naive implemntation of a Java Hashtable.
	 */
	public class Hashtable implements Map	{
		private var keys:Array = new Array();
		private var values:Array = new Array();
		
		public function clear():void {
			var len:int = keys.length;
			for (var i:int = len; i >=0 ; i--) {
				values.pop();
				keys.pop();
			}
		}
		
		public function containsKey(key:Equals):Boolean
		{
			var l:int = keys.length;
			for (var i:int = 0; i < l; i++) {
				if (Equals(keys[i]).equals(key)) return true;
			}
			return false;
		}
		
		public function putIfAbsent(key:Equals, val:Equals) :Boolean {
			if (!this.containsKey(key)) {
				this.put(key,val);
				return true;
			}
			return false;
		}
		
		public function containsValue(value:Equals):Boolean
		{
			var i:int = values.indexOf(value);
			if ( i != -1 )
				return true;
			return false;
		}
		
		public function getValue(key:Equals):Object
		{
			if (key == null) return null;
			var l:int = keys.length;
			for (var i:int = 0; i < l; i++) {
				if (Equals(keys[i]).equals(key)) 
					return values[i];
			}
			return null;
		}
		
		public function isEmpty():Boolean
		{
			if (keys.length == 0)
				return true;
				
			return false;
		}
		
		public function keySet():Array
		{
			return keys;
		}
		
		public function put(key:Equals, value:Equals):void
		{
			keys.push(key);
			values.push(value);
		}
		
		public function remove(key:Equals):Object
		{
			var i:int = keys.indexOf(key);
			if ( i == -1 )
				return null;
				
			keys.splice(i, 1);
			var ret:Array = values.splice(i, 1);
			return ret;
		}
		
		public function size():int
		{
			return keys.length;
		}
		
		public function getValues():Array
		{
			return values;
		}
	}
}