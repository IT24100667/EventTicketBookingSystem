<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.Payment" %>
<%@ page import="com.example.eventticketbookingsystem.model.Event" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
  // Get attributes from request
  Booking booking = (Booking) request.getAttribute("booking");
  Payment payment = (Payment) request.getAttribute("payment");
  Event event = (Event) request.getAttribute("event");
  User user = (User) session.getAttribute("user");
  String message = (String) request.getAttribute("message");
  Boolean inQueue = (Boolean) request.getAttribute("inQueue");
  String bookingId = (String) request.getAttribute("bookingId");

  if (inQueue == null) {
    inQueue = false;
  }

  // Date formatter for display
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
  <title>Payment Confirmation</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
  <link rel="stylesheet" href="css/style.css">
  <style>
    .confirmation-header {
      text-align: center;
      margin-bottom: 30px;
      padding-top: 20px;
    }
    .confirmation-icon {
      color: #ffc107;
      font-size: 64px;
      margin-bottom: 20px;
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
      flex: 1 0;
    }
    .email-notification {
      background-color: #e8f4fd;
      border-left: 4px solid #17a2b8;
      padding: 15px;
      margin-bottom: 30px;
      border-radius: 4px;
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
<!-- Navigation bar removed as requested -->

<div class="container mt-5">
  <div class="row">
    <div class="col-md-8 offset-md-2">
      <div class="card shadow">
        <div class="card-header bg-primary text-white">
          <h4 class="mb-0 text-center"><i class="fas fa-receipt mr-2"></i>Payment Processing</h4>
        </div>

        <div class="card-body">
          <div class="confirmation-header">
            <div class="confirmation-icon">
              <i class="fas fa-hourglass-half"></i>
            </div>
            <h3>Payment Received - Awaiting Confirmation</h3>
          </div>

          <!-- Updated message about pending admin approval -->
          <div class="email-notification">
            <h5 class="mb-2"><i class="fas fa-envelope mr-2"></i>Booking Information Sent</h5>
            <p class="mb-0">Your payment has been received and is pending admin approval. A confirmation email with the booking details has been sent to your registered email address. Once an administrator approves your booking, your tickets will be confirmed.</p>
          </div>

          <% if (booking != null) { %>
          <h5 class="mt-4">Booking Details</h5>
          <table class="table table-bordered">
            <tr>
              <th>Booking Reference</th>
              <td><%= booking.getId() %></td>
            </tr>
            <tr>
              <th>Event</th>
              <td><%= event != null ? event.getName() : "Unknown Event" %></td>
            </tr>
            <tr>
              <th>Number of Tickets</th>
              <td><%= booking.getTicketQuantity() %></td>
            </tr>
            <tr>
              <th>Total Amount</th>
              <td>$<%= String.format("%.2f", booking.getTotalPrice()) %></td>
            </tr>
            <tr>
              <th>Booking Date</th>
              <td><%= dateFormat.format(booking.getBookingDate()) %></td>
            </tr>
            <tr>
              <th>Status</th>
              <td>
                <% if (Booking.STATUS_CONFIRMED.equals(booking.getStatus())) { %>
                <span class="badge badge-success">Confirmed</span>
                <% } else if (Booking.STATUS_PENDING.equals(booking.getStatus())) { %>
                <span class="badge badge-warning">Pending Admin Approval</span>
                <% } else if (Booking.STATUS_CANCELLED.equals(booking.getStatus())) { %>
                <span class="badge badge-danger">Cancelled</span>
                <% } else { %>
                <span class="badge badge-secondary"><%= booking.getStatus() %></span>
                <% } %>
              </td>
            </tr>
          </table>
          <% } %>

          <% if (payment != null) { %>
          <h5 class="mt-4">Payment Details</h5>
          <table class="table table-bordered">
            <tr>
              <th>Payment Reference</th>
              <td><%= payment.getId() %></td>
            </tr>
            <tr>
              <th>Payment Method</th>
              <td><%= payment.getPaymentMethod() %></td>
            </tr>
            <tr>
              <th>Amount</th>
              <td>$<%= String.format("%.2f", payment.getAmount()) %></td>
            </tr>
            <tr>
              <th>Payment Date</th>
              <td><%= dateFormat.format(payment.getPaymentDate()) %></td>
            </tr>
            <tr>
              <th>Status</th>
              <td>
                <% if (Payment.STATUS_COMPLETED.equals(payment.getStatus())) { %>
                <span class="badge badge-success">Completed</span>
                <% } else if (Payment.STATUS_WAITING_CONFIRMATION.equals(payment.getStatus())) { %>
                <span class="badge badge-warning">Pending Admin Approval</span>
                <% } else if (Payment.STATUS_PENDING.equals(payment.getStatus())) { %>
                <span class="badge badge-info">Processing</span>
                <% } else { %>
                <span class="badge badge-danger">Failed</span>
                <% } %>
              </td>
            </tr>
          </table>
          <% } %>

          <div class="text-center mt-4">
            <a href="ViewBookingsServlet" class="btn btn-primary">
              <i class="fas fa-list mr-2"></i>View My Bookings
            </a>
            <a href="userDashboard.jsp" class="btn btn-secondary ml-2">
              <i class="fas fa-home mr-2"></i>Return to Dashboard
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Updated Footer with timestamp and user login -->
<footer>
  <div class="container">
    <p class="mb-0">Event Ticket Booking System &copy; 2025 | Current Date and Time (UTC - YYYY-MM-DD HH:MM:SS formatted): 2025-05-21 18:38:03 | Current User's Login: IT24100725</p>
  </div>
</footer>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>