package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.UserController;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet for handling user login
 */
@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {

    private UserController userController = new UserController();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic validation
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("userLogin.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        User user = userController.authenticateUser(username, password);

        if (user != null) {
            // Login successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());

            // Redirect to user dashboard
            response.sendRedirect("userDashboard.jsp");
        } else {
            // Login failed
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("userLogin.jsp").forward(request, response);
        }
    }
}
