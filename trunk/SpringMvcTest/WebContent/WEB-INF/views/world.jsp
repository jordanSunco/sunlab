<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Hello World</title>
    </head>
    <body>
        <h1>${hello}</h1>
        <c:url value="/a/b/c.js" />
    </body>
</html>
