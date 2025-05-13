package com.example.eventticketbookingsystem.model;

import java.util.Date;

public class Event {

    private String id;
    private String name;
    private String description;
    private String venue;
    private Date date;
    private double price;
    private int capacity;
    private int bookedSeats;
    private String eventType;

    private int discountThreshold; // no. tickets needed for discount eligibility
    private int discountPercentage;



}
