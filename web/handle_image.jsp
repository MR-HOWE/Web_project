<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2017/12/16
  Time: 11:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*, org.apache.commons.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("utf-8");
    String url = ""; //来源地址的URL
    String fileName = ""; //完整路径
    String picName = ""; //图片名
    String ID = ""; //上传用户的sno
    String msg = ""; //交互信息

    //上传至文件系统
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if(isMultipart){
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List items = upload.parseRequest(request);

        for (int i=0;i<items.size();i++){
            FileItem fi = (FileItem) items.get(i);
            if (fi.isFormField()){
                ID = fi.getString("utf-8");
            }
            else { //文件类型
                DiskFileItem dfi = (DiskFileItem) fi;
                if(!dfi.getName().trim().equals("")){
                    picName = ID + "_" + FilenameUtils.getName(dfi.getName());
                    fileName = application.getRealPath("/upload_avatar")+ System.getProperty("file.separator") + picName;
                    dfi.write(new File(fileName)); //写入文件系统中
                }
                //保存文件名到数据库
                String connectString = "jdbc:mysql://172.18.187.234:53306/jwxt"
                        + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
                try {
                    //连接数据库
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection(connectString, "user", "123");
                    Statement stmt = con.createStatement();

                    //插入文件名到数据库
                    String sql = String.format("update user set image='%s' where sno='%s'",picName,ID);
                    int cnt = 0;
                    cnt = stmt.executeUpdate(sql);
                    if (cnt>0){msg = "上传图片成功";}

                    //关闭数据库
                    stmt.close(); con.close();
                }catch (Exception e){
                    msg = e.getMessage();
                }
            }
        }
    }
    //返回用户所在页面
    url = ID;
    response.sendRedirect(url); //用户不会察觉到发生了变化
%>
<html>
<head>
    <title>handleimage</title>
</head>
<body>
    <p>hello,good afternoon.</p>
    <%=msg%>
</body>
</html>
