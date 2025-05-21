package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.FeedbackController;
import com.example.eventticketbookingsystem.model.Feedback;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class AddFeedbackServlet {

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
