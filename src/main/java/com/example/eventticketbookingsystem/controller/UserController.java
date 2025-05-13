package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.User;
import com.example.eventticketbookingsystem.util.UserFileHandler;

public class UserController {
    public User getUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }

        return UserFileHandler.getUserByUsername(username);
    }

}
