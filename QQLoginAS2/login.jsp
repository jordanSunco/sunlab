<%
System.out.println("--------------------------");
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        System.out.println(cookie.getName() + " = " + cookie.getValue());
    }
}
System.out.println(request.getQueryString());
System.out.println(request.getParameter("u"));
out.println("login: " + request.getParameter("p"));
%>