package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Concert;
import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.model.OtherEvent;
import com.example.eventticketbookingsystem.model.Sports;
import com.example.eventticketbookingsystem.util.EventFileHandler;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

    // Create Sport
    public boolean createSports(String name, String description, String venue, Date date, double price, int capacity, String sportType, String teams) {


        if (name == null || name.trim().isEmpty() || venue == null || venue.trim().isEmpty() || date == null || price <= 0 || capacity <= 0) {
            return false;
        }

        // Handle null values
        if (description == null) description = "";
        if (sportType == null) sportType = "";
        if (teams == null) teams = "";

        Sports sports = new Sports(name, description, venue, date, price, capacity, sportType, teams);

        return fileHandler.saveEvent(sports);
    }

    // For OtherEvent
    public boolean createOtherEvent(String name, String description, String venue, Date date, double price, int capacity, String eventCategory, String specialRequirements) {


        if (name == null || name.trim().isEmpty() || venue == null || venue.trim().isEmpty() ||
                date == null || price <= 0 || capacity <= 0) {
            return false;
        }

        // Handle null values
        if (description == null) description = "";
        if (eventCategory == null) eventCategory = "";
        if (specialRequirements == null) specialRequirements = "";

        OtherEvent event = new OtherEvent(name, description, venue, date, price, capacity, eventCategory, specialRequirements);

        return fileHandler.saveEvent(event);
    }


    // 2. Read

    // Read a singular event
    public Event getEventById(String eventId) {
        // Validation
        if (eventId == null || eventId.trim().isEmpty()) {
            return null;
        }

        return fileHandler.getEventById(eventId);
    }

    // Read all Events
    public List<Event> getAllEvents() {
        return fileHandler.getAllEvents();
    }


    // 3. Update

    public boolean updateEvent(Event event) {
        if (event == null) {
            return false;
        }

        return fileHandler.updateEvent(event);
    }

    // 4. Delete

    public boolean deleteEvent(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }

        return fileHandler.deleteEvent(id);
    }


    // 5. overloaded search methods

    // Search by name
    public List<Event> searchEvents(String name) {
        if (name == null || name.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Event> allEvents = getAllEvents();
        List<Event> result = new ArrayList<>();

        String searchName = name.toLowerCase().trim();
        for (Event event : allEvents) {
            if (event.getName().toLowerCase().contains(searchName)) {
                result.add(event);
            }
        }

        return result;
    }



    // Search by price range
    public List<Event> searchEvents(double minPrice, double maxPrice) {
        if (minPrice < 0 || maxPrice < minPrice) {
            return new ArrayList<>();
        }

        List<Event> allEvents = getAllEvents();
        List<Event> result = new ArrayList<>();

        for (Event event : allEvents) {
            double price = event.getPrice();
            if (price >= minPrice && price <= maxPrice) {
                result.add(event);
            }
        }

        return result;
    }


    // Search by venue
    public List<Event> searchEventsByVenue(String venue) {
        if (venue == null || venue.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Event> allEvents = getAllEvents();
        List<Event> result = new ArrayList<>();

        String searchVenue = venue.toLowerCase().trim();
        for (Event event : allEvents) {
            if (event.getVenue().toLowerCase().contains(searchVenue)) {
                result.add(event);
            }
        }

        return result;
    }


    public double calculateTicketPrice(String eventId, int quantity) {
        if (quantity <= 0) {
            return -1;
        }

        Event event = getEventById(eventId);
        if (event == null) {
            return -1;
        }

        double unitPrice = event.calculateTicketPrice();
        double totalPrice = unitPrice * quantity;

        // Apply Concert discount if applicable
        if (event.getEventType().equals("Concert")) {
            Concert concert = (Concert) event;
            totalPrice = totalPrice - (totalPrice * concert.getDiscount(quantity));
        }

        return totalPrice;
    }








}
