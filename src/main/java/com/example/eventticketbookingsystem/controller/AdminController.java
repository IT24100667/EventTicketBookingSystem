package com.example.eventticketbookingsystem.controller;

import com.example.eventticketbookingsystem.model.Admin;
import com.example.eventticketbookingsystem.model.User;
import com.example.eventticketbookingsystem.util.UserFileHandler;

import java.util.List;

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

    // Updates an existing admin's information based on the provided ID and new details
    public boolean updateAdmin(String id, String username, String password,
                               String fullName, String email, String phoneNumber) {
        // Validate input data: check for null values or required fields being empty
        if (id == null || username == null || password == null || fullName == null ||
                email == null || phoneNumber == null ||
                id.trim().isEmpty() || username.trim().isEmpty() ||
                fullName.trim().isEmpty()) {
            // Invalid input; cannot proceed with update
            return false;
        }
        // Basic email validation: must contain "@" and "."
        if (!email.contains("@") || !email.contains(".")) {
            // Email format is invalid
            return false;
        }
        // Retrieve the existing admin using the provided ID
        Admin existingAdmin = getAdminById(id);
        if (existingAdmin == null) {
            // No admin found with the specified ID
            return false;
        }
        // Delegate the update operation to the UserFileHandler
        return UserFileHandler.updateUser(id, username, password, fullName, email, phoneNumber);
    }

    public boolean deleteAdmin(String id) {
        // Validate the ID: check if it is null or empty
        if (id == null || id.trim().isEmpty()) {
            return false;
        }
        // Check if a person with the given ID exists and is an Admin
        Admin existingAdmin = getAdminById(id);
        if (existingAdmin == null) {
            // Return false if the admin doesn't exist
            return false;
        }
        // Attempt to delete the Admin using a file handler utility
        return UserFileHandler.deletePerson(id);
    }

    // Retrieves an Admin object by its unique ID
    public Admin getAdminById(String id) {
        // Validate the ID: check if it's null or empty after trimming
        if (id == null || id.trim().isEmpty()) {
            // Invalid ID, return null
            return null;
        }
        // Delegate the retrieval to UserFileHandler to get the admin by ID
        return UserFileHandler.getAdminById(id);
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

    public List<Admin> getAllAdmins() {
        // Delegate the retrieval of all Admins to the UserFileHandler
        return UserFileHandler.getAllAdmins();
    }

    public Admin authenticateAdmin(String username, String password) {
        // Validate input: check for null or empty username/password
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        // Delegate authentication to the UserFileHandler
        return UserFileHandler.authenticateAdmin(username, password);
    }

    public String getSystemStatistics() {
        // Get the total number of users in the system
        int userCount = UserFileHandler.getAllUsers().size();
        // Get the total number of admins in the system
        int adminCount = UserFileHandler.getAllAdmins().size();
        // Return a summary string with user and admin counts
        return "Users: " + userCount + ", Admins: " + adminCount;
    }

    public User getUserById(String id) {
        // Validate the ID: ensure it's not null or empty
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        // Delegate the retrieval to the UserFileHandler
        return UserFileHandler.getUserById(id);
    }

    public List<User> getAllUsers() {
        // Delegate the retrieval of users to the UserFileHandler
        return UserFileHandler.getAllUsers();
    }

    public boolean deleteUserAsAdmin(String userId) {
        // Validate the user ID: ensure it is not null or empty
        if (userId == null || userId.trim().isEmpty()) {
            return false;
        }
        // Verify that the user with the given ID exists
        User existingUser = getUserById(userId);
        if (existingUser == null) {
            // User does not exist, deletion cannot proceed
            return false;
        }
        // Delegate the deletion process to the UserFileHandler
        return UserFileHandler.deletePerson(userId);
    }
}
