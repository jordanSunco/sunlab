/**
 * (c) Copyright Mirasol Op'nWorks Inc. 2002, 2003. http://www.opnworks.com
 * Created on Apr 2, 2003 by lgauthier@opnworks.com
 */

package com.opnworks.tableviewer;

import org.eclipse.jface.viewers.ITableLabelProvider;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.swt.graphics.Image;

import com.opnworks.model.ExampleTask;

/**
 * 如何提取表格每列的数据
 * 
 * @author Sun
 */
public class ExampleLabelProvider extends LabelProvider implements
        ITableLabelProvider {
    public String getColumnText(Object element, int columnIndex) {
        ExampleTask task = (ExampleTask) element;

        String result = "";
        switch (columnIndex) {
            case 0:
                result = Boolean.toString(task.isCompleted());
                break;
            case 1:
                result = task.getDescription();
                break;
            default:
        }

        return result;
    }

    public Image getColumnImage(Object arg0, int arg1) {
        // TODO Auto-generated method stub
        return null;
    }
}
