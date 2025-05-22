<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Check if admin is logged in
  if (session.getAttribute("user") == null || session.getAttribute("isAdmin") == null ||
          !(Boolean)session.getAttribute("isAdmin")) {
    response.sendRedirect("adminLogin.jsp");
    return;
  }

  Admin admin = (Admin) session.getAttribute("user");
  List<Event> events = (List<Event>) request.getAttribute("events");
  Event viewEvent = (Event) request.getAttribute("event");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

  // Current timestamp for display
  String currentTimestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Events</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
  <style>
    html {
      height: 100%;
    }

    body {
      min-height: 100%;
      display: flex;
      flex-direction: column;
    }

    .content-wrapper {
      flex: 1;
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
          <li class="nav-item active">
            <a class="nav-link" href="ManageEventsServlet">Events</a>
          </li>
          <li class="nav-item">
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
    <div class="d-flex justify-content-between">
      <h2>Manage Events</h2>
      <button class="btn btn-primary" onclick="showAddForm()">Add New Event</button>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger mt-3">
      <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success mt-3">
      <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <!-- Add Event Form (Initially Hidden) -->
    <div id="addEventForm" style="display: none;" class="card mt-3">
      <div class="card-header">Add New Event</div>
      <div class="card-body">
        <form action="ManageEventsServlet" method="post" onsubmit="return validateEventForm(this)">
          <input type="hidden" name="action" value="add">

          <div class="form-group">
            <label>Event Type:</label>
            <select name="eventType" class="form-control" required onchange="showTypeFields(this.value)">
              <option value="">Select Type</option>
              <option value="concert">Concert</option>
              <option value="sports">Sports</option>
              <option value="other">Other</option>
            </select>
          </div>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label>Name:</label>
                <input type="text" name="name" class="form-control" required>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label>Date:</label>
                <input type="date" name="date" class="form-control" required>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label>Venue:</label>
                <input type="text" name="venue" class="form-control" required>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label>Price ($):</label>
                <input type="number" name="price" class="form-control" step="0.01" min="0" required>
              </div>
            </div>
          </div>

          <div class="form-group">
            <label>Capacity:</label>
            <input type="number" name="capacity" class="form-control" min="1" required>
          </div>

          <div class="form-group">
            <label>Description:</label>
            <textarea name="description" class="form-control" rows="3"></textarea>
          </div>

          <!-- Type-specific fields -->
          <div id="concertFields" style="display: none;">
            <div class="form-group">
              <label>Artist:</label>
              <input type="text" name="artist" class="form-control">
            </div>

            <div class="alert alert-info">
              <p>Concerts have a mandatory 5% service fee added to the base price.</p>
            </div>

            <div class="form-group">
              <label>Discount Threshold (tickets):</label>
              <input type="number" name="discountThreshold" class="form-control" min="0" value="0">
              <small class="form-text text-muted">Minimum number of tickets for discount</small>
            </div>

            <div class="form-group">
              <label>Discount Percentage (%):</label>
              <input type="number" name="discountPercentage" class="form-control" min="0" max="100" value="0">
              <small class="form-text text-muted">Percentage discount to apply</small>
            </div>
          </div>

          <div id="sportsFields" style="display: none;">
            <div class="form-group">
              <label>Sport Type:</label>
              <input type="text" name="sportType" class="form-control">
            </div>
            <div class="form-group">
              <label>Teams:</label>
              <input type="text" name="teams" class="form-control" placeholder="Team A vs Team B">
            </div>
          </div>

          <div id="otherFields" style="display: none;">
            <div class="form-group">
              <label>Event Category:</label>
              <input type="text" name="eventCategory" class="form-control">
            </div>
            <div class="alert alert-info">
              <p>Educational events (categories with "educational", "workshop", or "seminar") receive a 5% discount.</p>
            </div>
            <div class="form-group">
              <label>Special Requirements:</label>
              <textarea name="specialRequirements" class="form-control" rows="2"></textarea>
            </div>
          </div>

          <div class="text-center">
            <button type="submit" class="btn btn-success mr-2">Save Event</button>
            <button type="button" class="btn btn-secondary" onclick="hideAddForm()">Cancel</button>
          </div>
        </form>
      </div>
    </div>

    <div class="row mt-4">
      <!-- Event List -->
      <div class="col-md-8">
        <div class="card">
          <div class="card-header">Event List</div>
          <div class="card-body">
            <% if (events != null && !events.isEmpty()) { %>
            <table class="table">
              <thead>
              <tr>
                <th>Name</th>
                <th>Date</th>
                <th>Venue</th>
                <th>Base Price</th>
                <th>Final Price</th>
                <th>Actions</th>
              </tr>
              </thead>
              <tbody>
              <% for (Event event : events) { %>
              <tr>
                <td><%= event.getName() != null ? event.getName() : "" %></td>
                <td><%= dateFormat.format(event.getDate()) %></td>
                <td><%= event.getVenue() != null ? event.getVenue() : "" %></td>
                <td>$<%= String.format("%.2f", event.getPrice()) %></td>
                <td>$<%= String.format("%.2f", event.calculateTicketPrice()) %>
                  <% if (event.getEventType().equals("Concert")) { %>
                  <span class="badge badge-info">+5%</span>
                  <% } else if (event.getEventType().equals("Other")) {
                    OtherEvent otherEvent = (OtherEvent) event;
                    if (otherEvent.getEventCategory() != null &&
                            (otherEvent.getEventCategory().toLowerCase().contains("educational") ||
                                    otherEvent.getEventCategory().toLowerCase().contains("workshop") ||
                                    otherEvent.getEventCategory().toLowerCase().contains("seminar"))) { %>
                  <span class="badge badge-success">-5%</span>
                  <% }} %>
                </td>
                <td>
                  <a href="ManageEventsServlet?action=view&eventId=<%= event.getId() %>"
                     class="btn btn-sm btn-info">View</a>
                  <form action="ManageEventsServlet" method="post" style="display:inline;">
                    <input type="hidden" name="eventId" value="<%= event.getId() %>">
                    <input type="hidden" name="action" value="delete">
                    <button type="submit" class="btn btn-sm btn-danger"
                            onclick="return confirm('Delete this event?');">Delete</button>
                  </form>
                </td>
              </tr>
              <% } %>
              </tbody>
            </table>
            <% } else { %>
            <p>No events found.</p>
            <% } %>
          </div>
        </div>
      </div>

      <!-- Event Details -->
      <div class="col-md-4">
        <div class="card">
          <div class="card-header">Event Details</div>
          <div class="card-body">
            <% if (viewEvent != null) { %>
            <h4><%= viewEvent.getName() != null ? viewEvent.getName() : "" %></h4>
            <p><b>Date:</b> <%= dateFormat.format(viewEvent.getDate()) %></p>
            <p><b>Venue:</b> <%= viewEvent.getVenue() != null ? viewEvent.getVenue() : "" %></p>
            <p><b>Description:</b> <%= viewEvent.getDescription() != null ? viewEvent.getDescription() : "" %></p>

            <!-- Updated pricing information -->
            <p><b>Base Price:</b> $<%= String.format("%.2f", viewEvent.getPrice()) %></p>

            <% if (viewEvent.getEventType().equals("Concert")) { %>
            <p><b>Service Fee:</b> 5% added to base price</p>
            <p><b>Final Ticket Price:</b> $<%= String.format("%.2f", viewEvent.calculateTicketPrice()) %></p>
            <% } else if (viewEvent.getEventType().equals("Other")) {
              OtherEvent otherEvent = (OtherEvent) viewEvent;
              boolean isEducational = otherEvent.getEventCategory() != null &&
                      (otherEvent.getEventCategory().toLowerCase().contains("educational") ||
                              otherEvent.getEventCategory().toLowerCase().contains("workshop") ||
                              otherEvent.getEventCategory().toLowerCase().contains("seminar"));
              if (isEducational) { %>
            <p><b>Educational Discount:</b> 5% off base price</p>
            <p><b>Final Ticket Price:</b> $<%= String.format("%.2f", viewEvent.calculateTicketPrice()) %></p>
            <% } else { %>
            <p><b>Final Ticket Price:</b> $<%= String.format("%.2f", viewEvent.getPrice()) %></p>
            <% }} else { %>
            <p><b>Final Ticket Price:</b> $<%= String.format("%.2f", viewEvent.getPrice()) %></p>
            <% } %>

            <p><b>Capacity:</b> <%= viewEvent.getCapacity() %></p>
            <p><b>Available:</b> <%= viewEvent.getAvailableSeats() %></p>

            <% if (viewEvent instanceof Concert) { %>
            <% Concert concert = (Concert) viewEvent; %>
            <hr>
            <p><b>Artist:</b> <%= concert.getArtist() != null ? concert.getArtist() : "" %></p>
            <% if (concert.getDiscountThreshold() > 0) { %>
            <p><b>Discount:</b> <%= concert.getDiscountPercentage() %>% off when buying <%= concert.getDiscountThreshold() %>+ tickets</p>
            <% } else { %>
            <p><b>Discount:</b> None</p>
            <% } %>
            <% } else if (viewEvent instanceof Sports) { %>
            <% Sports sports = (Sports) viewEvent; %>
            <hr>
            <p><b>Sport:</b> <%= sports.getSportType() != null ? sports.getSportType() : "" %></p>
            <p><b>Teams:</b> <%= sports.getTeams() != null ? sports.getTeams() : "" %></p>
            <% } else if (viewEvent instanceof OtherEvent) { %>
            <% OtherEvent otherEvent = (OtherEvent) viewEvent; %>
            <hr>
            <p><b>Category:</b> <%= otherEvent.getEventCategory() != null ? otherEvent.getEventCategory() : "" %></p>
            <p><b>Requirements:</b> <%= otherEvent.getSpecialRequirements() != null && !otherEvent.getSpecialRequirements().isEmpty() ? otherEvent.getSpecialRequirements() : "None" %></p>
            <% } %>

            <div class="mt-3">
              <button class="btn btn-warning" onclick="showEditForm()">Edit Event</button>
            </div>

            <!-- Edit Form (Initially Hidden) -->
            <div id="editEventForm" style="display: none;" class="mt-3">
              <hr>
              <h5>Edit Event</h5>
              <form action="ManageEventsServlet" method="post" onsubmit="return validateEventForm(this)">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="eventId" value="<%= viewEvent.getId() %>">

                <div class="form-group">
                  <label>Name:</label>
                  <input type="text" name="name" class="form-control" value="<%= viewEvent.getName() != null ? viewEvent.getName() : "" %>" required>
                </div>

                <div class="form-group">
                  <label>Description:</label>
                  <textarea name="description" class="form-control" rows="2"><%= viewEvent.getDescription() != null ? viewEvent.getDescription() : "" %></textarea>
                </div>

                <div class="form-group">
                  <label>Venue:</label>
                  <input type="text" name="venue" class="form-control" value="<%= viewEvent.getVenue() != null ? viewEvent.getVenue() : "" %>" required>
                </div>

                <div class="form-group">
                  <label>Date:</label>
                  <input type="date" name="date" class="form-control" value="<%= dateFormat.format(viewEvent.getDate()) %>" required>
                </div>

                <div class="form-group">
                  <label>Price ($):</label>
                  <input type="number" name="price" class="form-control" step="0.01" min="0"
                         value="<%= viewEvent.getPrice() %>" required>
                </div>

                <div class="form-group">
                  <label>Capacity:</label>
                  <input type="number" name="capacity" class="form-control" min="<%= viewEvent.getBookedSeats() %>"
                         value="<%= viewEvent.getCapacity() %>" required>
                </div>

                <!-- Type-specific edit fields -->
                <% if (viewEvent instanceof Concert) { %>
                <% Concert concert = (Concert) viewEvent; %>
                <div class="form-group">
                  <label>Artist:</label>
                  <input type="text" name="artist" class="form-control" value="<%= concert.getArtist() != null ? concert.getArtist() : "" %>">
                </div>

                <div class="alert alert-info">
                  <p>Concerts have a mandatory 5% service fee added to the base price.</p>
                </div>

                <div class="form-group">
                  <label>Discount Threshold (tickets):</label>
                  <input type="number" name="discountThreshold" class="form-control" min="0"
                         value="<%= concert.getDiscountThreshold() %>">
                </div>

                <div class="form-group">
                  <label>Discount Percentage (%):</label>
                  <input type="number" name="discountPercentage" class="form-control" min="0" max="100"
                         value="<%= concert.getDiscountPercentage() %>">
                </div>
                <% } else if (viewEvent instanceof Sports) { %>
                <% Sports sports = (Sports) viewEvent; %>
                <div class="form-group">
                  <label>Sport Type:</label>
                  <input type="text" name="sportType" class="form-control" value="<%= sports.getSportType() != null ? sports.getSportType() : "" %>">
                </div>
                <div class="form-group">
                  <label>Teams:</label>
                  <input type="text" name="teams" class="form-control" value="<%= sports.getTeams() != null ? sports.getTeams() : "" %>">
                </div>
                <% } else if (viewEvent instanceof OtherEvent) { %>
                <% OtherEvent otherEvent = (OtherEvent) viewEvent; %>
                <div class="form-group">
                  <label>Event Category:</label>
                  <input type="text" name="eventCategory" class="form-control"
                         value="<%= otherEvent.getEventCategory() != null ? otherEvent.getEventCategory() : "" %>">
                </div>

                <div class="alert alert-info">
                  <p>Educational events (categories with "educational", "workshop", or "seminar") receive a 5% discount.</p>
                </div>

                <div class="form-group">
                  <label>Special Requirements:</label>
                  <textarea name="specialRequirements" class="form-control" rows="2"><%= otherEvent.getSpecialRequirements() != null ? otherEvent.getSpecialRequirements() : "" %></textarea>
                </div>
                <% } %>

                <div class="text-center">
                  <button type="submit" class="btn btn-warning mr-2">Update Event</button>
                  <button type="button" class="btn btn-secondary" onclick="hideEditForm()">Cancel</button>
                </div>
              </form>
            </div>
            <% } else { %>
            <p class="text-center">Select an event to view details</p>
            <% } %>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<footer>
  <p class="mb-0">Event Ticket Booking System &copy; 2025 </p>
</footer>

<script>
  function showAddForm() {
    document.getElementById('addEventForm').style.display = 'block';
  }

  function hideAddForm() {
    document.getElementById('addEventForm').style.display = 'none';
  }

  function showEditForm() {
    document.getElementById('editEventForm').style.display = 'block';
  }

  function hideEditForm() {
    document.getElementById('editEventForm').style.display = 'none';
  }

  function showTypeFields(eventType) {
    document.getElementById('concertFields').style.display = 'none';
    document.getElementById('sportsFields').style.display = 'none';
    document.getElementById('otherFields').style.display = 'none';

    if (eventType === 'concert') {
      document.getElementById('concertFields').style.display = 'block';
    } else if (eventType === 'sports') {
      document.getElementById('sportsFields').style.display = 'block';
    } else if (eventType === 'other') {
      document.getElementById('otherFields').style.display = 'block';
    }
  }

  // Add form validation
  function validateEventForm(form) {
    const eventType = form.eventType ? form.eventType.value : null;

    // Validate common fields
    if (form.name && !form.name.value.trim()) {
      alert("Event name is required");
      return false;
    }

    if (form.venue && !form.venue.value.trim()) {
      alert("Venue is required");
      return false;
    }

    if (form.date && !form.date.value) {
      alert("Date is required");
      return false;
    }

    if (form.price && (isNaN(parseFloat(form.price.value)) || parseFloat(form.price.value) <= 0)) {
      alert("Price must be greater than zero");
      return false;
    }

    if (form.capacity && (isNaN(parseInt(form.capacity.value)) || parseInt(form.capacity.value) <= 0)) {
      alert("Capacity must be greater than zero");
      return false;
    }

    // If this is the add form with event type selection
    if (eventType) {
      // Validate type-specific required fields
      if (eventType === 'concert') {
        if (form.artist && !form.artist.value.trim()) {
          alert("Artist name is required for concert events");
          return false;
        }
      }

      if (eventType === 'sports') {
        if (form.sportType && !form.sportType.value.trim()) {
          alert("Sport type is required for sports events");
          return false;
        }
      }

      if (eventType === 'other') {
        if (form.eventCategory && !form.eventCategory.value.trim()) {
          alert("Event category is required for 'other' event types");
          return false;
        }
      }
    }

    // Ensure all form values have defaults to prevent null values
    initializeFormDefaults(form);

    return true;
  }

  // Initialize all form values to ensure no nulls
  function initializeFormDefaults(form) {
    // Set default value for description if empty
    if (form.description && !form.description.value) {
      form.description.value = "";
    }

    // Handle type-specific fields
    if (form.artist && !form.artist.value) {
      form.artist.value = "";
    }

    if (form.discountThreshold && !form.discountThreshold.value) {
      form.discountThreshold.value = "0";
    }

    if (form.discountPercentage && !form.discountPercentage.value) {
      form.discountPercentage.value = "0";
    }

    if (form.sportType && !form.sportType.value) {
      form.sportType.value = "";
    }

    if (form.teams && !form.teams.value) {
      form.teams.value = "";
    }

    if (form.eventCategory && !form.eventCategory.value) {
      form.eventCategory.value = "";
    }

    if (form.specialRequirements && !form.specialRequirements.value) {
      form.specialRequirements.value = "";
    }
  }

  // Call this when document loads
  document.addEventListener('DOMContentLoaded', function() {
    // Initialize forms with default values
    const addForm = document.querySelector('#addEventForm form');
    if (addForm) {
      initializeFormDefaults(addForm);
    }

    const editForm = document.querySelector('#editEventForm form');
    if (editForm) {
      initializeFormDefaults(editForm);
    }
  });
</script>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>