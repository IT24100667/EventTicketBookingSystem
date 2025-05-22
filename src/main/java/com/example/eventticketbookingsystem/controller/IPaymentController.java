package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Payment;
import java.util.Date;
import java.util.List;


public interface IPaymentController {

    String processPayment(String bookingId, String paymentMethod);
    String createPayment(String bookingId, double amount, String paymentMethod, String status, Date paymentDate);


    Payment getPaymentById(String paymentId);
    Payment getPaymentByBookingId(String bookingId);
    List<Payment> getAllPayments();
    double getTotalCardRevenue();
    int getTotalCashPaymentsCount();



    boolean updatePayment(Payment payment);
    boolean updatePaymentStatusForBooking(String bookingId, String bookingStatus);
}