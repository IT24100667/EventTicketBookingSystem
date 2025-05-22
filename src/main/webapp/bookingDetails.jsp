<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    User user = (User) session.getAttribute("user");
    Booking booking = (Booking) request.getAttribute("booking");

    if (booking == null) {
        String bookingId = (String) session.getAttribute("currentBookingId");
        if (bookingId == null) {
            response.sendRedirect("ViewBookingsServlet");
            return;
        }
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Details</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        /* Page structure for sticky footer */
        html, body {
            height: 100%;
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .content-wrapper {
            flex: 1 0 auto;
        }

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
            padding: 10px 0;
            flex-shrink: 0;
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
                    <li class="nav-item active">
                        <a class="nav-link" href="ViewBookingsServlet">My Bookings</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ViewPaymentsServlet">My Payments</a>
                    </li>
                    <li class="nav-item">
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
    </div>

    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4>Booking Details</h4>
            </div>
            <div class="card-body">
                <% if (booking != null) { %>
                <h5>Booking Summary</h5>
                <p><strong>Booking ID:</strong> <%= booking.getId() %></p>
                <p><strong>Status:</strong> <%= booking.getStatus() %></p>
                <p><strong>Tickets:</strong> <%= booking.getTicketQuantity() %></p>
                <p><strong>Total Amount:</strong> $<%= String.format("%.2f", booking.getTotalPrice()) %></p>
                <p><strong>Booking Date:</strong> <%= dateFormat.format(booking.getBookingDate()) %></p>

                <div class="mt-4">
                    <a href="PaymentFormServlet?bookingId=<%= booking.getId() %>" class="btn btn-success">Proceed to Payment</a>
                    <a href="ViewEventsServlet" class="btn btn-secondary ml-2">Cancel</a>
                </div>
                <% } else { %>
                <div class="alert alert-danger">Booking details not found.</div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Updated Footer with Blue Line and Current Time/User -->
<footer class="bg-dark text-white text-center py-3">
    <p class="mb-0">Event Ticket Booking System &copy; 2025 </p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>