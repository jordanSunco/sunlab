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

package com.beyondo.sgs.client.impl.client.simple {
	
	import com.beyondo.sgs.client.impl.client.comm.ClientConnectorFactory;
	import com.beyondo.sgs.client.impl.client.comm.ClientConnector;
	import com.beyondo.sgs.client.impl.client.simple.SimpleClientConnector;

	/**
	 * A trivial ClientConnectorFactory that creates a new 
	 * <code>SimpleClientConnector</code> each time <code>createConnector</code>
	 * is invoked.
	 */
	public class SimpleConnectorFactory implements ClientConnectorFactory	{
		
    /**
     * Creates a new instance of <code>SimpleClientConnector</code> based on
     * the given <code>properties</code>.
     * 
     * @param properties which affect the creation of the
     *        <code>SimpleClientConnector</code> returned
     * @return a <code>SimpleClientConnector</code>
     */
		public function createConnector(properties:Object):ClientConnector {
			return new SimpleClientConnector(properties);
		}
		
	}
}