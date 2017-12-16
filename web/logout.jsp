<%@ page language="java" import="java.util.*"
         contentType="text/html; charset=utf-8" pageEncoding="UTF-8"
%>
<%
    session.invalidate();
    response.sendRedirect("index.html");
%>