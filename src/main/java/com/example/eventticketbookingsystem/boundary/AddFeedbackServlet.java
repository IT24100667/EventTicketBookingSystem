package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.FeedbackController;
import com.example.eventticketbookingsystem.model.Feedback;
import com.example.eventticketbookingsystem.model.User;

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
import java.util.List;

/**
 * Servlet to handle adding feedback
 * Current Date and Time (UTC): 2025-05-21 09:00:53
 * Current User's Login: IT24100725
 */
@WebServlet("/AddFeedbackServlet")
public class AddFeedbackServlet extends HttpServlet {

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

        // Check if there's a feedback to edit (need userId and createdDate)
        String feedbackUserId = request.getParameter("userId");
        String createdDateStr = request.getParameter("createdDate");
        Feedback feedbackToEdit = null;

        if (feedbackUserId != null && !feedbackUserId.isEmpty() &&
                createdDateStr != null && !createdDateStr.isEmpty()) {
            try {
                // Parse the created date
                Date createdDate = DATE_FORMAT.parse(createdDateStr);

                // Get feedback for editing
                feedbackToEdit = feedbackController.getFeedbackByUserIdAndDate(feedbackUserId, createdDate);

                // Check if user can edit this feedback
                if (feedbackToEdit == null || !feedbackController.canEditFeedback(feedbackUserId, createdDate, user.getId())) {
                    request.setAttribute("error", "You don't have permission to edit this feedback.");
                    request.getRequestDispatcher("ViewFeedbacksServlet").forward(request, response);
                    return;
                }
            } catch (ParseException e) {
                request.setAttribute("error", "Invalid date format for feedback.");
                request.getRequestDispatcher("ViewFeedbacksServlet").forward(request, response);
                return;
            }
        }

        // Get user's previous feedbacks
        List<Feedback> userFeedbacks = feedbackController.getFeedbacksByUserId(user.getId());

        // Set attributes and forward to JSP
        request.setAttribute("feedbackToEdit", feedbackToEdit);
        request.setAttribute("userFeedbacks", userFeedbacks);
        request.getRequestDispatcher("addFeedback.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Get form data
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Check if this is an edit or a new feedback
            String feedbackUserId = request.getParameter("feedbackUserId");
            String createdDateStr = request.getParameter("feedbackCreatedDate");
            boolean success;

            if (feedbackUserId != null && !feedbackUserId.isEmpty() &&
                    createdDateStr != null && !createdDateStr.isEmpty()) {
                try {
                    // Parse the created date
                    Date createdDate = DATE_FORMAT.parse(createdDateStr);

                    // Update existing feedback
                    success = feedbackController.updateFeedback(feedbackUserId, createdDate, rating, comment);
                    if (success) {
                        request.setAttribute("message", "Your feedback has been updated!");
                    } else {
                        request.setAttribute("error", "Failed to update feedback. You may not have permission to edit this feedback.");
                    }
                } catch (ParseException e) {
                    request.setAttribute("error", "Invalid date format for feedback.");
                    request.getRequestDispatcher("ViewFeedbacksServlet").forward(request, response);
                    return;
                }
            } else {
                // Add new feedback
                success = feedbackController.saveFeedback(user, rating, comment);
                if (success) {
                    request.setAttribute("message", "Thank you for your feedback!");
                } else {
                    request.setAttribute("error", "Failed to save feedback. Please try again.");
                }
            }

            // Redirect to view all feedback
            request.getRequestDispatcher("ViewFeedbacksServlet").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid rating. Please select a rating from 1 to 5.");
            request.getRequestDispatcher("addFeedback.jsp").forward(request, response);
        }
    }
}