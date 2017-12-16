<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2017/12/14
  Time: 11:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.sql.*"%>
<%@ page import="static java.lang.Integer.parseInt" %>
<%
    request.setCharacterEncoding("utf-8");
    String connectString = "jdbc:mysql://172.18.187.234:53306/jwxt"
            + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
    String msg ="";
    StringBuilder table = new StringBuilder("");
    Integer sid = 16352000; //当前登录的学生学号
    String name="用户名"; String sno="学号/工号"; String mail="邮箱地址";//获得信息
    String ima="img\\default_avatar.jpg";//todo
    try{
        //连接数据库
        Class.forName("com.mysql.jdbc.Driver");
        Connection con=DriverManager.getConnection(connectString, "user", "123");
        Statement stmt=con.createStatement();

        /* --   选课 将记录加入sc关系基本表  -- */
        if(request.getMethod().equalsIgnoreCase("post")){
            String sql_select = String.format("insert into sc(sno,cno) values(%d,%d) ",sid,Integer.parseInt(request.getParameter("idcno")));
            int cnt = 0;
            cnt = stmt.executeUpdate(sql_select);
            if (cnt>0){msg = "选课成功";}
        }

        /*  -- 显示学校开课课程于UI界面上 -- */
        //查询结果 (除该学生已选课程外的其他课程)
        String sql = String.format("select distinct course.* from course " +
                "where course.cno not in (select sc.cno from sc where sc.sno="+ sid +")");
        ResultSet rs=stmt.executeQuery(sql);
        //生成表格
        table.append("<table><tr><th>课程号</th><th>名称</th><th>时间</th>"
                +"<th>课时</th><th>总人数</th><th>剩余人数</th><th></th></tr>");
        while(rs.next()) {
            table.append(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
                    rs.getString("cno"),rs.getString("cname"),rs.getString("weekday"),
                    rs.getString("stime")+'-'+rs.getString("etime"),
                    rs.getString("total"),rs.getString("avail"),
                    "<form action=\"select_class.jsp\" method=\"post\" name=\"select_class\" id=\"table_form\">"
                            +"<input type=\"hidden\" name=\"idcno\" value=" +rs.getString("cno")+">"
                            + "<input type=\"submit\" name=\"sub\" id=\"sub\"  value=\"选课\">"
                            +"</form>"
            ));
        }
        table.append("</table>");

        //关闭数据库
        rs.close(); stmt.close(); con.close();
    }catch (Exception e){
        msg = e.getMessage();
    }

    //侧边栏显示
    try {
        //连接数据库
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, "user", "123");
        Statement stmt = con.createStatement();

        //查询操作
        String sql_query = String.format("select user.* from user where sno="+sid);
        ResultSet rs_query = stmt.executeQuery(sql_query);
        //获得相应数据
        if(rs_query.next()){
            name = rs_query.getString("name");
            sno = rs_query.getString("sno");
            mail = rs_query.getString("mail");
            ima = "upload_avatar\\"+rs_query.getString("image");//todo
        }

        //关闭数据库
        rs_query.close(); stmt.close(); con.close();
    }catch (Exception e){
        msg = e.getMessage();
    }
%>
<html>
<head>
    <title>选课</title>
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.min.css" />
    <style type="text/css">
        .container{
            margin:0 auto;
            width:500px;
            text-align:center;
            padding-bottom: 150px;padding-top:30px;
        }
        .container h1{color: rgb(16, 88, 162)}
        h1{text-align: center;}
        table{
            border-collapse: collapse;
            border: none;
            width: 500px;
        }
        tr:nth-of-type(odd){background-color: rgb(101, 168, 211);}
        th{
            
            margin: 0 0 0 0;
            padding: 15px 5px 15px 5px
        }
        td{ 

            margin: 0 0 0 0;
            padding: 5px 5px 5px 25px
        }
        #sub{background: linear-gradient(to bottom,rgb(163, 204, 226) ,rgb(142, 193, 222));}
        #table_form{margin-top:10px;}
        /*   ----------------    */
        body{
            background: rgb(188, 215, 236);
        }
        #leftside{
            width:320px;height:100%;
            position: fixed; top: 0; left: 0;
            background: linear-gradient(to bottom,rgb(163, 204, 226) ,rgb(142, 193, 222));
            box-shadow: inset 0px -3px 0px rgba(0,0,0,0.1),0px 3px 0px rgba(0,0,0,0.1),
            inset 0px 1px 0px white,0px 0px 1px black;


        }
        #left_top{width:320px;height:230px;background: rgb(25, 63, 118);}
        .bk{
            width:320px;height:230px;background-image: url(img/leftside_bg.png);background-position:-160px 250px;z-index:2;opacity: 0.2;
        }
        .photo_bk{position: relative;width: 150px;height:150px;border-radius: 150px;top:-70px;left:80px;
            overflow: hidden;border: white 5px solid;
        }
        .avatar {
            border-radius: 50%;
            transition:all 1.6s cubic-bezier(.17,.67,.62,1.22);
            -webkit-transition:all 1.6s cubic-bezier(.17,.67,.62,1.22);
            -moz-transition:all 1.6s cubic-bezier(.17,.67,.62,1.22);
            -o-transition:all 1.6s cubic-bezier(.17,.67,.62,1.22);
            -ms-transition:all 1.6s cubic-bezier(.17,.67,.62,1.22);
        }
        .avatar:hover {
            transform:rotate(360deg);
            -ms-transform:rotate(360deg); 	/* IE 9 */
            -moz-transform:rotate(360deg); 	/* Firefox */
            -webkit-transform:rotate(360deg); /* Safari 和 Chrome */
            -o-transform:rotate(360deg); 	/* Opera */
        }
        #form{position:relative;left:70px;top:-90px;width:220px;height:30px;margin:0px;opacity:0;filter:alpha(opacity=0);}
        .name{position: relative;bottom:50px;text-align: center;font-size: 30px;letter-spacing: 0.2em}
        .sno{text-align: center;font-size: 20px;position: relative;bottom:50px;color: #6E7376;}
        .mail{position: relative;bottom:50px;text-align: center;font-size: 10px;color: #6E7376;}
        #board{width: 700px;margin:0 auto;border-radius: 10px;
            border-radius: 10px;
            background: linear-gradient(to top,white ,rgb(167, 202, 230));
            box-shadow: inset 0px -3px 0px rgba(0,0,0,0.1),0px 3px 0px rgba(0,0,0,0.1),
            0px 0px 1px black;
            z-index: 5;
            position:relative;

        }
        #button{width:350px;height:70px;margin: 0px;padding:0px;margin-left: 20px;position: absolute;bottom:30px;}
        #button>li{width:70px;height:70px;list-style-type:none;display:inline-block;border-radius: 70px;
            text-align: center;background:rgb(122, 120, 114);margin: 15px;margin-top: 0px;

        }
        #button li i{margin-top: 20px;font-size: 30px;color: white;}
        #button li a{display: none;margin-top: 25px;font-size: 20px;color: white;}
        #button li:hover i{display:none;}
        #button li:hover a{display:block;}
        #form{position:relative;left:70px;top:-130px;width:220px;height:30px;margin:0px;opacity: 0;}
        .outer{width:100px;height:30px;position: relative;top:-45px;left:110px;
            background: linear-gradient(to top,rgb(85, 157, 205) ,rgb(34, 115, 181));border-radius: 10px;
            margin-left:0px;text-align: center;font-size: 15px;padding-top:5px;color: white;
            box-shadow: inset 0px -3px 0px rgba(0,0,0,0.1),0px 3px 0px rgba(0,0,0,0.1),
            0px 0px 1px black;
        }
        #okbtn {
            position: relative;top: 0;left: 40px;
            width: 100px;
        }
    </style>
</head>
<body>
<div id="leftside">
    <div id="left_top">
        <div class="bk"></div>
    </div>
    <div class="photo_bk avatar"><img src=<%=ima%> ></div>
    <div class="name"><%=name%></div>
    <div class="sno"><%=sno%></div>
    <div class="mail"><%=mail%></div>
    <div class="outer">
        上传头像
    </div>
    <div class="outer">
        确定
    </div>
    <div id="form">
        <form name="fileUpload" action="handle_image.jsp" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" value=<%=sno%>>
            <p><input type="file" name="file" size=5></p>
            <p><input id="okbtn" type="submit" name="image" value="确定"></p>
        </form>
    </div>
</div>

<div id="board">

    <div class="container">
        <h1>全校开课课程</h1>
        <!-- 全校开课课程表格 -->
        <%=table%>
        <%=msg%>
    </div>

    <ul id="button">

        <li><i class="fa fa-search" aria-hidden="true"></i>
            <a href="show_class.jsp">查课</a>
        </li>
        <li><i class="fa fa-search-plus" aria-hidden="true"></i>
            <a href="select_class.jsp">选课</a>
        </li>
    </ul>
</div>
</body>
</html>
