package com.example.eventticketbookingsystem.model;

    // BookingQueue class demonstrates a simple queue data structure
    // for processing bookings in First-In-First-Out (FIFO) order

public class BookingQueue {

    // The actual queue, using our CustomLinkedList implementation

    private CustomLinkedList queue;

     // Constructor - creates an empty queue

    public BookingQueue() {
        queue = new CustomLinkedList();
    }

     // Add a booking to the end of the queue

    public void enqueue(Booking booking) {
        queue.addLast(booking);
    }

     // Remove and return the booking from the front of the queue
     // Returns null if queue is empty

    public Booking dequeue() {
        if (isEmpty()) {
            return null;
        }
        return (Booking) queue.removeFirst();
    }

     // Look at the booking at the front of the queue without removing it
     // Returns null if queue is empty

    public Booking peek() {
        if (isEmpty()) {
            return null;
        }
        return (Booking) queue.getFirst();
    }

     // Check if the queue is empty

    public boolean isEmpty() {
        return queue.isEmpty();
    }


     // Get the number of bookings in the queue

    public int size() {
        return queue.size();
    }




    // Check if a booking with the given ID exists in the queue

    public boolean contains(String bookingId) {
        // Get all bookings as an array to iterate through them
        Object[] bookings = queue.toArray();

        for (Object obj : bookings) {
            Booking booking = (Booking) obj;
            if (booking.getId().equals(bookingId)) {
                return true;
            }
        }

        return false;
    }

     // Move a booking to the front of the queue (priority processing)
     // Returns true if successful, false if booking not found

    public boolean prioritize(String bookingId) {
        // Find the booking
        Booking bookingToMove = null;
        Object[] bookings = queue.toArray();

        for (Object obj : bookings) {
            Booking booking = (Booking) obj;
            if (booking.getId().equals(bookingId)) {
                bookingToMove = booking;
                break;
            }
        }

        // If found, remove and add to front
        if (bookingToMove != null) {
            queue.remove(bookingToMove);
            queue.addFirst(bookingToMove);
            return true;
        }

        return false;
    }

     // Get all bookings in the queue (for admin view)

    public CustomLinkedList getAllBookings() {
        // Create a copy of the queue to avoid external modification
        return queue.copy();
    }


     // Remove a specific booking from the queue by ID
     // Returns true if removed, false if not found

    public boolean removeBooking(String bookingId) {
        Object[] bookings = queue.toArray();

        for (Object obj : bookings) {
            Booking booking = (Booking) obj;
            if (booking.getId().equals(bookingId)) {
                return queue.remove(booking);
            }
        }

        return false;
    }

}
