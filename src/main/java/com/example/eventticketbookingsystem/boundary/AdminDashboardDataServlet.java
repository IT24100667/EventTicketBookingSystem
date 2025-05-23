// Package declaration and necessary imports
package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.AdminController;
import com.example.eventticketbookingsystem.controller.EventController;
import com.example.eventticketbookingsystem.model.Admin;
import com.example.eventticketbookingsystem.model.Event;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

// This servlet handles admin dashboard data requests via AJAX calls
@WebServlet("/AdminDashboardDataServlet")
public class AdminDashboardDataServlet extends HttpServlet {

    // Controllers to interact with user/admin and event data
    private AdminController adminController = new AdminController();
    private EventController eventController = new EventController();

    // Define the path to the data directory and bookings file
    private static final String DATA_DIRECTORY = System.getProperty("user.home") +
            File.separator + "eventbookingsystem" + File.separator + "data";
    private static final String BOOKINGS_FILE = DATA_DIRECTORY + File.separator + "bookings.txt";

    // Date format used for displaying timestamps
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    // Handles GET requests to the servlet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Try to get the existing session; don't create a new one if it doesn't exist
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is an instance of Admin
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            // If not logged in as admin, return HTTP 403 Forbidden
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Get statistics from controllers and file:
        int userCount = adminController.getAllUsers().size();   // Number of registered users
        int adminCount = adminController.getAllAdmins().size(); // Number of admin accounts
        List<Event> events = eventController.getAllEvents();    // List of all events
        int eventCount = events != null ? events.size() : 0;    // Number of events

        // Get total bookings and revenue from the bookings file
        int[] bookingStats = getBookingStats();
        int bookingCount = bookingStats[0];
        double revenue = bookingStats[1];

        // Get current timestamp for "Last Updated"
        String lastUpdate = DATE_FORMAT.format(new Date());

        // Set response type to HTML so the browser knows what to expect
        response.setContentType("text/html");
        PrintWriter out = response.getWriter(); // Writer to output HTML content

        // Start generating HTML content for the dashboard cards
        out.println("<div class='row'>");

        // Card 1: Registered Users
        out.println("<div class='col-md-4'>");
        out.println("<div class='card bg-primary text-white mb-4'>");
        out.println("<div class='card-body'><h2>" + userCount + "</h2><h5>Registered Users</h5></div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='ManageUsersServlet' class='text-white'>View Details</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div></div></div>");

        // Card 2: Admin Accounts
        out.println("<div class='col-md-4'>");
        out.println("<div class='card bg-warning text-dark mb-4'>");
        out.println("<div class='card-body'><h2>" + adminCount + "</h2><h5>Admin Accounts</h5></div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<span class='text-dark'>System Administrators</span>");
        out.println("</div></div></div>");

        // Card 3: Events
        out.println("<div class='col-md-4'>");
        out.println("<div class='card bg-success text-white mb-4'>");
        out.println("<div class='card-body'><h2>" + eventCount + "</h2><h5>Events</h5></div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='ManageEventsServlet' class='text-white'>View Details</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div></div></div>");

        out.println("</div>"); // End of row 1

        // Start row 2 for bookings and revenue
        out.println("<div class='row'>");

        // Card 4: Total Bookings
        out.println("<div class='col-md-6'>");
        out.println("<div class='card bg-info text-white mb-4'>");
        out.println("<div class='card-body'><h2>" + bookingCount + "</h2><h5>Total Bookings</h5></div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='ManageBookingsServlet' class='text-white'>View Bookings</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div></div></div>");

        // Card 5: Revenue
        out.println("<div class='col-md-6'>");
        out.println("<div class='card bg-danger text-white mb-4'>");
        out.println("<div class='card-body'><h2>$" + String.format("%.2f", revenue) + "</h2><h5>Total Revenue</h5></div>");
        out.println("<div class='card-footer d-flex align-items-center justify-content-between'>");
        out.println("<a href='ManagePaymentsServlet' class='text-white'>View Reports</a>");
        out.println("<div class='small text-white'><i class='fas fa-angle-right'></i></div>");
        out.println("</div></div></div>");

        out.println("</div>"); // End of row 2

        // Show last updated time
        out.println("<div class='text-muted small mt-2'>Last updated: " + lastUpdate + "</div>");
    }


    //This method reads the bookings file and calculates:
    //1. Total number of bookings
    //2. Total revenue generated from those bookings

    //@return an int array: [bookingCount, totalRevenue (as int)]
    private int[] getBookingStats() {
        int bookingCount = 0;
        double totalRevenue = 0.0;

        File bookingsFile = new File(BOOKINGS_FILE);

        // If the file doesn't exist, return zero stats
        if (!bookingsFile.exists()) {
            // Create the data directory if it doesn't exist
            File directory = new File(DATA_DIRECTORY);
            if (!directory.exists()) {
                directory.mkdirs(); // Make directories
            }
            return new int[]{bookingCount, (int)totalRevenue};
        }

        // Read the file line by line
        try (BufferedReader reader = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                bookingCount++; // Count each line as one booking

                // Split line by "|" and try to extract the amount (6th part)
                String[] parts = line.split("\\|");
                if (parts.length >= 6) {
                    try {
                        double amount = Double.parseDouble(parts[5]);
                        totalRevenue += amount; // Add to total revenue
                    } catch (NumberFormatException e) {
                        // Ignore lines with invalid amount
                        System.err.println("Invalid amount format in booking record: " + line);
                    }
                }
            }
        } catch (IOException e) {
            // Handle file read errors
            System.err.println("Error reading bookings file: " + e.getMessage());
        }

        // Return the booking count and revenue as integers
        return new int[]{bookingCount, (int)totalRevenue};
    }
}
