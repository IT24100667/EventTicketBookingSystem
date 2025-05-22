<%-- File: bookingConfirmation.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="com.example.eventticketbookingsystem.model.Event" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    User user = (User) session.getAttribute("user");
    String bookingId = (String) request.getAttribute("bookingId");
    Event event = (Event) request.getAttribute("event");
    Integer ticketQuantity = (Integer) request.getAttribute("ticketQuantity");
    Double totalPrice = (Double) request.getAttribute("totalPrice");
    String errorMessage = (String) request.getAttribute("error");

    // Default values if not set
    if (ticketQuantity == null) ticketQuantity = 0;
    if (totalPrice == null) totalPrice = 0.0;

    // Format date
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmation</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <i class="fas fa-ticket-alt mr-2"></i>Event Booking
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="EventListServlet">Events</a>
                </li>
                <% if (user != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="ViewBookingsServlet">My Bookings</a>
                </li>
                <% } %>
            </ul>
            <ul class="navbar-nav ml-auto">
                <% if (user != null) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-user mr-2"></i><%= user.getUsername() %>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="ViewBookingsServlet">My Bookings</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="LogoutServlet">Logout</a>
                    </div>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link" href="userLogin.jsp">Login</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="userRegister.jsp">Register</a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4><i class="fas fa-shopping-cart mr-2"></i>Booking Summary</h4>
                </div>

                <div class="card-body">
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle mr-2"></i><%= errorMessage %>
                    </div>
                    <% } %>

                    <% if (event != null) { %>
                    <h5 class="card-title">Event Details</h5>
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <img src="<%= event.getImageUrl() != null ? event.getImageUrl() : "images/default-event.jpg" %>"
                                 class="img-fluid rounded" alt="<%= event.getName() %>">
                        </div>
                        <div class="col-md-8">
                            <h4><%= event.getName() %></h4>
                            <p><strong><i class="far fa-calendar-alt mr-2"></i>Date:</strong> <%= dateFormat.format(event.getEventDate()) %></p>
                            <p><strong><i class="fas fa-map-marker-alt mr-2"></i>Venue:</strong> <%= event.getVenue() %></p>
                            <p><strong><i class="fas fa-ticket-alt mr-2"></i>Ticket Price:</strong> $<%= String.format("%.2f", event.getTicketPrice()) %> each</p>
                        </div>
                    </div>

                    <h5 class="card-title">Booking Details</h5>
                    <table class="table table-bordered">
                        <tr>
                            <th>Number of Tickets</th>
                            <td><%= ticketQuantity %></td>
                        </tr>
                        <tr>
                            <th>Price per Ticket</th>
                            <td>$<%= String.format("%.2f", event.getTicketPrice()) %></td>
                        </tr>
                        <tr>
                            <th>Total Price</th>
                            <td class="h5 text-primary">$<%= String.format("%.2f", totalPrice) %></td>
                        </tr>
                    </table>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle mr-2"></i>Please review your booking details before proceeding to payment.
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <form action="BookingServlet" method="post">
                            <input type="hidden" name="action" value="cancelBooking">
                            <input type="hidden" name="eventId" value="<%= event.getId() %>">
                            <button type="submit" class="btn btn-secondary">
                                <i class="fas fa-times mr-2"></i>Cancel
                            </button>
                        </form>

                        <form action="BookingServlet" method="post">
                            <input type="hidden" name="action" value="proceedToPayment">
                            <input type="hidden" name="eventId" value="<%= event.getId() %>">
                            <input type="hidden" name="ticketQuantity" value="<%= ticketQuantity %>">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-credit-card mr-2"></i>Pay Now
                            </button>
                        </form>
                    </div>
                    <% } else if (bookingId != null) { %>
                    <!-- This is the original success confirmation section -->
                    <div class="text-center">
                        <div class="mb-4">
                                <span class="fa-stack fa-2x">
                                  <i class="fas fa-circle fa-stack-2x text-success"></i>
                                  <i class="fas fa-check fa-stack-1x fa-inverse"></i>
                                </span>
                        </div>

                        <h2>Thank You!</h2>
                        <p class="lead">Your booking has been recorded.</p>
                        <p>Booking ID: <strong><%= bookingId %></strong></p>

                        <% if (request.getAttribute("message") != null) { %>
                        <div class="alert alert-info">
                            <%= request.getAttribute("message") %>
                        </div>
                        <% } %>

                        <hr>

                        <div class="mt-4">
                            <a href="ViewBookingsServlet" class="btn btn-primary">View My Bookings</a>
                            <a href="EventListServlet" class="btn btn-secondary">Browse More Events</a>
                        </div>
                    </div>
                    <% } else { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle mr-2"></i>Event details not found. Please try again.
                    </div>
                    <a href="EventListServlet" class="btn btn-primary">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Events
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer mt-5 py-3 bg-dark text-white">
    <div class="container text-center">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> Event Ticket Booking System. All rights reserved.</p>
    </div>
</footer>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>