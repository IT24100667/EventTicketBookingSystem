package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Booking;
import com.example.eventticketbookingsystem.model.Payment;
import com.example.eventticketbookingsystem.util.PaymentFileHandler;

import java.util.Date;
import java.util.List;


public class PaymentController implements IPaymentController {


    private final PaymentFileHandler fileHandler;
    private final BookingController bookingController;


    public PaymentController(PaymentFileHandler fileHandler, BookingController bookingController) {
        this.fileHandler = fileHandler;
        this.bookingController = bookingController;
    }


    public PaymentController() {
        this.fileHandler = new PaymentFileHandler();
        this.bookingController = new BookingController();
    }


    @Override
    public String processPayment(String bookingId, String paymentMethod) {
        // Get the booking
        Booking booking = bookingController.getBookingById(bookingId);

        if (booking == null) {
            return null;  // Booking not found
        }

        // Check for existing payment
        Payment existingPayment = checkExistingPayment(bookingId);
        if (existingPayment != null) {
            return existingPayment.getId();
        }

        // Create payment
        Payment payment = new Payment(bookingId, booking.getTotalPrice(), paymentMethod);
        payment.setStatus("PENDING"); // Set initial status explicitly

        // Process the payment
        boolean paymentSuccessful = processPaymentTransaction(payment);

        // Update booking status based on payment result
        updateBookingAfterPayment(bookingId, paymentSuccessful);

        // Save payment
        boolean saved = fileHandler.savePayment(payment);
        return saved ? payment.getId() : null; //return p id if it success
    }


    @Override //from ipc
    public String createPayment(String bookingId, double amount, String paymentMethod, String status, Date paymentDate) {
        // Check for existing payment
        Payment existingPayment = checkExistingPayment(bookingId);
        if (existingPayment != null) {
            return existingPayment.getId();  //if booking not null get p id
        }

        // Create a new payment with the specified details
        Payment payment = new Payment(bookingId, amount, paymentMethod);
        payment.setStatus(status);
        payment.setPaymentDate(paymentDate);

        // Makes sure the booking is properly queued
        ensureBookingInQueue(bookingId);

        // Save payment
        boolean saved = fileHandler.savePayment(payment);
        return saved ? payment.getId() : null; //return id
    }


    @Override //ipc
    public boolean updatePayment(Payment payment) {
        return fileHandler.savePayment(payment);
    }


    @Override //ipc
    public boolean updatePaymentStatusForBooking(String bookingId, String bookingStatus) {
        Payment payment = getPaymentByBookingId(bookingId);
        if (payment == null) {
            return false;
        }

        // If booking is confirmed, payment becomes "COMPLETED"
        //If booking is cancelled, payment becomes "CANCELLED" in q
        if (Booking.STATUS_CONFIRMED.equals(bookingStatus)) {
            payment.setStatus("COMPLETED");
        } else if (Booking.STATUS_CANCELLED.equals(bookingStatus)) {
            payment.setStatus("CANCELLED"); // Changed to "CANCELLED"
        }

        return fileHandler.savePayment(payment);
    }

    //Finds all payments linked to cancelled bookings
    //Makes sure their status is set to "CANCELLED"
    public void updateAllCancelledPayments() {
        List<Payment> allPayments = getAllPayments();
        List<Booking> cancelledBookings = bookingController.getBookingsByStatus(Booking.STATUS_CANCELLED);

        for (Payment payment : allPayments) {
            for (Booking booking : cancelledBookings) {
                if (payment.getBookingId().equals(booking.getId())) {
                    // This payment belongs to a cancelled booking
                    if (!"CANCELLED".equals(payment.getStatus())) {
                        payment.setStatus("CANCELLED");
                        fileHandler.savePayment(payment);
                    }
                    break;
                }
            }
        }
    }


    @Override
    public Payment getPaymentById(String paymentId) {
        return fileHandler.getPaymentById(paymentId);
    }


    @Override
    public Payment getPaymentByBookingId(String bookingId) {
        return fileHandler.getPaymentByBookingId(bookingId);
    }


    @Override
    public List<Payment> getAllPayments() {
        return fileHandler.getAllPayments();
    }


    @Override
    public double getTotalCardRevenue() {
        List<Payment> allPayments = fileHandler.getAllPayments();
        return allPayments.stream()
                .filter(payment -> Payment.METHOD_CARD.equals(payment.getPaymentMethod()))
                .filter(payment -> "COMPLETED".equals(payment.getStatus()) ||
                        "WAITING_CONFIRMATION".equals(payment.getStatus()))
                .mapToDouble(Payment::getAmount)
                .sum();
    }


    @Override
    public int getTotalCashPaymentsCount() {
        List<Payment> allPayments = fileHandler.getAllPayments();
        return (int) allPayments.stream()
                .filter(payment -> Payment.METHOD_CASH.equals(payment.getPaymentMethod()))
                .count();
    }


    // Private helper methods - demonstrates information hiding


    private Payment checkExistingPayment(String bookingId) {
        Payment existingPayment = fileHandler.getPaymentByBookingId(bookingId);
        if (existingPayment != null &&
                ("COMPLETED".equals(existingPayment.getStatus()) ||
                        "WAITING_CONFIRMATION".equals(existingPayment.getStatus()))) {
            return existingPayment;  // Valid payment exists
        }
        return null;
    }


    private boolean processPaymentTransaction(Payment payment) {
        // For educational purposes, payment always succeeds
        boolean success = simulatePaymentProcessing(payment);

        if (success) {
            payment.setStatus("WAITING_CONFIRMATION");
        } else {
            payment.setStatus("CANCELLED"); // Changed from "FAILED" to "CANCELLED"
        }

        return success;
    }


    private boolean simulatePaymentProcessing(Payment payment) {
        // For educational purposes, payment always succeeds
        return true;
    }


    private void updateBookingAfterPayment(String bookingId, boolean paymentSuccessful) {
        if (paymentSuccessful) {
            ensureBookingInQueue(bookingId);
        } else {
            bookingController.updateBookingStatus(bookingId, Booking.STATUS_FAILED);
        }
    }


    private void ensureBookingInQueue(String bookingId) {
        if (!bookingController.isBookingInQueue(bookingId)) {
            bookingController.addBookingToQueue(bookingId);
        }
    }
}