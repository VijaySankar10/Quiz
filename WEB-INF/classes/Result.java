import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class Result extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        HttpSession session = req.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;

        if (username == null) {
            out.println("<html><body>");
            out.println("<h2>Session expired. Please log in again.</h2>");
            out.println("<a href='Log-In.html'>Click Here to Login....</a>");
            out.println("</body></html>");
            return;
        }

        int score = 0;
        
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            cn = DriverManager.getConnection(url);

            String query = "SELECT * FROM Questions where SubName = ?";
            ps = cn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                int sno = rs.getInt("Sno");
                String correctAnswer = rs.getString("Answer");

                // Get the user-selected answer for this question
                String userAnswer = req.getParameter("Q" + sno);

                // Compare the user answer with the correct answer
                if (userAnswer != null && userAnswer.equals(correctAnswer)) {
                    score++; // Increase score for correct answer
                }
            }

            out.println("<html><body>");
            out.println("<h1>Your Score: " + score + "</h1>");
            out.println("<a href='ResultPage.html'>View Results</a>");
            out.println("</body></html>");

        } catch (ClassNotFoundException e) {
            out.println("<h2>JDBC Driver not found: " + e.getMessage() + "</h2>");
        } catch (SQLException e) {
            out.println("<h2>Database connection error: " + e.getMessage() + "</h2>");
        } finally {
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
    }
}
