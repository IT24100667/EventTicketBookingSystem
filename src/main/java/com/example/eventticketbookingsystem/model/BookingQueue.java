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


     // Clear all bookings from the queue

    public void clear() {
        queue.clear();
    }

    // Check if a booking with the given ID exists in the queue

    public boolean contains(String bookingId) {
        // Get all bookings as an array to iterate through them
        Object[] bookings = queue.toArray();

        //object obj=each item in array temporarily stored in obj each loop cycle
        for (Object obj : bookings) {
            //(Booking) converts object into Booking type
            Booking booking = (Booking) obj;
            //checks if the ID of the current booking matches the booking ID you're looking for
            if (booking.getId().equals(bookingId)) {
                return true;
            }
        }

        return false;//dis-matched ID of the booking
    }

     // Move a booking to the front of the queue (priority processing)
     // Returns true if successful, false if booking not found

    public boolean prioritize(String bookingId) {
        // Find the booking
        //create a variable to store the booking that you want to move
        Booking bookingToMove = null;
        //queue into array
        Object[] bookings = queue.toArray();

        //loop through bookings in array
        for (Object obj : bookings) {
            //convert object into Booking , so you can use Booking methods
            Booking booking = (Booking) obj;
            if (booking.getId().equals(bookingId)) {
                //if the ID of booking that you're looking for is matches with the current ID
                //store the booking in bookingToMove
                bookingToMove = booking;
                break;//stops loop bcz you found the ID of booking that you want
            }
        }

        // If found, remove and add to front
        if (bookingToMove != null) {
            queue.remove(bookingToMove);
            queue.addFirst(bookingToMove);
            return true; //show that it was prioritized
        }

        return false;//if the booking was not found
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
