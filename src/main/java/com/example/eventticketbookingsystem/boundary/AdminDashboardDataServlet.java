package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.AdminController;
import com.example.eventticketbookingsystem.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;


// Servlet to provide dashboard data for admins via AJAX
@WebServlet("/AdminDashboardDataServlet")
public class AdminDashboardDataServlet extends HttpServlet {

    // Controller used to fetch admin and user data
    private AdminController adminController = new AdminController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session without creating a new one
        HttpSession session = request.getSession(false);
        // Check if a user is logged in and is an Admin
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            // Unauthorized access - return 403 Forbidden
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Retrieve dashboard statistics from the AdminController
        int userCount = adminController.getAllUsers().size();   // Total registered users
        int adminCount = adminController.getAllAdmins().size(); // Total admin accounts

        // Placeholder values (to be fetched from relevant services/controllers in the future)
        int eventCount = 0;       // Total events
        int bookingCount = 0;     // Total bookings
        double revenue = 0.0;     // Total revenue

        // Format the current timestamp for the "last updated" label
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String lastUpdate = dateFormat.format(new Date());

        // Set response content type to HTML
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Begin HTML content generation
        out.println("<div class='row'>");

        // User Count Card
        out.println("<div class='col-md-4'>");
        out.println("<div class='card bg-primary text-white mb-4'>");
        out.println("<div class='card-body'>");
        out.println("<h2>" + userCount + "</h2>");
        out.println("<h5>Registered Users</h5>");
        out.println("</div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='ManageUsersServlet' class='text-white'>View Details</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div>");
        out.println("</div>");
        out.println("</div>");

        // Admin Count Card
        out.println("<div class='col-md-4'>");
        out.println("<div class='card bg-warning text-dark mb-4'>");
        out.println("<div class='card-body'>");
        out.println("<h2>" + adminCount + "</h2>");
        out.println("<h5>Admin Accounts</h5>");
        out.println("</div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<span class='text-dark'>System Administrators</span>");
        out.println("</div>");
        out.println("</div>");
        out.println("</div>");

        // Event Count Card
        out.println("<div class='col-md-4'>");
        out.println("<div class='card bg-success text-white mb-4'>");
        out.println("<div class='card-body'>");
        out.println("<h2>" + eventCount + "</h2>");
        out.println("<h5>Events</h5>");
        out.println("</div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='#' class='text-white'>View Details</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div>");
        out.println("</div>");
        out.println("</div>");

        out.println("</div>"); // End of first row

        out.println("<div class='row'>");

        // Booking Count Card
        out.println("<div class='col-md-6'>");
        out.println("<div class='card bg-info text-white mb-4'>");
        out.println("<div class='card-body'>");
        out.println("<h2>" + bookingCount + "</h2>");
        out.println("<h5>Total Bookings</h5>");
        out.println("</div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='#' class='text-white'>View Bookings</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div>");
        out.println("</div>");
        out.println("</div>");

        // Revenue Card
        out.println("<div class='col-md-6'>");
        out.println("<div class='card bg-danger text-white mb-4'>");
        out.println("<div class='card-body'>");
        out.println("<h2>$" + String.format("%.2f", revenue) + "</h2>");
        out.println("<h5>Total Revenue</h5>");
        out.println("</div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='#' class='text-white'>View Reports</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div>");
        out.println("</div>");
        out.println("</div>");

        out.println("</div>"); // End of second row

        // Display the last updated timestamp
        out.println("<div class='text-muted small mt-2'>Last updated: " + lastUpdate + "</div>");
    }
}
