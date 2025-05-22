<%-- File: userBookings.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.Event" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="com.example.eventticketbookingsystem.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    User user = (User) session.getAttribute("user");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    Map<String, Event> eventMap = (Map<String, Event>) request.getAttribute("eventMap");

    // NEW: Get payment map
    Map<String, Payment> paymentMap = (Map<String, Payment>) request.getAttribute("paymentMap");

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bookings</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        .status-message {
            font-size: 0.9rem;
            margin-top: 8px;
            padding: 8px;
            border-radius: 4px;
        }
        .status-pending {
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
        }
        .status-confirmed {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .status-cancelled {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .status-failed {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        /* NEW: Cash payment message style */
        .status-cash {
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
        }
        /* NEW: Booking reference style */
        .booking-reference {
            font-weight: bold;
            color: #dc3545;
            margin-top: 5px;
        }
        /* MODIFIED: Payment method badge - Option 1: Top middle */
        .payment-method-top {
            position: absolute;
            top: 13.5px;
            left: 78%;
            transform: translateX(-60%);
            z-index: 10;
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

        /* Flexbox layout for footer positioning */
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

        .payment-badge {
            font-size: 0.6em;
            font-weight: bold;
            padding: 4px 7px;
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
            <h2>My Bookings</h2>

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

            <% if (bookings != null && !bookings.isEmpty()) { %>
            <div class="row">
                <% for (Booking booking : bookings) {
                    Event event = eventMap.get(booking.getEventId());
                    if (event == null) continue; // Skip if event not found

                    // NEW: Get payment information
                    Payment payment = paymentMap != null ? paymentMap.get(booking.getId()) : null;
                    boolean isCashPayment = payment != null && "CASH".equals(payment.getPaymentMethod());
                    String paymentMethod = payment != null ? payment.getPaymentMethod() : "Unknown";

                    String statusClass = "";
                    String statusMessage = "";

                    if (booking.getStatus().equals(Booking.STATUS_PENDING)) {
                        statusClass = "status-pending";
                        statusMessage = "Your booking is currently in the processing queue. Please wait while our administrators confirm your booking.";
                    } else if (booking.getStatus().equals(Booking.STATUS_CONFIRMED)) {
                        // NEW: Different messages for card vs cash payments
                        if (isCashPayment) {
                            statusClass = "status-cash";
                            statusMessage = "Your booking is confirmed. Please pay cash at the venue on arrival.";
                        } else {
                            statusClass = "status-confirmed";
                            statusMessage = "Your booking and payment have been confirmed. Your tickets are ready!";
                        }
                    } else if (booking.getStatus().equals(Booking.STATUS_CANCELLED)) {
                        statusClass = "status-cancelled";
                        statusMessage = "This booking has been cancelled.";
                    } else {
                        statusClass = "status-failed";
                        statusMessage = "This booking has failed processing. Please contact support.";
                    }
                %>
                <div class="col-md-6 mb-4">
                    <div class="card position-relative">
                        <!-- MODIFIED: Show payment method badge in top middle -->
                        <% if (payment != null) { %>
                        <span class="badge payment-badge badge-<%= isCashPayment ? "success" : "primary" %> payment-method-top">
                            <i class="fas <%= isCashPayment ? "fa-money-bill-wave" : "fa-credit-card" %> mr-1"></i>
                            <%= paymentMethod %>
                        </span>
                        <% } %>

                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span>Booking #<%= booking.getId() %></span>
                            <% if (booking.getStatus().equals(Booking.STATUS_CONFIRMED)) { %>
                            <span class="badge badge-success">Confirmed</span>
                            <% } else if (booking.getStatus().equals(Booking.STATUS_PENDING)) { %>
                            <span class="badge badge-warning">Processing</span>
                            <% } else if (booking.getStatus().equals(Booking.STATUS_CANCELLED)) { %>
                            <span class="badge badge-danger">Cancelled</span>
                            <% } else { %>
                            <span class="badge badge-secondary">Failed</span>
                            <% } %>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title"><%= event.getName() %></h5>
                            <p class="card-text">
                                <strong>Event Date:</strong> <%= new SimpleDateFormat("yyyy-MM-dd").format(event.getDate()) %><br>
                                <strong>Venue:</strong> <%= event.getVenue() %><br>
                                <strong>Tickets:</strong> <%= booking.getTicketQuantity() %><br>
                                <strong>Total Price:</strong> $<%= String.format("%.2f", booking.getTotalPrice()) %><br>
                                <strong>Booking Date:</strong> <%= dateFormat.format(booking.getBookingDate()) %>
                            </p>

                            <div class="status-message <%= statusClass %>">
                                <i class="fas <%= isCashPayment && booking.getStatus().equals(Booking.STATUS_CONFIRMED) ?
                                    "fa-exclamation-triangle" : "fa-info-circle" %> mr-1"></i>
                                <%= statusMessage %>

                                <!-- NEW: Show booking reference prominently for cash payments -->
                                <% if (isCashPayment && booking.getStatus().equals(Booking.STATUS_CONFIRMED)) { %>
                                <div class="booking-reference">
                                    <i class="fas fa-receipt mr-1"></i> Booking Reference: <%= booking.getId() %>
                                </div>
                                <% } %>
                            </div>

                            <div class="mt-3">
                                <% if (booking.getStatus().equals(Booking.STATUS_PENDING) ||
                                        booking.getStatus().equals(Booking.STATUS_CONFIRMED)) { %>
                                <form action="CancelBookingServlet" method="post" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                                    <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-times-circle mr-1"></i> Cancel Booking
                                    </button>
                                </form>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="alert alert-info">
                <i class="fas fa-info-circle mr-2"></i> You don't have any bookings yet.
            </div>
            <div class="mt-3">
                <a href="ViewEventsServlet" class="btn btn-primary">
                    <i class="fas fa-search mr-2"></i> Browse Events
                </a>
            </div>
            <% } %>
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