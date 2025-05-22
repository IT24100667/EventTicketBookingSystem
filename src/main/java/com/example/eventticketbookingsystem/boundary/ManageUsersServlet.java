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
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet for admins to manage users in the system
 */
@WebServlet("/ManageUsersServlet")
public class ManageUsersServlet extends HttpServlet {

    private AdminController adminController = new AdminController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        // Debug class types
        System.out.println("User class: " + User.class.getName());

        // Get list of all users - with explicit typing
        List<User> userList = new ArrayList<>();
        for (User user : adminController.getAllUsers()) {
            userList.add(user);
        }

        request.setAttribute("userList", userList);

        // Forward to the management page
        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String action = request.getParameter("action");
        String userId = request.getParameter("userId");

        if (action != null && userId != null) {
            if (action.equals("delete")) {
                // Delete user
                boolean success = adminController.deleteUserAsAdmin(userId);

                if (success) {
                    request.setAttribute("message", "User deleted successfully");
                } else {
                    request.setAttribute("error", "Failed to delete user");
                }
            }
            else if (action.equals("view")) {
                // View user details with explicit casting
                User user = adminController.getUserById(userId);
                if (user != null) {
                    request.setAttribute("viewUser", user);
                }
            }
        }

        // Get updated list of all users - with explicit typing
        List<User> userList = new ArrayList<>();
        for (User user : adminController.getAllUsers()) {
            userList.add(user);
        }

        request.setAttribute("userList", userList);

        // Forward to the management page
        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }
}