package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.FeedbackController;
import com.example.eventticketbookingsystem.model.Feedback;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class ViewFeedbackServlet {

    private FeedbackController feedbackController = new FeedbackController();


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all feedback
        List<Feedback> feedbacks = feedbackController.getAllFeedback();

        // Get average rating and counts
        double averageRating = feedbackController.getAverageRating();

        // Set current user if logged in (for edit/delete permissions)
        HttpSession session = request.getSession(false);
        String currentUserId = "";
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            currentUserId = user.getId();
        }

        // Set attributes for JSP
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("currentUserId", currentUserId);
        request.setAttribute("feedbackCounts", feedbackController.getFeedbackCounts());

        // Forward to JSP
        request.getRequestDispatcher("viewFeedbacks.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // We'll use this to receive forwarded requests from other servlets
        doGet(request, response);
    }
}
