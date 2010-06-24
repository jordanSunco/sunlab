/*
 * Copyright
 */

package test.jfreechart;

import java.awt.Font;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartRenderingInfo;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.entity.StandardEntityCollection;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.servlet.ServletUtilities;
import org.jfree.data.category.DefaultCategoryDataset;

/**
 * 简单测试JFreeChart
 * 
 * @author Sun
 * @version JFreeChartServlet.java 2010-6-24 下午05:17:39
 */
@SuppressWarnings("serial")
public class JFreeChartServlet extends HttpServlet {
    private DefaultCategoryDataset dataset;

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        initData();

        ChartRenderingInfo info = new ChartRenderingInfo(
                new StandardEntityCollection());
        JFreeChart chart = createChart();
        configFont(chart);

        String filename = ServletUtilities.saveChartAsPNG(chart, 500, 350,
                info, request.getSession());

        request.getRequestDispatcher("/DisplayChart?filename=" + filename)
                .forward(request, response);
    }

    private void initData() {
        if (this.dataset == null) {
            this.dataset = new DefaultCategoryDataset();
        }

        this.dataset.clear();

        this.dataset.addValue(Math.random() * 100, "1994年", "收入");
        this.dataset.addValue(Math.random() * 100, "1994年", "支出");

        this.dataset.addValue(Math.random() * 100, "1995年", "收入");

        this.dataset.addValue(Math.random() * 100, "1996年", "收入");
        this.dataset.addValue(Math.random() * 100, "1996年", "支出");
    }

    private JFreeChart createChart() {
        JFreeChart jfreechart = ChartFactory.createBarChart("测试", "业务类型",
                "钱(元)", this.dataset, PlotOrientation.VERTICAL, true, true,
                false);
        return jfreechart;
    }

    /**
     * 设置中文字体, 放置出现乱码问题
     * 
     * @param chart
     */
    private void configFont(JFreeChart chart) {
        // 配置字体
        // X轴
        Font xfont = new Font("宋体", Font.PLAIN, 12);
        // Y轴
        Font yfont = new Font("宋体", Font.PLAIN, 12);
        // 底部
        Font kfont = new Font("宋体", Font.PLAIN, 12);
        // 图片标题
        Font titleFont = new Font("宋体", Font.BOLD, 25);

        // 图片标题
        chart.getTitle().setFont(titleFont);
        // 底部
        chart.getLegend().setItemFont(kfont);

        // 图形的绘制结构对象
        CategoryPlot plot = chart.getCategoryPlot();

        // X 轴
        CategoryAxis domainAxis = plot.getDomainAxis();
        // 轴标题
        domainAxis.setLabelFont(xfont);
        // 轴数值
        domainAxis.setTickLabelFont(xfont);

        // Y 轴
        ValueAxis rangeAxis = plot.getRangeAxis();
        rangeAxis.setLabelFont(yfont);
        rangeAxis.setTickLabelFont(yfont);
    }
}
