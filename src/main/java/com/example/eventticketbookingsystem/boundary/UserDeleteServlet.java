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
 * Servlet for handling user account deletion
 */
@WebServlet("/UserDeleteServlet")
public class UserDeleteServlet extends HttpServlet {

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

        String userId = currentUser.getId();

        // Delete user
        boolean success = userController.deleteUser(userId);

        if (success) {
            // Delete successful - invalidate session
            session.invalidate();
            response.sendRedirect("index.jsp?message=Account+deleted+successfully");
        } else {
            request.setAttribute("error", "Account deletion failed");
            request.getRequestDispatcher("userProfile.jsp").forward(request, response);
        }
    }
}