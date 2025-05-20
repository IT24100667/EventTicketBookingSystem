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


}
