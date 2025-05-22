<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.Event" %>
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
  Event event = (Event) request.getAttribute("event");

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
  <title>Cash Payment</title>
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
    .cash-payment-info {
      background-color: #e8f5e9;
      border: 1px solid #c8e6c9;
      border-radius: 8px;
      padding: 25px;
      margin-top: 15px;
      text-align: center;
    }
    .cash-icon {
      font-size: 64px;
      color: #28a745;
      margin-bottom: 15px;
    }
    .instruction-list {
      background-color: #fff8e1;
      border-radius: 8px;
      padding: 20px;
      margin-top: 20px;
    }
    .instruction-item {
      display: flex;
      margin-bottom: 15px;
      align-items: flex-start;
    }
    .instruction-number {
      background-color: #28a745;
      color: white;
      width: 30px;
      height: 30px;
      border-radius: 50%;
      display: flex;
      justify-content: center;
      align-items: center;
      margin-right: 15px;
      flex-shrink: 0;
    }
    .instruction-text {
      flex-grow: 1;
    }
    .booking-reference {
      background-color: #e8f5e9;
      border: 2px dashed #28a745;
      border-radius: 8px;
      padding: 15px;
      margin-top: 20px;
      text-align: center;
    }
    .reference-number {
      font-size: 24px;
      font-weight: bold;
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
        <div class="card-header bg-success text-white">
          <h4><i class="fas fa-money-bill-wave mr-2"></i>Cash Payment</h4>
        </div>

        <div class="card-body">
          <% if (request.getAttribute("error") != null) { %>
          <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
          </div>
          <% } %>

          <div class="cash-payment-info">
            <div class="cash-icon">
              <i class="fas fa-money-bill-wave"></i>
            </div>
            <h4>Pay at the Venue</h4>
            <p class="lead">You have selected to pay with cash at the event venue</p>
          </div>

          <div class="payment-details mt-4">
            <h5 class="mb-3">Booking Summary</h5>
            <div class="detail-row">
              <span class="label">Booking ID:</span>
              <span class="value" id="bookingId"><%= booking.getId() %></span>
            </div>
            <div class="detail-row">
              <span class="label">Event:</span>
              <span class="value"><%= event != null ? event.getName() : "Unknown Event" %></span>
            </div>
            <div class="detail-row">
              <span class="label">Tickets:</span>
              <span class="value" id="ticketCount"><%= booking.getTicketQuantity() %></span>
            </div>
            <div class="detail-row">
              <span class="label">Total Amount:</span>
              <span class="value" id="totalAmount">$<%= String.format("%.2f", booking.getTotalPrice()) %></span>
            </div>
          </div>

          <div class="instruction-list">
            <h5 class="mb-3"><i class="fas fa-info-circle mr-2"></i>Important Instructions</h5>

            <div class="instruction-item">
              <div class="instruction-number">1</div>
              <div class="instruction-text">
                <strong>Arrive Early</strong>
                <p>Please arrive at least 30 minutes before the event starts to make your payment.</p>
              </div>
            </div>

            <div class="instruction-item">
              <div class="instruction-number">2</div>
              <div class="instruction-text">
                <strong>Bring Your Booking Reference</strong>
                <p>You'll need to provide your booking reference number when making the payment.</p>
              </div>
            </div>

            <div class="instruction-item">
              <div class="instruction-number">3</div>
              <div class="instruction-text">
                <strong>Payment Method</strong>
                <p>Only cash payments are accepted at the venue. Please bring the exact amount if possible.</p>
              </div>
            </div>

            <div class="instruction-item">
              <div class="instruction-number">4</div>
              <div class="instruction-text">
                <strong>Reservation Period</strong>
                <p>Your booking will be held for 24 hours. If payment is not made within this timeframe, your reservation may be cancelled.</p>
              </div>
            </div>
          </div>

          <div class="booking-reference">
            <h5>Your Booking Reference</h5>
            <p>Please save this reference number and bring it with you to the venue.</p>
            <div class="reference-number"><%= booking.getId() %></div>
          </div>

          <form action="PaymentProcessServlet" method="post" class="mt-4">
            <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
            <input type="hidden" name="paymentMethod" value="CASH">

            <div class="form-group form-check">
              <input type="checkbox" class="form-check-input" id="termsCheck" name="termsCheck" required>
              <label class="form-check-label" for="termsCheck">
                I understand that I need to pay at the venue and my booking is only confirmed after payment.
              </label>
            </div>

            <div class="text-center mt-4">
              <button type="submit" class="btn btn-success">
                <i class="fas fa-check-circle mr-2"></i>Confirm Cash Payment
              </button>
              <a href="PaymentFormServlet?bookingId=<%= booking.getId() %>" class="btn btn-secondary ml-2">
                <i class="fas fa-arrow-left mr-2"></i>Back
              </a>
            </div>
          </form>
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