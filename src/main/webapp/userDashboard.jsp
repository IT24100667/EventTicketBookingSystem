<%-- File: userDashboard.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="com.example.eventticketbookingsystem.model.Event" %>
<%@ page import="com.example.eventticketbookingsystem.controller.EventController" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    // Get upcoming events from request (if available)
    List<Event> upcomingEvents = (List<Event>) request.getAttribute("upcomingEvents");

    // If events are not in the request, load them directly
    // This ensures events are shown even when navigating directly to this JSP
    if (upcomingEvents == null || upcomingEvents.isEmpty()) {
        EventController eventController = new EventController();
        upcomingEvents = eventController.getAllEvents();
    }

    // Date formatter for event display
    SimpleDateFormat formatter = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
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

        /* Footer styles to ensure it's at the bottom of the page */
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
            flex: 1;
        }

        /* Jumbotron styles */
        .jumbotron {
            background: linear-gradient(135deg, var(--light-accent), #ffffff);
            border-radius: 0.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-left: 5px solid var(--primary-color);
        }

        .tagline {
            color: #6c757d;
            font-size: 1.1rem;
        }

        /* Card styles */
        .card {
            border: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border-radius: 0.5rem;
        }

        .card-header {
            background-color: #ffffff;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 1rem 1.5rem;
        }

        /* Button styles */
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        /* Carousel styles */
        .carousel-container {
            position: relative;
            overflow: hidden;
            min-height: 320px;
            border-radius: 0.5rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            background-color: white;
        }

        .carousel-indicators {
            position: absolute;
            bottom: 20px;
            left: 0;
            right: 0;
            display: flex;
            justify-content: center;
            gap: 8px;
        }

        .carousel-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: #e0e0e0;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .carousel-indicator.active {
            background-color: var(--primary-color);
        }

        .event-card {
            height: 100%;
            transition: all 0.3s;
            border: none;
            background-color: white;
        }

        .carousel-slide {
            position: absolute;
            width: 100%;
            opacity: 0;
            transition: opacity 0.5s ease-in-out;
        }

        .carousel-slide.active {
            opacity: 1;
            z-index: 5;
        }

        /* Progress bar for timer */
        .timer-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 3px;
            background-color: var(--accent-color);
            width: 0%;
            transition: width 0.1s linear;
        }

        /* Center event content */
        .event-content {
            text-align: center;
            padding: 1.5rem;
        }

        .event-content h4 {
            color: var(--dark-accent);
            margin-bottom: 0.75rem;
        }

        .event-content .text-muted {
            color: var(--secondary-color) !important;
            font-weight: 500;
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

        /* Navigation styles - not changing the structure */
        .navbar .navbar-nav {
            margin-left: auto;
        }

        /* Footer styles */
        footer {
            background: linear-gradient(to right, var(--dark-accent), #495057);
            border-top: 4px solid var(--accent-color);
            padding: 15px 0;
            margin-top: 20px;
            width: 100%;
            color: white;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="content-wrapper">
    <div class="container mt-4">
        <!-- Navigation Bar - KEPT UNCHANGED as requested -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 rounded">
            <a class="navbar-brand" href="index.jsp">Event Booking</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarContent">
                <!-- Navigation items on the RIGHT side -->
                <ul class="navbar-nav">
                    <li class="nav-item active">
                        <a class="nav-link" href="UserDashboardServlet">Dashboard</a>
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
                    <li class="nav-item">
                        <a class="nav-link" href="ViewFeedbacksServlet">Feedback</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
                </ul>

                <!-- User Profile Icon -->
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
            </div>
        </nav>
    </div>

    <div class="container mt-4">
        <div class="jumbotron">
            <h1>Welcome, <%= user.getFullName() %>!</h1>
            <p class="lead">Let's Book Your Ticket</p>
            <p class="tagline">Discover your favorite entertainment right here</p>
        </div>

        <!-- Upcoming Events Carousel -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Upcoming Events</h5>
                <a href="ViewEventsServlet" class="btn btn-sm btn-outline-primary">View All</a>
            </div>
            <div class="card-body">
                <% if (upcomingEvents != null && !upcomingEvents.isEmpty()) { %>
                <!-- Carousel Container -->
                <div class="carousel-container" id="eventCarousel">
                    <div class="timer-progress" id="timerProgress"></div>

                    <!-- Event Slides -->
                    <div id="carouselSlides">
                        <% for (int i = 0; i < upcomingEvents.size(); i++) {
                            Event event = upcomingEvents.get(i);
                        %>
                        <div class="carousel-slide <%= i == 0 ? "active" : "" %>" data-index="<%= i %>">
                            <div class="card event-card">
                                <div class="card-body event-content">
                                    <h4 class="card-title"><%= event.getName() %></h4>
                                    <h6 class="card-subtitle mb-3 text-muted"><i class="far fa-calendar-alt mr-2"></i><%= formatter.format(event.getDate()) %></h6>
                                    <p class="card-text"><%= event.getDescription().length() > 150 ?
                                            event.getDescription().substring(0, 147) + "..." :
                                            event.getDescription() %></p>
                                    <p class="card-text"><strong><i class="fas fa-map-marker-alt mr-2 text-primary"></i>Venue:</strong> <%= event.getVenue() %></p>
                                    <p class="card-text"><strong><i class="fas fa-tag mr-2 text-primary"></i>Price:</strong> $<%= String.format("%.2f", event.getPrice()) %></p>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>

                    <!-- Carousel Indicators -->
                    <div class="carousel-indicators" id="carouselIndicators">
                        <% for (int i = 0; i < upcomingEvents.size(); i++) { %>
                        <div class="carousel-indicator <%= i == 0 ? "active" : "" %>" data-index="<%= i %>"></div>
                        <% } %>
                    </div>
                </div>
                <% } else { %>
                <div class="alert alert-info">
                    No upcoming events available at the moment. Check back soon!
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

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // IIFE to encapsulate our carousel functionality
    (function() {
        // Only run if we have events
        if (document.getElementById('carouselSlides') === null) return;

        // Implementing a circular linked list for our carousel
        class Node {
            constructor(index) {
                this.index = index;
                this.next = null;
                this.prev = null;
            }
        }

        class CircularLinkedList {
            constructor(size) {
                this.head = null;
                this.current = null;
                this.size = 0;

                // Initialize with nodes
                if (size > 0) {
                    this.initializeWithSize(size);
                }
            }

            initializeWithSize(size) {
                if (size <= 0) return;

                // Create first node
                let firstNode = new Node(0);
                this.head = firstNode;
                this.current = firstNode;
                this.size = 1;

                let prevNode = firstNode;

                // Create remaining nodes
                for (let i = 1; i < size; i++) {
                    let newNode = new Node(i);
                    prevNode.next = newNode;
                    newNode.prev = prevNode;
                    prevNode = newNode;
                    this.size++;
                }

                // Complete the circle
                prevNode.next = this.head;
                this.head.prev = prevNode;
            }

            moveNext() {
                if (!this.current) return null;
                this.current = this.current.next;
                return this.current;
            }

            moveToIndex(index) {
                if (!this.head || index < 0 || index >= this.size) return null;

                // Start from head
                let current = this.head;
                while (current.index !== index) {
                    current = current.next;
                }

                this.current = current;
                return this.current;
            }

            getCurrentIndex() {
                return this.current ? this.current.index : -1;
            }
        }

        // Get all the elements we need
        const slides = document.querySelectorAll('.carousel-slide');
        const indicators = document.querySelectorAll('.carousel-indicator');
        const timerProgress = document.getElementById('timerProgress');

        // Create our circular linked list
        const carousel = new CircularLinkedList(slides.length);

        let interval = 3000; // 3 seconds - controls how long each event is displayed
        let timer;
        let progress = 0;
        let progressTimer;

        // Function to update the carousel display
        function updateCarousel(index) {
            // Update slides
            slides.forEach(slide => slide.classList.remove('active'));
            slides[index].classList.add('active');

            // Update indicators
            indicators.forEach(ind => ind.classList.remove('active'));
            indicators[index].classList.add('active');
        }

        // Function to start the autoplay
        function startAutoplay() {
            if (timer) clearInterval(timer);
            if (progressTimer) clearInterval(progressTimer);

            // Reset progress
            progress = 0;
            timerProgress.style.width = '0%';

            // Start progress animation
            const progressStep = 100 / (interval / 100); // Update every 100ms
            progressTimer = setInterval(() => {
                progress += progressStep;
                timerProgress.style.width = `${Math.min(progress, 100)}%`;
            }, 100);

            // Set main timer for slide change
            timer = setTimeout(() => {
                const node = carousel.moveNext();
                updateCarousel(node.index);
                startAutoplay(); // Restart for next slide
            }, interval);
        }

        // Event listeners for indicators (still useful to allow clicking on dots)
        indicators.forEach((indicator, idx) => {
            indicator.addEventListener('click', () => {
                if (timer) clearInterval(timer);
                if (progressTimer) clearInterval(progressTimer);

                const node = carousel.moveToIndex(idx);
                updateCarousel(node.index);
                startAutoplay();
            });
        });

        // Initialize - start the carousel
        startAutoplay();
    })();
</script>
</body>
</html>