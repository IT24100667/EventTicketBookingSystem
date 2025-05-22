<%-- File: adminPayments.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Payment" %>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.example.eventticketbookingsystem.model.Admin" %>
<%
  // Check if admin is logged in
  if (session.getAttribute("user") == null || session.getAttribute("isAdmin") == null ||
          !(Boolean)session.getAttribute("isAdmin")) {
    response.sendRedirect("adminLogin.jsp");
    return;
  }
  Admin admin = (Admin) session.getAttribute("user");

  List<Payment> payments = (List<Payment>) request.getAttribute("payments");
  Map<String, Booking> bookingMap = (Map<String, Booking>) request.getAttribute("bookingMap");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Payments</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
  <style>
    .revenue-notice {
      background-color: #fff3cd;
      border-left: 4px solid #ffc107;
      padding: 10px 15px;
      margin-bottom: 15px;
    }
    .card-payment-revenue {
      border-left: 4px solid #28a745;
    }
    .cash-payment-row {
      background-color: #f9f9f9;
    }
    .cash-indicator {
      color: #dc3545;
      font-weight: bold;
      margin-left: 5px;
    }
    .navbar {
      padding: 0.75rem 1rem;
      background-color: #343a40 !important;
    }
    .navbar-brand {
      font-size: 1.4rem;
      font-weight: 600;
      margin-right: 2rem;
    }
    .navbar-dark .navbar-nav .nav-link {
      color: rgba(255, 255, 255, 0.8);
      padding: 0 15px;
    }
    .navbar-dark .navbar-nav .nav-link:hover {
      color: #fff;
    }
    .navbar-dark .navbar-nav .active>.nav-link {
      color: #fff;
      font-weight: 500;
    }
    .dropdown-menu {
      min-width: 240px;
      padding: 0;
    }
    .dropdown-item {
      padding: 0.75rem 1.5rem;
    }
    .dropdown-header {
      background-color: #f8f9fa;
      padding: 1rem 1.5rem;
      font-weight: 500;
      border-bottom: 1px solid #dee2e6;
    }
    .dropdown-divider {
      margin: 0;
    }
    .dropdown-item-text {
      padding: 1rem 1.5rem;
    }
    .dropdown-item .fas,
    .dropdown-item .far {
      margin-right: 10px;
      width: 16px;
      text-align: center;
    }
    .text-danger {
      color: #dc3545;
    }
    .navbar-nav.ml-auto {
      margin-left: auto !important;
    }
    .main-menu {
      margin-left: auto;
      margin-right: 1rem;
    }
    /* Footer styles - not fixed, at bottom of content */
    footer {
      background-color: #343a40;
      color: white;
      text-align: center;
      padding: 15px 0;
      margin-top: 20px;
      width: 100%;
    }
  </style>
</head>
<body>
<!-- Admin navbar -->
<div class="container-fluid px-0">
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
      <a class="navbar-brand" href="adminDashboard.jsp">Admin Panel</a>

      <!-- Navigation links on right side before user icon -->
      <div class="collapse navbar-collapse">
        <ul class="navbar-nav main-menu">
          <li class="nav-item">
            <a class="nav-link" href="adminDashboard.jsp">Dashboard</a>
          </li>
          <li class="nav-item ">
            <a class="nav-link" href="ManageUsersServlet">Users</a>
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
            <a class="nav-link" href="AdminViewFeedbacksServlet">Feedback</a>
          </li>
        </ul>

        <!-- Admin Profile Dropdown -->
        <ul class="navbar-nav">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <i class="fas fa-user-circle mr-1"></i> <%= admin.getUsername() %>
            </a>
            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
              <div class="dropdown-item-text dropdown-header">
                <strong>Signed in as</strong><br>
                <%= admin.getFullName() %>
              </div>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item" href="ViewAdminProfileServlet">
                <i class="fas fa-user"></i> Your Profile
              </a>
              <a class="dropdown-item" href="UpdateAdminServlet">
                <i class="fas fa-user-edit"></i> Edit Profile
              </a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item text-danger" href="#" data-toggle="modal" data-target="#deleteModal">
                <i class="fas fa-user-times"></i> Delete Account
              </a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item" href="LogoutServlet">
                <i class="fas fa-sign-out-alt"></i> Logout
              </a>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</div>
<!-- Added Feedback Link -->
<li class="nav-item">
  <a class="nav-link" href="AdminViewFeedbacksServlet">Feedback</a>
</li>
<li class="nav-item">
  <a class="nav-link" href="LogoutServlet">Logout</a>
</li>
</ul>
</nav>
</div>

<div class="container mt-4">
  <h2><i class="fas fa-credit-card mr-2"></i>Manage Payments</h2>

  <% if (request.getAttribute("message") != null) { %>
  <div class="alert alert-success">
    <i class="fas fa-check-circle mr-2"></i><%= request.getAttribute("message") %>
  </div>
  <% } %>

  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-danger">
    <i class="fas fa-exclamation-circle mr-2"></i><%= request.getAttribute("error") %>
  </div>
  <% } %>

  <!-- Payments Table -->
  <div class="card">
    <div class="card-header bg-primary text-white">
      <i class="fas fa-list mr-2"></i>Payment List
    </div>
    <div class="card-body">
      <% if (payments != null && !payments.isEmpty()) { %>
      <div class="table-responsive">
        <table class="table table-striped">
          <thead>
          <tr>
            <th>ID</th>
            <th>Booking ID</th>
            <th>Amount</th>
            <th>Method</th>
            <th>Payment Status</th>
            <th>Booking Status</th>
            <th>Date</th>
          </tr>
          </thead>
          <tbody>
          <% for (Payment payment : payments) {
            Booking booking = bookingMap != null ? bookingMap.get(payment.getBookingId()) : null;
            String bookingStatus = booking != null ? booking.getStatus() : "Unknown";
            boolean isCashPayment = "CASH".equals(payment.getPaymentMethod());
            boolean isBookingCancelled = booking != null && Booking.STATUS_CANCELLED.equals(bookingStatus);
          %>
          <tr class="<%= isCashPayment ? "cash-payment-row" : "" %>">
            <td><%= payment.getId() %></td>
            <td>
              <a href="ManageBookingsServlet?action=view&id=<%= payment.getBookingId() %>">
                <%= payment.getBookingId() %>
              </a>
            </td>
            <td>
              $<%= String.format("%.2f", payment.getAmount()) %>
              <% if (isCashPayment) { %>
              <i class="fas fa-exclamation-circle cash-indicator" title="Cash payment - not included in statistics"></i>
              <% } %>
            </td>
            <td>
              <% if (isCashPayment) { %>
              <span class="badge badge-success">CASH</span>
              <% } else { %>
              <span class="badge badge-primary">CARD</span>
              <% } %>
            </td>
            <td>
              <% if (isBookingCancelled) { %>
              <!-- Always show CANCELLED for cancelled bookings regardless of payment status -->
              <span class="badge badge-danger">Cancelled</span>
              <% } else if (payment.getStatus().equals(Payment.STATUS_COMPLETED)) { %>
              <span class="badge badge-success">Completed</span>
              <% } else if (payment.getStatus().equals(Payment.STATUS_WAITING_CONFIRMATION)) { %>
              <span class="badge badge-warning">Pending Confirmation</span>
              <% } else if (payment.getStatus().equals(Payment.STATUS_PENDING)) { %>
              <span class="badge badge-info">Processing</span>
              <% } else if (payment.getStatus().equals("CANCELLED")) { %>
              <span class="badge badge-danger">Cancelled</span>
              <% } else { %>
              <span class="badge badge-danger">Cancelled</span>
              <% } %>
            </td>
            <td>
              <% if (booking != null) { %>
              <% if (Booking.STATUS_CONFIRMED.equals(bookingStatus)) { %>
              <span class="badge badge-success">Confirmed</span>
              <% } else if (Booking.STATUS_PENDING.equals(bookingStatus)) { %>
              <span class="badge badge-warning">Pending</span>
              <% } else if (Booking.STATUS_CANCELLED.equals(bookingStatus)) { %>
              <span class="badge badge-danger">Cancelled</span>
              <% } else { %>
              <span class="badge badge-secondary"><%= bookingStatus %></span>
              <% } %>
              <% } else { %>
              <span class="badge badge-secondary">Unknown</span>
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
        <i class="fas fa-info-circle mr-2"></i>No payments found.
      </div>
      <% } %>
    </div>
  </div>

  <!-- Payment Statistics -->
  <div class="card mt-4">
    <div class="card-header bg-success text-white">
      <i class="fas fa-chart-pie mr-2"></i>Payment Statistics (Confirmed Bookings Only)
    </div>
    <div class="card-body">
      <!-- ADDED REVENUE NOTICE -->
      <div class="revenue-notice">
        <i class="fas fa-exclamation-triangle mr-2"></i>
        <strong>IMPORTANT:</strong> All statistics (counts, revenue, etc.) include CARD payments only. Cash payments are excluded from all calculations.
      </div>

      <div class="row">
        <div class="col-md-4 text-center">
          <div class="card bg-light mb-3 card-payment-revenue">
            <div class="card-body">
              <h3>
                <%
                  // FIXED: Count CARD payments only for confirmed bookings
                  int total = 0;
                  if (payments != null) {
                    for (Payment payment : payments) {
                      Booking booking = bookingMap != null ? bookingMap.get(payment.getBookingId()) : null;
                      if ("CARD".equals(payment.getPaymentMethod()) &&
                              booking != null && Booking.STATUS_CONFIRMED.equals(booking.getStatus())) {
                        total++;
                      }
                    }
                  }
                %>
                <%= total %>
              </h3>
              <p class="text-muted">Total Confirmed Payments (Card Only)</p>
            </div>
          </div>
        </div>
        <div class="col-md-4 text-center">
          <div class="card bg-light mb-3 card-payment-revenue">
            <div class="card-body">
              <h3>
                <%
                  // FIXED: Count CARD payments only for completed payments
                  int completed = 0;
                  if (payments != null) {
                    for (Payment payment : payments) {
                      Booking booking = bookingMap != null ? bookingMap.get(payment.getBookingId()) : null;
                      if ("CARD".equals(payment.getPaymentMethod()) &&
                              Payment.STATUS_COMPLETED.equals(payment.getStatus()) &&
                              booking != null && Booking.STATUS_CONFIRMED.equals(booking.getStatus())) {
                        completed++;
                      }
                    }
                  }
                %>
                <%= completed %>
              </h3>
              <p class="text-muted">Completed Payments (Card Only)</p>
            </div>
          </div>
        </div>
        <div class="col-md-4 text-center">
          <div class="card bg-light mb-3 card-payment-revenue">
            <div class="card-body">
              <h3>
                <%
                  // Calculate revenue from CARD PAYMENTS ONLY
                  double cardRevenue = 0;
                  if (payments != null) {
                    for (Payment payment : payments) {
                      Booking booking = bookingMap != null ? bookingMap.get(payment.getBookingId()) : null;
                      // Only add to revenue if it's a CARD payment
                      if ("CARD".equals(payment.getPaymentMethod()) &&
                              Payment.STATUS_COMPLETED.equals(payment.getStatus()) &&
                              booking != null && Booking.STATUS_CONFIRMED.equals(booking.getStatus())) {
                        cardRevenue += payment.getAmount();
                      }
                    }
                  }
                %>
                $<%= String.format("%.2f", cardRevenue) %>
              </h3>
              <p class="text-muted">Total Revenue (Card Payments Only)</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Pending Payments -->
  <div class="card mt-4">
    <div class="card-header bg-warning text-white">
      <i class="fas fa-clock mr-2"></i>Pending Payments
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-6 text-center">
          <div class="card bg-light mb-3 card-payment-revenue">
            <div class="card-body">
              <h3>
                <%
                  // FIXED: Count CARD payments only for pending payments
                  int pendingCount = 0;
                  if (payments != null) {
                    for (Payment payment : payments) {
                      Booking booking = bookingMap != null ? bookingMap.get(payment.getBookingId()) : null;
                      if ("CARD".equals(payment.getPaymentMethod()) &&
                              (Payment.STATUS_WAITING_CONFIRMATION.equals(payment.getStatus()) ||
                                      Payment.STATUS_PENDING.equals(payment.getStatus())) &&
                              booking != null && !Booking.STATUS_CANCELLED.equals(booking.getStatus())) {
                        pendingCount++;
                      }
                    }
                  }
                %>
                <%= pendingCount %>
              </h3>
              <p class="text-muted">Pending Payments Count (Card Only)</p>
            </div>
          </div>
        </div>
        <div class="col-md-6 text-center">
          <div class="card bg-light mb-3 card-payment-revenue">
            <div class="card-body">
              <h3>
                <%
                  // FIXED: Calculate pending amount for CARD payments only
                  double pendingAmount = 0;
                  if (payments != null) {
                    for (Payment payment : payments) {
                      Booking booking = bookingMap != null ? bookingMap.get(payment.getBookingId()) : null;
                      if ("CARD".equals(payment.getPaymentMethod()) &&
                              (Payment.STATUS_WAITING_CONFIRMATION.equals(payment.getStatus()) ||
                                      Payment.STATUS_PENDING.equals(payment.getStatus())) &&
                              booking != null && !Booking.STATUS_CANCELLED.equals(booking.getStatus())) {
                        pendingAmount += payment.getAmount();
                      }
                    }
                  }
                %>
                $<%= String.format("%.2f", pendingAmount) %>
              </h3>
              <p class="text-muted">Pending Amount (Card Only)</p>
            </div>
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
<script>
  // Auto-dismiss alerts after 5 seconds
  $(document).ready(function() {
    setTimeout(function() {
      $(".alert").fadeOut("slow");
    }, 5000);

    // Ensure that all payments for cancelled bookings show "Cancelled" status
    $("table tr").each(function() {
      var bookingStatusCell = $(this).find("td:nth-child(6)"); // Booking Status column
      var paymentStatusCell = $(this).find("td:nth-child(5)"); // Payment Status column

      if (bookingStatusCell.text().trim().includes("Cancelled")) {
        paymentStatusCell.html('<span class="badge badge-danger">Cancelled</span>');
      }
    });
  });
</script>
</body>
</html>