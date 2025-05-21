package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Booking;
import com.example.eventticketbookingsystem.model.BookingQueue;
import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.util.BookingFileHandler;

import java.util.List;

public class BookingController {

    private BookingFileHandler fileHandler;
    private static BookingQueue bookingQueue = new BookingQueue();  // Shared queue for FIFO processing
    private EventController eventController;

    public BookingController() {
        this.fileHandler = new BookingFileHandler();
        this.eventController = new EventController();
    }

     // Create a new booking
     // @return the booking ID if successful, null otherwise

    public String createBooking(String userId, String eventId, int ticketQuantity) {
        if (userId == null || eventId == null || ticketQuantity <= 0) {
            return null;
        }

        // Get the event
        Event event = eventController.getEventById(eventId);
        if (event == null) {
            return null;  // Event not found
        }

        // Check if enough seats available
        if (event.getAvailableSeats() < ticketQuantity) {
            return null;  // Not enough seats
        }

        // Calculate total price
        double totalPrice = eventController.calculateTicketPrice(eventId, ticketQuantity);
        if (totalPrice <= 0) {
            return null;  // Invalid price calculation
        }

        // Create the booking
        Booking booking = new Booking(userId, eventId, ticketQuantity, totalPrice);

        // Save booking to file
        boolean saved = fileHandler.saveBooking(booking);
        if (!saved) {
            return null;  // Failed to save
        }

        // Add to processing queue for FIFO processing
        bookingQueue.enqueue(booking);

        return booking.getId();
    }

     // Get a booking by ID

    public Booking getBookingById(String bookingId) {
        if (bookingId == null || bookingId.trim().isEmpty()) {
            return null;
        }

        return fileHandler.getBookingById(bookingId);
    }

     // Get all bookings for a user

    public List<Booking> getUserBookings(String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            return null;
        }

        return fileHandler.getBookingsByUserId(userId);
    }


     // Update booking status

    public boolean updateBookingStatus(String bookingId, String newStatus) {
        Booking booking = getBookingById(bookingId);
        if (booking == null) {
            return false;
        }

        booking.setStatus(newStatus);
        return fileHandler.saveBooking(booking);
    }
}
