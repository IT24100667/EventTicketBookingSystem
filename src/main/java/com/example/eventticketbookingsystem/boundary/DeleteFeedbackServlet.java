package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.FeedbackController;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DeleteFeedbackServlet {
    private FeedbackController feedbackController = new FeedbackController();
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get feedback identification parameters from request
        String feedbackUserId = request.getParameter("userId");
        String createdDateStr = request.getParameter("createdDate");

        if (feedbackUserId != null && !feedbackUserId.isEmpty() &&
                createdDateStr != null && !createdDateStr.isEmpty()) {

            try {
                // Parse the created date
                Date createdDate = DATE_FORMAT.parse(createdDateStr);

                // Try to delete the feedback
                boolean deleted = feedbackController.deleteFeedback(feedbackUserId, createdDate);

                if (deleted) {
                    request.setAttribute("message", "Feedback deleted successfully.");
                } else {
                    request.setAttribute("error", "You don't have permission to delete this feedback or it doesn't exist.");
                }
            } catch (ParseException e) {
                request.setAttribute("error", "Invalid date format for feedback.");
            }
        } else {
            request.setAttribute("error", "Invalid feedback identification parameters.");
        }

        // Redirect to view feedbacks
        request.getRequestDispatcher("ViewFeedbacksServlet").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}