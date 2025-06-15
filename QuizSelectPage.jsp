<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Subject</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #8360c3, #2ebf91);
            margin: 0;
            padding: 40px;
            color: #fff;
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 3em;
        }

        .container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .card {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            transition: transform 0.3s, background-color 0.3s;
            cursor: pointer;
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }

        .card:hover {
            transform: scale(1.05);
            background-color: rgba(255, 255, 255, 0.2);
        }

        .card a {
            text-decoration: none;
            color: #fff;
            font-size: 1.5em;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h1>Select a Subject</h1>
    <div class="container">
        <%
            // JDBC config
            String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection(url);
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT DISTINCT SubName FROM Questions");

                while (rs.next()) {
                    String subName = rs.getString("SubName");
        %>
                <a href="QuizPage.jsp?sub=<%= subName %>" style="text-decoration: none; color: white; font-size: 24px;" >
                    <div class="card">
                        <%= subName %>
                    </div>
                </a>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</body>
</html>