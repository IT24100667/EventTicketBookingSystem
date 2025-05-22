package com.example.eventticketbookingsystem.model;

public class Admin extends User {

    //Constructor for creating a new admin
    public Admin(String id, String username, String password, String fullName, String email, String phoneNumber) {
        // Call the parent constructor
        super(id, username, password, fullName, email, phoneNumber);
        setAdmin(true); // Set as admin
    }

    //for only admins,
    public boolean canManageSystem() {
        return true;  //admins have system management permission
    }
}
