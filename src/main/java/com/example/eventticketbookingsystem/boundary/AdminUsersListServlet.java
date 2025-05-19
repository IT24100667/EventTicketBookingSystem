package com.example.eventticketbookingsystem.boundary;


import com.example.eventticketbookingsystem.controller.AdminController;
import com.example.eventticketbookingsystem.model.Admin;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

// Servlet for AJAX user listing for admin dashboard
//This servlet returns a list of users in HTML format to be loaded via AJAX
@WebServlet("/AdminUsersListServlet") // This servlet is triggered when /AdminUsersListServlet is accessed
public class AdminUsersListServlet extends HttpServlet {

    // This controller handles operations related to admin actions (like getting users)
    private AdminController adminController = new AdminController();

    // This method runs when the page or JavaScript sends a GET request
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if an admin is logged in
        HttpSession session = request.getSession(false); // false means don't create a session if it doesn't exist
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            // If not logged in or not an admin, return 403 Forbidden status
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Get the list of all registered users from the controller
        List<User> userList = adminController.getAllUsers();

        // Set the type of response as HTML (because we will return HTML content)
        response.setContentType("text/html");
        PrintWriter out = response.getWriter(); // Used to write HTML to the response

        // Start building the HTML table
        out.println("<table class='table table-striped'>");
        out.println("<thead><tr><th>ID</th><th>Username</th><th>Full Name</th><th>Email</th><th>Actions</th></tr></thead>");
        out.println("<tbody>");

        // Loop through each user and display their information in a table row
        for (User user : userList) {
            out.println("<tr>");
            out.println("<td>" + user.getId() + "</td>");           // User ID
            out.println("<td>" + user.getUsername() + "</td>");     // Username
            out.println("<td>" + user.getFullName() + "</td>");     // Full name
            out.println("<td>" + user.getEmail() + "</td>");        // Email
            out.println("<td>");

            // "View" button form
            out.println("<form action='ManageUsersServlet' method='post' style='display:inline;'>");
            out.println("<input type='hidden' name='userId' value='" + user.getId() + "'>"); // Send user ID
            out.println("<input type='hidden' name='action' value='view'>");                 // Action = view
            out.println("<button type='submit' class='btn btn-info btn-sm'>View</button>");  // Submit button
            out.println("</form> ");

            // "Delete" button form with confirmation
            out.println("<form action='ManageUsersServlet' method='post' style='display:inline;' onsubmit='return confirm(\"Are you sure you want to delete this user?\")'>");
            out.println("<input type='hidden' name='userId' value='" + user.getId() + "'>");  // Send user ID
            out.println("<input type='hidden' name='action' value='delete'>");               // Action = delete
            out.println("<button type='submit' class='btn btn-danger btn-sm'>Delete</button>"); // Submit button
            out.println("</form>");

            out.println("</td>");
            out.println("</tr>");
        }

        // Close the table
        out.println("</tbody>");
        out.println("</table>");
    }
}
