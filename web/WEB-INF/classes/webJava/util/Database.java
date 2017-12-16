package webJava.util;
import java.sql.*;

public class Database {
    static private Connection conn;

    public Database(){
        connect();
    }

    public ResultSet query(String arg) {
        ResultSet rs = executeQuery(arg);
        return rs;
    }

    public int insert(String arg) throws Exception{
        try{
            return executeInsert_Update_delete(arg);
        }catch (Exception e){
            throw e;
        }
    }

    public int update(String arg) throws Exception{
        try{
            return executeInsert_Update_delete(arg);
        }catch (Exception e){
            throw e;
        }
    }

    public int delete(String arg) throws Exception{
        try{
            return executeInsert_Update_delete(arg);
        }catch (Exception e){
            throw e;
        }
    }

    // 建立连接
    private boolean connect() {
        String connectString = "jdbc:mysql://172.18.187.234:53306/jwxt"
                + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
        String user  = "user";
        String password = "123";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(connectString, user, password);
            return true;
        } catch (Exception e) {
            System.out.println("Connect Error!");
            e.printStackTrace();
        }
        return false;
    }

    //执行SQL查询语句, 返回结果集
    private ResultSet executeQuery(String sqlSentence) {
        Statement stat;
        ResultSet rs = null;

        try {
            stat = conn.createStatement();       //获取执行sql语句的对象
            rs = stat.executeQuery(sqlSentence); //执行sql查询，返回结果集
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rs;
    }

    private int executeInsert_Update_delete(String sqlSentence) throws Exception{
        Statement stat;
        try {
            stat = conn.createStatement();
            return stat.executeUpdate(sqlSentence);
        } catch (Exception e) {
            throw e;
        }
    }

}
