/*
 * Copyright
 */

package com.opnworks.tableviewer;

import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Table;

import com.opnworks.model.ExampleTaskList;

/**
 * 控制表格的内容
 * 
 * @author Sun
 * @version ExampleTableView.java 2011-8-9 17:03:50
 */
public class ExampleTableViewer extends TableViewer {
    private ExampleTableViewer(Table table, ExampleTaskList taskList) {
        super(table);
        setContentProvider(new ExampleContentProvider(taskList));
        setLabelProvider(new ExampleLabelProvider());
        setInput(taskList);
    }

    public static ExampleTableViewer newInstance(Composite parent, int style,
            ExampleTaskList taskList) {
        Table table = new ExampleTable(parent, style);
        return new ExampleTableViewer(table, taskList);
    }
}
