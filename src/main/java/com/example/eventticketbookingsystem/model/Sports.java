package com.example.eventticketbookingsystem.model;

import java.util.Date;

public class Sports extends Event {


    private String sportType;
    private String teams;

    public Sports(String name, String description, String venue, Date date, double price, int capacity, String sportType, String teams) {
        super(name, description, venue, date, price, capacity, "Sports");
        this.sportType = sportType;
        this.teams = teams;
    }


    @Override
    public double calculateTicketPrice() {
        return getPrice();
    }

    public String getSportType() {
        return sportType;
    }

    public void setSportType(String sportType) {
        this.sportType = sportType;
    }

    public String getTeams() {
        return teams;
    }

    public void setTeams(String teams) {
        this.teams = teams;
    }
}
