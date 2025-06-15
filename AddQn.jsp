<html>
<head>
    <title>Question | Edit</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .Ebn{
            text-decoration: none;
            color:black;
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            color: black;
            background-color: aqua;
            text-decoration: none;
            border: black;
            border-radius: 50px;
            cursor: pointer;

        }
        .Ebn:hover{
            color:bisque;
            background-color: #333;
            transition-duration: 5ms;
        }
        #top{
            display: flex;
            justify-content:space-between;
            padding: 0 20px;
        }
        
    </style>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String designation = (String) session.getAttribute("designation");
    %>
    <% if(designation==null || username==null){%>
        <label>Login Again...</label>
        <a href='Log-In.html'>Click Here to Login....</a>
    <% }else{ %>
    <div id="Container">
        <div id="pannel">
            <center>
                <div id="top">
                    <div id="lhead"><label style="font-size: 35px;">Add Questions</label></div>
                    <div id="rhead"><a href="http://localhost:8080/Quiz/index.jsp" class="Ebn">Exit</a></div>
                </div>
            </center>
            <hr>
            <form  action="http://localhost:8080/Quiz/Qncheck" method="post">
                <table>
                    <tr>
                        <td><label>Question  :</label></td>
                        <td><input type="text" class="styled-textbox" size="25" name="Question" value="" required></td>
                    </tr>
                    <tr>
                        <td><label>Option 1  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option1" size="20" value="" required></td>
                    </tr>
                    <tr>
                        <td><label>Option 2  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option2" size="20" value="" required></td>
                    </tr><tr>
                        <td><label>Option 3  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option3" size="20" value="" required></td>
                    </tr>
                    <tr>
                        <td><label>Option 4  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option4" size="20" value="" required></td>
                    </tr>
                    <tr>
                        <td><label>Answer  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Answer" size="20" value="" required></td>
                    </tr>
                </table>
                <div class="bn">
                    <input type="submit" class="Button" value="Add">
                    <input type="reset" class="Button" value="Reset">
                </div>
                
            </form>
        </div>
    </div>
    <% } %>
</body>