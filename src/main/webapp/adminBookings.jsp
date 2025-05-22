<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.Event" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.example.eventticketbookingsystem.model.Admin" %>

<%
  // Get attributes from request
  List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
  List<Event> events = (List<Event>) request.getAttribute("events");
  List<User> users = (List<User>) request.getAttribute("users");
  List<Booking> queuedBookings = (List<Booking>) request.getAttribute("queuedBookings");
  String message = (String) request.getAttribute("message");
  String error = (String) request.getAttribute("error");


  Admin admin = (Admin) session.getAttribute("user");



  // Date formatter for display
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Admin Booking</title>

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">

  <style>
    html {
      height: 100%;
    }

    body {
      min-height: 100%;
      display: flex;
      flex-direction: column;
      background-color: #f8f9fa;
      padding-top: 20px;
    }

    .content-wrapper {
      flex: 1;
    }

    .bd-placeholder-img {
      font-size: 1.125rem;
      text-anchor: middle;
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      user-select: none;
    }

    @media (min-width: 768px) {
      .bd-placeholder-img-lg {
        font-size: 3.5rem;
      }
    }

    /* Custom styles */
    .sidebar {
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      z-index: 100;
      padding: 48px 0 0;
      box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
    }

    .sidebar-sticky {
      position: relative;
      top: 0;
      height: calc(100vh - 48px);
      padding-top: .5rem;
      overflow-x: hidden;
      overflow-y: auto;
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

    .card {
      margin-bottom: 1.5rem;
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

<div class="content-wrapper">
  <div class="container mt-4">

    <!-- Main Content -->

    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
      <h1 class="h2"><i class="fas fa-ticket-alt mr-2"></i>Admin Booking</h1>

    </div>

    <!-- Alert Messages -->
    <% if (message != null && !message.isEmpty()) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="fas fa-check-circle mr-2"></i><%= message %>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <% } %>

    <% if (error != null && !error.isEmpty()) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="fas fa-exclamation-circle mr-2"></i><%= error %>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <% } %>

    <!-- Booking Processing Queue -->
    <div class="card">
      <div class="card-header bg-warning text-white">
        <div class="d-flex justify-content-between align-items-center">
          <h5 class="mb-0"><i class="fas fa-clock mr-2"></i>Booking Processing Queue</h5>
          <div>
            <form action="ManageBookingsServlet" method="post" style="display: inline;">
              <input type="hidden" name="action" value="processAll">
              <button type="submit" class="btn btn-sm btn-primary">
                <i class="fas fa-play mr-1"></i>Process All
              </button>
            </form>
          </div>
        </div>
      </div>
      <div class="card-body">
        <% if (queuedBookings != null && !queuedBookings.isEmpty()) { %>
        <div class="table-responsive">
          <table class="table table-bordered table-hover">
            <thead class="thead-light">
            <tr>
              <th>ID</th>
              <th>Event</th>
              <th>User</th>
              <th>Tickets</th>
              <th>Total</th>
              <th>Date</th>
              <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% for (Booking booking : queuedBookings) {
              String eventName = "Unknown Event";
              String userName = "Unknown User";

              // Get event and user info if available
              for (Event e : events) {
                if (e.getId().equals(booking.getEventId())) {
                  eventName = e.getName();
                  break;
                }
              }

              for (User u : users) {
                if (u.getId().equals(booking.getUserId())) {
                  userName = u.getUsername();
                  break;
                }
              }
            %>
            <tr>
              <td><%= booking.getId() %></td>
              <td><%= eventName %></td>
              <td><%= userName %></td>
              <td><%= booking.getTicketQuantity() %></td>
              <td>$<%= String.format("%.2f", booking.getTotalPrice()) %></td>
              <td><%= dateFormat.format(booking.getBookingDate()) %></td>
              <td>
                <div class="btn-group">
                  <form action="ManageBookingsServlet" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="confirm">
                    <input type="hidden" name="id" value="<%= booking.getId() %>">
                    <button type="submit" class="btn btn-sm btn-success mr-1">
                      <i class="fas fa-check"></i>
                    </button>
                  </form>

                  <form action="ManageBookingsServlet" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="prioritize">
                    <input type="hidden" name="id" value="<%= booking.getId() %>">
                    <button type="submit" class="btn btn-sm btn-info mr-1">
                      <i class="fas fa-arrow-up"></i>
                    </button>
                  </form>

                  <form action="ManageBookingsServlet" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="id" value="<%= booking.getId() %>">
                    <button type="submit" class="btn btn-sm btn-danger"
                            onclick="return confirm('Are you sure you want to cancel this booking?');">
                      Cancel
                    </button>
                  </form>
                </div>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
        <% } else { %>
        <div class="alert alert-info">
          <i class="fas fa-info-circle mr-2"></i>No bookings in the processing queue.
        </div>
        <% } %>
      </div>
    </div>

    <!-- Confirmed Bookings List -->
    <div class="card">
      <div class="card-header bg-success text-white">
        <h5 class="mb-0"><i class="fas fa-list mr-2"></i>Confirmed Bookings List</h5>
      </div>
      <div class="card-body">
        <%
          // Filter the bookings to show only confirmed ones
          List<Booking> confirmedBookings = new ArrayList<>();
          if (bookings != null) {
            for (Booking b : bookings) {
              if (Booking.STATUS_CONFIRMED.equals(b.getStatus())) {
                confirmedBookings.add(b);
              }
            }
          }

          if (confirmedBookings != null && !confirmedBookings.isEmpty()) {
        %>
        <div class="table-responsive">
          <table class="table table-striped table-hover">
            <thead class="thead-dark">
            <tr>
              <th>ID</th>
              <th>Event</th>
              <th>User</th>
              <th>Tickets</th>
              <th>Total</th>
              <th>Status</th>
              <th>Date</th>
              <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% for (Booking booking : confirmedBookings) {
              String eventName = "Unknown Event";
              String userName = "Unknown User";

              // Get event and user info if available
              for (Event e : events) {
                if (e.getId().equals(booking.getEventId())) {
                  eventName = e.getName();
                  break;
                }
              }

              for (User u : users) {
                if (u.getId().equals(booking.getUserId())) {
                  userName = u.getUsername();
                  break;
                }
              }
            %>
            <tr>
              <td><%= booking.getId() %></td>
              <td><%= eventName %></td>
              <td><%= userName %></td>
              <td><%= booking.getTicketQuantity() %></td>
              <td>$<%= String.format("%.2f", booking.getTotalPrice()) %></td>
              <td>
                <span class="badge badge-success">Confirmed</span>
              </td>
              <td><%= dateFormat.format(booking.getBookingDate()) %></td>
              <td>
                <div class="btn-group">
                  <form action="ManageBookingsServlet" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="id" value="<%= booking.getId() %>">
                    <button type="submit" class="btn btn-sm btn-danger"
                            onclick="return confirm('Are you sure you want to cancel this booking?');">
                      Cancel Booking
                    </button>
                  </form>
                </div>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
        <% } else { %>
        <div class="alert alert-info">
          <i class="fas fa-info-circle mr-2"></i>No confirmed bookings found. Process the queue to confirm bookings.
        </div>
        <% } %>
      </div>
    </div>
  </div>
</div>

<!-- Footer with updated timestamp and user login -->
<footer>
  <div class="container">
    <p class="mb-0">Event Ticket Booking System &copy; 2025 </p>
  </div>
</footer>

<!-- Bootstrap core JavaScript -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
  // Auto-dismiss alerts after 5 seconds
  $(document).ready(function() {
    setTimeout(function() {
      $(".alert").alert('close');
    }, 5000);
  });
</script>
</body>
</html>