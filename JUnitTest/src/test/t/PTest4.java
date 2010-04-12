/*
 * Copyright
 */

package t;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

/**
 * 
 * @author Administrator
 * @version PTest4.java 2010-4-12 下午04:17:59
 */
public class PTest4 {
    private P p;
    
    /**
     * 
     * @throws java.lang.Exception e
     */
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        System.out.println("setUpBeforeClass");
    }

    /**
     * 
     * @throws java.lang.Exception e
     */
    @AfterClass
    public static void tearDownAfterClass() throws Exception {
        System.out.println("tearDownAfterClass");
    }

    /**
     * 
     * @throws java.lang.Exception e
     */
    @Before
    public void setUp() throws Exception {
        this.p = new P();
    }

    /**
     * 
     * @throws java.lang.Exception e
     */
    @After
    public void tearDown() throws Exception {
        this.p = null;
    }
    
    /**
     * Test method for {@link t.P#s()}.
     */
    @Test
    public void testS() {
        assertEquals("s", this.p.s());
    }
}
