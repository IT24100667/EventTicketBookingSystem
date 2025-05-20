package com.example.eventticketbookingsystem.model;

import java.util.Date;
import java.util.UUID;

public class Feedback {
    private String id;
    private String userId;
    private String username; // Store username for display purposes
    private int rating; // 1-5 rating (5 is best)
    private String comment;
    private Date createdDate;
    private Date modifiedDate;

    // Constructor for new feedback
    public Feedback(String userId, String username, int rating, String comment) {
        this.id = "FB" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
        this.userId = userId;
        this.username = username;
        this.rating = Math.min(5, Math.max(1, rating)); // Ensure rating is between 1 and 5
        this.comment = comment;
        this.createdDate = new Date();
        this.modifiedDate = new Date();
    }

    // Constructor for loading from file
    public Feedback(String id, String userId, String username, int rating, String comment, Date createdDate, Date modifiedDate) {
        this.id = id;
        this.userId = userId;
        this.username = username;
        this.rating = rating;
        this.comment = comment;
        this.createdDate = createdDate;
        this.modifiedDate = modifiedDate;
    }

    // Getters and setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = Math.min(5, Math.max(1, rating));
        this.modifiedDate = new Date();
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
        this.modifiedDate = new Date();
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getModifiedDate() {
        return modifiedDate;
    }

    public void setModifiedDate(Date modifiedDate) {
        this.modifiedDate = modifiedDate;
    }

    // Returns emoji based on rating
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


}
