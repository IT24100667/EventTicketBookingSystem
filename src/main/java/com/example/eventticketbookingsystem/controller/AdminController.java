package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Admin;
import com.example.eventticketbookingsystem.util.UserFileHandler;

public class AdminController {

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
