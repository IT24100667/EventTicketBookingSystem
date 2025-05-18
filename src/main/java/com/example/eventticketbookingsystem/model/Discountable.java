package com.example.eventticketbookingsystem.model;

public interface Discountable {


    // based on number of tickets
    double getDiscount(int ticketCount);
}