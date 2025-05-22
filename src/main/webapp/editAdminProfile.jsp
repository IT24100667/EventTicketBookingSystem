<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Admin" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user") == null || session.getAttribute("isAdmin") == null ||
            !(Boolean)session.getAttribute("isAdmin")) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    Admin admin = (Admin) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Admin Profile</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Edit Admin Profile</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="UpdateAdminServlet" method="post">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" class="form-control" id="username" name="username"
                   value="<%= admin.getUsername() %>" required>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" class="form-control" id="password" name="password"
                   value="<%= admin.getPassword() %>" required>
        </div>

        <div class="form-group">
            <label for="fullName">Full Name:</label>
            <input type="text" class="form-control" id="fullName" name="fullName"
                   value="<%= admin.getFullName() %>" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" class="form-control" id="email" name="email"
                   value="<%= admin.getEmail() %>" required>
        </div>

        <div class="form-group">
            <label for="phoneNumber">Phone Number:</label>
            <input type="text" class="form-control" id="phoneNumber" name="phoneNumber"
                   value="<%= admin.getPhoneNumber() %>" required>
        </div>

        <button type="submit" class="btn btn-primary">Update Profile</button>
        <a href="adminDashboard.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>
