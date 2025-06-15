<%@ page import="java.util.*" %>
<%@ page import="jakarta.mail.*" %>
<%@ page import="jakarta.mail.internet.*" %>
<%@ page import="jakarta.activation.*" %>
<%@ page import="java.util.Properties" %>

<%
    String otp = "";
    String status = "";
    String submitted = request.getParameter("register");

    if (submitted != null) {
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String designation = request.getParameter("designation");

        // Generate 6-digit OTP
        otp = String.valueOf(new Random().nextInt(900000) + 100000);

        // Store user data + OTP in session
        session.setAttribute("email", email);
        session.setAttribute("username", username);
        session.setAttribute("password", password);
        session.setAttribute("designation", designation);
        session.setAttribute("otp", otp);

        // Send OTP to user's email
        try {
            final String fromEmail = "now@gmail.com";
            final String mailUser = "now@gmail.com";
            final String mailPass = "";

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(mailUser, mailPass);
                }
            });

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("OTP Verification - Connectly");
            message.setText("Hi " + username + ",\n\nYour OTP for registration is: " + otp + "\n\n- Connectly Team");

            Transport.send(message);
            status = "OTP sent to your email!";
        } catch (Exception e) {
            status = "Failed to send OTP: " + e.getMessage();
        }
    }
%>

<html>
<head><title>Register</title></head>
<body>
<% if (submitted == null) { %>
    <h2>Register</h2>
    <form method="post">
        Email: <input type="email" name="email" required><br><br>
        Username: <input type="text" name="username" required><br><br>
        Password: <input type="password" name="password" required><br><br>
        <input type="hidden" name="designation" value="User">
        <input type="submit" name="register" value="Register">
    </form>
<% } else { %>
    <h3><%= status %></h3>
    <form action="verifyOtp.jsp" method="post">
        Enter OTP: <input type="text" name="userOtp" required>
        <input type="submit" value="Verify OTP">
    </form>
<% } %>
</body>
</html>
