package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Feedback;
import com.example.eventticketbookingsystem.model.User;
import com.example.eventticketbookingsystem.util.FeedbackFileHandler;

import java.util.Map;

public class FeedbackController {
    // Changed to public for admin access
    public FeedbackFileHandler fileHandler;

    public FeedbackController() {
        this.fileHandler = new FeedbackFileHandler();
    }

    /**
     * Add a new feedback from a user
     *
     * @return true if successful, false otherwise
     */
    public boolean saveFeedback(User user, int rating, String comment) {
        if (user == null) {
            return false;
        }

        // Always create a new feedback entry instead of updating existing one
        Feedback feedback = new Feedback(user.getId(), user.getUsername(), rating, comment);
        return fileHandler.saveFeedback(feedback);
    }

    /**
     * Update an existing feedback
     * Only succeeds if the given user ID matches the feedback's user ID
     */
    public boolean updateFeedback(String feedbackId, String userId, int rating, String comment) {
        Feedback feedback = fileHandler.getFeedbackById(feedbackId);
        if (feedback != null && feedback.getUserId().equals(userId)) {
            feedback.setRating(rating);
            feedback.setComment(comment);
            return fileHandler.saveFeedback(feedback);
        }
        return false;
    }


