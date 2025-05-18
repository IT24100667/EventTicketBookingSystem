package com.example.eventticketbookingsystem.util;

import com.example.eventticketbookingsystem.model.Event;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class EventFileHandler {

    private static final String FILE_PATH = "C:\\Users\\Vivobook\\eventbookingsystem\\data\\events.txt";

    // data stored in file - type, id, name, description, venue, date, price, capacity, bookedSeats, artist

    public void getAllEvents(){

        List<Event> events = new ArrayList<>();


        try {
            BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH));
            String line;
            while ((line = reader.readLine()) != null){

                //  The split() method in Java interprets "|" as "or" operator.  \\| escapes it to make it an  "|" character.
                String[] parts = line.split("\\|");

                // Parse common fields : convert them from String to respective data types
                String type = parts[0];
                String id = parts[1];
                String name = parts[2];
                String description = parts[3];
                String venue = parts[4];
                String date = parts[5];
                double price = Double.parseDouble(parts[6]);
                int capacity = Integer.parseInt(parts[7]);
                int bookedSeats = Integer.parseInt(parts[8]);


            }

        } catch (IOException e) {

        }
    }


}
