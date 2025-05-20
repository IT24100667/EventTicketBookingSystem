package com.example.eventticketbookingsystem.model;

public interface Discountable {

    //defines what a class must do, not how
    //.

    // get discound percentage based on ticket number
    double getDiscount(int ticketCount);

    // min number of tickets to be eligible for discount
    int getDiscountThreshold();

    // discount percentage
    int getDiscountPercentage();
}