package com.example.eventticketbookingsystem.model;

import java.util.Date;

/**
 * Concert class - extends Event and implements Discountable
 * Shows inheritance and polymorphism (method overriding)
 */
public class Concert extends Event implements Discountable {
    private String artist;
    private int discountThreshold;
    private int discountPercentage;

    /**
     * Constructor for Concert
     */
    public Concert(String name, String description, String venue, Date date,
                   double price, int capacity, String artist) {
        // Call parent constructor
        super(name, description, venue, date, price, capacity, "Concert");
        this.artist = artist;
        this.discountThreshold = 0;
        this.discountPercentage = 0;
    }

    // Getter and setter for artist
    public String getArtist() { return artist; }
    public void setArtist(String artist) { this.artist = artist; }

    // Implementation of abstract method from parent class (overriding)
    @Override
    public double calculateTicketPrice() {
        // we have implemented a 5% service charge for concerts
        return getPrice() * 1.05;
    }

    @Override
    public double getDiscount(int ticketCount) {
        if (discountThreshold > 0 && ticketCount >= discountThreshold) {
            return discountPercentage / 100.0;
        }
        return 0.0;
    }

    @Override
    public int getDiscountThreshold() {
        return discountThreshold;
    }

    @Override
    public int getDiscountPercentage() {
        return discountPercentage;
    }

    // Add setters for the new fields
    public void setDiscountThreshold(int discountThreshold) {
        this.discountThreshold = discountThreshold;
    }

    public void setDiscountPercentage(int discountPercentage) {
        this.discountPercentage = discountPercentage;
    }


}