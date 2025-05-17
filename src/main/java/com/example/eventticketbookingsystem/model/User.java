package com.example.eventticketbookingsystem.model;


    public class User extends Person {
        private String username;    // Username for login
        private String password;    // Password for login
        private boolean isAdmin;    // Flag to identify if user is an admin



        //Constructor for creating a new user

        public User(String id, String username, String password, String fullName, String email, String phoneNumber) {
            super(id, fullName, email, phoneNumber); // Call parent constructor
            this.username = username;
            this.password = password;
            this.isAdmin = false;   // By default, a user is not an admin
        }

        // Getters and setters
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }

        public boolean isAdmin() { return isAdmin; }
        public void setAdmin(boolean admin) { isAdmin = admin; }



    }