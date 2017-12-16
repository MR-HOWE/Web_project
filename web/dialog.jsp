<%@ page language="java" import="java.util.*"
contentType="text/html; charset=utf-8" pageEncoding="UTF-8"
%>
<%
    Object user = session.getAttribute("user");
    if(user == null){
        System.out.println("not login");
        response.sendRedirect("/index.html");
    }

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        body {
            font-family: "Microsoft YaHei UI";
        }
        dialog {
            border: none;
            box-shadow: 3px 3px 6px #999,-3px 0px 6px #999;
            border-radius: 8px;
            height: 500px;
            width: 500px;
            box-sizing: border-box;
            padding: 0;
        }
        .toast {
            height: 100px;
            width: 200px;
        }
        .attention {
            background-color: #FF6633;
        }
        h4 {
            text-align: center;
            font-weight: 400;
            margin: 15px auto;
        }
        h3 {
            padding: 12px 20px;
            color: #fff;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            background-color: #0B75A5;
            font-weight: 400;
            margin: 0;
            text-align: center;
        }
        input{
            border: 1px solid #ccc;
            padding: 7px 0px;
            border-radius: 3px;
            padding-left:5px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s
        }
        input:focus{
            border-color: #66afe9;
            outline: 0;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6);
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6)
        }

        .top_input_layout {
            width: 300px;
            margin: 50px auto 30px auto;
            display: flex;
            justify-content: center;
        }
        .input_layout {
            width: 300px;
            margin: 30px auto;
            display: flex;
            justify-content: center;
        }

        .rounded {
            border-radius: 10px;
        }

        /* Colors for .btn and .btn-two */
        .btn.blue{background-color: #7fb1bf;}
        .btn.green{background-color: #9abf7f;}
        .btn.red{background-color: #fa5a5a;}
        .btn.purple{background-color: #cb99c5;}
        .btn.cyan{background-color: #7fccde;}
        .btn.yellow{background-color: #f0d264;}

        /* default button style */
        .btn {
            position: relative;
            border: 0;
            padding: 10px 25px;
            display: inline-block;
            text-align: center;
            color: white;
            text-decoration:none;
            font-family: "微软雅黑";
        }
        .btn:active {
            top: 4px;
        }

        /* button colors*/
        .btn.blue {box-shadow: 0px 4px #74a3b0;}
        .btn.blue:active {box-shadow: 0 0 #74a3b0; background-color: #709CA8;}

        .btn.green {box-shadow: 0px 4px 0px #87a86f;}
        .btn.green:active {box-shadow: 0 0 #87a86f; background-color: #87a86f;}

        .btn.red {box-shadow:0px 4px 0px #E04342;}
        .btn.red:active {box-shadow: 0 0 #ff4c4b; background-color: #ff4c4b;}

        .btn.purple {box-shadow:0px 4px 0px #AD83A8;}
        .btn.purple:active {box-shadow: 0 0 #BA8CB5; background-color: #BA8CB5;}

        .btn.cyan {box-shadow:0px 4px 0px #73B9C9;}
        .btn.cyan:active {box-shadow: 0 0 #73B9C9; background-color: #70B4C4;}

        .btn.yellow {box-shadow:0px 4px 0px #D1B757;}
        .btn.yellow:active {box-shadow: 0 0 #ff4c4b; background-color: #D6BB59;}

    </style>
</head>
<body>
<dialog id="dialog" class="toast" open>
    <h3 class="attention">请注意</h3>
    <h4>请输入密码确保密码无误</h4>
</dialog>
</body>
</html>