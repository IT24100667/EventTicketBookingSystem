<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Admin Login</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <%
        String message = null;
        if (request.getAttribute("message") != null) {
            message = (String) request.getAttribute("message");
        } else if (session.getAttribute("message") != null) {
            message = (String) session.getAttribute("message");
            session.removeAttribute("message"); // Clear the message after displaying
        }
        if (message != null) {
    %>
    <div class="alert alert-success">
        <%= message %>
    </div>
    <% } %>

    <form action="AdminLoginServlet" method="post">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>

        <button type="submit" class="btn btn-danger">Login as Admin</button>
    </form>

    <div class="mt-3">
        <a href="adminRegister.jsp">Register as new admin</a> |
        <a href="index.jsp">Back to Home</a>
    </div>
</div>
</body>
</html>