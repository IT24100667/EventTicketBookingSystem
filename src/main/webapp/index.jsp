<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.controller.EventController" %>
<%@ page import="com.example.eventticketbookingsystem.controller.FeedbackController" %>
<%@ page import="com.example.eventticketbookingsystem.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Get upcoming events
    List<Event> upcomingEvents = new ArrayList<>();
    Double averageRating = 0.0;
    Map<Integer, Integer> feedbackCounts = null;
    List<Feedback> featuredFeedbacks = null;

    try {
        EventController eventController = new EventController();
        upcomingEvents = eventController.getAllEvents();

        // Get feedback data
        FeedbackController feedbackController = new FeedbackController();
        averageRating = feedbackController.getAverageRating();
        feedbackCounts = feedbackController.getFeedbackCounts();

        List<Feedback> allFeedbacks = feedbackController.getAllFeedback();
        // Get up to 3 most recent feedbacks with rating >= 4
        featuredFeedbacks = new ArrayList<>();
        int count = 0;

        // First try to get high-rated feedback
        for (Feedback feedback : allFeedbacks) {
            if (feedback.getRating() >= 4 && count < 3 && feedback.getComment() != null && !feedback.getComment().trim().isEmpty()) {
                featuredFeedbacks.add(feedback);
                count++;
            }
        }

        // If we don't have enough, add any feedback with comments
        if (count < 3) {
            for (Feedback feedback : allFeedbacks) {
                if (count < 3 && !featuredFeedbacks.contains(feedback) &&
                        feedback.getComment() != null && !feedback.getComment().trim().isEmpty()) {
                    featuredFeedbacks.add(feedback);
                    count++;
                }
            }
        }
    } catch (Exception e) {
        // Handle exceptions silently
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Ticket Booking System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        :root {
            --primary: #3066BE;
            --secondary: #5F9DF7;
            --accent: #1746A2;
            --light: #FFFFFF;
            --dark: #343a40;
            --success: #28a745;
            --info: #17a2b8;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        .header-banner {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 50px 0;
            margin-bottom: 30px;
            color: var(--light);
        }

        .event-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            height: 100%;
        }

        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 20px rgba(0,0,0,0.12);
        }

        .badge-info {
            background-color: var(--info);
            font-weight: normal;
            padding: 5px 8px;
        }

        .badge-success {
            background-color: var(--success);
            font-weight: normal;
            padding: 5px 8px;
        }

        .btn-custom-primary {
            background-color: var(--primary);
            border-color: var(--primary);
            color: var(--light);
            padding: 10px 25px;
            border-radius: 30px;
            transition: all 0.3s;
        }

        .btn-custom-primary:hover {
            background-color: var(--accent);
            border-color: var(--accent);
            transform: scale(1.05);
            color: var(--light);
        }

        .section-title {
            position: relative;
            display: inline-block;
            margin-bottom: 30px;
            color: var(--primary);
            font-weight: 600;
        }

        .section-title:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -10px;
            width: 50px;
            height: 3px;
            background-color: var(--secondary);
        }

        .feedback-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s;
            height: 100%;
        }

        .feedback-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .star-rating {
            color: #FFC107;
            font-size: 20px;
            margin-bottom: 15px;
        }

        .progress {
            height: 10px;
            border-radius: 5px;
            margin-bottom: 8px;
        }

        .progress-bar-5 { background-color: #4caf50; }
        .progress-bar-4 { background-color: #8bc34a; }
        .progress-bar-3 { background-color: #ffc107; }
        .progress-bar-2 { background-color: #ff9800; }
        .progress-bar-1 { background-color: #f44336; }

        footer a {
            color: rgba(255,255,255,0.8);
            transition: all 0.3s;
            text-decoration: none;
        }

        footer a:hover {
            color: var(--light) !important;
            text-decoration: none;
        }

        .social-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s;
            margin-right: 10px;
        }

        .social-icon:hover {
            background: rgba(255,255,255,0.2);
            transform: scale(1.1);
        }

        .promo-box {
            background: linear-gradient(135deg, var(--secondary), #78A6C8);
            border-radius: 10px;
            padding: 25px;
            color: var(--light);
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }

        .promo-box h3 {
            font-weight: 700;
            margin-bottom: 15px;
        }

        .promo-box p {
            font-size: 16px;
            margin-bottom: 20px;
        }

        .promo-box:before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(255,255,255,0.1);
            z-index: 0;
        }

        .pricing-info {
            background-color: var(--light);
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <!-- Top Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 rounded">
        <a class="navbar-brand" href="index.jsp">Event Booking</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="ViewEventsServlet">All Events</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="userLogin.jsp">Login</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="userRegister.jsp">Register</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="adminLogin.jsp">Admin</a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Hero Banner -->
    <div class="header-banner text-center">
        <h1>Find and Book Amazing Events</h1>
        <p class="lead">Concerts, Sports, and Other Events - All in One Place!</p>
        <a href="ViewEventsServlet" class="btn btn-custom-primary btn-lg mt-3">Browse Events</a>
    </div>

    <% if (request.getParameter("message") != null) { %>
    <div class="alert alert-success">
        <%= request.getParameter("message") %>
    </div>
    <% } %>

    <!-- Promotional Content -->
    <div class="row mb-5">
        <div class="col-md-8">
            <div class="promo-box">
                <h3><i class="fas fa-ticket-alt mr-2"></i>Book With Confidence</h3>
                <p>Welcome to our Event Ticket Booking System, your one-stop solution for all your entertainment needs.
                    Whether you're looking for concerts, sports events, or educational workshops, we've got you covered!</p>
                <p>Enjoy seamless booking, secure payments, and instant confirmations. No hidden fees, just transparent pricing.</p>
                <a href="ViewEventsServlet" class="btn btn-light">Explore Events</a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 pricing-info">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Special Pricing</h5>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-music mr-2"></i> Concert Tickets</span>
                            <span class="badge badge-info">+5% service fee</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-graduation-cap mr-2"></i> Educational Events</span>
                            <span class="badge badge-success">5% discount</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-users mr-2"></i> Volume Discounts</span>
                            <span class="text-muted">Check event details</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Featured Events Section -->
    <h2 class="section-title mb-4">Featured Events</h2>

    <% if (upcomingEvents != null && !upcomingEvents.isEmpty()) { %>
    <div class="row">
        <%
            // Display up to 3 events
            int count = 0;
            for (Event event : upcomingEvents) {
                if (count++ >= 3) break;
        %>
        <div class="col-md-4 mb-4">
            <div class="card event-card h-100">
                <div class="card-body">
                    <h5 class="card-title"><%= event.getName() %></h5>
                    <h6 class="card-subtitle mb-3 text-muted"><%= event.getEventType() %></h6>
                    <p class="card-text">
                        <i class="far fa-calendar-alt mr-2"></i> <%= dateFormat.format(event.getDate()) %><br>
                        <i class="fas fa-map-marker-alt mr-2"></i> <%= event.getVenue() %><br>
                        <i class="fas fa-tag mr-2"></i> $<%= String.format("%.2f", event.getPrice()) %>

                        <% if (event.getEventType().equals("Concert")) { %>
                        <span class="badge badge-info">+5% service fee</span>
                        <% } else if (event.getEventType().equals("Other")) {
                            // We need to check if this is an educational event
                            if (event instanceof OtherEvent) {
                                OtherEvent otherEvent = (OtherEvent) event;
                                if (otherEvent.getEventCategory() != null &&
                                        (otherEvent.getEventCategory().toLowerCase().contains("educational") ||
                                                otherEvent.getEventCategory().toLowerCase().contains("workshop") ||
                                                otherEvent.getEventCategory().toLowerCase().contains("seminar"))) { %>
                        <span class="badge badge-success">5% discount</span>
                        <% }}} %>
                    </p>

                    <% if (event instanceof Concert) {
                        Concert concert = (Concert) event;
                        if (concert.getDiscountThreshold() > 0) { %>
                    <div class="mb-3">
                            <span class="badge badge-success">
                                <i class="fas fa-users mr-1"></i> <%= concert.getDiscountPercentage() %>% off for <%= concert.getDiscountThreshold() %>+ tickets
                            </span>
                    </div>
                    <% }} %>

                    <div class="mt-3">
                        <a href="ViewEventsServlet?eventId=<%= event.getId() %>" class="btn btn-primary btn-sm">View Details</a>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <div class="text-center mt-3 mb-5">
        <a href="ViewEventsServlet" class="btn btn-outline-primary">View All Events</a>
    </div>
    <% } else { %>
    <div class="alert alert-info">
        No events are currently listed. Please check back later.
    </div>
    <% } %>

    <!-- Real Feedback Integration -->
    <div class="row mb-5">
        <div class="col-lg-5 mb-4">
            <h2 class="section-title">Customer Feedback</h2>
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Overall Rating</h5>
                </div>
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-4 text-center mb-3 mb-md-0">
                            <h1 style="font-size: 3rem; font-weight: 700; color: #3066BE;">
                                <%= String.format("%.1f", averageRating) %>
                            </h1>
                            <div class="star-rating">
                                <%
                                    int fullStars = (int) Math.floor(averageRating);
                                    boolean hasHalfStar = (averageRating - fullStars) >= 0.5;

                                    for (int i = 0; i < fullStars; i++) { %>
                                <i class="fas fa-star"></i>
                                <% }

                                    if (hasHalfStar) { %>
                                <i class="fas fa-star-half-alt"></i>
                                <% }

                                    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
                                    for (int i = 0; i < emptyStars; i++) { %>
                                <i class="far fa-star"></i>
                                <% }
                                %>
                            </div>
                            <small class="text-muted">Based on <%= feedbackCounts != null ?
                                    (feedbackCounts.get(1) + feedbackCounts.get(2) + feedbackCounts.get(3) +
                                            feedbackCounts.get(4) + feedbackCounts.get(5)) : 0 %> ratings</small>
                        </div>
                        <div class="col-md-8">
                            <% if (feedbackCounts != null) {
                                for(int i = 5; i >= 1; i--) {
                                    int count = feedbackCounts.get(i);
                                    int total = feedbackCounts.get(1) + feedbackCounts.get(2) + feedbackCounts.get(3) +
                                            feedbackCounts.get(4) + feedbackCounts.get(5);
                                    int percentage = total > 0 ? (count * 100) / total : 0;
                            %>
                            <div class="d-flex align-items-center mb-2">
                                <div style="width: 40px; text-align: right;"><%= i %> <i class="fas fa-star text-warning"></i></div>
                                <div class="flex-grow-1 mx-2">
                                    <div class="progress">
                                        <div class="progress-bar progress-bar-<%= i %>" role="progressbar" style="width: <%= percentage %>%"></div>
                                    </div>
                                </div>
                                <div style="width: 30px;"><%= count %></div>
                            </div>
                            <% } } %>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-center">
                    <a href="ViewFeedbacksServlet" class="btn btn-outline-primary btn-sm">View All Feedback</a>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <h2 class="section-title">What Our Customers Say</h2>
            <div class="row">
                <% if (featuredFeedbacks != null && !featuredFeedbacks.isEmpty()) {
                    for (Feedback feedback : featuredFeedbacks) { %>
                <div class="col-lg-6 mb-3">
                    <div class="card feedback-card h-100">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="font-weight-bold"><%= feedback.getUsername() %></span>
                                <div class="star-rating" style="font-size: 14px; margin-bottom: 0;">
                                    <% for (int i = 0; i < feedback.getRating(); i++) { %>
                                    <i class="fas fa-star"></i>
                                    <% } %>
                                    <% for (int i = feedback.getRating(); i < 5; i++) { %>
                                    <i class="far fa-star"></i>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <p class="card-text"><%= feedback.getComment() %></p>
                        </div>
                        <div class="card-footer text-muted">
                            <small>Posted: <%= new SimpleDateFormat("yyyy-MM-dd").format(feedback.getCreatedDate()) %></small>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="col-12">
                    <div class="alert alert-info">
                        No customer reviews available yet. Be the first to provide feedback!
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Why Choose Us -->
    <div class="card mb-5">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><i class="fas fa-check-circle mr-2"></i>Why Choose Our Ticket Booking System?</h4>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <div class="mb-3">
                                <i class="fas fa-bolt text-primary" style="font-size: 2.5rem;"></i>
                            </div>
                            <h5>Fast & Easy Booking</h5>
                            <p class="card-text">Book your tickets in less than a minute with our streamlined booking process.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <div class="mb-3">
                                <i class="fas fa-shield-alt text-primary" style="font-size: 2.5rem;"></i>
                            </div>
                            <h5>Secure Transactions</h5>
                            <p class="card-text">Your payment and personal information are always protected with our secure system.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <div class="mb-3">
                                <i class="fas fa-hand-holding-usd text-primary" style="font-size: 2.5rem;"></i>
                            </div>
                            <h5>Transparent Pricing</h5>
                            <p class="card-text">We clearly display all fees and discounts so you always know what you're paying.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Improved Footer -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-3">
                <h5>Event Ticket Booking System</h5>
                <p>Your trusted platform for booking tickets to concerts, sports events, and educational workshops.</p>
            </div>
            <div class="col-md-3 mb-3">
                <h5>Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="ViewEventsServlet"><i class="fas fa-chevron-right mr-2 small"></i>All Events</a></li>
                    <li><a href="ViewEventsServlet?type=Concert"><i class="fas fa-chevron-right mr-2 small"></i>Concerts</a></li>
                    <li><a href="ViewEventsServlet?type=Sports"><i class="fas fa-chevron-right mr-2 small"></i>Sports</a></li>
                    <li><a href="ViewEventsServlet?type=Other"><i class="fas fa-chevron-right mr-2 small"></i>Other Events</a></li>
                </ul>
            </div>
            <div class="col-md-3 mb-3">
                <h5>Support</h5>
                <ul class="list-unstyled">
                    <li><a href="#"><i class="fas fa-envelope mr-2 small"></i>Contact Us</a></li>
                    <li><a href="#"><i class="fas fa-question-circle mr-2 small"></i>Help Center</a></li>
                    <li><a href="#"><i class="fas fa-lock mr-2 small"></i>Privacy Policy</a></li>
                    <li><a href="#"><i class="fas fa-file-alt mr-2 small"></i>Terms of Service</a></li>
                </ul>
            </div>
            <div class="col-md-2 mb-3">
                <h5>Connect</h5>
                <div class="mt-3">
                    <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <div class="text-center mt-3 pt-3 border-top border-secondary">
            <p class="mb-0">Event Ticket Booking System &copy; <%= new java.util.Date().getYear() + 1900 %> </p>
            <p class="mb-0"><small>Current Date and Time (UTC): <%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></small></p>
        </div>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>