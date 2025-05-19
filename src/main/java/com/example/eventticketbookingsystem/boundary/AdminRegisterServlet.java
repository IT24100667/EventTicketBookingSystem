package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.AdminController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

//Servlet for handling admin registration
@WebServlet("/AdminRegisterServlet") // This servlet runs when someone goes to /AdminRegisterServlet
public class AdminRegisterServlet extends HttpServlet {

    // Create an instance of the controller to manage admin accounts
    private AdminController adminController = new AdminController();

    // This method handles POST requests (like when a form is submitted)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form values entered by the user
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        // Print a message in the server log (for debugging)
        System.out.println("Processing admin registration for: " + username);

        // Check if any required field is missing
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            // Show error message and return to the registration page
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("adminRegister.jsp").forward(request, response);
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("adminRegister.jsp").forward(request, response);
            return;
        }

        // Check if the email looks valid
        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email address");
            request.getRequestDispatcher("adminRegister.jsp").forward(request, response);
            return;
        }

        // Try to register the new admin
        boolean success = adminController.registerAdmin(username, password, fullName, email, phoneNumber);

        // Print result in the server log
        System.out.println("Registration result: " + (success ? "success" : "failure"));

        if (success) {
            // If registration worked, save a message and go to the login page
            request.getSession().setAttribute("message", "Admin account created successfully. Please log in.");
            response.sendRedirect("adminLogin.jsp");
        } else {
            // If registration failed (for example, username already exists)
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("adminRegister.jsp").forward(request, response);
        }
    }

    // This method handles GET requests (like when someone types the URL directly)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to the registration form page
        response.sendRedirect("adminRegister.jsp");
    }
}
