package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Payment;
import com.example.eventticketbookingsystem.model.Booking;
//Base class that defines common behavior for payment processors
//Checks if a payment method is supported
//Sets payment status based on success or failure

public abstract class AbstractPaymentProcessor implements IPaymentProcessor {

    protected final String supportedMethod;

    public AbstractPaymentProcessor(String supportedMethod) {
        this.supportedMethod = supportedMethod;
    }


    @Override
    public boolean supportsPaymentMethod(String paymentMethod) {
        return supportedMethod.equals(paymentMethod);
    }


    protected void setPaymentStatus(Payment payment, boolean success) {
        if (success) {
            payment.setStatus(Payment.STATUS_WAITING_CONFIRMATION);
        } else {
            payment.setStatus(Payment.STATUS_FAILED);
        }
    }
}