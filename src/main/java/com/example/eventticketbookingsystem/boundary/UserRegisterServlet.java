package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.UserController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


 //Servlet for handling user registration
 // This demonstrates the Boundary part of the architecture
@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {

    private UserController userController = new UserController();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get parameters from request
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        // Validate passwords match
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("userRegister.jsp").forward(request, response);
            return;
        }

        // Register user
        boolean success = userController.registerUser(username, password, fullName, email, phoneNumber);

        if (success) {
            // Registration successful
            request.setAttribute("message", "Registration successful. Please log in.");
            request.getRequestDispatcher("userLogin.jsp").forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("error", "Registration failed. Username may be taken.");
            request.getRequestDispatcher("userRegister.jsp").forward(request, response);
        }
    }
}
