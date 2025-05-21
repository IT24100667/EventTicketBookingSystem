package com.example.eventticketbookingsystem.util;

import com.example.eventticketbookingsystem.model.Feedback;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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

    /**
     * Get all feedback from the file
     */
    public synchronized List<Feedback> getAllFeedbacks() {
        List<Feedback> feedbacks = new ArrayList<>();

        // Create directory if it doesn't exist
        File directory = new File("C:\\Users\\oshan\\Desktop\\DaTa");
        if (!directory.exists()) {
            directory.mkdirs();
        }

        // Check if file exists
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            return feedbacks;  // Return empty list if file doesn't exist
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;

            while ((line = reader.readLine()) != null) {
                try {
                    String[] parts = line.split("\\|");

                    if (parts.length < 7) {
                        System.out.println("Invalid feedback format, skipping: " + line);
                        continue;
                    }

                    String id = parts[0];
                    String userId = parts[1];
                    String username = parts[2];
                    int rating = Integer.parseInt(parts[3]);
                    String comment = parts[4];
                    Date createdDate = DATE_FORMAT.parse(parts[5]);
                    Date modifiedDate = DATE_FORMAT.parse(parts[6]);

                    Feedback feedback = new Feedback(
                            id, userId, username, rating, comment, createdDate, modifiedDate
                    );
                    feedbacks.add(feedback);
                } catch (ParseException | NumberFormatException e) {
                    System.out.println("Error parsing feedback line: " + line);
                    e.printStackTrace();
                }
            }
        } catch (FileNotFoundException e) {
            // File doesn't exist yet, return empty list
        } catch (IOException e) {
            System.out.println("Error reading feedback file");
            e.printStackTrace();
        }

        return feedbacks;
    }
    /**
     * Get feedback by ID
     */
    public Feedback getFeedbackById(String id) {
        List<Feedback> feedbacks = getAllFeedbacks();
        for (Feedback feedback : feedbacks) {
            if (feedback.getId().equals(id)) {
                return feedback;
            }
        }
        return null;
    }

    /**
     * Delete feedback by ID
     */
    public synchronized boolean deleteFeedback(String id) {
        List<Feedback> feedbacks = getAllFeedbacks();
        boolean removed = feedbacks.removeIf(feedback -> feedback.getId().equals(id));

        if (removed) {
            return saveAllFeedbacks(feedbacks);
        }
        return false;
    }

    /**
     * Calculate average rating
     */
    public double getAverageRating() {
        List<Feedback> feedbacks = getAllFeedbacks();
        if (feedbacks.isEmpty()) {
            return 0;
        }

        double sum = 0;
        for (Feedback feedback : feedbacks) {
            sum += feedback.getRating();
        }

        return sum / feedbacks.size();
    }

    /**
     * Count feedback by rating level
     */
    public Map<Integer, Integer> getFeedbackCounts() {
        List<Feedback> feedbacks = getAllFeedbacks();
        Map<Integer, Integer> counts = new HashMap<>();

        // Initialize counts for all rating levels
        for (int i = 1; i <= 5; i++) {
            counts.put(i, 0);
        }

        // Count feedbacks by rating
        for (Feedback feedback : feedbacks) {
            int rating = feedback.getRating();
            counts.put(rating, counts.get(rating) + 1);
        }

        return counts;
    }

    /**
     * Save all feedbacks to file
     */
    private synchronized boolean saveAllFeedbacks(List<Feedback> feedbacks) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Feedback feedback : feedbacks) {
                // Clean comment by removing any pipe characters and newlines
                String cleanComment = feedback.getComment() != null ?
                        feedback.getComment().replace("|", " ").replace("\n", " ").replace("\r", " ") : "";

                StringBuilder line = new StringBuilder();
                line.append(feedback.getId()).append("|");
                line.append(feedback.getUserId()).append("|");
                line.append(feedback.getUsername()).append("|");
                line.append(feedback.getRating()).append("|");
                line.append(cleanComment).append("|");
                line.append(DATE_FORMAT.format(feedback.getCreatedDate())).append("|");
                line.append(DATE_FORMAT.format(feedback.getModifiedDate()));

                writer.write(line.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.out.println("Error writing to feedback file");
            e.printStackTrace();
            return false;
        }
    }
}




}