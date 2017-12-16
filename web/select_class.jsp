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
    String connectString = "jdbc:mysql://127.0.0.1:3306/jwxt"
            + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String msg ="";
    StringBuilder table = new StringBuilder("");
    Integer sid = 16352000; //当前登录的学生学号
    try{
        //连接数据库
        Class.forName("com.mysql.jdbc.Driver");
        Connection con=DriverManager.getConnection(connectString, "web2017", "web2017");
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
                    "<form action=\"select_class.jsp\" method=\"post\" name=\"select_class\">"
                            +"<input type=\"hidden\" name=\"idcno\" value=" +rs.getString("cno")+">"
                            + "<input type=\"submit\" name=\"sub\" value=\"选课\">"
                            +"</form>"
            ));
        }
        table.append("</table>");

        //关闭数据库
        rs.close(); stmt.close(); con.close();
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
        }
        h1{text-align: center;}
        table{
            border-collapse: collapse;
            border: none;
            width: 500px;
        }
        td,th{
            border: solid grey 1px;
            margin: 0 0 0 0;
            padding: 5px 5px 5px 5px
        }
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
            width:320px;height:230px;background-image: url(image/image2.png);background-position:-160px 250px;z-index:2;opacity: 0.2;
        }
        .photo_bk{position: relative;width: 150px;height:150px;border-radius: 150px;top:-70px;left:80px;
            overflow: hidden;border: white 5px solid;
        }
        #form{position:relative;left:70px;top:-90px;width:220px;height:30px;margin:0px;opacity:0;filter:alpha(opacity=0);}
        .name{position: relative;bottom:50px;text-align: center;font-size: 30px;letter-spacing: 0.2em}
        .sno{text-align: center;font-size: 20px;position: relative;bottom:50px;color: #6E7376;}
        .mail{position: relative;bottom:50px;text-align: center;font-size: 10px;color: #6E7376;}
        #outer{width:100px;height:30px;position: relative;top:-45px;left:110px;
            background: linear-gradient(to top,rgb(85, 157, 205) ,rgb(34, 115, 181));border-radius: 10px;
            margin-left:0px;text-align: center;font-size: 15px;padding-top:5px;color: white;
            box-shadow: inset 0px -3px 0px rgba(0,0,0,0.1),0px 3px 0px rgba(0,0,0,0.1),
            0px 0px 1px black;
        }
        #board{width: 50%;height:70%;position: fixed;top:50px;left:450px;border-radius: 10px;
            border-radius: 10px;
            background: linear-gradient(to top,white ,rgb(38, 111, 179));
            z-index: 5;

        }
        #button{width:350px;height:70px;margin: 0px;padding:0px;margin-left: 20px;position: absolute;bottom:30px;}
        #button>li{width:70px;height:70px;list-style-type:none;display:inline-block;border-radius: 70px;
            text-align: center;background:rgb(122, 120, 114);margin: 15px;margin-top: 0px;

        }
        #button li i{margin-top: 20px;font-size: 30px;color: white;}
        #button li a{display: none;margin-top: 25px;font-size: 20px;color: white;}
        #button li:hover i{display:none;}
        #button li:hover a{display:block;}
    </style>
</head>
<body>
    <div id="leftside">
        <div id="left_top">
            <div class="bk"></div>
        </div>
        <div class="photo_bk"><img src="image/touxiang.jpg" ></div>
        <div class="name">RanRan</div>
        <div class="sno">12345678</div>
        <div class="mail">1213@dqc.om</div>

        <div id="outer">
            上传头像
        </div>

        <div id="form">
            <form name="fileUpload" action="project.jsp" method="POST"
                  enctype="multipart/form-data">
                <p><input type="file" name="file" size=5></p>
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
            <li><i class="fa fa-user-o" aria-hidden="true"></i>
                <a href="">登录</a>
            </li>
            <li><i class="fa fa-search" aria-hidden="true"></i>
                <a href="">查课</a>
            </li>
            <li><i class="fa fa-search-plus" aria-hidden="true"></i>
                <a href="">选课</a>
            </li>
        </ul>
    </div>
</body>
</html>
