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

// Servlet for handling admin profile updates
@WebServlet("/UpdateAdminServlet")
public class UpdateAdminServlet extends HttpServlet {

    // Controller to interact with admin data (like updating profile info)
    private AdminController adminController = new AdminController();

    // Handles form submission (POST) when the admin updates their profile
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            // If not logged in, redirect to login page
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        // Get the currently logged-in admin from the session
        Admin currentAdmin = (Admin) session.getAttribute("user");

        // Get updated values from the form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        // Validate input: check if any required field is empty
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            // If any field is missing, show error and go back to profile edit page
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("editAdminProfile.jsp").forward(request, response);
            return;
        }

        // Try to update the admin's info in the system
        boolean success = adminController.updateAdmin(
                currentAdmin.getId(), username, password, fullName, email, phoneNumber);

        if (success) {
            // If update is successful, get the updated admin object
            Admin updatedAdmin = adminController.getAdminById(currentAdmin.getId());

            // Update the session with new info
            session.setAttribute("user", updatedAdmin);
            session.setAttribute("username", updatedAdmin.getUsername());

            // Show success message and go to dashboard
            request.setAttribute("message", "Profile updated successfully");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        } else {
            // If update failed (maybe username already exists), show error
            request.setAttribute("error", "Failed to update profile. Username may already be taken.");
            request.getRequestDispatcher("editAdminProfile.jsp").forward(request, response);
        }
    }

    // If someone visits the servlet via GET request (e.g., clicking "Edit Profile")
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            // Not logged in, send to login page
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        // If logged in, forward to the edit profile page
        request.getRequestDispatcher("editAdminProfile.jsp").forward(request, response);
    }
}

