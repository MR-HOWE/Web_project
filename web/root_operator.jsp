<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2017/12/15
  Time: 1:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.sql.*"%>
<%@ page import="static java.lang.Integer.parseInt" %>
<%
    request.setCharacterEncoding("utf-8");
    String connectString = "jdbc:mysql://127.0.0.1:3306/jwxt"
            + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";
    String msg =""; //交互信息
    String js_statement = ""; //动态生成js语句
    StringBuilder table = new StringBuilder(""); //课程表格
    Integer sid = 6; //当前登录的管理员id
    String fscno="";String fscname="";String fsweekday="";String fsstime="";String fsetime="";String fstotal="";String fsavail="";String fscid = "";
    try{
        //连接数据库
        Class.forName("com.mysql.jdbc.Driver");
        Connection con=DriverManager.getConnection(connectString, "web2017", "web2017");
        Statement stmt=con.createStatement();

        /*  ----   管理员 对course关系表操作   ----  */
        if(request.getMethod().equalsIgnoreCase("post")){
            //删除课程
            if(request.getParameter("del")!=null){
                String sql_delete = String.format("delete from course where id=%d ",Integer.parseInt(request.getParameter("cid")));
                int cnt = 0;
                cnt = stmt.executeUpdate(sql_delete);
                if (cnt>0){msg = "已删除课程";}
            }
            //增加课程
            else if(request.getParameter("add")!=null){
                String acno = request.getParameter("acno");
                String acname = request.getParameter("acname");
                String aweekday = request.getParameter("aweekday");
                String astime = request.getParameter("astime");
                String aetime = request.getParameter("aetime");
                String atotal = request.getParameter("atotal");
                String aavail = request.getParameter("aavail");
                String sql_add = String.format("insert into course(cno,cname,weekday,stime,etime,total,avail) values(%d,'%s',%d,%d,%d,%d,%d);",
                        Integer.parseInt(acno),acname,Integer.parseInt(aweekday),
                        Integer.parseInt(astime),Integer.parseInt(aetime),Integer.parseInt(atotal),Integer.parseInt(aavail));
                int cnt = 0;
                cnt = stmt.executeUpdate(sql_add);
                if (cnt>0){msg = "已增加课程";}
            }
            //弹出将要修改的课程信息
            else if(request.getParameter("ff")!=null){
                js_statement = "<script>popBox2()</script>";
                fscid = request.getParameter("cid");
                String sql_query = String.format("select course.* from course where id="+fscid);
                ResultSet rs_query = stmt.executeQuery(sql_query);
                if(rs_query.next()){
                    fscno = rs_query.getString("cno");
                    fscname = rs_query.getString("cname");
                    fsweekday = rs_query.getString("weekday");
                    fsstime = rs_query.getString("stime");
                    fsetime = rs_query.getString("etime");
                    fstotal = rs_query.getString("total");
                    fsavail = rs_query.getString("avail");
                }
            }
            //修改课程
            else if(request.getParameter("fix")!=null){
                String fcid = request.getParameter("fcid");
                String fcno = request.getParameter("fcno");
                String fcname = request.getParameter("fcname");
                String fweekday = request.getParameter("fweekday");
                String fstime = request.getParameter("fstime");
                String fetime = request.getParameter("fetime");
                String ftotal = request.getParameter("ftotal");
                String favail = request.getParameter("favail");
                String sql_update = String.format("update course set cno=%d,cname='%s',weekday=%d,stime=%d,etime=%d,total=%d,avail=%d "
                                +"where id="+fcid,
                        Integer.parseInt(fcno),fcname,Integer.parseInt(fweekday),
                        Integer.parseInt(fstime),Integer.parseInt(fetime),Integer.parseInt(ftotal),Integer.parseInt(favail));
                int cnt = 0;
                cnt = stmt.executeUpdate(sql_update);
                if (cnt>0){msg = "已修改课程";}
            }
        }

        /*  ----   显示所有课程于UI界面上  ---- */
        //查询结果
        String sql = String.format("select course.* from course ");
        ResultSet rs = stmt.executeQuery(sql);
        //生成表格
        table.append("<table><tr><th>课程号</th><th>名称</th><th>时间</th>"
                +"<th>课时</th><th>总人数</th><th>剩余人数</th>"
                +"<th><input type=\"button\" name=\"pBox\" value=\"增加\" onclick=\"popBox()\"/></th></tr>");
        while(rs.next()) {
            table.append(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
                    rs.getString("cno"),rs.getString("cname"),rs.getString("weekday"),
                    rs.getString("stime")+'-'+rs.getString("etime"),
                    rs.getString("total"),rs.getString("avail"),
                    "<form id=\"f1\" action=\"root_operator.jsp\" method=\"post\" name=\"root_op\">"
                            +"<input type=\"hidden\" name=\"cid\" value=" +rs.getString("id")+">"
                            + "<input type=\"submit\" name=\"ff\" value=\"修改\" >"
                            + "<input type=\"submit\" name=\"del\" value=\"删除\">"
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
    <title>管理界面</title>
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
        #dialog,#dialog2{
            position: absolute; top: 20%; left: 35%;
            width: 350px; height: 300px;
            display: none;
            z-index: 11;
            border: solid darkslateblue 1px;
            background-color: white;
        }
        #dialog p,#dialog2 p{
            margin-left: 15px;
        }
        /* -----------  */
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
    <script type="text/javascript">
        var popBox = function(){
            //降低原页面显示度 设置透明
            var container = document.getElementById('con');
            container.style.opacity = "0.1";
            //显示增加对话框
            var dialog = document.getElementById('dialog');
            dialog.style.display = "block";
        };
        var popBox2 = function(){
            //降低原页面显示度 设置透明
            var container = document.getElementById('con');
            container.style.opacity = "0.1";
            //显示修改对话框
            var dialog2 = document.getElementById('dialog2');
            dialog2.style.display = "block";
        };
        var closeBox = function(){
            //原页面
            var container = document.getElementById('con');
            container.style.opacity = "1";
            //对话框
            var dialog = document.getElementById('dialog');
            dialog.style.display = "none";
            var dialog2 = document.getElementById('dialog2');
            dialog2.style.display = "none";
        };
    </script>
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
        <!-- 界面主体 -->
        <div class="container" id="con">
            <h1>管理界面</h1>
            <!-- 所有课程表格 -->
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

    <!-- 增加课程对话框 -->
    <div id="dialog">
        <form id="f2" action="root_operator.jsp" method="post" name="root_add">
            <p>课程号:&nbsp<input type="text" name="acno" style="width: 7em"></p>
            <p>课程名称:&nbsp<input type="text" name="acname" style="width: 7em"></p>
            <p>课程时间:&nbsp
                <select name="aweekday">
                    <option value="1">周一</option>
                    <option value="2">周二</option>
                    <option value="3">周三</option>
                    <option value="4">周四</option>
                    <option value="5">周五</option>
                    <option value="6">周六</option>
                    <option value="0">周日</option>
                </select>
            </p>
            <p>课时:&nbsp<input type="text" name="astime" style="width: 2em">&nbsp-&nbsp<input type="text" name="aetime" style="width: 2em"></p>
            <p>课程容量:&nbsp<input type="text" name="atotal" style="width: 7em"></p>
            <p>剩余容量:&nbsp<input type="text" name="aavail" style="width: 7em"></p>
            <p>
                <input type="submit" name="add" value="保存"/>
                <input type="button" name="cBox" value="取消" onclick="closeBox()"/>
            </p>
        </form>
    </div>
    <!-- 修改课程对话框 -->
    <div id="dialog2">
        <form id="f3" action="root_operator.jsp" method="post" name="root_fix">
            <p>课程号:&nbsp<input type="text" name="fcno" style="width: 7em" value=<%=fscno%>></p>
            <p>课程名称:&nbsp<input type="text" name="fcname" style="width: 7em" value=<%=fscname%>></p>
            <p>课程时间:&nbsp
                <select name="fweekday">
                    <option value="1" <%=fsweekday.equals("1")?"selected":""%>>周一</option>
                    <option value="2" <%=fsweekday.equals("2")?"selected":""%>>周二</option>
                    <option value="3" <%=fsweekday.equals("3")?"selected":""%>>周三</option>
                    <option value="4" <%=fsweekday.equals("4")?"selected":""%>>周四</option>
                    <option value="5" <%=fsweekday.equals("5")?"selected":""%>>周五</option>
                    <option value="6" <%=fsweekday.equals("6")?"selected":""%>>周六</option>
                    <option value="0" <%=fsweekday.equals("0")?"selected":""%>>周日</option>
                </select>
            </p>
            <p>课时:&nbsp<input type="text" name="fstime" style="width: 2em" value=<%=fsstime%>>
                &nbsp-&nbsp<input type="text" name="fetime" style="width: 2em" value=<%=fsetime%>></p>
            <p>课程容量:&nbsp<input type="text" name="ftotal" style="width: 7em" value=<%=fstotal%>></p>
            <p>剩余容量:&nbsp<input type="text" name="favail" style="width: 7em" value=<%=fsavail%>></p>
            <input type="hidden" name="fcid" value=<%=fscid%>>
            <p>
                <input type="submit" name="fix" value="保存"/>
                <input type="button" name="cBox2" value="取消" onclick="closeBox()"/>
            </p>
        </form>
    </div>
    <%=js_statement%>
</body>
</html>

