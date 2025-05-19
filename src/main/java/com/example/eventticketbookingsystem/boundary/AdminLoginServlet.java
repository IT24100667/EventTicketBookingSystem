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

// Servlet for handling admin login
@WebServlet("/AdminLoginServlet") // This servlet is triggered when someone accesses /AdminLoginServlet
public class AdminLoginServlet extends HttpServlet {

    // This controller will help us check login info
    private AdminController adminController = new AdminController();

    // This method runs when the login form is submitted (POST request)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the username and password entered in the form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Print to server log for debugging (optional)
        System.out.println("Admin login attempt - Username: " + username);

        // Check if username or password is missing
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            // Show error and go back to login page
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            return;
        }

        // Check if the username and password are correct
        Admin admin = adminController.authenticateAdmin(username, password);
        System.out.println("Authentication result: " + (admin != null ? "success" : "failure"));

        if (admin != null) {
            // If login is successful, start a session and store user info
            HttpSession session = request.getSession();
            session.setAttribute("user", admin);               // Store the whole admin object
            session.setAttribute("userId", admin.getId());     // Store admin ID
            session.setAttribute("username", admin.getUsername()); // Store admin username
            session.setAttribute("isAdmin", true);             // Mark as admin

            // Redirect to the admin dashboard
            response.sendRedirect("adminDashboard.jsp");
        } else {
            // If login failed, show error and go back to login page
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
        }
    }

    // This method runs when someone opens the login page directly (GET request)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the user is already logged in and is an admin
        HttpSession session = request.getSession(false); // Don't create a new session
        if (session != null && session.getAttribute("user") != null &&
                session.getAttribute("isAdmin") != null && (Boolean)session.getAttribute("isAdmin")) {

            // Already logged in, send to dashboard directly
            response.sendRedirect("adminDashboard.jsp");
            return;
        }

        // Not logged in, show the login page
        request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
    }
}
