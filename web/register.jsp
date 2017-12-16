<%@ page language="java" import="java.util.*,webJava.util.Database"
         contentType="text/html; charset=utf-8" pageEncoding="UTF-8"
%>
<%
    request.setCharacterEncoding("utf-8");
    String user = request.getParameter("user");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    String name = request.getParameter("name");
    Database db = new Database();

    String query_str = String.format("INSERT INTO User(Sno,PWD,name,mail) VALUES('%s','%s','%s','%s');",user,password,name,email);

    System.out.println(query_str);

    int res = 0;
    try {
        res = db.insert(query_str);
    } catch (Exception e){
        res = 0;
    }

    final String fail = "0";
    final String success = "1";

    out.clear();

    if(res >= 1){
        out.write(success);
        return;
    }
    else {
        out.write(fail);
        return;
    }
%>