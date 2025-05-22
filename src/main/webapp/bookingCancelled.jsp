<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Cancelled</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="card shadow border-0">
        <div class="card-body text-center py-5">
            <div class="mb-4">
                <i class="fas fa-check-circle text-success" style="font-size: 4rem;"></i>
            </div>
            <h2 class="alert-heading">Booking Cancelled!</h2>
            <p class="lead">Your booking has been cancelled successfully.</p>
            <hr>
            <div class="mt-4">
                <a href="userDashboard.jsp" class="btn btn-primary mr-2">
                    <i class="fas fa-home mr-1"></i> Return to Dashboard
                </a>
                <a href="ViewBookingsServlet" class="btn btn-secondary">
                    <i class="fas fa-list mr-1"></i> View My Bookings
                </a>
            </div>
        </div>
    </div>



</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/js/all.min.js"></script>
</body>
</html>