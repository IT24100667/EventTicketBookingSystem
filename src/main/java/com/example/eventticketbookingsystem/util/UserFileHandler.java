package com.example.eventticketbookingsystem.util;


import com.example.eventticketbookingsystem.model.Admin;
import com.example.eventticketbookingsystem.model.Person;
import com.example.eventticketbookingsystem.model.User;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserFileHandler {


     //UserFileHandler - manages storing and retrieving User objects from files
     // Shared utility for both User and Admin components


        // Define a specific location for data files
        private static final String DATA_DIRECTORY = System.getProperty("user.home") +
                File.separator + "eventbookingsystem" + File.separator + "data";

        private static final String USER_FILE = DATA_DIRECTORY + File.separator + "users.txt";
        private static List<Person> people = new ArrayList<>();


     //Load people from file

    private static void loadPeople() {
        people.clear();

        try {
            File file = new File(USER_FILE);
            if (!file.exists()) {
                return;
            }

            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line;

            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7) {
                    String id = parts[0];
                    String username = parts[1];
                    String password = parts[2];
                    String fullName = parts[3];
                    String email = parts[4];
                    String phoneNumber = parts[5];
                    boolean isAdmin = Boolean.parseBoolean(parts[6]);

                    if (isAdmin) {
                        people.add(new Admin(id, username, password, fullName, email, phoneNumber));
                    } else {
                        people.add(new User(id, username, password, fullName, email, phoneNumber));
                    }
                }
            }
            reader.close();

            System.out.println("Loaded " + people.size() + " people from file");

        } catch (IOException e) {
            System.out.println("Error loading people: " + e.getMessage());
        }
    }

        static {
            // Create directory if it doesn't exist
            File dataDir = new File(DATA_DIRECTORY);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created data directory: " + dataDir.getAbsolutePath() +
                        " (Success: " + created + ")");
            } else {
                System.out.println("Using existing data directory: " + dataDir.getAbsolutePath());
            }

            System.out.println("User file will be stored at: " + new File(USER_FILE).getAbsolutePath());

            loadPeople();
        }



     // Get user by username (returns either User or Admin)

    public static User getUserByUsername(String username) {
        for (Person person : people) {
            if (person instanceof User) {
                User user = (User)person;
                if (user.getUsername().equals(username)) {
                    return user;
                }
            }
        }
        return null;
    }

    public static Admin getAdminByUsername(String username) {
        // Get the user associated with the given username
        User user = getUserByUsername(username);

        // Check if the user is an instance of Admin
        if (user instanceof Admin) {
            // Cast and return the Admin object
            return (Admin) user;
        }

        // Return null if the user is not an Admin or doesn't exist
        return null;
    }

    // Adds a new admin to the system if the username is not already taken
    public static boolean addAdmin(String username, String password, String fullName,
                                   String email, String phoneNumber) {
        // Check if a user with the given username already exists in the system
        if (getUserByUsername(username) != null) {
            // Username is already taken; cannot add admin
            return false;
        }

        // Generate a unique ID for the new admin using UUID
        String id = UUID.randomUUID().toString();
        // Create a new Admin object with the provided information
        Admin admin = new Admin(id, username, password, fullName, email, phoneNumber);
        // Add the new admin to the list of people

        people.add(admin);
        // Save the updated list of people to persistent storage
        savePeople();
        // Return true to indicate that the admin was successfully added
        return true;
    }

    // Saves the list of people to a file specified by USER_FILE
    private static void savePeople() {
        try {
            // Create a BufferedWriter to write to the file
            BufferedWriter writer = new BufferedWriter(new FileWriter(USER_FILE));
            // Iterate through each person in the list
            for (Person person : people) {
                // Convert the person object to a file-friendly string and write it to the file
                writer.write(person.toFileString());
                writer.newLine(); // Write a newline after each person
            }
            // Close the writer to finalize the file and free resources
            writer.close();
            // Print a confirmation message with the number of people saved
            System.out.println("Saved " + people.size() + " people to file");
        } catch (IOException e) {
            // Handle any I/O errors that occur during writing
            System.out.println("Error saving people: " + e.getMessage());
        }
    }

}
