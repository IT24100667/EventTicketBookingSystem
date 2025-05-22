<%-- File: manageUsers.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Admin" %>
<%@ page import="com.example.eventticketbookingsystem.model.User" %>
<%@ page import="java.util.List" %>
<%
  // Check if admin is logged in
  if (session.getAttribute("user") == null || session.getAttribute("isAdmin") == null ||
          !(Boolean)session.getAttribute("isAdmin")) {
    response.sendRedirect("adminLogin.jsp");
    return;
  }

  Admin admin = (Admin) session.getAttribute("user");

  // Explicit casting to resolve type issues
  List<User> userList = null;
  if (request.getAttribute("userList") != null) {
    userList = (List<User>)request.getAttribute("userList");
  }

  User viewUser = null;
  if (request.getAttribute("viewUser") != null) {
    viewUser = (User)request.getAttribute("viewUser");
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Users</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  <style>
    html {
      height: 100%;
    }

    body {
      min-height: 100%;
      display: flex;
      flex-direction: column;
      background-color: #f8f9fa;
      padding-top: 20px;
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
    .card {
      box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      margin-bottom: 1.5rem;
    }
    .card-header {
      font-weight: 500;
    }
    .btn {
      margin-right: 5px;
    }
    .container {
      max-width: 1200px;
    }
    .user-details {
      border-left: 3px solid #17a2b8;
      padding-left: 15px;
    }
    .table {
      margin-bottom: 0;
    }
    .table th {
      background-color: #f8f9fa;
    }
    .navbar {
      margin-bottom: 20px;
    }
    .progress {
      height: 10px;
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
          <li class="nav-item active">
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
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2><i class="fas fa-users mr-2"></i> Manage Users</h2>
      <ol class="breadcrumb bg-transparent p-0 m-0">
      </ol>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="fas fa-exclamation-circle mr-2"></i> <%= request.getAttribute("error") %>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <% } %>

    <% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="fas fa-check-circle mr-2"></i> <%= request.getAttribute("message") %>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <% } %>

    <div class="row">
      <div class="col-lg-8">
        <div class="card">
          <div class="card-header bg-primary text-white">
            <div class="d-flex justify-content-between align-items-center">
              <h5 class="mb-0"><i class="fas fa-list mr-2"></i> User List</h5>
              <span class="badge badge-light"><%= userList != null ? userList.size() : 0 %> Users</span>
            </div>
          </div>
          <div class="card-body">
            <div id="userListContainer">
              <% if (userList != null && !userList.isEmpty()) { %>
              <div class="table-responsive">
                <table class="table table-striped table-hover">
                  <thead>
                  <tr>
                    <th scope="col">Username</th>
                    <th scope="col">Full Name</th>
                    <th scope="col">Email</th>
                    <th scope="col" class="text-center">Actions</th>
                  </tr>
                  </thead>
                  <tbody>
                  <% for (User user : userList) { %>
                  <tr>
                    <td><%= user.getUsername() %></td>
                    <td><%= user.getFullName() %></td>
                    <td><%= user.getEmail() %></td>
                    <td class="text-center">
                      <form action="ManageUsersServlet" method="post" style="display:inline;">
                        <input type="hidden" name="userId" value="<%= user.getId() %>">
                        <input type="hidden" name="action" value="view">
                        <button type="submit" class="btn btn-info btn-sm">
                          <i class="fas fa-eye"></i> View
                        </button>
                      </form>

                      <form action="ManageUsersServlet" method="post" style="display:inline;"
                            onsubmit="return confirm('Are you sure you want to delete this user?')">
                        <input type="hidden" name="userId" value="<%= user.getId() %>">
                        <input type="hidden" name="action" value="delete">
                        <button type="submit" class="btn btn-danger btn-sm">
                          <i class="fas fa-trash"></i> Delete
                        </button>
                      </form>
                    </td>
                  </tr>
                  <% } %>
                  </tbody>
                </table>
              </div>
              <% } else { %>
              <div class="alert alert-info">
                <i class="fas fa-info-circle mr-2"></i> No users found in the system.
              </div>
              <% } %>
            </div>
          </div>
          <div class="card-footer text-muted">
            <small><i class="fas fa-sync-alt mr-1"></i> User list updates automatically every 30 seconds</small>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="card">
          <div class="card-header bg-info text-white">
            <h5 class="mb-0"><i class="fas fa-user-circle mr-2"></i> User Details</h5>
          </div>
          <div class="card-body">
            <% if (viewUser != null) { %>
            <div class="user-details">
              <h4><%= viewUser.getFullName() %></h4>
              <p class="text-muted mb-4">User ID: <%= viewUser.getId() %></p>

              <div class="mb-3">
                <div class="d-flex justify-content-between">
                  <strong><i class="fas fa-user mr-2"></i> Username:</strong>
                  <span><%= viewUser.getUsername() %></span>
                </div>
              </div>

              <div class="mb-3">
                <div class="d-flex justify-content-between">
                  <strong><i class="fas fa-envelope mr-2"></i> Email:</strong>
                  <span><%= viewUser.getEmail() %></span>
                </div>
              </div>

              <div class="mb-3">
                <div class="d-flex justify-content-between">
                  <strong><i class="fas fa-phone mr-2"></i> Phone:</strong>
                  <span><%= viewUser.getPhoneNumber() %></span>
                </div>
              </div>

              <div class="alert alert-light mt-4">
                <h6><i class="fas fa-info-circle mr-2"></i> User Activity</h6>
                <p class="mb-0 text-muted">User activity tracking coming soon...</p>
              </div>
            </div>
            <% } else { %>
            <div class="text-center py-4">
              <i class="fas fa-user-circle fa-5x text-muted mb-3"></i>
              <p class="text-muted">Select a user to view details</p>
            </div>
            <% } %>
          </div>
        </div>

        <div class="card mt-3">
          <div class="card-header bg-warning text-dark">
            <h5 class="mb-0"><i class="fas fa-chart-pie mr-2"></i> User Statistics</h5>
          </div>
          <div class="card-body">
            <div class="mb-3">
              <div class="d-flex justify-content-between mb-1">
                <span>Total Regular Users</span>
                <strong><%= userList != null ? userList.size() : 0 %></strong>
              </div>
              <div class="progress">
                <div class="progress-bar bg-primary" role="progressbar" style="width: 100%"></div>
              </div>
            </div>

            <div class="mb-3">
              <div class="d-flex justify-content-between mb-1">
                <span>Active Users (Last 30 days)</span>
                <strong>0</strong> <!-- Placeholder -->
              </div>
              <div class="progress">
                <div class="progress-bar bg-success" role="progressbar" style="width: 0%"></div>
              </div>
            </div>

            <div class="alert alert-secondary mt-3">
              <p class="mb-0 small"><i class="fas fa-lightbulb mr-1"></i> Tip: Use the dashboard to view more detailed statistics and generate reports.</p>
            </div>
          </div>
        </div>

        <a href="adminDashboard.jsp" class="btn btn-secondary btn-block mt-3 mb-5">
          <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
        </a>
      </div>
    </div>
  </div>
</div>

<!-- Normal footer that appears at the bottom of content -->
<footer>
  <div class="container">
    <p class="mb-0">Event Ticket Booking System &copy; 2025 </p>
  </div>
</footer>

<script>
  // Function to refresh user list every 30 seconds using AJAX
  function refreshUserList() {
    $.ajax({
      url: 'AdminUsersListServlet',
      type: 'GET',
      success: function(data) {
        $('#userListContainer').html(data);
      },
      error: function() {
        $('#userListContainer').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle mr-2"></i> Error refreshing user list. Please try again.</div>');
      }
    });
  }

  // Refresh every 30 seconds
  $(document).ready(function() {
    setInterval(refreshUserList, 30000);
  });
</script>
</body>
</html>