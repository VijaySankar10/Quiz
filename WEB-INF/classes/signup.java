import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class signup extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String username = req.getParameter("UName");
        String password = req.getParameter("PWord");
        String mail = req.getParameter("MailID");

        String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";

        try (Connection cn = DriverManager.getConnection(url);
             PreparedStatement ps1 = cn.prepareStatement("SELECT UserName FROM login_details WHERE UserName = ?");
             PreparedStatement ps2 = cn.prepareStatement("INSERT INTO login_details(UserName, Password,Designation,EMail) VALUES(?, ?, ?, ?)")) {

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Check if the username already exists
            ps1.setString(1, username);
            try (ResultSet rs = ps1.executeQuery()) {
                if (rs.next()) {
                    out.println("<html><body><center>");
                    out.println("<h1>Username already exists. Please try another username.</h1>");
                    out.println("</center></body></html>");
                } else {
                    // Insert new user details
                    ps2.setString(1, username);
                    ps2.setString(2, password);
                    ps2.setString(3,"User");
                    ps2.setString(4,mail);
                    ps2.executeUpdate();

                    HttpSession session = req.getSession();
                    session.setAttribute("Username",username);
                    session.setAttribute("designation","user");
                    res.sendRedirect("index.jsp");

                }
            }
        } catch (Exception e) {
            out.println("<html><body><center>");
            out.println("<h1>Error occurred: " + e.getMessage() + "</h1>");
            out.println("</center></body></html>");
            e.printStackTrace();
        }
    }
}