<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Edit Your Profile</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <form action="UserUpdateServlet" method="post">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" class="form-control" id="username" name="username"
                   value="<%= user.getUsername() %>" required>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" class="form-control" id="password" name="password"
                   value="<%= user.getPassword() %>" required>
        </div>

        <div class="form-group">
            <label for="fullName">Full Name:</label>
            <input type="text" class="form-control" id="fullName" name="fullName"
                   value="<%= user.getFullName() %>" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" class="form-control" id="email" name="email"
                   value="<%= user.getEmail() %>" required>
        </div>

        <div class="form-group">
            <label for="phoneNumber">Phone Number:</label>
            <input type="text" class="form-control" id="phoneNumber" name="phoneNumber"
                   value="<%= user.getPhoneNumber() %>" required>
        </div>

        <button type="submit" class="btn btn-primary">Update Profile</button>
    </form>

    <hr>
    <h3>Delete Account</h3>
    <p class="text-danger">Warning: This action cannot be undone.</p>

    <form action="UserDeleteServlet" method="post" onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone.');">
        <button type="submit" class="btn btn-danger">Delete My Account</button>
    </form>

    <div class="mt-3">
        <a href="userDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</div>
</body>
</html>