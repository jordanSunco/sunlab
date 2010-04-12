/*
 * Copyright
 */

package upload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.ProgressListener;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;

/**
 * Servlet implementation class UploadServlet
 */
public class UploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 上传文件路径
     */
    public String uploadDirLocation;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        // 获得配置的上传文件目录路径
        this.uploadDirLocation = config.getInitParameter("uploadDirLocation");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {

        // 接收页面参数
        System.out.println(request.getParameter("userId"));

        // upload(request);
        try {
            uploadByCommons(request, response);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    /**
     * 简单读取request中的所有信息, 并写入文件中
     * 
     * @throws IOException
     */
    private void upload(HttpServletRequest request) throws IOException {
        // 获得输入流
        InputStream in = request.getInputStream();

        // TODO 从输入流中判断 上传的文件名, 类型等等

        File f = new File(this.uploadDirLocation, "test.txt");
        FileOutputStream o = new FileOutputStream(f);

        // 读取并写入
        byte b[] = new byte[1024];
        int n;
        while ((n = in.read(b)) != -1) {
            o.write(b, 0, n);
        }

        o.close();
        in.close();
    }

    /**
     * 使用Commons Fileupload 上传文件
     * 
     * @param request
     * @param response
     * @throws Exception
     */
    private void uploadByCommons(HttpServletRequest request,
            final HttpServletResponse response) throws Exception {
        // Create a factory for disk-based file items
        FileItemFactory factory = new DiskFileItemFactory();
        // FileItemFactory factory = new DiskFileItemFactory(
        // DiskFileItemFactory.DEFAULT_SIZE_THRESHOLD, new File(
        // "C:/"));

        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload(factory);

        // Create a progress listener
        ProgressListener progressListener = new ProgressListener() {
            private long megaBytes = -1;

            public void update(long pBytesRead, long pContentLength, int pItems) {
                long mBytes = pBytesRead / 1000000;
                if (megaBytes == mBytes) {
                    return;
                }
                megaBytes = mBytes;
                System.out.println("We are currently reading item " + pItems);
                if (pContentLength == -1) {
                    System.out.println("So far, " + pBytesRead
                            + " bytes have been read.");
                } else {
                    System.out.println("So far, " + pBytesRead + " of "
                            + pContentLength + " bytes have been read.");
                }
            }
        };

        upload.setProgressListener(progressListener);

        // Parse the request
        List /* FileItem */items = upload.parseRequest(request);

        // Process the uploaded items
        Iterator iter = items.iterator();
        while (iter.hasNext()) {
            FileItem item = (FileItem) iter.next();

            if (item.isFormField()) {
                // 处理一般表单项
            } else {
                // 处理文件上传
                String fieldName = item.getFieldName();
                String fileName = item.getName();
                String contentType = item.getContentType();
                boolean isInMemory = item.isInMemory();
                long sizeInBytes = item.getSize();

                System.out.println(fieldName);
                System.out.println(fileName);
                System.out.println(contentType);
                System.out.println(isInMemory);
                System.out.println(sizeInBytes);

                // Why does FileItem.getName() return the whole path, and not just the file name?
                // http://commons.apache.org/fileupload/faq.html#whole-path-from-IE
                // Internet Explorer provides the entire path to the uploaded file and not just the base file name.
                // Since FileUpload provides exactly what was supplied by the client (browser), you may want to remove
                // this path information in your application. You can do that using the following method from Commons IO
                // (which you already have, since it is used by FileUpload).
                File uploadedFile = new File(this.uploadDirLocation,
                        FilenameUtils.getName(fileName));
                item.write(uploadedFile);

                response.getWriter().println(
                        "<script>parent.callback()</script>");
            }
        }
    }
}
