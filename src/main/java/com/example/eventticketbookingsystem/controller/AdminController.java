package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Admin;
import com.example.eventticketbookingsystem.util.UserFileHandler;

public class AdminController {

    public boolean registerAdmin(String username, String password, String fullName,
                                 String email, String phoneNumber) {
        // Validate input data
        if (username == null || password == null || fullName == null ||
                email == null || phoneNumber == null ||
                username.trim().isEmpty() || password.trim().isEmpty() ||
                fullName.trim().isEmpty()) {
            return false;
        }
        // Basic email validation
        if (!email.contains("@") || !email.contains(".")) {
            return false;
        }
        // Add the admin
        return UserFileHandler.addAdmin(username, password, fullName, email, phoneNumber);
    }

    public Admin getAdminByUsername(String username) {
        // Check if the provided username is null or empty after trimming
        if (username == null || username.trim().isEmpty()) {
            // Return null if the username is invalid
            return null;
        }

        // Delegate the retrieval of the admin to the UserFileHandler
        return UserFileHandler.getAdminByUsername(username);
    }
}
