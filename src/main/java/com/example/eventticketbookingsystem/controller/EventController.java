package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Concert;
import com.example.eventticketbookingsystem.util.EventFileHandler;

import java.util.Date;

public class EventController {


    private EventFileHandler fileHandler;

    // Constructor
    public EventController() {
        this.fileHandler = new EventFileHandler();
    }

    // 1. create methods

    // concert

    public boolean createConcert(String name, String description, String venue, Date date, double price, int capacity, String artist, int discountThreshold, int discountPercentage) {
        // Add some validations
        if (name == null || name.trim().isEmpty() || venue == null || venue.trim().isEmpty() || date == null || price <= 0 || capacity <= 0) {
            return false;
        }

        // Handle null description
        if (description == null) {
            description = "";
        }

        // Ensure artist is not null
        if (artist == null) {
            artist = "";
        }

        // Create concert object
        Concert concert = new Concert(name, description, venue, date, price, capacity, artist);

        // Add discounts
        concert.setDiscountThreshold(discountThreshold);
        concert.setDiscountPercentage(discountPercentage);

        // Once concert event is created save to file
        return fileHandler.saveEvent(concert);
    }


}
