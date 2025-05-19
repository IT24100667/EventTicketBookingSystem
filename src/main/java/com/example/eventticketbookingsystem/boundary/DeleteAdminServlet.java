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

// Servlet for handling admin account deletion
// This servlet deletes the currently logged-in admin's account after password confirmation
@WebServlet("/DeleteAdminServlet") // This servlet runs when /DeleteAdminServlet is accessed
public class DeleteAdminServlet extends HttpServlet {

    // Create an instance of the controller that manages admin-related operations
    private AdminController adminController = new AdminController();

    // Handles POST requests (like when a form is submitted)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the admin is logged in
        HttpSession session = request.getSession(false); // Don't create a new session if one doesn't exist
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            // If not logged in or not an admin, redirect to the login page
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        // Get the currently logged-in admin's details
        Admin currentAdmin = (Admin) session.getAttribute("user");

        // Get the password input from the form to confirm deletion
        String confirmPassword = request.getParameter("confirmPassword");

        // Check if the entered password matches the admin's actual password
        if (confirmPassword != null && confirmPassword.equals(currentAdmin.getPassword())) {

            // If password matches, try to delete the admin account
            boolean success = adminController.deleteAdmin(currentAdmin.getId());

            if (success) {
                // If deletion is successful, end the current session (log out the admin)
                session.invalidate();

                // Create a new session to display a confirmation message
                session = request.getSession(true);
                session.setAttribute("message", "Your admin account has been successfully deleted.");

                // Redirect to login page with message
                response.sendRedirect("adminLogin.jsp");
            } else {
                // If deletion fails, show an error message on the dashboard
                request.setAttribute("error", "Failed to delete account. Please try again.");
                request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            }
        } else {
            // If password doesn't match, show error and cancel deletion
            request.setAttribute("error", "Incorrect password. Account deletion canceled.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        }
    }
}
