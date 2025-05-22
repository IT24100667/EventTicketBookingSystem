<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user") == null || session.getAttribute("isAdmin") == null ||
            !(Boolean)session.getAttribute("isAdmin")) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    Admin admin = (Admin) session.getAttribute("user");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    List<Event> events = (List<Event>) request.getAttribute("events");
    List<User> users = (List<User>) request.getAttribute("users");
    List<Booking> queuedBookings = (List<Booking>) request.getAttribute("queuedBookings");

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<!-- Admin navbar -->
<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="adminDashboard.jsp">Admin Panel</a>
        <ul class="navbar-nav ml-auto">
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
                <a class="nav-link" href="LogoutServlet">Logout</a>
            </li>
        </ul>
    </div>
</nav>

<div class="container mt-4">
    <h2>Manage Bookings</h2>

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

    <!-- Booking Queue -->
    <div class="card mb-4">
        <div class="card-header d-flex justify-content-between">
            <span>Booking Queue</span>
            <span class="badge badge-info"><%= queuedBookings != null ? queuedBookings.size() : 0 %> pending</span>
        </div>
        <div class="card-body">
            <% if (queuedBookings != null && !queuedBookings.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-sm">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Event</th>
                        <th>Tickets</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Booking booking : queuedBookings) { %>
                    <tr>
                        <td><%= booking.getId() %></td>
                        <td><%= booking.getUserId() %></td>
                        <td><%= booking.getEventId() %></td>
                        <td><%= booking.getTicketQuantity() %></td>
                        <td>
                            <form action="ManageBookingsServlet" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="prioritize">
                                <input type="hidden" name="id" value="<%= booking.getId() %>">
                                <button type="submit" class="btn btn-sm btn-warning">Prioritize</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <form action="ManageBookingsServlet" method="get">
                <input type="hidden" name="action" value="processQueue">
                <button type="submit" class="btn btn-primary">Process All Queue</button>
            </form>
            <% } else { %>
            <div class="alert alert-info">No bookings in the queue.</div>
            <% } %>
        </div>
    </div>

    <!-- Filter Form -->
    <div class="card mb-4">
        <div class="card-header">Filter Bookings</div>
        <div class="card-body">
            <form action="ManageBookingsServlet" method="get">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>By Status:</label>
                            <select name="status" class="form-control">
                                <option value="">All Statuses</option>
                                <option value="<%= Booking.STATUS_PENDING %>">Pending</option>
                                <option value="<%= Booking.STATUS_CONFIRMED %>">Confirmed</option>
                                <option value="<%= Booking.STATUS_FAILED %>">Failed</option>
                                <option value="<%= Booking.STATUS_CANCELLED %>">Cancelled</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>By Event:</label>
                            <select name="eventId" class="form-control">
                                <option value="">All Events</option>
                                <% if (events != null) {
                                    for (Event event : events) { %>
                                <option value="<%= event.getId() %>"><%= event.getName() %></option>
                                <% }
                                } %>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>By User:</label>
                            <select name="userId" class="form-control">
                                <option value="">All Users</option>
                                <% if (users != null) {
                                    for (User user : users) { %>
                                <option value="<%= user.getId() %>"><%= user.getUsername() %></option>
                                <% }
                                } %>
                            </select>
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Apply Filters</button>
            </form>
        </div>
    </div>

    <!-- Bookings Table -->
    <div class="card">
        <div class="card-header">Booking List</div>
        <div class="card-body">
            <% if (bookings != null && !bookings.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
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
                    <% for (Booking booking : bookings) { %>
                    <tr>
                        <td><%= booking.getId() %></td>
                        <td><%= booking.getEventId() %></td>
                        <td><%= booking.getUserId() %></td>
                        <td><%= booking.getTicketQuantity() %></td>
                        <td>$<%= String.format("%.2f", booking.getTotalPrice()) %></td>
                        <td>
                            <% if (booking.getStatus().equals(Booking.STATUS_CONFIRMED)) { %>
                            <span class="badge badge-success">Confirmed</span>
                            <% } else if (booking.getStatus().equals(Booking.STATUS_PENDING)) { %>
                            <span class="badge badge-warning">Pending</span>
                            <% } else if (booking.getStatus().equals(Booking.STATUS_CANCELLED)) { %>
                            <span class="badge badge-danger">Cancelled</span>
                            <% } else { %>
                            <span class="badge badge-secondary">Failed</span>
                            <% } %>
                        </td>
                        <td><%= dateFormat.format(booking.getBookingDate()) %></td>
                        <td>
                            <a href="ManageBookingsServlet?action=view&id=<%= booking.getId() %>"
                               class="btn btn-sm btn-info">View</a>

                            <a href="ManageBookingsServlet?action=edit&id=<%= booking.getId() %>"
                               class="btn btn-sm btn-primary">Edit</a>

                            <form action="ManageBookingsServlet" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="id" value="<%= booking.getId() %>">
                                <button type="submit" class="btn btn-sm btn-danger"
                                        onclick="return confirm('Are you sure you want to cancel this booking?');">
                                    Cancel
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-info">No bookings found.</div>
            <% } %>
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