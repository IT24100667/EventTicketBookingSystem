<%-- File: paymentSuccess.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.Payment" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Check if user is logged in
  if (session.getAttribute("user") == null) {
    response.sendRedirect("userLogin.jsp");
    return;
  }

  User user = (User) session.getAttribute("user");
  Payment payment = (Payment) request.getAttribute("payment");
  Booking booking = (Booking) request.getAttribute("booking");

  if (payment == null || booking == null) {
    response.sendRedirect("ViewBookingsServlet");
    return;
  }

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Payment Success</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<nav class="navbar navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">Event Booking</a>
    <ul class="navbar-nav ml-auto">
      <li class="nav-item">
        <a class="nav-link" href="ViewEventsServlet">Events</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="ViewBookingsServlet">My Bookings</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="userDashboard.jsp">Dashboard</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="LogoutServlet">Logout</a>
      </li>
    </ul>
  </div>
</nav>

<div class="container mt-4">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card">
        <div class="card-header bg-success text-white">
          <h4 class="mb-0">Payment Successful!</h4>
        </div>
        <div class="card-body text-center">
          <div class="mb-4">
            <i class="fa fa-check-circle text-success" style="font-size: 72px;"></i>
          </div>

          <h5>Thank you for your payment!</h5>
          <p>Your booking has been confirmed.</p>

          <div class="card bg-light mb-4">
            <div class="card-body">
              <div class="row">
                <div class="col-md-6 text-left">
                  <p><strong>Payment ID:</strong> <%= payment.getId() %></p>
                  <p><strong>Booking ID:</strong> <%= booking.getId() %></p>
                  <p><strong>Amount Paid:</strong> $<%= String.format("%.2f", payment.getAmount()) %></p>
                </div>
                <div class="col-md-6 text-left">
                  <p><strong>Payment Method:</strong> <%= payment.getPaymentMethod() %></p>
                  <p><strong>Payment Date:</strong> <%= dateFormat.format(payment.getPaymentDate()) %></p>
                  <p><strong>Status:</strong> <%= payment.getStatus() %></p>
                </div>
              </div>
            </div>
          </div>

          <div class="mt-4">
            <a href="ViewBookingsServlet" class="btn btn-primary">View My Bookings</a>
            <a href="ViewEventsServlet" class="btn btn-secondary">Browse More Events</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<footer class="bg-dark text-white text-center py-3 mt-5">
  <p class="mb-0">Event Ticket Booking System &copy; 2025</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>