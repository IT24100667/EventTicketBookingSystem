package com.example.eventticketbookingsystem.model;

import java.util.Date;
import java.util.UUID;

public class Feedback {
    private String userId;
    private String username; // Store username for display purposes
    private int rating; // 1-5 rating (5 is best)
    private String comment;
    private Date createdDate;
    private Date modifiedDate;

    /**
     * Constructor for  creating a new feedback
     */
    public Feedback(String userId, String username, int rating, String comment) {
        this.userId = userId;
        this.username = username;
        this.rating = Math.min(5, Math.max(1, rating)); // Ensure rating is between 1 and 5
        this.comment = comment;
        this.createdDate = new Date();
        this.modifiedDate = new Date();
    }

    /**
     * Constructor for loading existing feedback
     */
    public Feedback(String userId, String username, int rating, String comment, Date createdDate, Date modifiedDate) {
        this.userId = userId;
        this.username = username;
        this.rating = rating;
        this.comment = comment;
        this.createdDate = createdDate;
        this.modifiedDate = modifiedDate;
    }

    // Getters and setters for userId
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    // Getters and setters for username
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    // Getters and setters for rating
    public int getRating() {
        return rating;
    }

    /**
     * Sets rating (only allows values from 1 to 5)
     * Also updates the modified date
     */
    public void setRating(int rating) {
        this.rating = Math.min(5, Math.max(1, rating));
        this.modifiedDate = new Date();
    }

    // Getters and setters for comment
    public String getComment() {
        return comment;
    }

    /**
     * Sets comment and updates the modified date
     */
    public void setComment(String comment) {
        this.comment = comment;
        this.modifiedDate = new Date();
    }


    // Getters and setters for createdDate
    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    // Getters and setters for modifiedDate
    public Date getModifiedDate() {
        return modifiedDate;
    }

    public void setModifiedDate(Date modifiedDate) {
        this.modifiedDate = modifiedDate;
    }

    /**
     * Returns emoji based on rating value
     */
    public String getRatingEmoji() {
        switch (rating) {
            case 5: return "😁"; // Very Happy
            case 4: return "🙂"; // Happy
            case 3: return "😐"; // Neutral
            case 2: return "🙁"; // Sad
            case 1: return "😞"; // Very Sad
            default: return "❓"; // Unknown
        }
    }

    /**
     * Returns a CSS class based on rating
     */
    public String getRatingClass() {
        switch (rating) {
            case 5: return "rating-excellent";
            case 4: return "rating-good";
            case 3: return "rating-average";
            case 2: return "rating-poor";
            case 1: return "rating-terrible";
            default: return "";
        }
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "userId='" + userId + '\'' +
                ", username='" + username + '\'' +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", createdDate=" + createdDate +
                ", modifiedDate=" + modifiedDate +
                '}';
    }
}
