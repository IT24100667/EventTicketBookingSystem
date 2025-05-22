<%-- File: userPayments.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Payment" %>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    User user = (User) session.getAttribute("user");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Payments</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        /* Color scheme variables */
        :root {
            --primary-color: #3a86ff;
            --secondary-color: #4361ee;
            --accent-color: #4cc9f0;
            --background-color: #f8f9fa;
            --light-accent: #e2eafc;
            --dark-accent: #343a40;
            --success-color: #57cc99;
        }

        /* Footer positioning with flexbox */
        html {
            height: 100%;
        }

        body {
            min-height: 100%;
            display: flex;
            flex-direction: column;
            background-color: var(--background-color);
            color: #333;
        }

        .content-wrapper {
            flex: 1;
        }

        /* Navigation styles */
        .navbar .navbar-nav {
            margin-left: auto;
        }

        /* User profile dropdown styling */
        .user-dropdown {
            min-width: 280px;
            padding: 0;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-radius: 0.5rem;
        }

        .user-dropdown .dropdown-header {
            background-color: var(--light-accent);
            padding: 12px;
            font-weight: bold;
            border-bottom: 1px solid #dee2e6;
            border-radius: 0.5rem 0.5rem 0 0;
        }

        .user-dropdown .dropdown-body {
            padding: 15px;
            background-color: white;
        }

        .user-dropdown .dropdown-footer {
            padding: 12px;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
            text-align: center;
            border-radius: 0 0 0.5rem 0.5rem;
        }

        .profile-icon {
            font-size: 1.5rem;
            color: white;
            cursor: pointer;
            margin-left: 15px;
            transition: color 0.3s;
        }

        .profile-icon:hover {
            color: var(--accent-color);
        }

        /* Footer styles */
        footer {
            background: linear-gradient(to right, var(--dark-accent), #495057);
            border-top: 4px solid var(--accent-color);
            color: white;
            text-align: center;
            padding: 15px 0;
            margin-top: 20px;
            width: 100%;
        }
    </style>
</head>
<body>
<div class="content-wrapper">
    <div class="container mt-4">
        <!-- Updated Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 rounded">
            <a class="navbar-brand" href="index.jsp">Event Booking</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarContent">
                <!-- Navigation items on the RIGHT side -->
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="userDashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ViewEventsServlet">Events</a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link" href="ViewBookingsServlet">My Bookings</a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="ViewPaymentsServlet">My Payments</a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link" href="ViewFeedbacksServlet">Feedback</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
                </ul>

                <!-- User Profile Icon with Dropdown -->
                <% if(user != null) { %>
                <div class="dropdown">
                    <a class="dropdown-toggle" href="#" id="profileDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-user-circle profile-icon"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right user-dropdown" aria-labelledby="profileDropdown">
                        <div class="dropdown-header">
                            <h6><%= user.getFullName() %></h6>
                            <small class="text-muted"><%= user.getUsername() %></small>
                        </div>
                        <div class="dropdown-body">
                            <p class="mb-2"><i class="fas fa-envelope mr-2 text-primary"></i> <%= user.getEmail() %></p>
                            <p class="mb-2"><i class="fas fa-phone mr-2 text-primary"></i> <%= user.getPhoneNumber() %></p>
                        </div>
                        <div class="dropdown-footer">
                            <a href="userProfile.jsp" class="btn btn-primary btn-sm">Edit Profile</a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </nav>

        <div class="mt-4">
            <h2>My Payment History</h2>

            <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("message") %>
            </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <% if (payments != null && !payments.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Booking ID</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Payment payment : payments) { %>
                    <tr>
                        <td><%= payment.getId() %></td>
                        <td>
                            <a href="ViewBookingsServlet">
                                <%= payment.getBookingId() %>
                            </a>
                        </td>
                        <td>$<%= String.format("%.2f", payment.getAmount()) %></td>
                        <td><%= payment.getPaymentMethod() %></td>
                        <td>
                            <% if (payment.getStatus().equals(Payment.STATUS_COMPLETED)) { %>
                            <span class="badge badge-success">Completed</span>
                            <% } else if (payment.getStatus().equals(Payment.STATUS_PENDING)) { %>
                            <span class="badge badge-warning">Pending</span>
                            <% } else { %>
                            <span class="badge badge-danger">Failed</span>
                            <% } %>
                        </td>
                        <td><%= dateFormat.format(payment.getPaymentDate()) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-info">
                You don't have any payments yet. Book an event to make a payment.
            </div>
            <div class="mt-3">
                <a href="ViewEventsServlet" class="btn btn-primary">Browse Events</a>
            </div>
            <% } %>

            <div class="mt-4">
                <a href="userDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </div>
    </div>
</div>

<!-- Updated Footer with timestamp and user login -->
<footer>
    <div class="container">
        <p class="mb-0">Event Ticket Booking System &copy; 2025 </p>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>