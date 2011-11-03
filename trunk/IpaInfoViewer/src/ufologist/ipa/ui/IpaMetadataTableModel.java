/*
 * Copyright 
 */

package ufologist.ipa.ui;

import java.lang.reflect.Field;

import javax.swing.table.AbstractTableModel;

import ufologist.ipa.core.ItunesMetadata;

/**
 * 
 * @author Sun
 * @version IpaMetadataTableModel.java 2011-11-1 下午03:32:45
 */
public class IpaMetadataTableModel extends AbstractTableModel {
    private ItunesMetadata[] metadata;

    public IpaMetadataTableModel(ItunesMetadata[] metadata) {
        this.metadata = metadata;
    }

    public int getRowCount() {
        return this.metadata.length;
    }

    public int getColumnCount() {
        return ItunesMetadata.class.getDeclaredFields().length;
    }

    public String getColumnName(int column) {
        return ItunesMetadata.class.getDeclaredFields()[column].getName();
    }

    public Object getValueAt(int rowIndex, int columnIndex) {
        Object value = null;
        ItunesMetadata meta = this.metadata[rowIndex];

        Field field = ItunesMetadata.class.getDeclaredFields()[columnIndex];
        field.setAccessible(true);
        try {
            value = field.get(meta);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return value;
    }
}
