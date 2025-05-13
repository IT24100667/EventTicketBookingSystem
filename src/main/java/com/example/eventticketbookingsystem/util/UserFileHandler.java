package com.example.eventticketbookingsystem.util;


import com.example.eventticketbookingsystem.model.Admin;
import com.example.eventticketbookingsystem.model.Person;
import com.example.eventticketbookingsystem.model.User;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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


}
