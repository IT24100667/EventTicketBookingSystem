package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.BookingQueue;
import com.example.eventticketbookingsystem.util.BookingFileHandler;

public class BookingController {

    private BookingFileHandler fileHandler;
    private static BookingQueue bookingQueue = new BookingQueue();  // Shared queue for FIFO processing
    private EventController eventController;

    public BookingController() {
        this.fileHandler = new BookingFileHandler();
        this.eventController = new EventController();
    }


}
