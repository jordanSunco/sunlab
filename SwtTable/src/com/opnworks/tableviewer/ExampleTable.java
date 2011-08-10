/*
 * Copyright
 */

package com.opnworks.tableviewer;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;

/**
 * 设置表格布局和列
 * 
 * @author Sun
 * @version ExampleTable.java 2011-8-9 17:08:52
 */
public class ExampleTable extends Table {
    public ExampleTable(Composite parent, int style) {
        super(parent, style);
//         GridData gridData = new GridData(GridData.FILL_BOTH);
//         gridData.grabExcessVerticalSpace = true;
//         gridData.horizontalSpan = 3;
//         setLayoutData(gridData);

        setLinesVisible(true);
        setHeaderVisible(true);
        createColumns();
    }

    /**
     * 解决org.eclipse.swt.SWTException: Subclassing not allowed问题
     */
    @Override
    protected void checkSubclass() {
        // override the method checkSubclass() with null content.
        // Than you can custom widgets in your class hiearchy.
    }

    private void createColumns() {
        TableColumn column = new TableColumn(this, SWT.LEFT);
        column.setText("第一列");
        column.setWidth(80);

        column = new TableColumn(this, SWT.RIGHT);
        column.setText("第二列");
        column.setWidth(80);
    }
}
