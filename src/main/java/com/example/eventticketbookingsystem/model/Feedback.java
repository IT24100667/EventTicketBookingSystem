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

}
