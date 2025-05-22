package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Payment;
import com.example.eventticketbookingsystem.model.Booking;


public class CardPaymentProcessor extends AbstractPaymentProcessor {

    public CardPaymentProcessor() {
        super(Payment.METHOD_CARD);
    }


    @Override
    public boolean processPayment(Payment payment, Booking booking) {
        // Card-specific validation could go here

        // Simulate card processing (in real system, would call payment gateway)
        boolean success = simulateCardPaymentProcessing();

        // Set appropriate status
        setPaymentStatus(payment, success);

        return success;
    }


    private boolean simulateCardPaymentProcessing() {
        // For educational purposes, payment succeeds 90% of the time
        return Math.random() < 0.9;
    }
}