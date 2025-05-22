<%-- File: adminDashboard.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.eventticketbookingsystem.model.Admin" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("user") == null || session.getAttribute("isAdmin") == null ||
            !(Boolean)session.getAttribute("isAdmin")) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    Admin admin = (Admin) session.getAttribute("user");


%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
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
        body {
            background-color: #f5f5f5;
        }

        /* New dashboard card styles with icons */
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            transition: all 0.3s ease;
            background-color: #fff;
            overflow: hidden;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }
        .card-header-custom {
            padding: 0;
        }
        .card-header-custom .icon-area {
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card-header-custom .icon {
            font-size: 2.5rem;
            color: #fff;
        }
        .card-content {
            padding: 20px;
        }
        .card-content h5 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 5px;
        }
        .card-content p {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        .card-content .data-count {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            display: block;
        }
        .card-actions {
            padding: 10px 20px 20px;
        }
        .card-actions .btn-action {
            border-radius: 20px;
            padding: 8px 20px;
            font-weight: 500;
            font-size: 0.9rem;
        }

        /* Background colors */
        .bg-user {
            background-color: #0d6efd;
        }
        .bg-event {
            background-color: #28a745;
        }
        .bg-booking {
            background-color: #ffc107;
        }
        .bg-payment {
            background-color: #17a2b8;
        }
        .bg-feedback {
            background-color: #6c757d;
        }

        /* Text colors to match backgrounds */
        .text-user {
            color: #0d6efd;
        }
        .text-event {
            color: #28a745;
        }
        .text-booking {
            color: #ffc107;
        }
        .text-payment {
            color: #17a2b8;
        }
        .text-feedback {
            color: #6c757d;
        }

        /* System Overview section */
        .system-overview h2 {
            margin-bottom: 1rem;
            font-weight: 300;
            font-size: 1.8rem;
        }
        .stat-card {
            text-align: center;
            padding: 1.5rem 1rem;
            border-radius: 8px;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .stat-label {
            text-transform: uppercase;
            color: #6c757d;
            font-size: 0.9rem;
            letter-spacing: 1px;
        }
        .stat-users {
            color: #0d6efd;
        }
        .stat-events {
            color: #28a745;
        }
        .stat-bookings {
            color: #17a2b8;
        }
        .stat-revenue {
            color: #dc3545;
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
                    <li class="nav-item active">
                        <a class="nav-link" href="adminDashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
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

<div class="container mt-4">
    <div class="jumbotron">
        <h1>Welcome, Admin!</h1>
        <p class="lead">This is the admin dashboard for the Event Ticket Booking System.</p>
    </div>

    <!-- New Management Cards with Icons -->
    <div class="row">
        <!-- User Management Card -->
        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="card-header-custom d-flex">
                    <div class="icon-area bg-user flex-shrink-0">
                        <i class="icon fas fa-users"></i>
                    </div>
                    <div class="card-content flex-grow-1">
                        <h5>User Management</h5>
                        <p>Add, edit, or remove users from the system</p>
                        <span class="data-count text-user" id="userCountCard">2</span>
                        <small class="text-muted">Total registered users</small>
                    </div>
                </div>
                <div class="card-actions">
                    <a href="ManageUsersServlet" class="btn btn-outline-primary btn-action">
                        <i class="fas fa-cog mr-1"></i> Manage Users
                    </a>
                </div>
            </div>
        </div>

        <!-- Event Management Card -->
        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="card-header-custom d-flex">
                    <div class="icon-area bg-event flex-shrink-0">
                        <i class="icon fas fa-calendar-alt"></i>
                    </div>
                    <div class="card-content flex-grow-1">
                        <h5>Event Management</h5>
                        <p>Create, edit, or cancel events</p>
                        <span class="data-count text-event" id="eventCountCard">3</span>
                        <small class="text-muted">Total events</small>
                    </div>
                </div>
                <div class="card-actions">
                    <a href="ManageEventsServlet" class="btn btn-outline-success btn-action">
                        <i class="fas fa-cog mr-1"></i> Manage Events
                    </a>
                </div>
            </div>
        </div>

        <!-- Booking Management Card -->
        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="card-header-custom d-flex">
                    <div class="icon-area bg-booking flex-shrink-0">
                        <i class="icon fas fa-ticket-alt"></i>
                    </div>
                    <div class="card-content flex-grow-1">
                        <h5>Booking Management</h5>
                        <p>View, update, or process booking requests</p>
                        <span class="data-count text-booking" id="bookingCountCard">5</span>
                        <small class="text-muted">Total bookings</small>
                    </div>
                </div>
                <div class="card-actions">
                    <a href="ManageBookingsServlet" class="btn btn-outline-warning btn-action">
                        <i class="fas fa-cog mr-1"></i> Manage Bookings
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Payment Management Card -->
        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="card-header-custom d-flex">
                    <div class="icon-area bg-payment flex-shrink-0">
                        <i class="icon fas fa-credit-card"></i>
                    </div>
                    <div class="card-content flex-grow-1">
                        <h5>Payment Management</h5>
                        <p>View and track all payment transactions</p>
                        <span class="data-count text-payment" id="paymentValueCard">$150.50</span>
                        <small class="text-muted">Total revenue</small>
                    </div>
                </div>
                <div class="card-actions">
                    <a href="ManagePaymentsServlet" class="btn btn-outline-info btn-action">
                        <i class="fas fa-cog mr-1"></i> Manage Payments
                    </a>
                </div>
            </div>
        </div>

        <!-- Feedback Management Card -->
        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="card-header-custom d-flex">
                    <div class="icon-area bg-feedback flex-shrink-0">
                        <i class="icon fas fa-comments"></i>
                    </div>
                    <div class="card-content flex-grow-1">
                        <h5>Feedback Management</h5>
                        <p>View and manage user feedback and ratings</p>
                        <span class="data-count text-feedback" id="feedbackCountCard">7</span>
                        <small class="text-muted">Total feedback</small>
                    </div>
                </div>
                <div class="card-actions">
                    <a href="AdminViewFeedbacksServlet" class="btn btn-outline-secondary btn-action">
                        <i class="fas fa-cog mr-1"></i> Manage Feedback
                    </a>
                </div>
            </div>
        </div>

        <!-- Quick Stats Card -->
        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="card-header-custom d-flex">
                    <div class="icon-area bg-dark flex-shrink-0">
                        <i class="icon fas fa-chart-line"></i>
                    </div>
                    <div class="card-content flex-grow-1">
                        <h5>System Status</h5>
                        <p>Current system status and quick actions</p>
                        <div class="mt-2">
                            <span class="badge badge-success"><i class="fas fa-check-circle mr-1"></i> All Systems Operational</span>
                        </div>
                        <div class="mt-2">

                        </div>
                    </div>
                </div>
                <div class="card-actions">
                    <button class="btn btn-outline-dark btn-action" onclick="loadSystemOverview(true)">
                        <i class="fas fa-sync-alt mr-1"></i> Refresh Data
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- System Overview - Modern design -->
    <div class="card mb-4 mt-4 system-overview">
        <div class="card-header">
            <h2><i class="fas fa-tachometer-alt mr-2"></i>System Overview</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-users fa-2x mb-3 stat-users"></i>
                        <div class="stat-value stat-users" id="userCount">2</div>
                        <div class="stat-label">Registered Users</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-calendar-alt fa-2x mb-3 stat-events"></i>
                        <div class="stat-value stat-events" id="eventCount">3</div>
                        <div class="stat-label">Total Events</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-ticket-alt fa-2x mb-3 stat-bookings"></i>
                        <div class="stat-value stat-bookings" id="bookingCount">5</div>
                        <div class="stat-label">Total Bookings</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-dollar-sign fa-2x mb-3 stat-revenue"></i>
                        <div class="stat-value stat-revenue" id="paymentValue">$150.50</div>
                        <div class="stat-label">Total Revenue</div>
                    </div>
                </div>
            </div>

            <div class="alert alert-info mt-3">

            </div>
        </div>
    </div>
</div>

<!-- System Overview Modal -->
<div class="modal fade system-overview-modal" id="systemOverviewModal" tabindex="-1" role="dialog" aria-labelledby="systemOverviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="systemOverviewModalLabel"><i class="fas fa-tachometer-alt mr-2"></i>System Overview</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="systemOverviewContent">
                <!-- Content will be loaded via AJAX -->
                <div class="text-center">
                    <div class="spinner-border text-primary" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                    <p>Loading system data...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="loadSystemOverview(true)">
                    <i class="fas fa-sync-alt mr-1"></i> Refresh Data
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Account Deletion Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Account Deletion</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete your admin account? This action cannot be undone.</p>
                <p>To confirm, please enter your password:</p>

                <form id="deleteForm" action="DeleteAdminServlet" method="post">
                    <div class="form-group">
                        <label for="confirmPassword">Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" form="deleteForm" class="btn btn-danger">Delete Account</button>
            </div>
        </div>
    </div>
</div>

<!-- Admin View Profile Modal -->
<div class="modal fade" id="adminProfileModal" tabindex="-1" role="dialog" aria-labelledby="adminProfileModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="adminProfileModalLabel">Admin Profile</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="text-center mb-4">
                    <i class="fas fa-user-circle fa-5x text-primary"></i>
                </div>
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label">Username:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= admin.getUsername() %></p>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label">Full Name:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= admin.getFullName() %></p>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label">Email:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= admin.getEmail() %></p>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label">Phone:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= admin.getPhoneNumber() %></p>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label">ID:</label>
                    <div class="col-sm-8">
                        <p class="form-control-plaintext"><%= admin.getId() %></p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <a href="UpdateAdminServlet" class="btn btn-primary">Edit Profile</a>
            </div>
        </div>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3 mt-5">
    <p class="mb-0">Event Ticket Booking System &copy; 2025 </p>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
        // Initialize dropdown
        $('.dropdown-toggle').dropdown();

        // Show profile modal when clicked on "Your Profile" in dropdown
        $('a[href="ViewAdminProfileServlet"]').click(function(e) {
            e.preventDefault();
            $('#adminProfileModal').modal('show');
        });

        // Load initial dashboard data
        loadSystemOverview(false);
    });

    function loadSystemOverview(showModal = false) {
        // Show the modal if requested
        if (showModal) {
            $('#systemOverviewModal').modal('show');
        }

        // AJAX request to get system data
        $.ajax({
            url: 'AdminDashboardDataServlet',
            type: 'GET',
            success: function(response) {
                // Parse the HTML response to extract data
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = response;

                // Get data from the response
                const userCard = tempDiv.querySelector('.card.bg-primary h2');
                const eventCard = tempDiv.querySelector('.card.bg-success h2');
                const bookingCard = tempDiv.querySelector('.card.bg-info h2');
                const revenueCard = tempDiv.querySelector('.card.bg-danger h2');
                const lastUpdated = tempDiv.querySelector('.text-muted.small');

                // Update dashboard UI with extracted data
                if (userCard) {
                    const userCount = userCard.textContent;
                    document.getElementById('userCount').textContent = userCount;
                    document.getElementById('userCountCard').textContent = userCount;
                }

                if (eventCard) {
                    const eventCount = eventCard.textContent;
                    document.getElementById('eventCount').textContent = eventCount;
                    document.getElementById('eventCountCard').textContent = eventCount;
                }

                if (bookingCard) {
                    const bookingCount = bookingCard.textContent;
                    document.getElementById('bookingCount').textContent = bookingCount;
                    document.getElementById('bookingCountCard').textContent = bookingCount;
                }

                if (revenueCard) {
                    const revenueValue = revenueCard.textContent;
                    document.getElementById('paymentValue').textContent = revenueValue;
                    document.getElementById('paymentValueCard').textContent = revenueValue;
                }

                // Update last updated message
                if (lastUpdated) {
                    $('#lastUpdatedMessage').text(lastUpdated.textContent);
                }

                // Update modal content if requested
                if (showModal) {
                    $('#systemOverviewContent').html(response);
                }
            },
            error: function() {
                $('#lastUpdatedMessage').text('Error loading statistics. Please try again.');
                if (showModal) {
                    $('#systemOverviewContent').html('<div class="alert alert-danger">Error loading system data. Please try again.</div>');
                }
            }
        });
    }
</script>
</body>
</html>