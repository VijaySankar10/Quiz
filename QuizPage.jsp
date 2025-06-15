<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 40px;
        }

        h1 {
            text-align: center;
            color: #333;
            font-size: 2.5em;
        }

        .quiz-container {
            max-width: 900px;
            margin: 30px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .question {
            margin-bottom: 30px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 20px;
        }

        .question h3 {
            margin-bottom: 15px;
            color: #444;
        }

        .options label {
            display: block;
            background-color: #f9f9f9;
            padding: 10px 15px;
            margin-bottom: 10px;
            border-radius: 10px;
            border: 1px solid #ccc;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .options label:hover {
            background-color: #e0e0e0;
        }

        .submit-btn {
            display: block;
            width: fit-content;
            margin: 40px auto 0;
            background-color: #6200ea;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #3c0080;
        }
    </style>
</head>
<body>
<%
    String subName = request.getParameter("sub");
    if (subName == null || subName.trim().equals("")) {
%>
    <h1>No subject selected.</h1>
<%
    } else {
%>
    <h1>Quiz - <%= subName %></h1>
    <div class="quiz-container">
        <form action="/Quiz/SubmitQuiz.jsp" method="post">
            <input type="hidden" name="subName" value="<%= subName %>">
            <%
                String url = "jdbc:sqlserver://localhost:1433;databaseName=Quiz;user=Vijay;password=;encrypt=false";
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection(url);
                    String query = "SELECT Qn, option1, option2, option3, option4, Sno FROM Questions WHERE SubName = ?";
                    ps = conn.prepareStatement(query);
                    ps.setString(1, subName);
                    rs = ps.executeQuery();

                    int qno = 1;
                    while (rs.next()) {
                        String question = rs.getString("Qn");
                        String opt1 = rs.getString("option1");
                        String opt2 = rs.getString("option2");
                        String opt3 = rs.getString("option3");
                        String opt4 = rs.getString("option4");
                        String Sno = rs.getString("Sno");
            %>
                <div class="question">
                    <h3>Q<%= qno++ %>. <%= question %> (Sno: <%= Sno %>)</h3>
                    <div class="options">
                        <label><input type="radio" name="answer<%= Sno %>" value="<%= opt1 %>"> <%= opt1 %></label>
                        <label><input type="radio" name="answer<%= Sno %>" value="<%= opt2 %>"> <%= opt2 %></label>
                        <label><input type="radio" name="answer<%= Sno %>" value="<%= opt3 %>"> <%= opt3 %></label>
                        <label><input type="radio" name="answer<%= Sno %>" value="<%= opt4 %>"> <%= opt4 %></label>
                    </div>
                </div>
            <%
                    }

                    if (qno == 1) {
            %>
                <p>No questions available for this subject.</p>
            <%
                    }

                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
            <button type="submit" class="submit-btn">Submit Quiz</button>
        </form>
    </div>
<%
    }
%>
</body>
</html>
