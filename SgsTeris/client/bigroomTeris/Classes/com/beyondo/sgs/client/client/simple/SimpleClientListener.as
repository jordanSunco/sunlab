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

package com.beyondo.sgs.client.client.simple {
	
	import com.beyondo.sgs.client.client.ServerSessionListener;
	import com.beyondo.sgs.util.PasswordAuthentication;

	/**
	 * A listener used in conjunction with a <code>SimpleClient</code>.
	 * <p>
	 * A <code>SimpleClientListener</code>, specified when a
	 * <code>SimpleClient</code> is constructed, is notified of
	 * connection-related events generated during login session establishment,
	 * client reconnection, and client logout, and also is notified of message
	 * receipt and channel join events.
	 * </p>
	 * @see SimpleClient
	 */
	public interface SimpleClientListener extends ServerSessionListener	{
		
    /**
     * Requests a login credential for the client associated with this
     * listener.
     *
     * @return a login credential for the client
     */
		function get passwordAuthentication() : PasswordAuthentication;
		
    /**
     * Sets a login credential for the client associated with this
     * listener.
     *
     * @param pauth a login credential for the client
     */
		function set passwordAuthentication(pauth:PasswordAuthentication) : void;
		
    /**
     * Notifies this listener that a session has been established with the
     * server as a result of a successful login.
     */
		function loggedIn() : void;
		
    /**
     * Notifies this listener that a session could not be established with
     * the server due to some failure such as failure to verify a login
     * credential or failure to contact the server.
     * 
     * @param reason a description of the failure
     */
		function loginFailed(reason:String) : void;
		
		function exceptionThrown(err:String):void;
	}
}