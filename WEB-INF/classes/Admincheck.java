import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class Admincheck extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String username = req.getParameter("UName");
        String password = req.getParameter("PWord");

        String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";

        boolean success = false;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            cn = DriverManager.getConnection(url);

            String query = "SELECT UserName, Password, Designation FROM login_details WHERE UserName = ? AND Password = ? AND Designation=?";
            ps = cn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, "Admin");

            rs = ps.executeQuery();

            if (rs.next()) {
                success = true;
                HttpSession session = req.getSession();
                session.setAttribute("username",username);
                session.setAttribute("designation","Admin");
            }
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
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                out.println("<html><body>");
                out.println("<h2>Error closing resources: " + e.getMessage() + "</h2>");
                out.println("</body></html>");
            }
        }
        if (success) {
            res.sendRedirect("index.jsp");
        } else {
            out.println("<html><body>");
            out.println("<h2> "+ "Invalid username or password!"+"</h2>");
            out.println("</body></html>");
        }
    }
}