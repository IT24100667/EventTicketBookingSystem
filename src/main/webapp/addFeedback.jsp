<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/22/2025
  Time: 10:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="com.example.eventticketbookingsystem.model.Feedback" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Check if user is logged in
  if (session.getAttribute("user") == null) {
    response.sendRedirect("userLogin.jsp");
    return;
  }

  User user = (User) session.getAttribute("user");
  Feedback feedbackToEdit = (Feedback) request.getAttribute("feedbackToEdit");
  List<Feedback> userFeedbacks = (List<Feedback>) request.getAttribute("userFeedbacks");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  boolean isEditing = (feedbackToEdit != null);
  String pageTitle = isEditing ? "Edit Feedback" : "Add Feedback";
  int currentRating = isEditing ? feedbackToEdit.getRating() : 0;
  String currentComment = isEditing ? feedbackToEdit.getComment() : "";
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><%= pageTitle %></title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
  <style>
    .rating-container {
      display: flex;
      flex-direction: row;
      justify-content: center;
      margin: 20px 0;
    }
    .rating-option {
      text-align: center;
      margin: 0 10px;
      cursor: pointer;
      transition: all 0.3s;
    }
    .rating-option:hover {
      transform: scale(1.2);
    }
    .rating-emoji {
      font-size: 48px;
      opacity: 0.5;
    }
    .rating-emoji.selected {
      opacity: 1;
    }
    .rating-label {
      display: block;
      margin-top: 5px;
      font-size: 14px;
    }
    .feedback-form {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .form-group label {
      font-weight: bold;
    }
    .user-feedbacks {
      margin-top: 30px;
    }
    footer {
      position: fixed;
      left: 0;
      bottom: 0;
      width: 100%;
      z-index: 100;
    }
  </style>
</head>
<body>
<!-- Basic Nav -->
<div class="container mt-4">
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 rounded">

    <a class="navbar-brand" href="index.jsp">Event Booking</a>

    <ul class="navbar-nav ml-auto">
      <% if (user != null) { %>
      <li class="nav-item">
        <a class="nav-link" href="userDashboard.jsp">Dashboard</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="ViewEventsServlet">Events</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="ViewBookingsServlet">My Bookings</a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="ViewFeedbacksServlet">Feedback</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="LogoutServlet">Logout</a>
      </li>
      <% } else { %>
      <li class="nav-item">
        <a class="nav-link" href="ViewEventsServlet">Events</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="userLogin.jsp">Login</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="userRegister.jsp">Register</a>
      </li>
      <% } %>
    </ul>
  </nav>
</div>

<div class="container mt-4">
  <div class="row">
    <div class="col-md-12">
      <h2 class="text-center"><%= pageTitle %></h2>

      <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle mr-2"></i><%= request.getAttribute("error") %>
      </div>
      <% } %>

      <div class="feedback-form bg-white mt-4">
        <p class="text-center lead">How would you rate your experience with our platform?</p>

        <form action="AddFeedbackServlet" method="post" id="feedbackForm">
          <!-- Hidden inputs -->
          <input type="hidden" id="rating" name="rating" value="<%= currentRating %>">
          <% if (isEditing) { %>
          <input type="hidden" name="feedbackUserId" value="<%= feedbackToEdit.getUserId() %>">
          <input type="hidden" name="feedbackCreatedDate" value="<%= dateFormat.format(feedbackToEdit.getCreatedDate()) %>">
          <% } %>

          <!-- Emoji Rating System -->
          <div class="rating-container">
            <div class="rating-option" onclick="selectRating(1)">
              <div class="rating-emoji <%= currentRating == 1 ? "selected" : "" %>" id="emoji-1">😞</div>
              <span class="rating-label">Terrible</span>
            </div>
            <div class="rating-option" onclick="selectRating(2)">
              <div class="rating-emoji <%= currentRating == 2 ? "selected" : "" %>" id="emoji-2">🙁</div>
              <span class="rating-label">Poor</span>
            </div>
            <div class="rating-option" onclick="selectRating(3)">
              <div class="rating-emoji <%= currentRating == 3 ? "selected" : "" %>" id="emoji-3">😐</div>
              <span class="rating-label">Average</span>
            </div>
            <div class="rating-option" onclick="selectRating(4)">
              <div class="rating-emoji <%= currentRating == 4 ? "selected" : "" %>" id="emoji-4">🙂</div>
              <span class="rating-label">Good</span>
            </div>
            <div class="rating-option" onclick="selectRating(5)">
              <div class="rating-emoji <%= currentRating == 5 ? "selected" : "" %>" id="emoji-5">😁</div>
              <span class="rating-label">Excellent</span>
            </div>
          </div>

          <!-- Comment Box -->
          <div class="form-group">
            <label for="comment">Additional Comments:</label>
            <textarea class="form-control" id="comment" name="comment" rows="5" placeholder="Please share your thoughts about our platform..."><%= currentComment %></textarea>
          </div>

          <div class="text-center">
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-paper-plane mr-2"></i><%= isEditing ? "Update Feedback" : "Submit Feedback" %>
            </button>
            <a href="ViewFeedbacksServlet" class="btn btn-secondary ml-2">
              <i class="fas fa-arrow-left mr-2"></i>Back to Feedbacks
            </a>
          </div>
        </form>
      </div>

      <!-- Display user's previous feedbacks -->
      <% if (userFeedbacks != null && !userFeedbacks.isEmpty() && !isEditing) { %>
      <div class="user-feedbacks">
        <h3 class="mt-5 mb-3">Your Previous Feedbacks</h3>
        <div class="row">
          <% for (Feedback feedback : userFeedbacks) {
            String encodedDate = java.net.URLEncoder.encode(dateFormat.format(feedback.getCreatedDate()), "UTF-8");
          %>
          <div class="col-md-6 mb-3">
            <div class="card">
              <div class="card-header d-flex justify-content-between align-items-center">
                <div>
                  <span class="feedback-emoji"><%= feedback.getRatingEmoji() %></span>
                  <span>Rating: <%= feedback.getRating() %>/5</span>
                </div>
                <div>
                  <a href="AddFeedbackServlet?userId=<%= feedback.getUserId() %>&createdDate=<%= encodedDate %>" class="btn btn-sm btn-primary">
                    <i class="fas fa-edit"></i>
                  </a>
                  <a href="DeleteFeedbackServlet?userId=<%= feedback.getUserId() %>&createdDate=<%= encodedDate %>"
                     class="btn btn-sm btn-danger"
                     onclick="return confirm('Are you sure you want to delete this feedback?');">
                    <i class="fas fa-trash"></i>
                  </a>
                </div>
              </div>
              <div class="card-body">
                <% if (feedback.getComment() != null && !feedback.getComment().isEmpty()) { %>
                <p class="card-text"><%= feedback.getComment() %></p>
                <% } else { %>
                <p class="card-text text-muted"><em>No additional comments</em></p>
                <% } %>
              </div>
            </div>
          </div>
          <% } %>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</div>

<footer class="bg-dark text-white text-center py-3 mt-5">
  <p class="mb-0">Event Ticket Booking System &copy; 2025 | Current Date: 2025-05-21 09:09:52 | User: IT24100725</p>
</footer>

<script>
  function selectRating(rating) {
    // Clear all selected states
    for (let i = 1; i <= 5; i++) {
      document.getElementById('emoji-' + i).classList.remove('selected');
    }

    // Set the selected rating
    document.getElementById('emoji-' + rating).classList.add('selected');
    document.getElementById('rating').value = rating;
  }

  // Form validation
  document.getElementById('feedbackForm').onsubmit = function(e) {
    const rating = document.getElementById('rating').value;
    if (!rating || rating == "0") {
      alert("Please select a rating before submitting your feedback.");
      e.preventDefault();
      return false;
    }
    return true;
  };
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

