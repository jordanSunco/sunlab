/*
 * Copyright
 */

package test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import test.web.controller.TestHelloController;

/**
 * 
 * @author Sun
 * @version AllTests.java 2010-7-29 上午10:03:16
 */
@RunWith(Suite.class)
@SuiteClasses({TestHelloController.class})
public class AllTests {
    // Test Suite
}
