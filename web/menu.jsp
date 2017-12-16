<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2017/12/16
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.sql.*"%>
<%
    request.setCharacterEncoding("utf-8");
    String connectString = "jdbc:mysql://172.18.187.234:53306/jwxt"
            + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
    String msg = ""; //交互信息
    String name="用户名"; String sno="学号/工号"; String mail="邮箱地址";//获得信息
    String ima="img\\default_avatar.jpg";
    String sid = "16352000"; //用户名
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
            ima = "upload_avatar\\"+rs_query.getString("image");
        }

        //关闭数据库
        rs_query.close(); stmt.close(); con.close();
    }catch (Exception e){
        msg = e.getMessage();
    }
%>
<!DOCTYPE HTML>
<html >
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.min.css" />
    <title></title>
    <style>
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
        .bk{width:320px;height:230px;background-image: url(img/leftside_bg.png);background-position:-160px 250px;z-index:2;opacity: 0.2;
            
        }

        .photo_bk {
            position: relative;
            width: 150px;
            height: 150px;
            border-radius: 150px;
            top: -70px;
            left: 80px;
            overflow: hidden;
            border: white 5px solid;
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
            margin-top: 30px;

        }
        #notification_outer{
            width:550px;
            margin:0 auto;
            padding-bottom: 150px;
            padding-top:30px;
        }
        #board h1{text-align: center;font-family: 黑体;color: rgb(12, 84, 158);font-size: 40px;letter-spacing: 1em;
            text-shadow:0.5px 3px 0px rgba(0,0,0,0.3);
        }
        #notification li{color: rgb(39, 116, 182);font-size: 20px;margin-top: 10px;}
        a:link{color:rgb(42, 120, 186);}
        a:visited{color:rgb(42, 120, 186); }
        a:hover{color:rgb(91, 162, 206); }


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

        <div id="notification_outer">
            <h1>公告</h1>
            <ul id="notification">
                <li><a href="http://sjd.sysu.edu.cn/">中山大学学习宣传贯彻党的十九大精神专题网站</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152025.htm">李希到中山大学宣讲十九大精神并调研</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152101.htm">中山大学-中国科学院高能物理研究所合作协议</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152098.htm">华威大学副校长Lawrebce Young教授一行访问我校</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152102.htm">图书馆举办名师捐赠珍藏文献图片展</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152003.htm">罗俊校长出访大洋洲 推动我校与澳新高水平大学合作</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152067.htm">李善名副校长出席《财富》全球论坛左精彩发言</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152026.htm">开拓重症新思路 树立救援新航标</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152060.htm">我校“学业指导与学生发展：讲座暨交流活动顺利举行</a></li>
                <li><a href="http://news2.sysu.edu.cn/news01/152049.htm">国际翻译学院"欧洲视阈中的中国：国际研讨会开幕式成功举办</a></li>
            </ul>
        </div>
        <ul id="button">
            <li><i class="fa fa-user-o" aria-hidden="true"></i>
                <a href="root_operator.jsp">管理员</a>
            </li>
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
