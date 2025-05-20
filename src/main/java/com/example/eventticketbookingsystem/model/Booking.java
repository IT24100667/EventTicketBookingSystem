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
}
