package com.example.eventticketbookingsystem.model;

import java.util.Date;

public class Concert extends Event implements Discountable {

    private String artist;

    public Concert(String name, String description, String venue, Date date, double price, int capacity, String artist) {
        super(name, description, venue, date, price, capacity, "Concert");  // give event type parameter as concert
        this.artist = artist;
    }


    // abstract method implemented
    @Override
    public double calculateTicketPrice() {
        return getPrice();
    }

    @Override
    public double getDiscount(int ticketQuantity) {
        return super.getDiscount(ticketQuantity);
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }
}
