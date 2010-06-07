/*
 * Copyright
 */

package chart;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

/**
 * 处理Flash图形页面传来的导出图片请求
 * 
 * @author Sun
 */
@SuppressWarnings("serial")
public class ExportImageServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 页面flash的宽度和高度
        int width = Integer.parseInt(request.getParameter("width"));
        int height = Integer.parseInt(request.getParameter("height"));

        BufferedImage result = new BufferedImage(width, height,
                BufferedImage.TYPE_INT_RGB);

        // 页面是将一个个像素作为参数传递进来的, 所以如果图表越大, 处理时间越长
        for (int y = 0; y < height; y++) {
            String[] row = request.getParameter("r" + y).split(",");

            int x = 0;
            for (int c = 0, length = row.length; c < length; c++) {
                // 十六进制颜色数组
                String[] pixel = row[c].split(":");

                int repeat = pixel.length > 1 ? Integer.parseInt(pixel[1]) : 1;
                for (int l = 0; l < repeat; l++) {
                    result.setRGB(x, y, Integer.parseInt(pixel[0], 16));
                    x++;
                }
            }
        }

        response.setContentType("image/jpeg");
        response.addHeader("Content-Disposition",
                "attachment; filename=\"amcharts.jpg\"");

        Graphics2D g = result.createGraphics();
        // 处理图形平滑度
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
        g.drawImage(result, 0, 0, width, height, null);
        g.dispose();

        ServletOutputStream f = response.getOutputStream();
        JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(f);
        JPEGEncodeParam param = encoder.getDefaultJPEGEncodeParam(result);
        // 设置图片质量,0.0(最差) - 1.0(最好)
        param.setQuality(1, true);
        encoder.encode(result, param);
        // 输出图片
        ImageIO.write(result, "JPEG", response.getOutputStream());

        f.close();
    }
}
