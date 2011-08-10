/**
 * (c) Copyright Mirasol Op'nWorks Inc. 2002, 2003. http://www.opnworks.com
 * Created on Apr 2, 2003 by lgauthier@opnworks.com
 */

package com.opnworks;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

import com.opnworks.model.ExampleTaskList;
import com.opnworks.tableviewer.ExampleTableViewer;

/**
 * @author Sun
 * @version TableViewerExample.java 2011-8-9 16:13:50
 * @see <a
 *      href="http://www.eclipse.org/articles/Article-Table-viewer/table_viewer.html">Building
 *      and delivering a table editor with SWT/JFace</a>
 */
public class TableViewerExample {
    public static void main(String[] args) {
        Shell shell = new Shell();
        shell.setText("Task List - TableViewer Example");
        shell.setLayout(new GridLayout());

        ExampleTaskList taskList = new ExampleTaskList();
        int style = SWT.BORDER | SWT.FULL_SELECTION;
        ExampleTableViewer.newInstance(shell, style, taskList);

        shell.open();
        Display display = shell.getDisplay();
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch()) display.sleep();
        }
    }
}
