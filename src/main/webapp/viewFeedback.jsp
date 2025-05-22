<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/22/2025
  Time: 10:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="com.example.eventticketbookingsystem.model.Feedback" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Get the current user (if logged in)
  User user = (User) session.getAttribute("user");
  String currentUserId = (String) request.getAttribute("currentUserId");

  List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
  Double averageRating = (Double) request.getAttribute("averageRating");
  Map<Integer, Integer> feedbackCounts = (Map<Integer, Integer>) request.getAttribute("feedbackCounts");

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>User Feedback</title>
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
    .add-feedback-btn {
      position: fixed;
      bottom: 30px;
      right: 30px;
      z-index: 99;
      border-radius: 50%;
      width: 60px;
      height: 60px;
      font-size: 24px;
    }

    .floating-btn {
      position: fixed;
      right: 30px;
      bottom: 80px;
      z-index: 999;
      width: 50px;
      height: 50px;
      border-radius: 50%;
      font-size: 22px;
      display: flex;
      align-items: center;
      justify-content: center;
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
        <li class="nav-item active">
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
  <h2>User Feedback</h2>

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
            <%= String.format("%.1f", averageRating) %>
          </div>
          <div class="rating-emoji">
            <%
              int avgRatingInt = (int) Math.round(averageRating);
              String emojiOutput = "❓"; // Default emoji

              // Fixed: Using expression tag instead of out.print()
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
            <% for(int i = 5; i >= 1; i--) {
              int count = feedbackCounts.get(i);
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
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Feedback List -->
  <div class="card mt-4">
    <div class="card-header bg-info text-white">
      <h4><i class="fas fa-comments mr-2"></i>User Reviews</h4>
    </div>
    <div class="card-body">
      <% if (feedbacks != null && !feedbacks.isEmpty()) { %>
      <div class="row">
        <% for(Feedback feedback : feedbacks) {
          boolean isCurrentUserFeedback = currentUserId != null && currentUserId.equals(feedback.getUserId());
          String encodedDate = java.net.URLEncoder.encode(dateFormat.format(feedback.getCreatedDate()), "UTF-8");
        %>
        <div class="col-md-6">
          <div class="card feedback-card <%= feedback.getRatingClass() %>">
            <div class="card-header d-flex justify-content-between align-items-center">
              <div>
                <span class="feedback-emoji"><%= feedback.getRatingEmoji() %></span>
                <span class="font-weight-bold"><%= feedback.getUsername() %></span>
              </div>
              <div>
                <% if (isCurrentUserFeedback) { %>
                <a href="AddFeedbackServlet?userId=<%= feedback.getUserId() %>&createdDate=<%= encodedDate %>"
                   class="btn btn-sm btn-primary">
                  <i class="fas fa-edit"></i>
                </a>
                <a href="DeleteFeedbackServlet?userId=<%= feedback.getUserId() %>&createdDate=<%= encodedDate %>"
                   class="btn btn-sm btn-danger"
                   onclick="return confirm('Are you sure you want to delete your feedback?');">
                  <i class="fas fa-trash"></i>
                </a>
                <% } %>
              </div>
            </div>
            <div class="card-body">
              <% if (feedback.getComment() != null && !feedback.getComment().isEmpty()) { %>
              <p class="card-text"><%= feedback.getComment() %></p>
              <% } else { %>
              <p class="card-text text-muted"><em>No additional comments</em></p>
              <% } %>
            </div>
            <div class="card-footer text-muted text-right">
              <small>Posted: <%= dateFormat.format(feedback.getCreatedDate()) %></small>
              <% if (!feedback.getModifiedDate().equals(feedback.getCreatedDate())) { %>
              <br><small>Edited: <%= dateFormat.format(feedback.getModifiedDate()) %></small>
              <% } %>
            </div>
          </div>
        </div>
        <% } %>
      </div>
      <% } else { %>
      <div class="alert alert-info">
        <i class="fas fa-info-circle mr-2"></i>No feedback available yet. Be the first to provide feedback!
      </div>
      <% } %>
    </div>
  </div>
</div>

<% if (user != null) { %>
<!-- Floating Add Feedback Button -->
<a href="AddFeedbackServlet" class="btn btn-success add-feedback-btn floating-btn d-flex align-items-center justify-content-center">
  <i class="fas fa-plus"></i>
</a>
<% } %>

<!-- Updated Footer with Blue Line and Current Time/User -->
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
