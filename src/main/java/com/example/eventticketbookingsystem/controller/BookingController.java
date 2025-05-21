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

    // Cancel a booking

    public boolean cancelBooking(String bookingId, String userId) {
        Booking booking = getBookingById(bookingId);

        // Check if booking exists and belongs to user
        if (booking == null || !booking.getUserId().equals(userId)) {
            return false;
        }

        // Check if booking can be cancelled
        if (!booking.canBeCancelled()) {
            return false;
        }

        // Update status to cancelled
        booking.setStatus(Booking.STATUS_CANCELLED);
        boolean updated = fileHandler.saveBooking(booking);

        if (updated) {
            // Remove from queue if present
            bookingQueue.removeBooking(bookingId);

            // Release tickets back to event if confirmed
            if (Booking.STATUS_CONFIRMED.equals(booking.getStatus())) {
                Event event = eventController.getEventById(booking.getEventId());
                if (event != null) {
                    int newBookedSeats = event.getBookedSeats() - booking.getTicketQuantity();
                    if (newBookedSeats < 0) {
                        newBookedSeats = 0;  // Safety check
                    }
                    event.setBookedSeats(newBookedSeats);
                    eventController.updateEvent(event);
                }
            }
        }

        return updated;
    }

     // Process the next booking in the queue
     // Returns true if successful, false if queue empty or processing failed

    public boolean processNextBooking() {
        if (bookingQueue.isEmpty()) {
            return false;
        }

        Booking booking = bookingQueue.dequeue();

        // Check if booking is still pending
        if (!Booking.STATUS_PENDING.equals(booking.getStatus())) {
            return false;  // Booking already processed or cancelled
        }

        // Get the event
        Event event = eventController.getEventById(booking.getEventId());
        if (event == null) {
            return false;
        }

        // Check if seats still available
        if (event.getAvailableSeats() < booking.getTicketQuantity()) {
            // Not enough seats, mark booking as failed
            booking.setStatus(Booking.STATUS_FAILED);
            fileHandler.saveBooking(booking);
            return false;
        }

        // Book the seats
        boolean booked = eventController.bookTickets(booking.getEventId(), booking.getTicketQuantity());
        if (!booked) {
            // Failed to book, mark as failed
            booking.setStatus(Booking.STATUS_FAILED);
            fileHandler.saveBooking(booking);
            return false;
        }

        // Mark as confirmed
        booking.setStatus(Booking.STATUS_CONFIRMED);
        return fileHandler.saveBooking(booking);
    }
}
