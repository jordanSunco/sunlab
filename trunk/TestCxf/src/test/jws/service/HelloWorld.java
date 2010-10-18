/*
 * Copyright
 */

package test.jws.service;

import javax.jws.WebService;

/**
 * Service Endpoint Interface (SEI)
 * 
 * @author Sun
 * @version HelloWorld.java 2010-10-15 下午05:56:28
 */
@WebService
public interface HelloWorld {
    String sayHi(String text);
}
