package com.example.eventticketbookingsystem.model;

import java.util.Date;


public class Payment {
    public static final String METHOD_CARD = "CARD"; //  payment methods
    public static final String METHOD_CASH = "CASH";

    public static final String STATUS_PENDING = "PENDING"; // payment statuses
    public static final String STATUS_COMPLETED = "COMPLETED";
    public static final String STATUS_FAILED = "FAILED";
    public static final String STATUS_WAITING_CONFIRMATION = "WAITING_CONFIRMATION";

    private String id;                // create payment id
    private String bookingId;         // to get booking id
    private double amount;
    private String paymentMethod;
    private String status;
    private Date paymentDate;         // to get payment date


    public Payment(String bookingId, double amount, String paymentMethod) {

        this.bookingId = bookingId;
        this.id = "PAY/"+bookingId;  // create payment ID using booking ID
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = STATUS_PENDING;  // Start as pending
        this.paymentDate = new Date(); // Current time
    }


    public Payment(String id, String bookingId, double amount,
                   String paymentMethod, String status, Date paymentDate) { //load payment data
        this.id = id;
        this.bookingId = bookingId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.paymentDate = paymentDate;
    }


    public String getId() {
        return id;
    }

    public String getBookingId() {
        return bookingId;
    }

    public double getAmount() {
        return amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    // Methods to update payment information
    public void setStatus(String status) {
        this.status = status;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    // Convenience methods for changing payment status
    public void completePayment() {
        this.status = STATUS_COMPLETED;
    }

    public void failPayment() {
        this.status = STATUS_FAILED;
    }

    public void waitForConfirmation() {
        this.status = STATUS_WAITING_CONFIRMATION;
    }
}