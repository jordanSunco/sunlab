/*
 * Copyright
 */

package ufologist.ipa.ui;

import java.awt.Component;
import java.net.MalformedURLException;
import java.net.URL;

import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.table.DefaultTableCellRenderer;

/**
 * 用于在表格单元格中渲染应用的icon图标
 * 
 * @author Sun
 * @version ImageRenderer.java 2011-11-2 上午10:52:05
 * @see http://www.java2s.com/Code/Java/Swing-JFC/RenderinganimageinaJTablecollumn.htm
 */
public class ImageRenderer extends DefaultTableCellRenderer {
    /**
     * TODO 性能问题, 随便看一下table都会刷新整个UI, 每次都要重新加载图片, 非常慢
     * 目前还不知如何解决
     * 
     * @see http://stackoverflow.com/questions/2219988/java-jtable-with-frequent-update
     * @see http://java.sun.com/products/jfc/tsc/articles/ChristmasTree/
     */
    public Component getTableCellRendererComponent(JTable table, Object value,
            boolean isSelected, boolean hasFocus, int row, int column) {
        JLabel label = new JLabel();

        try {
            ImageIcon icon = new ImageIcon(new URL((String) value));
            label.setIcon(icon);
        } catch (MalformedURLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return label;
    }
}
