package com.example.eventticketbookingsystem.util;

import com.example.eventticketbookingsystem.model.Concert;
import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.model.OtherEvent;
import com.example.eventticketbookingsystem.model.Sports;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class EventFileHandler {

    private static final String FILE_PATH = "C:\\Users\\Vivobook\\eventbookingsystem\\data\\events.txt";

    // data stored in file - type, id, name, description, venue, date, price, capacity, bookedSeats, ....(varies based on type)

    public List<Event> getAllEvents(){

        List<Event> events = new ArrayList<>();


        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))){
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String line;
            while ((line = reader.readLine()) != null){

                //  The split() method in Java interprets "|" as "or" operator.  \\| escapes it to make it an  "|" character.
                String[] parts = line.split("\\|");

                // Parse common fields : convert them from String to respective data types
                String eventType = parts[0];
                String id = parts[1];
                String name = parts[2];
                String description = parts[3];
                String venue = parts[4];

                Date date = dateFormat.parse(parts[5]);

                double price = Double.parseDouble(parts[6]);
                int capacity = Integer.parseInt(parts[7]);
                int bookedSeats = Integer.parseInt(parts[8]);

                // Declare the event object
                Event event = null;

                // type, id, name, description, venue, date, price, capacity, bookedSeats, artist, discountThreshold, discountPercentage
                if (eventType.equals("Concert")){
                    String artist = parts[9];
                    int discountThreshold = Integer.parseInt(parts[10]);
                    int discountPercentage = Integer.parseInt(parts[11]);

                    // instantize Concert object
                    event = new Concert(name, description, venue, date, price, capacity, artist);
                    event.setDiscountThreshold(discountThreshold);
                    event.setDiscountPercentage(discountPercentage);



                }
                // type, id, name, description, venue, date, price, capacity, bookedSeats, sportType, teams
                else if (eventType.equals("Sports")) {

                    //instantize Sport object
                    String sportType = parts[9];
                    String teams = parts[10];
                    event = new Sports(name, description, venue, date, price, capacity, sportType, teams);

                }
                else if (eventType.equals("Other")) {

                    String eventCategory = parts[9];
                    String specialRequirements = parts[10];

                    //instantize Sport object
                    event = new OtherEvent(name, description, venue, date, price, capacity, eventCategory, specialRequirements);

                }

                // only 2 fields id and bookedSeats remain
                // because of this we need to declare Event as null initially
                event.setId(id);
                event.setBookedSeats(bookedSeats);

                // add the events to the list
                events.add(event);


            }

        } catch (IOException e) {

            System.out.println("There was some Error reading file");

        } catch (ParseException e) {
            System.out.println("There was some issue when parsing Date: " + e.getMessage());;
        }

        return events;

    }



    public Event getEventById(String id){

        List<Event> events = getAllEvents(); // got all events stored in file

        for (Event event : events) {
            if (event.getId().equals(id)) {
                return event;
            }
        }
        // if we reach here it means no event found so null returned
        return null;

    }

}
