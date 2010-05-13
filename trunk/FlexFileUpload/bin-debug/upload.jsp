<%@page import="java.io.File,java.io.FileOutputStream,java.io.IOException,java.io.InputStream"%>
<%
    try {
        // 获得输入流
        InputStream in = request.getInputStream();

        // TODO 从输入流中判断 上传的文件名, 类型等等

        File f = new File("c:/", System.currentTimeMillis() + ".txt");
        FileOutputStream o = new FileOutputStream(f);

        // 读取并写入
        byte b[] = new byte[1024];
        int n;
        while ((n = in.read(b)) != -1) {
            o.write(b, 0, n);
        }

        o.close();
        in.close();
    } catch (IOException ioe) {
        ioe.printStackTrace(System.out);
    }
%>