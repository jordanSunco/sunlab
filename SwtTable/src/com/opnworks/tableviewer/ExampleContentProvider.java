/*
 * Copyright
 */

package com.opnworks.tableviewer;

import org.eclipse.jface.viewers.IStructuredContentProvider;
import org.eclipse.jface.viewers.Viewer;

import com.opnworks.model.ExampleTaskList;

/**
 * 如何获取表格的数据源
 * 
 * @author Sun
 */
public class ExampleContentProvider implements IStructuredContentProvider {
    private ExampleTaskList taskList;

    public ExampleContentProvider(ExampleTaskList taskList) {
        this.taskList = taskList;
    }

    public Object[] getElements(Object parent) {
        return this.taskList.getTasks().toArray();
    }

    public void inputChanged(Viewer v, Object oldInput, Object newInput) {
        // TODO Auto-generated method stub
    }

    public void dispose() {
        // TODO Auto-generated method stub
    }
}
