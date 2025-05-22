package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Payment;
import com.example.eventticketbookingsystem.model.Booking;


public class CashPaymentProcessor extends AbstractPaymentProcessor {


    public CashPaymentProcessor() {
        super(Payment.METHOD_CASH);
    }


    @Override
    public boolean processPayment(Payment payment, Booking booking) {
        // Cash payments are always waiting for physical payment
        payment.setStatus(Payment.STATUS_WAITING_CONFIRMATION);

        // Cash payments always succeed in the system (they'll be confirmed later)
        return true;
    }
}