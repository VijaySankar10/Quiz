<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Question</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #ff9966, #ff5e62);
            padding: 40px;
            color: #fff;
        }

        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 30px;
        }

        form {
            max-width: 600px;
            margin: auto;
            background-color: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"], select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 10px;
            border: none;
        }

        input[type="submit"] {
            background-color: #fff;
            color: #ff5e62;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: background 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #ffd6cc;
        }

        .message {
            text-align: center;
            font-weight: bold;
            font-size: 1.2em;
            margin-top: 20px;
            color: lightyellow;
        }
    </style>
</head>
<body>
    <h1>Add a New Question</h1>

    <form method="post">
        <label>Question:</label>
        <input type="text" name="qn" required>

        <label>Option 1:</label>
        <input type="text" name="opt1" required>

        <label>Option 2:</label>
        <input type="text" name="opt2" required>

        <label>Option 3:</label>
        <input type="text" name="opt3" required>

        <label>Option 4:</label>
        <input type="text" name="opt4" required>

        <label>Correct Answer:</label>
        <input type="text" name="answer" required>

        <label>Subject Name:</label>
        <input type="text" name="subname" required>

        <input type="submit" value="Add Question">
    </form>

<%
    String qn = request.getParameter("qn");
    String opt1 = request.getParameter("opt1");
    String opt2 = request.getParameter("opt2");
    String opt3 = request.getParameter("opt3");
    String opt4 = request.getParameter("opt4");
    String answer = request.getParameter("answer");
    String subname = request.getParameter("subname");

    if (qn != null && opt1 != null && opt2 != null && opt3 != null && opt4 != null && answer != null && subname != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url);

            String query = "INSERT INTO Questions (Qn, option1, option2, option3, option4, Answer, SubName) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, qn);
            pstmt.setString(2, opt1);
            pstmt.setString(3, opt2);
            pstmt.setString(4, opt3);
            pstmt.setString(5, opt4);
            pstmt.setString(6, answer);
            pstmt.setString(7, subname);

            int inserted = pstmt.executeUpdate();

            if (inserted > 0) {
%>
                <div class="message">✅ Question added successfully!</div>
<%
            } else {
%>
                <div class="message">❌ Failed to insert the question.</div>
<%
            }

        } catch (Exception e) {
%>
            <div class="message">❌ Error: <%= e.getMessage() %></div>
<%
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
%>

</body>
</html>