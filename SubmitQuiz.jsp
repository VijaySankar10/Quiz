<%@ page import="java.sql.*" %>
<%@ page import="jakarta.mail.*, jakarta.mail.internet.*, jakarta.activation.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="com.itextpdf.text.*" %>
<%@ page import="com.itextpdf.text.pdf.*" %>
<%@ page import="java.io.*" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String subName = request.getParameter("subName");
    String username = (String) session.getAttribute("username");
    String userEmail = null;

    String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int total = 0;
    int correct = 0;
    String certificatePath = application.getRealPath("/") + "certificates/" + username + "_certificate.pdf";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(url);

        // Get user email from login_details
        ps = conn.prepareStatement("SELECT EMail FROM login_details WHERE UserName = ?");
        ps.setString(1, username);
        rs = ps.executeQuery();
        if (rs.next()) {
            userEmail = rs.getString("EMail");
        } else {
            throw new Exception("Email not found for user: " + username);
        }
        rs.close();
        ps.close();

        // Evaluate quiz
        ps = conn.prepareStatement("SELECT Sno, Answer FROM Questions WHERE SubName = ?");
        ps.setString(1, subName);
        rs = ps.executeQuery();

        while (rs.next()) {
            String sno = rs.getString("Sno");
            String Answer = rs.getString("Answer");
            String userAnswer = request.getParameter("answer" + sno);
            if (userAnswer != null) {
                total++;
                if (userAnswer.equals(Answer)) {
                    correct++;
                }
            }
        }

        double percentage = (total > 0) ? (correct * 100.0 / total) : 0;
        boolean passed = percentage >= 50;

        out.println("<h2>You scored: " + correct + "/" + total + " (" + String.format("%.2f", percentage) + "%)</h2>");

        // 1. Generate the Certificate PDF
        generateCertificate(username, subName, certificatePath);

        // 2. Send email with result and certificate attachment
        final String sender = "now@gmail.com";
        final String appPass = "";

        if (sendEmailWithAttachment(userEmail, sender, appPass, username, subName, percentage, certificatePath)) {
            out.println("<p>Result and certificate sent to your email: " + userEmail + "</p>");
        } else {
            out.println("<p>Error sending email. Please try again later.</p>");
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

<%!
// Certificate generation method with enhanced styling
public void generateCertificate(String username, String subName, String certificatePath) throws Exception {
    Document document = new Document(PageSize.A4, 50, 50, 50, 50); // Margins: left, right, top, bottom
    PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(certificatePath));
    document.open();

    // Draw a border
    PdfContentByte canvas = writer.getDirectContent();
    Rectangle rect = new Rectangle(36, 36, 559, 806); // A4 size - margins
    rect.setBorder(Rectangle.BOX);
    rect.setBorderWidth(2);
    rect.setBorderColor(BaseColor.LIGHT_GRAY);
    canvas.rectangle(rect);

    // Define fonts
    Font titleFont = new Font(Font.FontFamily.HELVETICA, 38, Font.BOLD, new BaseColor(0, 102, 204)); // Blue
    Font subtitleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.NORMAL, BaseColor.DARK_GRAY);
    Font nameFont = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLACK);
    Font bodyFont = new Font(Font.FontFamily.HELVETICA, 16, Font.NORMAL, BaseColor.BLACK);
    Font footerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.ITALIC, BaseColor.GRAY);

    // Title
    Paragraph title = new Paragraph("Certificate of Completion", titleFont);
    title.setAlignment(Element.ALIGN_CENTER);
    title.setSpacingBefore(60);
    document.add(title);

    // Subtitle
    Paragraph subtitle = new Paragraph("Presented To", subtitleFont);
    subtitle.setAlignment(Element.ALIGN_CENTER);
    subtitle.setSpacingBefore(30);
    document.add(subtitle);

    // Username
    Paragraph name = new Paragraph(username, nameFont);
    name.setAlignment(Element.ALIGN_CENTER);
    name.setSpacingBefore(10);
    document.add(name);

    // Body content
    Paragraph body = new Paragraph("For successfully completing the quiz on \"" + subName + "\".", bodyFont);
    body.setAlignment(Element.ALIGN_CENTER);
    body.setSpacingBefore(30);
    document.add(body);

    Paragraph congrats = new Paragraph("Congratulations on your achievement!", bodyFont);
    congrats.setAlignment(Element.ALIGN_CENTER);
    congrats.setSpacingBefore(20);
    document.add(congrats);

    // Signature and line
    document.add(Chunk.NEWLINE);
    document.add(Chunk.NEWLINE);
    Chunk line = new Chunk("                                                                                         ");
    line.setUnderline(0.5f, -2f); // underline thickness and offset
    Paragraph lineParagraph = new Paragraph(line);
    lineParagraph.setAlignment(Element.ALIGN_CENTER);
    document.add(lineParagraph);

    Paragraph signature = new Paragraph("Authorized by the Quiz App Team", subtitleFont);
    signature.setAlignment(Element.ALIGN_CENTER);
    signature.setSpacingBefore(10);
    document.add(signature);

    // Footer
    Paragraph footer = new Paragraph("Issued on: " + java.time.LocalDate.now(), footerFont);
    footer.setAlignment(Element.ALIGN_CENTER);
    footer.setSpacingBefore(60);
    document.add(footer);

    Paragraph thankYou = new Paragraph("Thank you for participating!", footerFont);
    thankYou.setAlignment(Element.ALIGN_CENTER);
    thankYou.setSpacingBefore(10);
    document.add(thankYou);

    document.close();
}

    // Method to send email with certificate attachment
    public boolean sendEmailWithAttachment(String recipientEmail, String senderEmail, String senderPassword, String username, String subName, double percentage, String certificatePath) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            // Corrected session creation with Jakarta Mail
            Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new jakarta.mail.PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Quiz Result and Certificate for " + subName);

            String resultMsg = "Hello " + username + ",\n\n"
                    + "You scored " + String.format("%.2f", percentage) + "%. "
                    + "Congratulations on completing the quiz for " + subName + ".\n\n"
                    + "Your certificate of completion is attached.\n\n"
                    + "Thank you,\n"
                    + "Quiz App";

            // Create the message part
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(resultMsg);

            // Create the file part (certificate)
            MimeBodyPart filePart = new MimeBodyPart();
            File file = new File(certificatePath);
            DataSource source = new FileDataSource(file);
            filePart.setDataHandler(new DataHandler(source));
            filePart.setFileName(file.getName());

            // Create the multipart and add the parts
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(filePart);

            // Set the content
            message.setContent(multipart);

            // Send the email
            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
%>
