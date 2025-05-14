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

    public Event(String name, String description, String venue, Date date,
                 double price, int capacity, String eventType) {
        this.id = generateId();
        this.name = name;
        this.description = description;
        this.venue = venue;
        this.date = date;
        this.price = price;
        this.capacity = capacity;
        this.bookedSeats = 0;
        this.eventType = eventType;
        this.discountThreshold = 0;
        this.discountPercentage = 0;
    }


    // method to generate IDs
    private String generateId() {
        return "EVENT" + System.currentTimeMillis();
    }


    // Calculate discount for a given number of tickets
    public double getDiscount(int ticketQuantity) {
        if (discountThreshold > 0 && ticketQuantity >= discountThreshold) {
            return discountPercentage / 100.0;
        }
        return 0.0;
    }

    // method to book seats
    public boolean bookTickets(int numberOfTickets) {
        if (numberOfTickets <= 0) {
            return false;
        }

        if (bookedSeats + numberOfTickets > capacity) {
            return false;  // Not enough seats
        }

        bookedSeats += numberOfTickets;
        return true;
    }


    // check if event is sold out
    public boolean isSoldOut() {
        return bookedSeats >= capacity;
    }





}
