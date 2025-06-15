<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #FFFFFF;
            color: #0C0C0C;
            margin: 0;
            padding: 0;
        }
        #container {
            width: 80%;
            margin: auto;
            text-align: center;
            padding: 20px;
        }
        #header {
            background-color: #69DC9E;
            padding: 20px;
            border-radius: 10px;
        }
        h1 {
            margin: 0;
            color: #0C0C0C;
        }
        .section {
            background-color: #E59F71;
            padding: 20px;
            margin: 20px auto;
            border-radius: 10px;
            width: 60%;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .button {
            display: inline-block;
            text-decoration: none;
            color: #FFFFFF;
            background-color: #BA5A31;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            transition: 0.3s;
        }
        .button:hover {
            background-color: #69DC9E;
            color: #0C0C0C;
        }
        .userlogin, .adminlogin {
            display: inline-block;
            width: 45%;
            margin: 10px;
        }
    </style>
</head>
<body>
    <div id="container">
        <div id="header">
            <h1>Quiz Management</h1>
        </div>
        <div id="content">
            <%
                String username = (String) session.getAttribute("username");
                String designation = (String) session.getAttribute("designation");
            %>
            <% if ("User".equalsIgnoreCase(designation)) { %>
                <div class="section">
                    <h2>Start Exam:</h2>
                    <a href="/Quiz/QuizSelectPage.jsp" class="button">Start Now</a>
                </div>
            <% } else if ("Admin".equalsIgnoreCase(designation)) { %>
                <div class="section">
                    <h2>Edit Questions:</h2>
                    <a href="/Quiz/QuizEditPage.html" class="button">Manage Questions</a>
                </div>
            <% } else if(designation==null || username==null){%>
                <div class="section">
                    <div class="userlogin">
                    <h2>User Login :</h2>
                    <a href="Log-In.html" class="button">User Login</a>
                    </div>
                    <div class="adminlogin">
                    <h2>Admin Login :</h2>
                    <a href="Admin-Login.html" class="button">Admin-Login</a>
                    </div>
                </div>
            <% } else { %>
                <div class="section">
                    <p>Invalid Designation. Please contact the administrator.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>