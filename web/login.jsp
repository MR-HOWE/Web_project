<%@ page language="java" import="java.util.*,webJava.util.Database"
         contentType="text/html; charset=utf-8"
%>
<%@ page import="java.sql.ResultSet" %>
<%
    request.setCharacterEncoding("utf-8");
    String user = request.getParameter("user");
    String password = request.getParameter("password");
    String test = request.getParameter("test");
    System.out.println(user);
    System.out.println(password);
    System.out.println(test);
    Database db = new Database();

    String query_str = String.format("select * from User where Sno='%s';",user);
    System.out.println(query_str);
    ResultSet rs = db.query(query_str);

    String realPw = "noPW";
    String image = "";
    String name = "";
    String email = "";
    int admin = 0;

    int cnt = 0;
    try{
        while(rs.next()) {
            cnt++;
            realPw = rs.getString("PWD");
            admin = rs.getInt("admin");
            image = rs.getString("image");
            name = rs.getString("name");
            email = rs.getString("mail");
        }
    } catch (Exception e){
        e.printStackTrace();
    }

    final String NoUser = "0";
    final String WrongPassword = "1";
    final String Admin = "2";
    final String success = "3";

    out.clear();
    if(cnt == 0) {
        System.out.println("noUser");
        out.write(NoUser);
        return;
    }
    if(!realPw.equals(password)){
        out.write(WrongPassword);
        return;
    }
    if(realPw.equals(password)){
        if(admin == 1){
            out.write(Admin);
            return;
        } else {
            out.write(success);
            session.setAttribute("user",user);
            session.setAttribute("image",image);
            session.setAttribute("name",name);
            session.setAttribute("email",email);
            return;
        }
    }
%>