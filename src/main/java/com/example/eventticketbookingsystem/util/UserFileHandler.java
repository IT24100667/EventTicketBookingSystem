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


    // Add a new regular user
    public static boolean addUser(String username, String password, String fullName,
                                  String email, String phoneNumber) {
        // Check if username already exists
        if (getUserByUsername(username) != null) {
            return false;
        }

        String id = UUID.randomUUID().toString();
        User user = new User(id, username, password, fullName, email, phoneNumber);

        people.add(user);
        savePeople();
        return true;
    }


    // Get person by ID
    public static Person getPersonById(String id) {
        for (Person person : people) {
            if (person.getId().equals(id)) {
                return person;
            }
        }
        return null;
    }


    // Get user by ID (returns only regular User objects, not Admin)
    public static User getUserById(String id) {
        Person person = getPersonById(id);
        if (person instanceof User && !(person instanceof Admin)) {
            return (User) person;
        }
        return null;
    }


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


    // Get user by username (returns either User or Admin)

    public static User getUserByUsername(String username) {
        for (Person person : people) {
            if (person instanceof User) {
                User user = (User) person;
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


    //Get all regular users
    public static List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        for (Person person : people) {
            if (person instanceof User && !(person instanceof Admin)) {
                users.add((User) person);
            }
        }
        return users;
    }


    // Update user information (works for both User and Admin)
    public static boolean updateUser(String id, String username, String password,
                                     String fullName, String email, String phoneNumber) {
        Person personToUpdate = getPersonById(id);
        if (personToUpdate == null || !(personToUpdate instanceof User)) {
            return false;
        }

        User user = (User) personToUpdate;

        // Check if new username conflicts with another user
        User existingUser = getUserByUsername(username);
        if (existingUser != null && !existingUser.getId().equals(id)) {
            return false; // Username taken by another user
        }

        // Update user information
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);

        savePeople();
        return true;
    }


    //Delete a person by ID (works for both User and Admin)
    public static boolean deletePerson(String id) {
        for (int i = 0; i < people.size(); i++) {
            if (people.get(i).getId().equals(id)) {
                people.remove(i);
                savePeople();
                return true;
            }
        }
        return false;
    }


    //Authenticate user (works for both User and Admin)
    public static User authenticateUser(String username, String password) {
        for (Person person : people) {
            if (person instanceof User) {
                User user = (User) person;
                if (user.getUsername().equals(username) &&
                        user.getPassword().equals(password) &&
                        !(person instanceof Admin)) {
                    return user;
                }
            }
        }
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

    public static Admin getAdminById(String id) {
        // Retrieve a person using the provided ID
        Person person = getPersonById(id);
        // Check if the retrieved person is an Admin
        if (person instanceof Admin) {
            // Cast and return the Admin object
            return (Admin) person;
        }
        // Return null if the person is not an Admin or does not exist
        return null;
    }

    public static List<Admin> getAllAdmins() {
        // Create a new list to store Admin objects
        List<Admin> admins = new ArrayList<>();

        // Iterate over all people
        for (Person person : people) {
            // Check if the current person is an instance of Admin
            if (person instanceof Admin) {
                // Cast the person to Admin and add to the list
                admins.add((Admin) person);
            }
        }
        // Return the list of Admins
        return admins;
    }

    public static Admin authenticateAdmin(String username, String password) {
        // Iterate through the list of people
        for (Person person : people) {
            // Check if the person is an Admin
            if (person instanceof Admin) {
                Admin admin = (Admin) person;
                // Check if the username and password match
                if (admin.getUsername().equals(username) &&
                        admin.getPassword().equals(password)) {
                    // Return the matching Admin
                    return admin;
                }
            }
        }
        // Return null if no matching Admin was found
        return null;
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
