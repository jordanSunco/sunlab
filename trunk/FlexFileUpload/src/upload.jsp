<%@page import="java.io.File,java.io.FileOutputStream,java.io.IOException,java.io.InputStream"%>
<%
    try {
        // ���������
        InputStream in = request.getInputStream();

        // TODO �����������ж� �ϴ����ļ���, ���͵ȵ�

        File f = new File("c:/", System.currentTimeMillis() + ".txt");
        FileOutputStream o = new FileOutputStream(f);

        // ��ȡ��д��
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