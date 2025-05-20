package com.example.eventticketbookingsystem.model;

import java.util.Date;

/**
 * OtherEvent class - extends Event
 * Demonstrates inheritance and accommodates additional event types
 */
public class OtherEvent extends Event {
    private String eventCategory;
    private String specialRequirements;

    public OtherEvent(String name, String description, String venue, Date date,
                      double price, int capacity, String eventCategory, String specialRequirements) {
        // Call parent constructor
        super(name, description, venue, date, price, capacity, "Other");
        this.eventCategory = eventCategory;
        this.specialRequirements = specialRequirements;
    }

    // Getters and setters for OtherEvent-specific fields
    public String getEventCategory() { return eventCategory; }
    public void setEventCategory(String eventCategory) { this.eventCategory = eventCategory; }

    public String getSpecialRequirements() { return specialRequirements; }
    public void setSpecialRequirements(String specialRequirements) { this.specialRequirements = specialRequirements; }

    // Implementation of abstract method from parent class (overriding)
    @Override
    public double calculateTicketPrice() {

        // Apply discount for educational events
        if (eventCategory != null &&
                (eventCategory.toLowerCase().contains("educational") ||
                        eventCategory.toLowerCase().contains("workshop") ||
                        eventCategory.toLowerCase().contains("seminar"))) {
            return getPrice() * 0.95; // 5% discount for educational events
        }
        //if not just return pricea
        return getPrice();
    }

    @Override
    public String toString() {
        return super.toString() + " - " + eventCategory;
    }
}