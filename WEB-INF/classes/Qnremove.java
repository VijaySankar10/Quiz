import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class Qnremove extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        int Sno = Integer.parseInt(req.getParameter("Sno"));


        String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";

        int success;
        Connection cn = null;
        PreparedStatement ps = null;

        try {

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            cn = DriverManager.getConnection(url);

            String query = "DELETE FROM Questions WHERE Sno=?";
            ps = cn.prepareStatement(query);
            ps.setInt(1, Sno);

            success=ps.executeUpdate();

        } catch (SQLException e) {
            out.println("<html><body>");
            out.println("<h2>Database connection error: " + e.getMessage() + "</h2>");
            out.println("</body></html>");
            return;
        } catch (ClassNotFoundException e) {
            out.println("<html><body>");
            out.println("<h2>JDBC Driver not found: " + e.getMessage() + "</h2>");
            out.println("</body></html>");
            return;
        } finally 
        {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                out.println("<html><body>");
                out.println("<h2>Error closing resources: " + e.getMessage() + "</h2>");
                out.println("</body></html>");
            }
        }
        if (success>0) {
            out.println("<html><body>");
            out.println("<h2>Record with Sno " + Sno + " has been successfully deleted.</h2>");
            out.println("<meta http-equiv='refresh' content='5;URL=RemoveQn.jsp'>");
        } else {
            out.println("<html><body>");
            out.println("<h2> "+ "Cannot Remove Question ..."+"</h2>");
            out.println("</body></html>");
        }
    }
}