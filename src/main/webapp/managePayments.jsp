<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Payment" %>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Check if admin is logged in
  if (session.getAttribute("user") == null ||
          session.getAttribute("isAdmin") == null ||
          !(Boolean)session.getAttribute("isAdmin")) {
    response.sendRedirect("adminLogin.jsp");
    return;
  }

  // Safely get attributes with null checks
  List<Payment> payments = request.getAttribute("payments") != null ?
          (List<Payment>) request.getAttribute("payments") : new ArrayList<>();

  Map<String, Booking> bookings = request.getAttribute("bookings") != null ?
          (Map<String, Booking>) request.getAttribute("bookings") : new HashMap<>();

  Double totalRevenueObj = (Double) request.getAttribute("totalRevenue");
  double totalRevenue = totalRevenueObj != null ? totalRevenueObj.doubleValue() : 0.0;

  Integer totalCompletedPaymentsObj = (Integer) request.getAttribute("totalCompletedPayments");
  int totalCompletedPayments = totalCompletedPaymentsObj != null ? totalCompletedPaymentsObj.intValue() : 0;

  Integer totalRefundedPaymentsObj = (Integer) request.getAttribute("totalRefundedPayments");
  int totalRefundedPayments = totalRefundedPaymentsObj != null ? totalRefundedPaymentsObj.intValue() : 0;

  Integer totalPaymentsObj = (Integer) request.getAttribute("totalPayments");
  int totalPayments = totalPaymentsObj != null ? totalPaymentsObj.intValue() : 0;

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Payments</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="adminDashboard.jsp">Admin Panel</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item">
          <a class="nav-link" href="adminDashboard.jsp">Dashboard</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="ManageEventsServlet">Events</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="ManageBookingsServlet">Bookings</a>
        </li>
        <li class="nav-item active">
          <a class="nav-link" href="ManagePaymentsServlet">Payments</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="ManageUsersServlet">Users</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="LogoutServlet">Logout</a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <h2>Manage Payments</h2>

  <% if (request.getAttribute("message") != null) { %>
  <div class="alert alert-info mt-3">
    <%= request.getAttribute("message") %>
  </div>
  <% } %>

  <!-- Revenue Statistics Section -->
  <div class="row mt-4">
    <div class="col-md-3">
      <div class="card bg-success text-white">
        <div class="card-body">
          <h5 class="card-title">Total Revenue</h5>
          <h3>$<%= String.format("%.2f", totalRevenue) %></h3>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card bg-info text-white">
        <div class="card-body">
          <h5 class="card-title">Completed Payments</h5>
          <h3><%= totalCompletedPayments %></h3>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card bg-warning text-white">
        <div class="card-body">
          <h5 class="card-title">Refunded Payments</h5>
          <h3><%= totalRefundedPayments %></h3>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card bg-secondary text-white">
        <div class="card-body">
          <h5 class="card-title">Total Payments</h5>
          <h3><%= totalPayments %></h3>
        </div>
      </div>
    </div>
  </div>

  <!-- All Payments Section -->
  <div class="card mt-4">
    <div class="card-header bg-primary text-white">
      <h5>Payment Records</h5>
    </div>
    <div class="card-body">
      <% if (payments != null && !payments.isEmpty()) { %>
      <div class="table-responsive">
        <table class="table table-striped">
          <thead>
          <tr>
            <th>Payment ID</th>
            <th>Booking ID</th>
            <th>Amount</th>
            <th>Payment Method</th>
            <th>Transaction ID</th>
            <th>Date</th>
            <th>Status</th>
          </tr>
          </thead>
          <tbody>
          <% for (Payment payment : payments) {
            String statusClass = "";
            if ("COMPLETED".equals(payment.getStatus())) {
              statusClass = "badge-success";
            } else if ("REFUNDED".equals(payment.getStatus())) {
              statusClass = "badge-warning";
            } else {
              statusClass = "badge-danger";
            }

            Booking booking = bookings.get(payment.getBookingId());
          %>
          <tr>
            <td><small><%= payment.getId() %></small></td>
            <td>
              <a href="ManageBookingsServlet?bookingId=<%= payment.getBookingId() %>"
                 title="View booking details">
                <%= payment.getBookingId() %>
              </a>
            </td>
            <td>$<%= String.format("%.2f", payment.getAmount()) %></td>
            <td><%= payment.getPaymentMethod() %></td>
            <td><small><%= payment.getId() %></small></td>
            <td><%= dateFormat.format(payment.getPaymentDate()) %></td>
            <td><span class="badge <%= statusClass %>"><%= payment.getStatus() %></span></td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
      <% } else { %>
      <p>No payment records found.</p>
      <% } %>
    </div>
  </div>

  <!-- Payment Methods Analysis -->
  <div class="card mt-4">
    <div class="card-header bg-info text-white">
      <h5>Payment Methods Analysis</h5>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-6">
          <h5>Payment Methods Distribution</h5>
          <p>This chart would show the distribution of payment methods.</p>
          <!-- In a real application, you would include a chart here -->
          <div class="chart-placeholder bg-light p-5 text-center">
            <p>Payment Methods Chart Placeholder</p>
          </div>
        </div>
        <div class="col-md-6">
          <h5>Daily Revenue</h5>
          <p>This chart would show daily revenue over time.</p>
          <!-- In a real application, you would include a chart here -->
          <div class="chart-placeholder bg-light p-5 text-center">
            <p>Revenue Chart Placeholder</p>
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