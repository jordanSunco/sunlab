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

package com.beyondo.util
{
	/**
	 * A long value that may be updated atomically. An AtomicLong is used
	 * in applications such as atomically incremented sequence numbers.
	 */
	public class AtomicLong {
		private var value:Number;
		
		/**
		 * Create a new AtomicLong with the given initial value or zero
		 * as initial value.
		 * 
		 * @param initialValue the initial value
		 */
		public function AtomicLong(initialValue:Number = 0) {
			this.value = initialValue;
		}
		
		public function getValue() : Number { return this.value; }
		public function setValue(num:Number) : void { this.value = num; }
	    
	    /**
	     * Atomically sets to the given value and returns the old value.
	     *
	     * @param newValue the new value
	     * @return the previous value
	     */
		public function getAndSet(newValue:Number) : Number{
			var old:Number = this.getValue();
			this.value = newValue;
			return old;
		}
		
	    /**
	     * Atomically sets the value to the given updated value
	     * if the current value {@code ==} the expected value.
	     *
	     * @param expect the expected value
	     * @param update the new value
	     * @return true if successful. False return indicates that
	     * the actual value was not equal to the expected value.
	     */
	    public final function compareAndSet(expect:Number, update:Number) :
	    	Boolean {
			var old:Number = this.getValue();
			if (old == expect) {
				this.value = update;
			}
	    	
			return (old == expect);
	    }

	    /**
	     * Atomically increments by one the current value.
	     *
	     * @return the previous value
	     */
	    public final function getAndIncrement() : Number {
	        while (true) {
	            var current:Number = this.getValue();
	            var next:Number = current + 1;
	            if (compareAndSet(current, next))
	                return current;
	        }
	        return 0;
	    }

	    /**
	     * Atomically decrements by one the current value.
	     *
	     * @return the previous value
	     */
	    public final function getAndDecrement() : Number {
	        while (true) {
	            var current:Number = this.getValue();
	            var next:Number = current - 1;
	            if (compareAndSet(current, next))
	                return current;
	        }
	        return 0;
	    }

	    /**
	     * Atomically adds the given value to the current value.
	     *
	     * @param delta the value to add
	     * @return the previous value
	     */
	    public final function getAndAdd(delta:Number) : Number {
	        while (true) {
	            var current:Number = this.getValue();
	            var next:Number = current + delta;
	            if (compareAndSet(current, next))
	                return current;
	        }
	        return 0;
	    }
		
	    /**
	     * Atomically increments by one the current value.
	     *
	     * @return the updated value
	     */
	    public final function incrementAndGet() : Number {
	        for (;;) {
	            var current:Number = this.getValue();
	            var next:Number = current + 1;
	            if (compareAndSet(current, next))
	                return next;
	        }
	        return 0;
	    }
	
	    /**
	     * Atomically decrements by one the current value.
	     *
	     * @return the updated value
	     */
	    public final function decrementAndGet() : Number {
	        for (;;) {
	            var current:Number = this.getValue();
	            var next:Number = current - 1;
	            if (compareAndSet(current, next))
	                return next;
	        }
	        return 0;
	    }

	    /**
	     * Atomically adds the given value to the current value.
	     *
	     * @param delta the value to add
	     * @return the updated value
	     */
	    public final function addAndGet(delta:Number) : Number{
	        for (;;) {
	            var current:Number = this.getValue();
	            var next:Number = current + delta;
	            if (compareAndSet(current, next))
	                return next;
	        }
	        return 0;
	    }
	
	    /**
	     * Returns the String representation of the current value.
	     * @return the String representation of the current value.
	     */
	    public function toString(radix:Number = 10) : String {
	        return this.getValue().toString(radix);
	    }
	    
	    public final function intValue() : int {
	    	return int(this.getValue());
	    }
	    
	}
}