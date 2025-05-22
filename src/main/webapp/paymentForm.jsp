<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

    // Current time and user login as provided
    String currentDateTime = "2025-05-17 11:45:05";
    String userLogin = "IT24100725";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Payment Method</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        .payment-details {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .detail-row {
            display: flex;
            margin-bottom: 12px;
        }
        .label {
            font-weight: bold;
            width: 150px;
            color: #555;
        }
        .value {
            color: #333;
            font-weight: 500;
        }
        .payment-method-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin: 15px 0;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .payment-method-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .payment-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        .card-icon {
            color: #007bff;
        }
        .cash-icon {
            color: #28a745;
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
            margin-top: 3rem;
        }

    </style>
</head>
<body>

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
                <li class="nav-item">
                    <a class="nav-link" href="ViewBookingsServlet">My Bookings</a>
                </li>
                <li class="nav-item">
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
</div>


<div class="container mt-4">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4><i class="fas fa-credit-card mr-2"></i>Select Payment Method</h4>
                </div>

                <div class="card-body">
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <div class="payment-details">
                        <h5 class="mb-3">Booking Summary</h5>
                        <div class="detail-row">
                            <span class="label">Booking ID:</span>
                            <span class="value" id="bookingId"><%= booking.getId() %></span>
                        </div>
                        <div class="detail-row">
                            <span class="label">Status:</span>
                            <span class="value" id="bookingStatus">PENDING</span>
                        </div>
                        <div class="detail-row">
                            <span class="label">Tickets:</span>
                            <span class="value" id="ticketCount"><%= booking.getTicketQuantity() %></span>
                        </div>
                        <div class="detail-row">
                            <span class="label">Total Amount:</span>
                            <span class="value" id="totalAmount">$<%= String.format("%.2f", booking.getTotalPrice()) %></span>
                        </div>
                        <div class="detail-row">
                            <span class="label">Booking Date:</span>
                            <span class="value" id="bookingDate"><%= dateFormat.format(booking.getBookingDate()) %></span>
                        </div>
                    </div>

                    <h5 class="mb-4">Choose Your Payment Method</h5>

                    <div class="row">
                        <!-- Card Payment Option -->
                        <div class="col-md-6">
                            <form action="PaymentFormServlet" method="post">
                                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                <input type="hidden" name="paymentMethod" value="CARD">
                                <div class="payment-method-card text-center" onclick="this.parentNode.submit();">
                                    <div class="payment-icon card-icon">
                                        <i class="fas fa-credit-card"></i>
                                    </div>
                                    <h5>Card Payment</h5>
                                    <p>Pay securely online with your credit or debit card</p>
                                </div>
                            </form>
                        </div>

                        <!-- Cash Payment Option -->
                        <div class="col-md-6">
                            <form action="PaymentFormServlet" method="post">
                                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                <input type="hidden" name="paymentMethod" value="CASH">
                                <div class="payment-method-card text-center" onclick="this.parentNode.submit();">
                                    <div class="payment-icon cash-icon">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </div>
                                    <h5>Cash Payment</h5>
                                    <p>Pay with cash at the venue on the day of the event</p>
                                </div>
                            </form>
                        </div>
                    </div>



                    <div class="text-center mt-4">
                        <a href="javascript:history.back()" class="btn btn-secondary">
                            <i class="fas fa-arrow-left mr-2"></i>Back
                        </a>
                    </div>


                </div>
            </div>
        </div>
    </div>
</div>

<!-- Updated Footer with Blue Line and Current Time/User -->
<footer class="bg-dark text-white text-center py-3 mt-5">
    <p class="mb-0">Event Ticket Booking System &copy; 2025</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>