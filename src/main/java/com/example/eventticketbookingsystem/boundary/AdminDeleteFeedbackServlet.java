package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.FeedbackController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet for administrators to delete user feedback
 * Current Date and Time (UTC): 2025-05-21 09:04:08
 * Current User's Login: IT24100725
 */
@WebServlet("/AdminDeleteFeedbackServlet")
public class AdminDeleteFeedbackServlet extends HttpServlet {

    private FeedbackController feedbackController = new FeedbackController();
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                session.getAttribute("isAdmin") == null || !(Boolean)session.getAttribute("isAdmin")) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        // Get feedback identification parameters from request
        String userId = request.getParameter("userId");
        String createdDateStr = request.getParameter("createdDate");

        if (userId != null && !userId.isEmpty() &&
                createdDateStr != null && !createdDateStr.isEmpty()) {

            try {
                // Parse the created date
                Date createdDate = DATE_FORMAT.parse(createdDateStr);

                // Admin can delete any feedback, so we use the method that doesn't check user permissions
                boolean deleted = feedbackController.fileHandler.deleteFeedback(userId, createdDate);

                if (deleted) {
                    request.setAttribute("message", "Feedback deleted successfully.");
                } else {
                    request.setAttribute("error", "Failed to delete feedback. It may not exist.");
                }
            } catch (ParseException e) {
                request.setAttribute("error", "Invalid date format for feedback.");
            }
        } else {
            request.setAttribute("error", "Invalid feedback identification parameters. Both user ID and creation date are required.");
        }

        // Redirect to admin feedback view
        request.getRequestDispatcher("AdminViewFeedbacksServlet").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}