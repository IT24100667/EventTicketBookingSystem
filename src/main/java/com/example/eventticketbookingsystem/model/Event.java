package com.example.eventticketbookingsystem.model;

import java.util.Date;

public abstract class Event {

    private String id;
    private String name;
    private String description;
    private String venue;
    private Date date;
    private double price;
    private int capacity;
    private int bookedSeats;
    private String eventType;

    //unique for Concert
    private int discountThreshold; // no. of tickets needed for discount eligibility
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



    // the child class can have unique implementations of calculating price
    public abstract double calculateTicketPrice();


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

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getBookedSeats() { return bookedSeats; }
    public void setBookedSeats(int bookedSeats) { this.bookedSeats = bookedSeats; }

    public int getAvailableSeats() { return capacity - bookedSeats; }

    public String getEventType() { return eventType; }

    public int getDiscountThreshold() { return discountThreshold; }
    public void setDiscountThreshold(int discountThreshold) { this.discountThreshold = discountThreshold; }

    public int getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(int discountPercentage) { this.discountPercentage = discountPercentage; }







}
