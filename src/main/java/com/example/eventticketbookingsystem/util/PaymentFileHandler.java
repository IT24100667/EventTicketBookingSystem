package com.example.eventticketbookingsystem.util;

import com.example.eventticketbookingsystem.model.Payment;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class PaymentFileHandler {

    private static final String DATA_DIRECTORY = System.getProperty("user.home") +
            File.separator + "eventbookingsystem" + File.separator + "data";

    private static final String FILE_PATH = DATA_DIRECTORY + File.separator + "payments.txt";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


    public boolean savePayment(Payment payment) { //save payments to file path
        if (payment == null) return false;

        List<Payment> payments = getAllPayments();

        // Check payment information, else stop and return
        boolean exists = false;
        for (int i = 0; i < payments.size(); i++) {
            if (payments.get(i).getId().equals(payment.getId())) {
                payments.set(i, payment);
                exists = true;
                break;
            }
        }

        if (!exists) {
            payments.add(payment);
        }

        return writePaymentsToFile(payments);
    }


    public List<Payment> getAllPayments() { //read from file
        List<Payment> payments = new ArrayList<>();
        File file = new File(FILE_PATH);


        File directory = new File(FILE_PATH);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        // return empty list if file doesn't exist
        if (!file.exists()) return payments;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    // error handling
                    String[] parts = line.split("\\|");
                    if (parts.length < 6) continue;

                    payments.add(new Payment(
                            parts[0],
                            parts[1],
                            Double.parseDouble(parts[2]),
                            parts[3],
                            parts[4],
                            DATE_FORMAT.parse(parts[5])
                    ));
                } catch (Exception e) {
                    System.out.println("Error parsing payment: " + line);
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading payments file: " + e.getMessage());
        }

        return payments;
    }


    private boolean writePaymentsToFile(List<Payment> payments) { //save payment list to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Payment payment : payments) {
                //error handling and store payment details to file
                writer.write(String.format("%s|%s|%s|%s|%s|%s",
                        payment.getId(),
                        payment.getBookingId(),
                        payment.getAmount(),
                        payment.getPaymentMethod(),
                        payment.getStatus(),
                        DATE_FORMAT.format(payment.getPaymentDate())
                ));
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.out.println("Error writing payments file: " + e.getMessage());
            return false;
        }
    }


    public Payment getPaymentById(String id) { //read and return payment using payment id
        if (id == null) return null;

        for (Payment payment : getAllPayments()) {
            if (id.equals(payment.getId())) {
                return payment;
            }
        }
        return null;
    }


    public Payment getPaymentByBookingId(String bookingId) { //If it finds a payment with a matching booking ID, it immediately returns that payment record.
        if (bookingId == null) return null;

        for (Payment payment : getAllPayments()) {
            if (bookingId.equals(payment.getBookingId())) {
                return payment;
            }
        }
        return null;
    }
}
