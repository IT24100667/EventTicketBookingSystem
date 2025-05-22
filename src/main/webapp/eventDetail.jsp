<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  Event event = (Event) request.getAttribute("event");
  if (event == null) {
    response.sendRedirect("ViewEventsServlet");
    return;
  }
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  boolean isDiscountable = (event instanceof Discountable);

  boolean isEducationalEvent = false;
  if (event instanceof OtherEvent) {
    OtherEvent otherEvent = (OtherEvent) event;
    isEducationalEvent = otherEvent.getEventCategory() != null &&
            (otherEvent.getEventCategory().toLowerCase().contains("educational") ||
                    otherEvent.getEventCategory().toLowerCase().contains("workshop") ||
                    otherEvent.getEventCategory().toLowerCase().contains("seminar"));
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><%= event.getName() %></title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<!-- Basic Nav -->
<div class="container mt-4">
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 rounded">

    <a class="navbar-brand" href="index.jsp">Event Booking</a>

    <ul class="navbar-nav ml-auto">
      <li class="nav-item">
        <a class="nav-link" href="ViewEventsServlet">Back to Events</a>
      </li>
    </ul>

  </nav>
</div>
<div class="container mt-4">
  <div class="card">
    <div class="card-header">
      <h3><%= event.getName() %></h3>
    </div>
    <div class="card-body">
      <p><%= event.getDescription() %></p>

      <hr>

      <div class="row">
        <div class="col-md-6">
          <p><b>Date:</b> <%= dateFormat.format(event.getDate()) %></p>
          <p><b>Venue:</b> <%= event.getVenue() %></p>

          <!-- Updated pricing information section -->
          <p><b>Base Price:</b> $<%= String.format("%.2f", event.getPrice()) %></p>

          <% if (event.getEventType().equals("Concert")) { %>
          <p><b>Service Fee:</b> 5% ($<%= String.format("%.2f", event.getPrice() * 0.05) %>)</p>
          <p><b>Ticket Price:</b> $<%= String.format("%.2f", event.calculateTicketPrice()) %></p>
          <% } else if (isEducationalEvent) { %>
          <p><b>Educational Discount:</b> 5% (-$<%= String.format("%.2f", event.getPrice() * 0.05) %>)</p>
          <p><b>Ticket Price:</b> $<%= String.format("%.2f", event.calculateTicketPrice()) %></p>
          <% } else { %>
          <p><b>Ticket Price:</b> $<%= String.format("%.2f", event.getPrice()) %></p>
          <% } %>

          <p><b>Available Seats:</b> <%= event.getAvailableSeats() %></p>
        </div>
        <div class="col-md-6">
          <% if (event instanceof Concert) { %>
          <% Concert concert = (Concert) event; %>
          <p><b>Artist:</b> <%= concert.getArtist() %></p>
          <% if (concert.getDiscountThreshold() > 0) { %>
          <p><b>Volume Discount:</b> <%= concert.getDiscountPercentage() %>% off when buying <%= concert.getDiscountThreshold() %>+ tickets</p>
          <% } %>
          <% } else if (event instanceof Sports) { %>
          <% Sports sports = (Sports) event; %>
          <p><b>Sport:</b> <%= sports.getSportType() %></p>
          <p><b>Teams:</b> <%= sports.getTeams() %></p>
          <% } else if (event instanceof OtherEvent) { %>
          <% OtherEvent otherEvent = (OtherEvent) event; %>
          <p><b>Category:</b> <%= otherEvent.getEventCategory() %></p>
          <p><b>Special Requirements:</b> <%= otherEvent.getSpecialRequirements() != null && !otherEvent.getSpecialRequirements().isEmpty() ? otherEvent.getSpecialRequirements() : "None" %></p>
          <% if (isEducationalEvent) { %>
          <div class="alert alert-success mt-3">
            <small>Educational events receive a 5% discount on the base price!</small>
          </div>
          <% } %>
          <% } %>
        </div>
      </div>

      <% if (event instanceof Concert) {
        Concert concert = (Concert) event;
        if (concert.getDiscountThreshold() > 0) { %>
      <div class="alert alert-info mt-3">
        <p><%= concert.getDiscountPercentage() %>% discount when you book <%= concert.getDiscountThreshold() %> or more tickets!</p>
      </div>
      <% } %>
      <div class="alert alert-info mt-3">
        <p>All concerts include a 5% service fee.</p>
      </div>
      <% } %>

      <hr>

      <div class="row">
        <div class="col-md-6 offset-md-3">
          <% if (event.getAvailableSeats() > 0) { %>
          <form action="BookTicketsServlet" method="post">
            <input type="hidden" name="eventId" value="<%= event.getId() %>">

            <div class="form-group">
              <label>Number of Tickets:</label>
              <input type="number" name="ticketQuantity" id="ticketQuantity" class="form-control"
                     min="1" max="<%= event.getAvailableSeats() %>" value="1"
                     oninput="updateTotalPrice()">
            </div>

            <!-- Detailed Price Breakdown -->
            <div class="form-group">
              <label>Price Breakdown:</label>
              <div class="card">
                <div class="card-body">
                  <p>Base Price: $<span id="basePrice"><%= String.format("%.2f", event.getPrice()) %></span> per ticket</p>

                  <% if (event.getEventType().equals("Concert")) { %>
                  <p>Service Fee: 5% added</p>
                  <% } else if (isEducationalEvent) { %>
                  <p>Educational Discount: 5% off</p>
                  <% } %>

                  <p>Ticket Price: $<span id="unitPrice"><%= String.format("%.2f", event.calculateTicketPrice()) %></span> per ticket</p>
                  <p>Quantity: <span id="quantityDisplay">1</span></p>

                  <% if (event instanceof Concert) {
                    Concert concert = (Concert) event;
                    if (concert.getDiscountThreshold() > 0) { %>
                  <p id="volumeDiscountText" style="display:none;">
                    Volume Discount: <%= concert.getDiscountPercentage() %>% off
                  </p>
                  <% }} %>

                  <hr>
                  <p class="font-weight-bold">Total: <span id="totalPriceDisplay">$<%= String.format("%.2f", event.calculateTicketPrice()) %></span></p>
                </div>
              </div>
            </div>

            <div class="text-center">
              <% if (session.getAttribute("user") != null) { %>
              <button type="submit" class="btn btn-success">Book Now</button>
              <% } else { %>
              <a href="userLogin.jsp?redirect=ViewEventsServlet?eventId=<%= event.getId() %>" class="btn btn-primary">Login to Book</a>
              <% } %>
            </div>
          </form>
          <% } else { %>
          <div class="alert alert-danger text-center">
            <p>Sorry, this event is sold out!</p>
          </div>
          <% } %>
        </div>
      </div>
    </div>
  </div>

  <div class="mt-3">
    <a href="ViewEventsServlet" class="btn btn-secondary">Back to All Events</a>
  </div>
</div>

<footer class="bg-dark text-white text-center py-3 mt-5">
  <p class="mb-0">Event Ticket Booking System &copy; 2025</p>
</footer>

<script>
  function updateTotalPrice() {
    const quantity = parseInt(document.getElementById('ticketQuantity').value);
    const basePrice = <%= event.getPrice() %>;

    // Calculate unit price with service fee or discount
    <% if (event.getEventType().equals("Concert")) { %>
    const unitPrice = basePrice * 1.05; // 5% service fee
    <% } else if (isEducationalEvent) { %>
    const unitPrice = basePrice * 0.95; // 5% discount
    <% } else { %>
    const unitPrice = basePrice;
    <% } %>

    let totalPrice = quantity * unitPrice;

    // Apply volume discount for concerts if eligible
    <% if (event instanceof Concert) {
         Concert concert = (Concert) event;
         if (concert.getDiscountThreshold() > 0) { %>
    if (quantity >= <%= concert.getDiscountThreshold() %>) {
      let discount = <%= concert.getDiscountPercentage() / 100.0 %>;
      totalPrice = totalPrice * (1 - discount);
      document.getElementById('volumeDiscountText').style.display = 'block';
    } else {
      document.getElementById('volumeDiscountText').style.display = 'none';
    }
    <% }} %>

    document.getElementById('quantityDisplay').textContent = quantity;
    document.getElementById('totalPriceDisplay').textContent = '$' + totalPrice.toFixed(2);
  }

  // Initialize the total price when page loads
  window.onload = function() {
    updateTotalPrice();
  };
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>