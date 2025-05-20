package com.example.eventticketbookingsystem.model;

import java.util.Date;

public class Booking {

    // Status constants for booking status

    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_CONFIRMED = "CONFIRMED";
    public static final String STATUS_FAILED = "FAILED";
    public static final String STATUS_CANCELLED = "CANCELLED";

    // Instance variables

    private String id;
    private String userId;
    private String eventId;
    private int ticketQuantity;
    private double totalPrice;
    private String status;
    private Date bookingDate;


    // Constructor to create a new booking

    public Booking(String userId, String eventId, int ticketQuantity, double totalPrice) {
        this.id = "BK" + System.currentTimeMillis(); // Simple ID generation
        this.userId = userId;
        this.eventId = eventId;
        this.ticketQuantity = ticketQuantity;
        this.totalPrice = totalPrice;
        this.status = STATUS_PENDING; // All bookings start as pending
        this.bookingDate = new Date(); // Current date/time
    }

     // Constructor for loading booking from file

    public Booking(String id, String userId, String eventId, int ticketQuantity,
                   double totalPrice, String status, Date bookingDate) {
        this.id = id;
        this.userId = userId;
        this.eventId = eventId;
        this.ticketQuantity = ticketQuantity;
        this.totalPrice = totalPrice;
        this.status = status;
        this.bookingDate = bookingDate;
    }

    // Getter and setter methods

    public String getId() {
        return id;
    }

    public String getUserId() {
        return userId;
    }

    public String getEventId() {
        return eventId;
    }

    public int getTicketQuantity() {
        return ticketQuantity;
    }

    public void setTicketQuantity(int ticketQuantity) {
        this.ticketQuantity = ticketQuantity;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getBookingDate() {
        return bookingDate;
    }


    // Check if booking is confirmed

    public boolean isConfirmed() {
        return STATUS_CONFIRMED.equals(status);
    }

    // Check if booking can be cancelled

    public boolean canBeCancelled() {
        // Can cancel if pending or confirmed
        return STATUS_PENDING.equals(status) || STATUS_CONFIRMED.equals(status);
    }

    // Format booking for storage

    @Override
    public String toString() {
        return "Booking #" + id + " - Event: " + eventId +
                ", Status: " + status + ", Tickets: " + ticketQuantity;
    }
}
