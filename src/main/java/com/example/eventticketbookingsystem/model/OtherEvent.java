package com.example.eventticketbookingsystem.model;

import java.util.Date;

public class OtherEvent extends Event {

    private String eventCategory;
    private String specialRequirements;

    public OtherEvent(String name, String description, String venue, Date date, double price, int capacity, String eventCategory, String specialRequirements) {
        super(name, description, venue, date, price, capacity, "Other");
        this.eventCategory = eventCategory;
        this.specialRequirements = specialRequirements;
    }

    @Override
    public double calculateTicketPrice() {
        return 0;
    }

    public String getEventCategory() {
        return eventCategory;
    }

    public void setEventCategory(String eventCategory) {
        this.eventCategory = eventCategory;
    }

    public String getSpecialRequirements() {
        return specialRequirements;
    }

    public void setSpecialRequirements(String specialRequirements) {
        this.specialRequirements = specialRequirements;
    }
}
