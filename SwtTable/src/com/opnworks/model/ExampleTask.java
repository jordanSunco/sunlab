/**
 * (c) Copyright Mirasol Op'nWorks Inc. 2002, 2003. http://www.opnworks.com
 * Created on Apr 2, 2003 by lgauthier@opnworks.com
 */

package com.opnworks.model;

/**
 * Class used as a trivial case of a Task Serves as the business object for the
 * TableViewer Example.
 * 
 * A Task has the following properties: completed, description, owner and
 * percentComplete
 * 
 * @author Laurent
 */
public class ExampleTask {
    private boolean completed = false;
    private String description = "";

    public ExampleTask(String description) {
        super();
        setDescription(description);
    }

    public boolean isCompleted() {
        return this.completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
