<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Booking" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Check if user is logged in
  if (session.getAttribute("user") == null) {
    response.sendRedirect("userLogin.jsp");
    return;
  }

  User user = (User) session.getAttribute("user");
  Booking booking = (Booking) request.getAttribute("booking");

  if (booking == null) {
    String bookingId = (String) session.getAttribute("currentBookingId");
    if (bookingId == null) {
      response.sendRedirect("ViewBookingsServlet");
      return;
    }
  }

  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Card Payment</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
  <style>
    .payment-details {
      background-color: #f9f9f9;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 20px;
    }
    .detail-row {
      display: flex;
      margin-bottom: 12px;
    }
    .label {
      font-weight: bold;
      width: 150px;
      color: #555;
    }
    .value {
      color: #333;
      font-weight: 500;
    }
    .card-form {
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      padding: 20px;
      margin-top: 15px;
    }
    .invalid-feedback {
      display: block;
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
        <li class="nav-item ">
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
  <div class="row">
    <div class="col-md-8 offset-md-2">
      <div class="card shadow">
        <div class="card-header bg-primary text-white">
          <h4><i class="fas fa-credit-card mr-2"></i>Card Payment</h4>
        </div>

        <div class="card-body">
          <% if (request.getAttribute("error") != null) { %>
          <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
          </div>
          <% } %>

          <div class="payment-details">
            <h5 class="mb-3">Booking Summary</h5>
            <div class="detail-row">
              <span class="label">Booking ID:</span>
              <span class="value" id="bookingId"><%= booking.getId() %></span>
            </div>
            <div class="detail-row">
              <span class="label">Amount:</span>
              <span class="value" id="totalAmount">$<%= String.format("%.2f", booking.getTotalPrice()) %></span>
            </div>
          </div>

          <form id="cardPaymentForm" action="PaymentProcessServlet" method="post">
            <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
            <input type="hidden" name="paymentMethod" value="CARD">

            <div class="card-form">
              <div class="form-group">
                <label for="cardNumber">Card Number</label>
                <input type="text" class="form-control" id="cardNumber" name="cardNumber"
                       placeholder="1234 5678 9012 3456" maxlength="19" autocomplete="cc-number" required>
              </div>
              <div class="row">
                <div class="col-md-6">
                  <div class="form-group">
                    <label for="expiryDate">Expiry Date (MM/YY)</label>
                    <input type="text" class="form-control" id="expiryDate" name="expiryDate"
                           placeholder="MM/YY" maxlength="5" autocomplete="cc-exp" required>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-group">
                    <label for="cvv">CVV</label>
                    <input type="password" class="form-control" id="cvv" name="cvv"
                           placeholder="123" maxlength="3" autocomplete="cc-csc" required>
                  </div>
                </div>
              </div>
              <div class="form-group">
                <label for="nameOnCard">Name on Card</label>
                <input type="text" class="form-control" id="nameOnCard" name="nameOnCard"
                       placeholder="John Doe" autocomplete="cc-name" required>
              </div>
            </div>


            <div class="text-center mt-4">
              <button type="submit" class="btn btn-success">
                <i class="fas fa-check mr-2"></i>Confirm Payment
              </button>
              <a href="PaymentFormServlet?bookingId=<%= booking.getId() %>" class="btn btn-secondary ml-2">
                <i class="fas fa-arrow-left mr-2"></i>Back
              </a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Updated Footer with Blue Line and Current Time/User -->
<footer class="bg-dark text-white text-center py-3 mt-5">
  <p class="mb-0">Event Ticket Booking System &copy; 2025</p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
  $(document).ready(function() {
    // Card Number validation - 16 digits only
    $('#cardNumber').on('input', function() {
      // Remove any non-digit characters
      let value = $(this).val().replace(/\D/g, '');

      // Limit to 16 digits
      if (value.length > 16) {
        value = value.substring(0, 16);
      }

      // Format with spaces for readability
      const parts = [];
      for (let i = 0; i < value.length; i += 4) {
        parts.push(value.substring(i, i + 4));
      }
      $(this).val(parts.join(' '));

      // Validate length
      validateCardField(this, value.length === 16, 'Card number must be 16 digits');
    });

    // Expiry Date validation - MM/YY format (MM: 1-12, YY: 0-99)
    $('#expiryDate').on('input', function() {
      let value = $(this).val().replace(/\D/g, '');

      // Limit to 4 digits total (MMYY)
      if (value.length > 4) {
        value = value.substring(0, 4);
      }

      // Format as MM/YY
      if (value.length > 2) {
        $(this).val(value.substring(0, 2) + '/' + value.substring(2));
      } else {
        $(this).val(value);
      }

      // Validate MM is between 01-12
      let isValid = true;
      let message = '';

      if (value.length >= 2) {
        const month = parseInt(value.substring(0, 2));
        if (month < 1 || month > 12) {
          isValid = false;
          message = 'Month must be between 01-12';
        }
      }

      validateCardField(this, isValid, message);
    }).on('blur', function() {
      if ($(this).val().length > 0 && $(this).val().length < 5) {
        validateCardField(this, false, 'Please enter a complete expiry date');
      }
    });

    // CVV validation - 3 digits only
    $('#cvv').on('input', function() {
      // Remove any non-digit characters
      let value = $(this).val().replace(/\D/g, '');

      // Limit to 3 digits
      if (value.length > 3) {
        value = value.substring(0, 3);
      }

      $(this).val(value);

      // Validate length
      validateCardField(this, value.length === 3, 'CVV must be 3 digits');
    });

    // Name on card validation
    $('#nameOnCard').on('input', function() {
      validateCardField(this, $(this).val().trim().length > 0, 'Please enter the name on card');
    });

    // Form submission validation
    $('#cardPaymentForm').on('submit', function(e) {
      const cardNumber = $('#cardNumber').val().replace(/\D/g, '');
      const expiryDate = $('#expiryDate').val();
      const cvv = $('#cvv').val();
      const nameOnCard = $('#nameOnCard').val();

      let isValid = true;

      // Validate card number
      if (cardNumber.length !== 16) {
        validateCardField($('#cardNumber')[0], false, 'Card number must be 16 digits');
        isValid = false;
      }

      // Validate expiry date
      if (expiryDate.length < 5) {
        validateCardField($('#expiryDate')[0], false, 'Please enter a complete expiry date');
        isValid = false;
      } else {
        const month = parseInt(expiryDate.substring(0, 2));
        if (month < 1 || month > 12) {
          validateCardField($('#expiryDate')[0], false, 'Month must be between 01-12');
          isValid = false;
        }
      }

      // Validate CVV
      if (cvv.length !== 3) {
        validateCardField($('#cvv')[0], false, 'CVV must be 3 digits');
        isValid = false;
      }

      // Validate name
      if (nameOnCard.trim().length === 0) {
        validateCardField($('#nameOnCard')[0], false, 'Please enter the name on card');
        isValid = false;
      }

      if (!isValid) {
        e.preventDefault(); // Prevent form submission if validation fails
      }
    });
  });

  // Helper function to validate card fields and show errors
  function validateCardField(field, isValid, errorMessage) {
    // Remove any existing error message
    const existingError = $(field).siblings('.invalid-feedback');
    if (existingError.length > 0) {
      existingError.remove();
    }

    // Add/remove invalid class
    if (!isValid) {
      $(field).addClass('is-invalid');

      // Create and append error message
      const errorDiv = $('<div>').addClass('invalid-feedback').text(errorMessage);
      $(field).after(errorDiv);
    } else {
      $(field).removeClass('is-invalid');
    }
  }
</script>
</body>
</html>