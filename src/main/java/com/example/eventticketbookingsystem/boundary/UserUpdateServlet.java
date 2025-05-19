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
 * Servlet for handling user profile updates
 */
@WebServlet("/UserUpdateServlet")
public class UserUpdateServlet extends HttpServlet {

    private UserController userController = new UserController();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        // Get parameters
        String userId = currentUser.getId();
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        // Update user
        boolean success = userController.updateUser(userId, username, password, fullName, email, phoneNumber);

        if (success) {
            // Update successful - update user in session
            User updatedUser = userController.getUserById(userId);
            session.setAttribute("user", updatedUser);
            session.setAttribute("username", updatedUser.getUsername());

            request.setAttribute("message", "Profile updated successfully");
        } else {
            request.setAttribute("error", "Update failed. Username may be taken.");
        }

        request.getRequestDispatcher("userProfile.jsp").forward(request, response);
    }
}