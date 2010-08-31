/*
 * Copyright
 */

package provider;

import javax.ws.rs.ext.ContextResolver;
import javax.ws.rs.ext.Provider;
import javax.xml.bind.JAXBContext;

import model.Model;

import com.sun.jersey.api.json.JSONConfiguration;
import com.sun.jersey.api.json.JSONJAXBContext;

/**
 * 
 * @author Sun
 * @version JAXBContextResolver.java 2010-8-30 下午02:33:40
 */
@Provider
public class JAXBContextResolver implements ContextResolver<JAXBContext> {
    private JAXBContext context;

    private Class[] types = { Model.class };

    public JAXBContextResolver() throws Exception {
        this.context = new JSONJAXBContext(JSONConfiguration.natural().build(),
                this.types);
    }

    public JAXBContext getContext(Class<?> objectType) {
        for (Class type : types) {
            if (type == objectType) {
                return this.context;
            }
        }
        return null;
    }
}
