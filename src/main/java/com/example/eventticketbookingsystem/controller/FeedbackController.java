package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Feedback;
import com.example.eventticketbookingsystem.model.User;
import com.example.eventticketbookingsystem.util.FeedbackFileHandler;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class FeedbackController {
    // Changed to public for admin access
    public FeedbackFileHandler fileHandler;

    public FeedbackController() {
        this.fileHandler = new FeedbackFileHandler();
    }

    /**
     * Add a new feedback from a user
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
    public boolean updateFeedback(String userId, Date createdDate, int rating, String comment) {
        Feedback feedback = fileHandler.getFeedbackByUserIdAndDate(userId, createdDate);
        if (feedback != null) {
            feedback.setRating(rating);
            feedback.setComment(comment);
            return fileHandler.saveFeedback(feedback);
        }
        return false;
    }

    /**
     * Get all feedback
     */
    public List<Feedback> getAllFeedback() {
        return fileHandler.getAllFeedbacks();
    }

    /**
     * Get feedback by userId and createdDate
     */
    public Feedback getFeedbackByUserIdAndDate(String userId, Date createdDate) {
        return fileHandler.getFeedbackByUserIdAndDate(userId, createdDate);
    }

    /**
     * Get all feedbacks by user ID
     */
    public List<Feedback> getFeedbacksByUserId(String userId) {
        List<Feedback> allFeedbacks = fileHandler.getAllFeedbacks();
        List<Feedback> userFeedbacks = new ArrayList<>();

        for (Feedback feedback : allFeedbacks) {
            if (feedback.getUserId().equals(userId)) {
                userFeedbacks.add(feedback);
            }
        }

        return userFeedbacks;
    }

    /**
     * Delete feedback
     * Only succeeds if the given user ID matches the feedback's user ID
     */
    public boolean deleteFeedback(String userId, Date createdDate) {
        Feedback feedback = fileHandler.getFeedbackByUserIdAndDate(userId, createdDate);
        if (feedback != null) {
            return fileHandler.deleteFeedback(userId, createdDate);
        }
        return false;
    }

    /**
     * Admin delete feedback
     * Can delete any feedback regardless of user ID
     */
    public boolean adminDeleteFeedback(String userId, Date createdDate) {
        return fileHandler.deleteFeedback(userId, createdDate);
    }

    /**
     * Get average rating
     */
    public double getAverageRating() {
        return fileHandler.getAverageRating();
    }

    /**
     * Get feedback counts by rating
     */
    public Map<Integer, Integer> getFeedbackCounts() {
        return fileHandler.getFeedbackCounts();
    }

    /**
     * Check if a user can edit the specified feedback
     */
    public boolean canEditFeedback(String userId, Date createdDate, String currentUserId) {
        Feedback feedback = fileHandler.getFeedbackByUserIdAndDate(userId, createdDate);
        return feedback != null && feedback.getUserId().equals(currentUserId);
    }

    /**
     * Get most recent feedback by user ID
     */
    public Feedback getMostRecentFeedbackByUserId(String userId) {
        List<Feedback> userFeedbacks = getFeedbacksByUserId(userId);
        if (userFeedbacks.isEmpty()) {
            return null;
        }

        Feedback mostRecent = userFeedbacks.get(0);
        for (Feedback feedback : userFeedbacks) {
            if (feedback.getCreatedDate().after(mostRecent.getCreatedDate())) {
                mostRecent = feedback;
            }
        }

        return mostRecent;
    }
}


