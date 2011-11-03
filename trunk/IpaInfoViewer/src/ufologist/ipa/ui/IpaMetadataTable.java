/*
 * Copyright
 */

package ufologist.ipa.ui;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.table.TableColumn;

import ufologist.ipa.core.IpaReader;
import ufologist.ipa.core.ItunesMetadata;
import ufologist.ipa.core.impl.IpaReaderImpl;

/**
 * 
 * @author Sun
 * @version IpaMetadataTable.java 2011-11-1 下午03:30:23
 */
public class IpaMetadataTable extends JTable {
    private IpaReader ipaReader = new IpaReaderImpl();

    public IpaMetadataTable() {
        super();
    }

    public IpaMetadataTable(File fileOrDir) {
        singleSelection();
        initModel(fileOrDir);
//        renderIconColumn();
    }

    private void singleSelection() {
        this.getSelectionModel().setSelectionMode(
                ListSelectionModel.SINGLE_SELECTION);
    }

    public void initModel(File file) {
        try {
            this.setModel(new IpaMetadataTableModel(getMetadata(file)));
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    /**
     * TODO 性能问题, 暂时不将icon显示在table中
     */
    private void renderIconColumn() {
        TableColumn iconColumn = this.getColumnModel().getColumn(3);
        iconColumn.setCellRenderer(new ImageRenderer());
        iconColumn.setMaxWidth(57);
        iconColumn.setResizable(false);
        this.setRowHeight(57);
    }

    private ItunesMetadata[] getMetadata(File fileOrDir) throws IOException {
        List<ItunesMetadata> meta = new ArrayList<ItunesMetadata>();
        if (fileOrDir.isDirectory()) {
            for (File ipa : fileOrDir.listFiles(new IpaFilter())) {
                ItunesMetadata m = this.ipaReader.getMetadata(ipa);
                m.setFileName(ipa.getName());
                meta.add(m);
            }
        } else {
            ItunesMetadata m = this.ipaReader.getMetadata(fileOrDir);
            m.setFileName(fileOrDir.getName());
            meta.add(m);
        }

        ItunesMetadata[] itunesMetadata = new ItunesMetadata[meta.size()];
        return meta.toArray(itunesMetadata);
    }
}
