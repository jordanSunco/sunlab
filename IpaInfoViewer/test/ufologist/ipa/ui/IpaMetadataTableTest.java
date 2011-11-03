/*
 * Copyright 
 */

package ufologist.ipa.ui;

import java.awt.Dimension;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JScrollPane;

import ufologist.ipa.core.IpaReader;
import ufologist.ipa.core.impl.IpaReaderImpl;
import ufologist.ipa.ui.IpaMetadataTable;

/**
 * 
 * @author Sun
 * @version IpaMetadataTableTest.java 2011-11-1 下午03:42:39
 */
public class IpaMetadataTableTest {
    private IpaReader ipaReader = new IpaReaderImpl();

    public static void main(String[] args) throws IOException {
        new IpaMetadataTableTest().test();
    }

    public void test() throws IOException {
        JFrame frame = new JFrame("ipa(iOS App) Table");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

//        IpaMetadataTable table = new IpaMetadataTable(new File(
//                "D:/Downloads/ipa/app/software"));
        IpaMetadataTable table = new IpaMetadataTable(new File(this.getClass()
                .getResource("/Air_Video_2.4.9.ipa").getFile()));

        JScrollPane scrollPane = new JScrollPane(table);
        scrollPane.setPreferredSize(new Dimension(800, 300));
        frame.getContentPane().add(scrollPane);

        frame.pack();
        frame.setVisible(true);
    }
}
