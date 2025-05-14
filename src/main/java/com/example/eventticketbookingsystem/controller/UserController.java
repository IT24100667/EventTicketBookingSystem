package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.User;
import com.example.eventticketbookingsystem.util.UserFileHandler;

public class UserController {


     // Register a new regular user
     // @return true if registration successful, false if username already exists

    public boolean registerUser(String username, String password, String fullName,
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

        // Add the user
        return UserFileHandler.addUser(username, password, fullName, email, phoneNumber);
    }


    //Update existing user information

    public boolean updateUser(String id, String username, String password,
                              String fullName, String email, String phoneNumber) {
        // Validate input data
        if (id == null || username == null || password == null || fullName == null ||
                email == null || phoneNumber == null ||
                id.trim().isEmpty() || username.trim().isEmpty() ||
                fullName.trim().isEmpty()) {
            return false;
        }

        // Basic email validation
        if (!email.contains("@") || !email.contains(".")) {
            return false;
        }

        // Check if the user exists and is not an admin
        User existingUser = getUserById(id);
        if (existingUser == null) {
            return false;
        }

        // Update the user
        return UserFileHandler.updateUser(id, username, password, fullName, email, phoneNumber);
    }


     // Delete a user
    public boolean deleteUser(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }

        // Check if the user exists and is not an admin
        User existingUser = getUserById(id);
        if (existingUser == null) {
            return false;
        }

        return UserFileHandler.deletePerson(id);
    }


    //Get user by ID

    public User getUserById(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }

        return UserFileHandler.getUserById(id);

    }



    public User getUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }

        return UserFileHandler.getUserByUsername(username);
    }



     //Get all regular users

    public List<User> getAllUsers() {
        return UserFileHandler.getAllUsers();
    }


     //Authenticate a user
    public User authenticateUser(String username, String password) {
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }

        return UserFileHandler.authenticateUser(username, password);
    }


}
