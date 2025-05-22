<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String searchType = (String) request.getAttribute("searchType");
    String sortBy = (String) request.getAttribute("sortBy");
    String eventType = (String) request.getAttribute("type");
    Double minPrice = (Double) request.getAttribute("minPrice");
    Double maxPrice = (Double) request.getAttribute("maxPrice");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat displayFormat = new SimpleDateFormat("MMM dd, yyyy");

    // Count events for user feedback
    int eventCount = (events != null) ? events.size() : 0;

    // Create parameter string for URL preservation
    String paramString = "";
    if (searchTerm != null && !searchTerm.isEmpty()) {
        paramString += "&searchTerm=" + searchTerm;
        if (searchType != null && !searchType.isEmpty()) {
            paramString += "&searchType=" + searchType;
        }
    }
    if (minPrice != null && maxPrice != null) {
        paramString += "&minPrice=" + minPrice + "&maxPrice=" + maxPrice;
    }

    // Current timestamp
    String currentTimestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Events - Event Booking System</title>
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
            --warning: #ffc107;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-bottom: 70px; /* Space for fixed footer */
            background-color: #f8f9fa;
        }

        .event-card {
            height: 100%;
            transition: transform 0.2s;
            border: none;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            font-weight: 600;
            padding: 12px 15px;
        }

        .event-info {
            margin-bottom: 0.5rem;
        }

        .badge-concert {
            background-color: #17a2b8;
            color: white;
        }

        .badge-sports {
            background-color: #28a745;
            color: white;
        }

        .badge-other {
            background-color: #ffc107;
            color: #212529;
        }

        .sort-btn {
            display: inline-flex;
            align-items: center;
            margin: 0 5px;
        }

        .sort-btn i {
            margin-right: 4px;
        }

        .price-container {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-container {
            background-color: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .btn-custom-primary {
            background-color: var(--primary);
            border-color: var(--primary);
        }

        .btn-custom-primary:hover {
            background-color: var(--accent);
            border-color: var(--accent);
        }

        .type-filter {
            margin-bottom: 15px;
        }

        .type-filter .btn {
            border-radius: 30px;
            padding: 8px 15px;
            margin: 0 3px;
            font-weight: 500;
        }

        .btn-concert {
            border-color: #17a2b8;
            color: #17a2b8;
        }

        .btn-concert.active, .btn-concert:hover {
            background-color: #17a2b8;
            color: white;
        }

        .btn-sports {
            border-color: #28a745;
            color: #28a745;
        }

        .btn-sports.active, .btn-sports:hover {
            background-color: #28a745;
            color: white;
        }

        .btn-other {
            border-color: #ffc107;
            color: #ffc107;
        }

        .btn-other.active, .btn-other:hover {
            background-color: #ffc107;
            color: #212529;
        }

        .advanced-search-toggle {
            cursor: pointer;
            color: var(--primary);
        }

        .advanced-search-toggle:hover {
            text-decoration: underline;
        }

        .search-filters {
            display: inline-block;
            background: #e9ecef;
            padding: 5px 10px;
            border-radius: 20px;
            margin: 0 5px 5px 0;
            font-size: 0.9rem;
        }

        .search-filters .close {
            font-size: 0.9rem;
            margin-left: 5px;
        }

        footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            z-index: 100;
        }

        @media (max-width: 768px) {
            .type-filter .btn {
                margin-bottom: 5px;
            }

            .advanced-search .form-row {
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
<!-- Basic Nav -->
<div class="container mt-4">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 rounded">
        <a class="navbar-brand" href="index.jsp">Event Booking</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp"><i class="fas fa-home mr-1"></i> Home</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="ViewEventsServlet"><i class="fas fa-calendar-alt mr-1"></i> Events</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="ViewBookingsServlet"><i class="fas fa-ticket-alt mr-1"></i> My Bookings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="ViewFeedbacksServlet"><i class="fas fa-comment mr-1"></i> Feedback</a>
                </li>
                <% if(session.getAttribute("user") != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="LogoutServlet"><i class="fas fa-sign-out-alt mr-1"></i> Logout</a>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link" href="userLogin.jsp"><i class="fas fa-sign-in-alt mr-1"></i> Login</a>
                </li>
                <% } %>
            </ul>
        </div>
    </nav>
</div>

<div class="container mt-4">
    <h2 class="mb-4"><i class="fas fa-calendar-alt mr-2"></i>Browse Events</h2>

    <div class="filter-container">
        <!-- Basic Search Form -->
        <form action="ViewEventsServlet" method="get" class="mb-3">
            <div class="input-group">
                <input type="text" name="searchTerm" class="form-control" placeholder="Search events..."
                       value="<%= searchTerm != null ? searchTerm : "" %>">
                <select name="searchType" class="custom-select" style="max-width: 140px;">
                    <option value="name" <%= "name".equals(searchType) || searchType == null ? "selected" : "" %>>By Name</option>
                    <option value="venue" <%= "venue".equals(searchType) ? "selected" : "" %>>By Venue</option>
                </select>
                <div class="input-group-append">
                    <button class="btn btn-custom-primary" type="submit">
                        <i class="fas fa-search mr-1"></i> Search
                    </button>
                </div>
            </div>

            <!-- Preserve other parameters -->
            <% if (sortBy != null) { %>
            <input type="hidden" name="sortBy" value="<%= sortBy %>">
            <% } %>
            <% if (eventType != null) { %>
            <input type="hidden" name="type" value="<%= eventType %>">
            <% } %>

            <div class="mt-3">
                <a data-toggle="collapse" href="#advancedSearch" class="advanced-search-toggle">
                    <i class="fas fa-sliders-h mr-1"></i> Advanced Search
                </a>
            </div>

            <div class="collapse mt-3" id="advancedSearch">
                <div class="card card-body advanced-search">
                    <div class="form-row">
                        <div class="col-md-5">
                            <label for="minPrice">Min Price ($)</label>
                            <input type="number" step="0.01" min="0" name="minPrice" id="minPrice" class="form-control"
                                   value="<%= minPrice != null ? minPrice : "" %>">
                        </div>
                        <div class="col-md-5">
                            <label for="maxPrice">Max Price ($)</label>
                            <input type="number" step="0.01" min="0" name="maxPrice" id="maxPrice" class="form-control"
                                   value="<%= maxPrice != null ? maxPrice : "" %>">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-outline-primary btn-block">Apply</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>

        <!-- Event Type Filter -->
        <div class="type-filter text-center">
            <div class="btn-group btn-group-sm">
                <a href="ViewEventsServlet<%= paramString.isEmpty() ? "" : "?" + paramString.substring(1) %><%= !paramString.isEmpty() && sortBy != null ? "&sortBy=" + sortBy : (paramString.isEmpty() && sortBy != null ? "?sortBy=" + sortBy : "") %>"
                   class="btn <%= eventType == null ? "btn-dark" : "btn-outline-dark" %>">
                    <i class="fas fa-th mr-1"></i> All Types
                </a>
                <a href="ViewEventsServlet?type=Concert<%= paramString %><%= sortBy != null ? "&sortBy=" + sortBy : "" %>"
                   class="btn <%= "Concert".equals(eventType) ? "btn-concert active" : "btn-outline-secondary btn-concert" %>">
                    <i class="fas fa-music mr-1"></i> Concerts
                </a>
                <a href="ViewEventsServlet?type=Sports<%= paramString %><%= sortBy != null ? "&sortBy=" + sortBy : "" %>"
                   class="btn <%= "Sports".equals(eventType) ? "btn-sports active" : "btn-outline-secondary btn-sports" %>">
                    <i class="fas fa-running mr-1"></i> Sports
                </a>
                <a href="ViewEventsServlet?type=Other<%= paramString %><%= sortBy != null ? "&sortBy=" + sortBy : "" %>"
                   class="btn <%= "Other".equals(eventType) ? "btn-other active" : "btn-outline-secondary btn-other" %>">
                    <i class="fas fa-star mr-1"></i> Other Events
                </a>
            </div>
        </div>

        <!-- Sorting Options -->
        <div class="d-flex justify-content-center">
            <span class="mr-2"><i class="fas fa-sort mr-1"></i> Sort by:</span>
            <a href="ViewEventsServlet?sortBy=date<%= paramString %><%= eventType != null ? "&type=" + eventType : "" %>"
               class="btn btn-sm <%= "date".equals(sortBy) ? "btn-primary" : "btn-outline-primary" %> sort-btn">
                <i class="fas fa-calendar-day"></i> Date
            </a>
            <% if (sortBy != null || searchTerm != null || eventType != null || minPrice != null) { %>
            <a href="ViewEventsServlet" class="btn btn-sm btn-outline-secondary ml-2">
                <i class="fas fa-times mr-1"></i> Clear All Filters
            </a>
            <% } %>
        </div>
    </div>

    <!-- Active Filters Display -->
    <% if (searchTerm != null || eventType != null || minPrice != null || sortBy != null) { %>
    <div class="mb-3">
        <span class="text-muted mr-2">Active filters:</span>

        <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
        <span class="search-filters">
      <%= "venue".equals(searchType) ? "Venue" : "Name" %>: <%= searchTerm %>
      <a href="ViewEventsServlet<%= eventType != null ? "?type=" + eventType : "" %><%= sortBy != null ? (eventType != null ? "&" : "?") + "sortBy=" + sortBy : "" %><%= minPrice != null ? (eventType != null || sortBy != null ? "&" : "?") + "minPrice=" + minPrice + "&maxPrice=" + maxPrice : "" %>" class="close">&times;</a>
    </span>
        <% } %>

        <% if (eventType != null) { %>
        <span class="search-filters">
      Type: <%= eventType %>
      <a href="ViewEventsServlet<%= searchTerm != null ? "?searchTerm=" + searchTerm + "&searchType=" + searchType : "" %><%= sortBy != null ? (searchTerm != null ? "&" : "?") + "sortBy=" + sortBy : "" %><%= minPrice != null ? (searchTerm != null || sortBy != null ? "&" : "?") + "minPrice=" + minPrice + "&maxPrice=" + maxPrice : "" %>" class="close">&times;</a>
    </span>
        <% } %>

        <% if (minPrice != null && maxPrice != null) { %>
        <span class="search-filters">
      Price: $<%= minPrice %> - $<%= maxPrice %>
      <a href="ViewEventsServlet<%= searchTerm != null ? "?searchTerm=" + searchTerm + "&searchType=" + searchType : "" %><%= eventType != null ? (searchTerm != null ? "&" : "?") + "type=" + eventType : "" %><%= sortBy != null ? ((searchTerm != null || eventType != null) ? "&" : "?") + "sortBy=" + sortBy : "" %>" class="close">&times;</a>
    </span>
        <% } %>

        <% if (sortBy != null) { %>
        <span class="search-filters">
      Sorted by: <%= sortBy %>
      <a href="ViewEventsServlet<%= searchTerm != null ? "?searchTerm=" + searchTerm + "&searchType=" + searchType : "" %><%= eventType != null ? (searchTerm != null ? "&" : "?") + "type=" + eventType : "" %><%= minPrice != null ? ((searchTerm != null || eventType != null) ? "&" : "?") + "minPrice=" + minPrice + "&maxPrice=" + maxPrice : "" %>" class="close">&times;</a>
    </span>
        <% } %>
    </div>
    <% } %>

    <!-- Results Summary -->
    <div class="mb-3 text-muted">
        <p><i class="fas fa-list mr-1"></i> Showing <%= eventCount %> events</p>
    </div>

    <!-- Events List -->
    <% if (events != null && !events.isEmpty()) { %>
    <div class="row">
        <% for (Event event : events) { %>
        <div class="col-md-4 mb-4">
            <div class="card event-card">
                <div class="card-header">
                    <%= event.getName() != null ? event.getName() : "" %>
                </div>
                <div class="card-body">
                    <div class="event-info">
                        <i class="fas fa-tag mr-2 text-muted"></i>
                        <% if (event.getEventType().equals("Concert")) { %>
                        <span class="badge badge-concert">Concert</span>
                        <% } else if (event.getEventType().equals("Sports")) { %>
                        <span class="badge badge-sports">Sports</span>
                        <% } else { %>
                        <span class="badge badge-other">
                <%= event instanceof OtherEvent ? (((OtherEvent)event).getEventCategory() != null ? ((OtherEvent)event).getEventCategory() : "Other") : "Other" %>
              </span>
                        <% } %>
                    </div>

                    <div class="event-info">
                        <i class="far fa-calendar-alt mr-2 text-muted"></i>
                        <%= displayFormat.format(event.getDate()) %>
                    </div>

                    <div class="event-info">
                        <i class="fas fa-map-marker-alt mr-2 text-muted"></i>
                        <%= event.getVenue() != null ? event.getVenue() : "" %>
                    </div>

                    <!-- Price Display -->
                    <div class="price-container event-info">
                        <i class="fas fa-dollar-sign mr-2 text-muted"></i>
                        <span><%= String.format("%.2f", event.getPrice()) %></span>

                        <% if (event.getEventType().equals("Concert")) { %>
                        <span class="badge badge-info ml-2">+5% service fee</span>
                        <% } else if (event.getEventType().equals("Other")) {
                            OtherEvent otherEvent = (OtherEvent) event;
                            if (otherEvent.getEventCategory() != null &&
                                    (otherEvent.getEventCategory().toLowerCase().contains("educational") ||
                                            otherEvent.getEventCategory().toLowerCase().contains("workshop") ||
                                            otherEvent.getEventCategory().toLowerCase().contains("seminar"))) { %>
                        <span class="badge badge-success ml-2">5% discount</span>
                        <% }} %>
                    </div>

                    <div class="event-info">
                        <i class="fas fa-users mr-2 text-muted"></i>
                        <span><%= event.getAvailableSeats() %> seats available</span>
                    </div>

                    <% if (event.getEventType().equals("Concert")) {
                        Concert concert = (Concert) event;
                        if (concert.getDiscountThreshold() > 0) { %>
                    <div class="mt-2 mb-3">
            <span class="badge badge-success">
              <i class="fas fa-percentage mr-1"></i> <%= concert.getDiscountPercentage() %>% discount for <%= concert.getDiscountThreshold() %>+ tickets
            </span>
                    </div>
                    <% }} %>

                    <a href="ViewEventsServlet?eventId=<%= event.getId() %>" class="btn btn-custom-primary btn-block mt-3">
                        <i class="fas fa-info-circle mr-1"></i> View Details
                    </a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="alert alert-info">
        <i class="fas fa-info-circle mr-2"></i>
        No events found. Please try a different search or check back later.
    </div>
    <% } %>

    <!-- Footnote about sorting -->
    <% if ("date".equals(sortBy)) { %>
    <div class="mt-4 mb-5 card bg-light">
        <div class="card-body">
            <h5 class="card-title"><i class="fas fa-sort-amount-down mr-2"></i>About Event Sorting</h5>
            <p class="card-text">
                Events are currently sorted by date (earliest first) using the Merge Sort algorithm.
                Merge Sort is an efficient, comparison-based sorting algorithm with O(n log n) time complexity.
            </p>
        </div>
    </div>
    <% } %>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p class="mb-0">Event Ticket Booking System &copy; 2025</p>
    <p class="mb-0"><small>Current Date and Time (UTC): <%= currentTimestamp %></small></p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.min.js"></script>
<script>
    // Show advanced search if price filter is active
    <% if (minPrice != null || maxPrice != null) { %>
    $(document).ready(function() {
        $('#advancedSearch').collapse('show');
    });
    <% } %>

    // Safely handle null values in event data display
    document.addEventListener('DOMContentLoaded', function() {
        // Add error handling for images and other resources
        document.querySelectorAll('img').forEach(function(img) {
            img.onerror = function() {
                this.style.display = 'none';
            };
        });
    });
</script>
</body>
</html>