/*
 * Copyright
 */

package ufologist.ipa;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;

import ufologist.ipa.ui.IpaInfoViewer;
import chrriis.common.UIUtils;
import chrriis.dj.nativeswing.swtimpl.NativeInterface;

/**
 * 
 * @author Sun
 * @version App.java 2011-11-2 下午04:15:04
 */
public class App {
    public static void main(String[] args) {
        UIUtils.setPreferredLookAndFeel();
        NativeInterface.open();
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                JFrame frame = new JFrame(".ipa Information Viewer");
                frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                frame.getContentPane().add(new IpaInfoViewer());

                frame.setSize(800, 600);
                frame.setLocationByPlatform(true);
                frame.setVisible(true);
            }
        });
        NativeInterface.runEventPump();
    }
}
