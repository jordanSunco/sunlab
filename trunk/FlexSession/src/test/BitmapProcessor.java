/*
 * Copyright
 */

package test;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

/**
 * 
 * @author Administrator
 * @version BitmapProcessor.java 2010-4-10 下午03:46:33
 */
public class BitmapProcessor {
    private String imageFileLocation = "c:/1.jpg";
    
    /**
     * 将Flex传过来的图像二进制数组保存为图片文件
     * Flex对位图数据进行编码, Java直接写入文件
     * 
     * @param b
     * @throws IOException
     */
    public void writeImage(byte[] b) throws IOException {
        BufferedImage bufferImage = ImageIO.read(new ByteArrayInputStream(b));
        ImageIO.write(bufferImage, "jpg", new File(imageFileLocation));
//        FileOutputStream fo = new FileOutputStream(imageFileLocation);
//        fo.write(b);
//        fo.flush();
//        fo.close();
    }
    
    /**
     * Flex 传入图像的像素数据, 通过Java解析后保存为图片
     * 
     * @param p
     */
    public void writeImageP(byte[] p) {
        // JPEGImageEncoder
    }
}
