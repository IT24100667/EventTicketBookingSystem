package com.example.eventticketbookingsystem.util;

import com.example.eventticketbookingsystem.model.Booking;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

     // BookingFileHandler manages reading and writing booking data to a file

    public class BookingFileHandler {

        private static final String DATA_DIRECTORY = System.getProperty("user.home") +
                File.separator + "eventbookingsystem" + File.separator + "data";

        private static final String FILE_PATH = DATA_DIRECTORY + File.separator + "bookings.txt";
        private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

         // Save a booking to the file

        public boolean saveBooking(Booking booking) {
            List<Booking> bookings = getAllBookings();

            // Check if booking already exists
            boolean exists = false;
            for (int i = 0; i < bookings.size(); i++) {
                if (bookings.get(i).getId().equals(booking.getId())) {
                    bookings.set(i, booking);  // Replace with updated booking
                    exists = true;
                    break;
                }
            }

            if (!exists) {
                bookings.add(booking);  // Add new booking
            }

            return saveAllBookings(bookings);
        }

         // Get all bookings from the file

        public List<Booking> getAllBookings() {
            List<Booking> bookings = new ArrayList<>();

            // Create directory if it doesn't exist
            File directory = new File(FILE_PATH);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            // Check if file exists
            File file = new File(FILE_PATH);
            if (!file.exists()) {
                return bookings;  // Return empty list if file doesn't exist
            }

            try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
                String line;

                while ((line = reader.readLine()) != null) {
                    try {
                        // Format: id|userId|eventId|ticketQuantity|totalPrice|status|bookingDate
                        String[] parts = line.split("\\|");

                        if (parts.length < 7) {
                            System.out.println("Invalid booking format: " + line);
                            continue;
                        }

                        String id = parts[0];
                        String userId = parts[1];
                        String eventId = parts[2];
                        int ticketQuantity = Integer.parseInt(parts[3]);
                        double totalPrice = Double.parseDouble(parts[4]);
                        String status = parts[5];
                        Date bookingDate = DATE_FORMAT.parse(parts[6]);

                        Booking booking = new Booking(id, userId, eventId, ticketQuantity,
                                totalPrice, status, bookingDate);
                        bookings.add(booking);

                    } catch (NumberFormatException | ParseException e) {
                        System.out.println("Error parsing booking: " + line);
                        // Continue to next line
                    }
                }
            } catch (IOException e) {
                System.out.println("Error reading bookings file: " + e.getMessage());
            }

            return bookings;
        }

         // Get a booking by ID

        public Booking getBookingById(String id) {
            List<Booking> bookings = getAllBookings();

            for (Booking booking : bookings) {
                if (booking.getId().equals(id)) {
                    return booking;
                }
            }

            return null;  // Not found
        }

         // Delete a booking by ID

        public boolean deleteBooking(String id) {
            List<Booking> bookings = getAllBookings();
            List<Booking> updatedBookings = new ArrayList<>();
            boolean removed = false;

            for (Booking booking : bookings) {
                if (!booking.getId().equals(id)) {
                    updatedBookings.add(booking);
                } else {
                    removed = true;
                }
            }

            if (removed) {
                return saveAllBookings(updatedBookings);
            }

            return false;  // Booking not found
        }

         // Save all bookings to the file

        private boolean saveAllBookings(List<Booking> bookings) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
                for (Booking booking : bookings) {
                    // Format: id|userId|eventId|ticketQuantity|totalPrice|status|bookingDate
                    StringBuilder line = new StringBuilder();
                    line.append(booking.getId()).append("|");
                    line.append(booking.getUserId()).append("|");
                    line.append(booking.getEventId()).append("|");
                    line.append(booking.getTicketQuantity()).append("|");
                    line.append(booking.getTotalPrice()).append("|");
                    line.append(booking.getStatus()).append("|");
                    line.append(DATE_FORMAT.format(booking.getBookingDate()));

                    writer.write(line.toString());
                    writer.newLine();
                }

                return true;
            } catch (IOException e) {
                System.out.println("Error writing bookings file: " + e.getMessage());
                return false;
            }
        }

         // Get all bookings for a specific user

        public List<Booking> getBookingsByUserId(String userId) {
            List<Booking> allBookings = getAllBookings();
            List<Booking> userBookings = new ArrayList<>();

            for (Booking booking : allBookings) {
                if (booking.getUserId().equals(userId)) {
                    userBookings.add(booking);
                }
            }

            return userBookings;
        }

         // Get all bookings for a specific event

        public List<Booking> getBookingsByEventId(String eventId) {
            List<Booking> allBookings = getAllBookings();
            List<Booking> eventBookings = new ArrayList<>();

            for (Booking booking : allBookings) {
                if (booking.getEventId().equals(eventId)) {
                    eventBookings.add(booking);
                }
            }

            return eventBookings;
        }

         // Get all bookings with a specific status

        public List<Booking> getBookingsByStatus(String status) {
            List<Booking> allBookings = getAllBookings();
            List<Booking> statusBookings = new ArrayList<>();

            for (Booking booking : allBookings) {
                if (booking.getStatus().equals(status)) {
                    statusBookings.add(booking);
                }
            }

            return statusBookings;
        }
    }

