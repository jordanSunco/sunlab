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

package com.beyondo.util.collection
{
	import com.beyondo.util.Equals;
	
	/**
	 * A naive definition of the Java Map interface.
	 */
	public interface Map {
		function clear() : void;
		function containsKey(key:Equals):Boolean;
		function containsValue(value:Equals):Boolean;
		// entrySet() not implemented
		// equals(Object o) not implemented
		function getValue(key:Equals):Object;
		// 	hashCode() not implemented
		function isEmpty():Boolean;
		function keySet():Array;
		function put(key:Equals, value:Equals):void;
		// putAll(Map t) not implemented
		function remove(key:Equals):Object;
		function size():int;
		function getValues():Array;
	}
}