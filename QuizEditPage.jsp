<html>
<head>
    <title>Question | Edit</title>
    <link rel="stylesheet" href="styles.css">
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
            <center><label style="font-size: 35px;">Add / Remove Questions</label></center>
            <hr>
            <form  action="http://localhost:8080/Quiz/Qncheck" method="post">
                <table>
                    <tr>
                        <td><label>Question  :</label></td>
                        <td><input type="text" class="styled-textbox" size="25" name="Question" value=""></td>
                    </tr>
                    <tr>
                        <td><label>Option 1  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option1" size="20" value=""></td>
                    </tr>
                    <tr>
                        <td><label>Option 2  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option2" size="20" value=""></td>
                    </tr><tr>
                        <td><label>Option 3  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option3" size="20" value=""></td>
                    </tr>
                    <tr>
                        <td><label>Option 4  :</label></td>
                        <td><input type="text" class="styled-textbox" name="Option4" size="20" value=""></td>
                    </tr>
                </table>
                <input type="hidden" name="designation" value="User">
                <div class="bn">
                    <input type="submit" class="Button" value="Log-In">
                    <input type="reset" class="Button" value="Reset">
                </div>
                
            </form>
        </div>
    </div>
    <% } %>
</body>
