/*
 * Copyright
 */

package t.suite;

import t.PTest;
import junit.framework.Test;
import junit.framework.TestSuite;

/**
 * Test Suite for JUnit3
 * 
 * @author Sun
 * @version AllTests.java 2010-4-12 下午04:15:55
 */
public class AllTests {
    /**
     * 
     * @return Test
     */
    public static Test suite() {
        TestSuite suite = new TestSuite("Test for t");
        // $JUnit-BEGIN$
        suite.addTestSuite(PTest.class);
        // $JUnit-END$
        return suite;
    }
}
