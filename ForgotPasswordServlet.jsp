<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.mail.*, jakarta.mail.internet.*" %>

<%
    String email = request.getParameter("email");
    String name = request.getParameter("name");

    String dbUrl = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String password = null;

    boolean emailSent = false;
    boolean userExists = false;

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        cn = DriverManager.getConnection(dbUrl);

        String query = "SELECT Password FROM login_details WHERE UserName = ? AND EMail = ?";
        ps = cn.prepareStatement(query);
        ps.setString(1, name);
        ps.setString(2, email);
        rs = ps.executeQuery();

        if (rs.next()) {
            password = rs.getString("Password");
            userExists = true;

            // Email sending
            final String senderEmail = "@gmail.com"; 
            final String senderPassword = "";

            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            try {
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(senderEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
                message.setSubject("Password Recovery - Quiz App");
                message.setText("Hi " + name + ",\n\nYour password is: " + password + "\n\nPlease keep it safe.\n\nRegards,\nQuiz App Team");

                Transport.send(message);
                emailSent = true;
            } catch (MessagingException e) {
                out.println("<p style='color:red;'>Email sending failed. Check logs for details.</p>");
                e.printStackTrace();
            }
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (cn != null) cn.close();
        } catch (SQLException e) {
            out.println("<p>Error closing DB connection.</p>");
        }
    }
%>

<html>
<head>
    <title>Forgot Password Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #83a4d4, #b6fbff);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .message-box {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            text-align: center;
        }
        h2 {
            color: #333;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: white;
            background-color: #4A90E2;
            padding: 10px 20px;
            border-radius: 8px;
        }
        a:hover {
            background-color: #357ABD;
        }
    </style>
</head>
<body>
    <div class="message-box">
        <% if (!userExists) { %>
            <h2 style="color: red;">User not found. Please check your username and email.</h2>
        <% } else if (emailSent) { %>
            <h2>Password sent successfully to <%= email %></h2>
        <% } else { %>
            <h2 style="color: red;">Error sending email. Please try again.</h2>
        <% } %>
        <a href="forgot-password.html">Go Back</a>
    </div>
</body>
</html>
