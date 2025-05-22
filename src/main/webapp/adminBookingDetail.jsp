<%-- File: adminBookingDetail.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Check if admin is logged in
  if (session.getAttribute("user") == null || session.getAttribute("isAdmin") == null ||
          !(Boolean)session.getAttribute("isAdmin")) {
    response.sendRedirect("adminLogin.jsp");
    return;
  }

  Admin admin = (Admin) session.getAttribute("user");
  Booking booking = (Booking) request.getAttribute("booking");
  User user = (User) request.getAttribute("user");
  Event event = (Event) request.getAttribute("event");
  Boolean inQueue = (Boolean) request.getAttribute("inQueue");

  // Default to false if not set
  if (inQueue == null) {
    inQueue = false;
  }

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  SimpleDateFormat shortDateFormat = new SimpleDateFormat("yyyy-MM-dd");

  // Log the current date and admin
  String currentDateTime = "2025-05-16 20:48:36"; // In a real app, this would be dynamically generated
  String adminUsername = "IT24100725"; // In a real app, this would come from the admin object
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Booking Detail</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <style>
    .badge-large {
      font-size: 1rem;
      padding: 0.5rem 0.75rem;
    }
    .card-header-primary {
      background-color: #007bff;
      color: white;
    }
    .queue-status {
      background-color: #fff3cd;
      border: 1px solid #ffeeba;
      border-left: 4px solid #ffc107;
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 4px;
    }
    .booking-info-item {
      padding: 10px;
      border-bottom: 1px solid #eee;
    }
    .booking-info-item:last-child {
      border-bottom: none;
    }
    .booking-actions {
      background-color: #f8f9fa;
      padding: 20px;
      border-radius: 4px;
      margin-top: 20px;
    }
    .admin-info {
      font-size: 0.8rem;
      color: #6c757d;
      margin-top: 20px;
      border-top: 1px solid #dee2e6;
      padding-top: 10px;
    }
  </style>
</head>
<body>
<!-- Admin navbar -->
<div class="container mt-4">
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 rounded">

    <a class="navbar-brand" href="adminDashboard.jsp">Admin Panel</a>

    <ul class="navbar-nav ml-auto">

      <li class="nav-item ">
        <a class="nav-link" href="adminDashboard.jsp">Dashboard</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="ManageUsersServlet">Users</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="ManageEventsServlet">Events</a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="ManageBookingsServlet">Bookings</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="ManagePaymentsServlet">Payments</a>
      </li>
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
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Booking Details</h2>
    <a href="ManageBookingsServlet" class="btn btn-secondary">
      <i class="fas fa-arrow-left mr-1"></i> Back to Bookings
    </a>
  </div>

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

  <% if (booking != null) { %>

  <!-- Booking Status -->
  <div class="row mb-4">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header card-header-primary">
          <h4 class="mb-0">Booking #<%= booking.getId() %></h4>
        </div>
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h5>Status:</h5>
            <div>
              <% if (booking.getStatus().equals(Booking.STATUS_CONFIRMED)) { %>
              <span class="badge badge-success badge-large">Confirmed</span>
              <% } else if (booking.getStatus().equals(Booking.STATUS_PENDING)) { %>
              <span class="badge badge-warning badge-large">Pending</span>
              <% if (inQueue) { %>
              <span class="badge badge-info badge-large ml-2">In Processing Queue</span>
              <% } %>
              <% } else if (booking.getStatus().equals(Booking.STATUS_CANCELLED)) { %>
              <span class="badge badge-danger badge-large">Cancelled</span>
              <% } else { %>
              <span class="badge badge-secondary badge-large">Failed</span>
              <% } %>
            </div>
          </div>

          <% if (inQueue && booking.getStatus().equals(Booking.STATUS_PENDING)) { %>
          <!-- Queue Status Info -->
          <div class="queue-status">
            <h5><i class="fas fa-info-circle mr-2"></i>Queue Information</h5>
            <p>This booking is currently in the processing queue awaiting confirmation.</p>
            <div class="d-flex mt-3">
              <form action="ManageBookingsServlet" method="post" class="mr-2">
                <input type="hidden" name="action" value="prioritize">
                <input type="hidden" name="id" value="<%= booking.getId() %>">
                <button type="submit" class="btn btn-warning">
                  <i class="fas fa-arrow-up mr-1"></i> Move to Front of Queue
                </button>
              </form>

              <form action="ManageBookingsServlet" method="get">
                <input type="hidden" name="action" value="confirmBooking">
                <input type="hidden" name="id" value="<%= booking.getId() %>">
                <button type="submit" class="btn btn-success">
                  <i class="fas fa-check-circle mr-1"></i> Confirm Booking Now
                </button>
              </form>
            </div>
          </div>
          <% } %>

          <!-- Booking Date -->
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-3 font-weight-bold">Booking Date:</div>
              <div class="col-md-9"><%= dateFormat.format(booking.getBookingDate()) %></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Booking Details -->
  <div class="row">
    <!-- Event Information -->
    <div class="col-md-6 mb-4">
      <div class="card h-100">
        <div class="card-header bg-info text-white">
          <h5 class="mb-0">Event Information</h5>
        </div>
        <div class="card-body">
          <% if (event != null) { %>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Event Name:</div>
              <div class="col-md-8"><%= event.getName() %></div>
            </div>
          </div>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Event Date:</div>
              <div class="col-md-8"><%= shortDateFormat.format(event.getDate()) %></div>
            </div>
          </div>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Venue:</div>
              <div class="col-md-8"><%= event.getVenue() %></div>
            </div>
          </div>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Available Seats:</div>
              <div class="col-md-8"><%= event.getAvailableSeats() %></div>
            </div>
          </div>
          <% } else { %>
          <div class="alert alert-warning">Event information not available</div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- User Information -->
    <div class="col-md-6 mb-4">
      <div class="card h-100">
        <div class="card-header bg-primary text-white">
          <h5 class="mb-0">Customer Information</h5>
        </div>
        <div class="card-body">
          <% if (user != null) { %>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Username:</div>
              <div class="col-md-8"><%= user.getUsername() %></div>
            </div>
          </div>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Email:</div>
              <div class="col-md-8"><%= user.getEmail() %></div>
            </div>
          </div>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Name:</div>
              <div class="col-md-8"><%= user.getFullName() %></div>
            </div>
          </div>
          <div class="booking-info-item">
            <div class="row">
              <div class="col-md-4 font-weight-bold">Phone:</div>
              <div class="col-md-8"><%= user.getPhoneNumber() %></div>
            </div>
          </div>
          <% } else { %>
          <div class="alert alert-warning">User information not available</div>
          <% } %>
        </div>
      </div>
    </div>
  </div>

  <!-- Ticket Information -->
  <div class="row mb-4">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header bg-success text-white">
          <h5 class="mb-0">Ticket Information</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <div class="booking-info-item">
                <div class="row">
                  <div class="col-md-4 font-weight-bold">Ticket Quantity:</div>
                  <div class="col-md-8"><%= booking.getTicketQuantity() %></div>
                </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="booking-info-item">
                <div class="row">
                  <div class="col-md-4 font-weight-bold">Total Price:</div>
                  <div class="col-md-8">$<%= String.format("%.2f", booking.getTotalPrice()) %></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Booking Actions -->
  <div class="booking-actions">
    <h4 class="mb-3">Actions</h4>
    <div class="d-flex flex-wrap">
      <a href="ManageBookingsServlet?action=edit&id=<%= booking.getId() %>" class="btn btn-primary mr-2 mb-2">
        <i class="fas fa-edit mr-1"></i> Edit Booking
      </a>

      <% if (booking.getStatus().equals(Booking.STATUS_PENDING)) { %>
      <form action="ManageBookingsServlet" method="get" class="mr-2 mb-2">
        <input type="hidden" name="action" value="confirmBooking">
        <input type="hidden" name="id" value="<%= booking.getId() %>">
        <button type="submit" class="btn btn-success">
          <i class="fas fa-check-circle mr-1"></i> Confirm Booking
        </button>
      </form>
      <% } %>

      <% if (inQueue) { %>
      <form action="ManageBookingsServlet" method="post" class="mr-2 mb-2">
        <input type="hidden" name="action" value="prioritize">
        <input type="hidden" name="id" value="<%= booking.getId() %>">
        <button type="submit" class="btn btn-warning">
          <i class="fas fa-arrow-up mr-1"></i> Prioritize in Queue
        </button>
      </form>
      <% } %>

      <% if (booking.canBeCancelled()) { %>
      <form action="ManageBookingsServlet" method="post" class="mb-2" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
        <input type="hidden" name="action" value="cancel">
        <input type="hidden" name="id" value="<%= booking.getId() %>">
        <button type="submit" class="btn btn-danger">
          <i class="fas fa-times mr-1"></i> Cancel Booking
        </button>
      </form>
      <% } %>
    </div>
  </div>

  <div class="admin-info">
    <p><small>Viewed by: <%= adminUsername %> | Date: <%= currentDateTime %></small></p>
  </div>

  <% } else { %>
  <div class="alert alert-danger">
    Booking not found. It may have been deleted or the ID is invalid.
  </div>
  <% } %>
</div>

<footer class="bg-dark text-white text-center py-3 mt-5">
  <p class="mb-0">Event Ticket Booking System &copy; 2025</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js"></script>
</body>
</html>