import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class Qncheck extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String Question = req.getParameter("Question");
        String Option1 = req.getParameter("Option1");
        String Option2 = req.getParameter("Option2");
        String Option3 = req.getParameter("Option3");
        String Option4 = req.getParameter("Option4");
        String Answer = req.getParameter("Answer");

        String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";

        boolean success = false;
        Connection cn = null;
        PreparedStatement ps = null;

        try {

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            cn = DriverManager.getConnection(url);

            String query = "INSERT INTO Questions(Qn,option1,option2,option3,option4,Answer) VALUES(?,?,?,?,?,?)";
            ps = cn.prepareStatement(query);
            ps.setString(1,Question);
            ps.setString(2,Option1);
            ps.setString(3,Option2);
            ps.setString(4,Option3);
            ps.setString(5,Option4);
            ps.setString(6,Answer);

            ps.executeUpdate();
            success=true;
            
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
        if (success) {
            out.println("<html><body>");
            out.println("<h2>Record has been successfully inserted.</h2>");
            out.println("<meta http-equiv='refresh' content='5;URL=AddQn.jsp'>");
        } else {
            out.println("<html><body>");
            out.println("<h2> "+ "Question Insertion Failed..."+"</h2>");
            out.println("</body></html>");
        }
    }
}