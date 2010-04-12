/*
 * Copyright
 */

package t;

import junit.framework.TestCase;

/**
 * 
 * @author Sun
 * @version PTest.java 2010-4-12 下午03:43:19
 */
public class PTest extends TestCase {
    private P p;

    protected void setUp() throws Exception {
        super.setUp();

        this.p = new P();
    }

    protected void tearDown() throws Exception {
        super.tearDown();

        this.p = null;
    }

    /**
     * Test method for {@link t.P#s()}.
     */
    public void testS() {
        assertEquals("s", this.p.s());
        // assertEquals("s1", p.s());
    }
}
