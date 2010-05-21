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

package com.beyondo.sgs.util {

	/**
	 * The class <code>PasswordAuthentication</code> is a data holder. It is
	 * simply a repository for a user name and a password.	
	 */
	public class PasswordAuthentication	{
		
		private var _username : String;
		private var _password : String;
		
		/**
		 *  Creates a new <code>PasswordAuthentication</code> object from the given
		 * user name and password.
		 * @param username the user name
		 * @param password the password
		 */
		public function PasswordAuthentication(username:String, password: String) {
			this._username = username;
			this._password = password;
		}
		
		public function set username(username:String) : void {_username = username;}
		public function get username() : String {return _username;}

		public function set password(password:String) : void {_password = password;}
		public function get password() : String {return _password;}
	}
}