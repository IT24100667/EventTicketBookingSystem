package com.example.eventticketbookingsystem.model;

public abstract class Person {
        protected String id;
        protected String fullName;
        protected String email;
        protected String phoneNumber;

        // Constructor
        public Person(String id, String fullName, String email, String phoneNumber) {
            this.id = id;
            this.fullName = fullName;
            this.email = email;
            this.phoneNumber = phoneNumber;
        }

        // Abstract method - demonstrates abstraction
        public abstract String getRole();

        // Method to save person to file - will be overridden
        public abstract String toFileString();
}
