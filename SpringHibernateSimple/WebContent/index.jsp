<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="test.service.IUserService" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
<%
    org.springframework.web.context.WebApplicationContext webApplicationContext = WebApplicationContextUtils
            .getWebApplicationContext(session.getServletContext());

    IUserService userService = (IUserService) webApplicationContext
            .getBean("userService");

    out.println(userService.getUserById(1).getName());
%>
</body>
</html>