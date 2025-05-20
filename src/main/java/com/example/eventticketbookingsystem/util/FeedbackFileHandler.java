package com.example.eventticketbookingsystem.util;

import com.example.eventticketbookingsystem.model.Feedback;

import java.text.SimpleDateFormat;
import java.util.List;

public class FeedbackFileHandler {
    private static final String FILE_PATH = "C:\\Users\\ashinsana\\Desktop\\DaTa\\feedback.txt";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * Save a feedback to the file system
     */
    public synchronized boolean saveFeedback(Feedback feedback) {
        List<Feedback> feedbacks = getAllFeedbacks();
        boolean isUpdate = false;

        // Check if this is an update to existing feedback
        for (int i = 0; i < feedbacks.size(); i++) {
            if (feedbacks.get(i).getId().equals(feedback.getId())) {
                feedbacks.set(i, feedback);
                isUpdate = true;
                break;
            }
        }

        // If not an update, add as new feedback
        if (!isUpdate) {
            feedbacks.add(feedback);
        }

        // Save all feedback
        return saveAllFeedbacks(feedbacks);
    }
}