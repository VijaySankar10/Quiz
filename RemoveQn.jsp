<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Question</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #4e54c8, #8f94fb);
            color: white;
            padding: 50px;
        }

        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 30px;
        }

        form {
            max-width: 500px;
            margin: auto;
            background-color: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }

        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }

        input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 10px;
            border: none;
        }

        input[type="submit"] {
            background-color: white;
            color: #4e54c8;
            padding: 12px 20px;
            font-size: 16px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: background 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #d6d8ff;
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
    <h1>Delete a Question</h1>

    <form method="post">
        <label>Enter Sno (Question ID) to Delete:</label>
        <input type="number" name="sno" required>
        <input type="submit" value="Delete Question">
    </form>

<%
    String snoStr = request.getParameter("sno");

    if (snoStr != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";

        try {
            int sno = Integer.parseInt(snoStr);
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url);

            String sql = "DELETE FROM Questions WHERE Sno = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sno);

            int deleted = pstmt.executeUpdate();

            if (deleted > 0) {
%>
                <div class="message">✅ Question with Sno <%= sno %> was deleted successfully!</div>
<%
            } else {
%>
                <div class="message">❌ No question found with Sno <%= sno %>.</div>
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
