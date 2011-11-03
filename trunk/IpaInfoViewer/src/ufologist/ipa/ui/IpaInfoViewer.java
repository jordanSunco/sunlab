/*
 * Copyright
 */

package ufologist.ipa.ui;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.TableModel;

import chrriis.dj.nativeswing.swtimpl.components.JDirectoryDialog;
import chrriis.dj.nativeswing.swtimpl.components.JWebBrowser;

/**
 * 
 * @author Sun
 * @version IpaInfoViewer.java 2011-11-2 下午02:19:37
 */
public class IpaInfoViewer extends JPanel implements ListSelectionListener,
        ActionListener {
    private String appStorePrefixUrl = "http://itunes.apple.com/us/app/id";

    private IpaMetadataTable table;
    private JWebBrowser webBrowser;
    private JButton browseDirButton;

    public IpaInfoViewer() {
        super(new BorderLayout());
        initUi();
    }

    private void initUi() {
        this.table = new IpaMetadataTable();
        this.table.getSelectionModel().addListSelectionListener(this);
        JScrollPane scrollPane = new JScrollPane(this.table);
        scrollPane.setPreferredSize(new Dimension(300, 200));

        // JEditorPane only support HTML 3.2, NO CSS, NO javascript!
        // JEditorPane editorPane = new JEditorPane(url);
        this.webBrowser = new JWebBrowser();
        this.webBrowser.setMenuBarVisible(false);

        this.browseDirButton = new JButton("选择有.ipa文件的目录");
        this.browseDirButton.addActionListener(this);

        add(scrollPane, BorderLayout.NORTH);
        add(this.webBrowser, BorderLayout.CENTER);
        add(this.browseDirButton, BorderLayout.SOUTH);
    }

    public void valueChanged(ListSelectionEvent e) {
        if (!e.getValueIsAdjusting()) {
            TableModel model = this.table.getModel();
            int selectedRow = this.table.getSelectedRow();

            if (selectedRow != -1) {
                Object itemId = model.getValueAt(selectedRow, 1);
                this.webBrowser.navigate(this.appStorePrefixUrl + itemId);
            }
        }
    }

    public void actionPerformed(ActionEvent e) {
        JDirectoryDialog directoryDialog = new JDirectoryDialog();
        directoryDialog.setSelectedDirectory(this.browseDirButton.getText());
        directoryDialog.show(this);

        String dir = directoryDialog.getSelectedDirectory();
        if (dir != null) {
            this.table.initModel(new File(dir));
            this.browseDirButton.setText(dir);
        }
    }
}
