package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.FeedbackController;
import com.example.eventticketbookingsystem.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class AdminViewFeedbackServlet {
    private FeedbackController feedbackController = new FeedbackController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                session.getAttribute("isAdmin") == null || !(Boolean)session.getAttribute("isAdmin")) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        // Get all feedbacks
        List<Feedback> feedbacks = feedbackController.getAllFeedback();
        double averageRating = feedbackController.getAverageRating();

        // Set attributes for JSP
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("feedbackCounts", feedbackController.getFeedbackCounts());

        // Forward to admin feedback JSP - CHANGED TO SINGULAR FORM
        request.getRequestDispatcher("adminFeedback.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle post requests (forwarded from other servlets)
        doGet(request, response);
    }
}

