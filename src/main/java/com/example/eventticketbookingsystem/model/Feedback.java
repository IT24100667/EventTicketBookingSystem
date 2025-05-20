package com.example.eventticketbookingsystem.model;

import java.util.Date;

public class Feedback {
    private String id;
    private String userId;
    private String username; // Store username for display purposes
    private int rating; // 1-5 rating (5 is best)
    private String comment;
    private Date createdDate;
    private Date modifiedDate;
}
