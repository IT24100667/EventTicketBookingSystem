<%-- File: adminEditBooking.jsp --%>
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

  Booking booking = (Booking) request.getAttribute("booking");
  User bookingUser = (User) request.getAttribute("user");
  Event event = (Event) request.getAttribute("event");

  if (booking == null || event == null) {
    response.sendRedirect("ManageBookingsServlet");
    return;
  }

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Booking</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<!-- Admin navbar -->
<nav class="navbar navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="adminDashboard.jsp">Admin Panel</a>
    <ul class="navbar-nav ml-auto">
      <li class="nav-item">
        <a class="nav-link" href="ManageBookingsServlet">Back to Bookings</a>
      </li>
    </ul>
  </div>
</nav>

<div class="container mt-4">
  <h2>Edit Booking</h2>

  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-danger">
    <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <div class="card">
    <div class="card-header">
      Editing Booking #<%= booking.getId() %>
    </div>
    <div class="card-body">
      <form action="ManageBookingsServlet" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<%= booking.getId() %>">

        <div class="row">
          <div class="col-md-6">
            <div class="form-group">
              <label>Event:</label>
              <input type="text" class="form-control" value="<%= event.getName() %>" readonly>
            </div>

            <div class="form-group">
              <label>User:</label>
              <input type="text" class="form-control" value="<%= bookingUser != null ? bookingUser.getUsername() : "Unknown" %>" readonly>
            </div>

            <div class="form-group">
              <label>Booking Date:</label>
              <input type="text" class="form-control" value="<%= dateFormat.format(booking.getBookingDate()) %>" readonly>
            </div>
          </div>

          <div class="col-md-6">
            <div class="form-group">
              <label>Status:</label>
              <select name="status" class="form-control">
                <option value="<%= Booking.STATUS_PENDING %>" <%= booking.getStatus().equals(Booking.STATUS_PENDING) ? "selected" : "" %>>Pending</option>
                <option value="<%= Booking.STATUS_CONFIRMED %>" <%= booking.getStatus().equals(Booking.STATUS_CONFIRMED) ? "selected" : "" %>>Confirmed</option>
                <option value="<%= Booking.STATUS_FAILED %>" <%= booking.getStatus().equals(Booking.STATUS_FAILED) ? "selected" : "" %>>Failed</option>
                <option value="<%= Booking.STATUS_CANCELLED %>" <%= booking.getStatus().equals(Booking.STATUS_CANCELLED) ? "selected" : "" %>>Cancelled</option>
              </select>
            </div>

            <div class="form-group">
              <label>Ticket Quantity:</label>
              <input type="number" name="ticketQuantity" class="form-control"
                     min="1" max="<%= event.getCapacity() %>"
                     value="<%= booking.getTicketQuantity() %>" required>
              <small class="form-text text-muted">
                Available seats: <%= event.getAvailableSeats() + booking.getTicketQuantity() %>
                (Current booking has <%= booking.getTicketQuantity() %> tickets)
              </small>
            </div>

            <div class="form-group">
              <label>Total Price:</label>
              <input type="text" class="form-control"
                     value="$<%= String.format("%.2f", booking.getTotalPrice()) %>" readonly>
              <small class="form-text text-muted">
                Price will be recalculated automatically based on ticket quantity
              </small>
            </div>
          </div>
        </div>

        <div class="form-group">
          <label>Notes:</label>
          <textarea class="form-control" rows="3" name="notes"></textarea>
        </div>

        <div class="text-center mt-4">
          <button type="submit" class="btn btn-primary mr-2">Update Booking</button>
          <a href="ManageBookingsServlet?action=view&id=<%= booking.getId() %>" class="btn btn-secondary">Cancel</a>
        </div>
      </form>
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