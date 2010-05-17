/*
 * Copyright
 */

package t.suite;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import t.PTest;
import t.PTest4;

/**
 * Test Suite for JUnit4
 * 
 * @author Sun
 * @version AllTests.java 2010-4-12 下午04:15:55
 */
@RunWith(Suite.class)
@SuiteClasses({ PTest.class, PTest4.class })
public class AllTests4 {
    // suite for JUnit4
}
