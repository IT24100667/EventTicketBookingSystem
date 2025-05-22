package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Payment;
import com.example.eventticketbookingsystem.model.Booking;


public interface IPaymentProcessor {


    boolean processPayment(Payment payment, Booking booking); //do you want to pay your bookings ? (T/F)


    boolean supportsPaymentMethod(String paymentMethod); //what is your payment method (cash or credit) ? (T/F)
}