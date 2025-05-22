<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Feedback" %>
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

  List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
  Double averageRating = (Double) request.getAttribute("averageRating");
  Map<Integer, Integer> feedbackCounts = (Map<Integer, Integer>) request.getAttribute("feedbackCounts");

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Feedback</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
  <style>
    .feedback-card {
      margin-bottom: 20px;
      border-radius: 10px;
      overflow: hidden;
      transition: transform 0.3s;
    }
    .feedback-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }
    .feedback-emoji {
      font-size: 32px;
      margin-right: 10px;
    }
    .rating-excellent {
      background-color: #c8e6c9;
    }
    .rating-good {
      background-color: #dcedc8;
    }
    .rating-average {
      background-color: #fff9c4;
    }
    .rating-poor {
      background-color: #ffccbc;
    }
    .rating-terrible {
      background-color: #ffcdd2;
    }
    .progress {
      height: 12px;
      margin-bottom: 10px;
    }
    .progress-bar-5 {
      background-color: #4caf50;
    }
    .progress-bar-4 {
      background-color: #8bc34a;
    }
    .progress-bar-3 {
      background-color: #ffc107;
    }
    .progress-bar-2 {
      background-color: #ff9800;
    }
    .progress-bar-1 {
      background-color: #f44336;
    }
    .average-rating {
      font-size: 72px;
      font-weight: bold;
      color: #2196f3;
    }
    .rating-count {
      font-size: 14px;
      color: #757575;
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
          <li class="nav-item">
            <a class="nav-link" href="ManagePaymentsServlet">Payments</a>
          </li>
          <li class="nav-item active">
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

<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2><i class="fas fa-comments mr-2"></i>Manage User Feedback</h2>
  </div>

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

  <!-- Feedback Summary -->
  <div class="card mt-4">
    <div class="card-header bg-primary text-white">
      <h4><i class="fas fa-chart-bar mr-2"></i>Feedback Summary</h4>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-4 text-center">
          <div class="average-rating">
            <%= averageRating != null ? String.format("%.1f", averageRating) : "0.0" %>
          </div>
          <div class="rating-emoji">
            <%
              int avgRatingInt = averageRating != null ? (int) Math.round(averageRating) : 0;
              String emojiOutput = "❓"; // Default emoji

              switch(avgRatingInt) {
                case 5: emojiOutput = "😁"; break;
                case 4: emojiOutput = "🙂"; break;
                case 3: emojiOutput = "😐"; break;
                case 2: emojiOutput = "🙁"; break;
                case 1: emojiOutput = "😞"; break;
              }
            %>
            <%= emojiOutput %>
          </div>
          <p class="rating-count">Based on <%= feedbacks != null ? feedbacks.size() : 0 %> ratings</p>
        </div>
        <div class="col-md-8">
          <!-- Rating Distribution -->
          <div class="rating-distribution">
            <% if (feedbackCounts != null) { %>
            <% for(int i = 5; i >= 1; i--) {
              int count = feedbackCounts.containsKey(i) ? feedbackCounts.get(i) : 0;
              int total = feedbacks != null ? feedbacks.size() : 0;
              int percentage = total > 0 ? (count * 100) / total : 0;
            %>
            <div class="d-flex align-items-center mb-2">
              <div style="width: 45px;"><%= i %> <i class="fas fa-star text-warning"></i></div>
              <div class="flex-grow-1 mx-2">
                <div class="progress">
                  <div class="progress-bar progress-bar-<%= i %>" role="progressbar" style="width: <%= percentage %>%"></div>
                </div>
              </div>
              <div style="width: 45px;"><%= count %></div>
            </div>
            <% } %>
            <% } else { %>
            <div class="alert alert-info">No rating data available</div>
            <% } %>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Feedback List -->
  <div class="card mt-4">
    <div class="card-header bg-info text-white">
      <h4><i class="fas fa-list mr-2"></i>All Feedback</h4>
    </div>
    <div class="card-body">
      <% if (feedbacks != null && !feedbacks.isEmpty()) { %>
      <div class="table-responsive">
        <table class="table table-striped">
          <thead>
          <tr>
            <th>User</th>
            <th>Rating</th>
            <th>Comment</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <% for(Feedback feedback : feedbacks) {
            String encodedDate = java.net.URLEncoder.encode(dateFormat.format(feedback.getCreatedDate()), "UTF-8");
          %>
          <tr>
            <td><%= feedback.getUsername() %></td>
            <td>
              <span class="feedback-emoji"><%= feedback.getRatingEmoji() %></span>
              <%= feedback.getRating() %>
            </td>
            <td>
              <% if (feedback.getComment() != null && !feedback.getComment().isEmpty()) { %>
              <%= feedback.getComment() %>
              <% } else { %>
              <em class="text-muted">No comment provided</em>
              <% } %>
            </td>
            <td><%= dateFormat.format(feedback.getCreatedDate()) %></td>
            <td>
              <a href="AdminDeleteFeedbackServlet?userId=<%= feedback.getUserId() %>&createdDate=<%= encodedDate %>"
                 class="btn btn-sm btn-danger"
                 onclick="return confirm('Are you sure you want to delete this feedback?');">
                <i class="fas fa-trash mr-1"></i> Delete
              </a>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
      <% } else { %>
      <div class="alert alert-info">
        <i class="fas fa-info-circle mr-2"></i>No feedback available yet.
      </div>
      <% } %>
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
      $('.alert').fadeOut('slow');
    }, 5000);
  });
</script>
</body>
</html>
