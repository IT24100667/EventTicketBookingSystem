package com.example.eventticketbookingsystem.util;

import com.example.eventticketbookingsystem.model.Concert;
import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.model.OtherEvent;
import com.example.eventticketbookingsystem.model.Sports;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class EventFileHandler {

    // added a specific location for data files
    private static final String DATA_DIRECTORY = System.getProperty("user.home") +
            File.separator + "eventbookingsystem" + File.separator + "data";

    private static final String FILE_PATH = DATA_DIRECTORY + File.separator + "events.txt";

    // Constructor to ensure the data directory exists
    public EventFileHandler() {
        initializeDataDirectory();
    }

    // Make sure the data directory exists
    private void initializeDataDirectory() {
        File directory = new File(DATA_DIRECTORY);
        if (!directory.exists()) {
            boolean created = directory.mkdirs();
            if (created) {
                System.out.println("Created data directory at: " + DATA_DIRECTORY);
            } else {
                System.out.println("Failed to create data directory at: " + DATA_DIRECTORY);
            }
        }
    }

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

                // Declaration
                Event event = null;

                // type, id, name, description, venue, date, price, capacity, bookedSeats, artist, discountThreshold, discountPercentage
                if (eventType.equals("Concert")){
                    String artist = parts[9];
                    int discountThreshold = Integer.parseInt(parts[10]);
                    int discountPercentage = Integer.parseInt(parts[11]);

                    // instantize Concert object
                    Concert concertEvent = new Concert(name, description, venue, date, price, capacity, artist);

                    concertEvent.setDiscountThreshold(discountThreshold);
                    concertEvent.setDiscountPercentage(discountPercentage);

                    // Assign to the event variable
                    event = concertEvent;



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


    // saving methods

    // this is just a supporting method
    private boolean saveAllEvents(List<Event> events){
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))){

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

            // get the event from events list
            for (Event event : events){
                StringBuilder line = new StringBuilder();

                // .append is used to add the values to the "line" and every value is seperated by "|"

                //removing newlines to avoid any errors when admin gives a description
                String cleanDescription = event.getDescription().replace("\n", " ").replace("\r", " ");

                line.append(event.getEventType()).append("|");
                line.append(event.getId()).append("|");
                line.append(event.getName()).append("|");
                line.append(cleanDescription).append("|");
                line.append(event.getVenue()).append("|");
                line.append(dateFormat.format(event.getDate())).append("|"); // converts the data to a string in yyyy-MM-dd format
                line.append(event.getPrice()).append("|");
                line.append(event.getCapacity()).append("|");
                line.append(event.getBookedSeats()).append("|");
                // until this point writing data to files remain the same for all event types


                if (event.getEventType().equals("Concert")){
                    Concert concert = (Concert) event;
                    line.append(concert.getArtist()).append("|");
                    line.append(concert.getDiscountThreshold()).append("|");
                    line.append(concert.getDiscountPercentage());
                }

                else if (event.getEventType().equals("Sports")) {
                    Sports sports = (Sports) event;
                    line.append(sports.getSportType()).append("|");
                    line.append(sports.getTeams());
                }

                else if (event.getEventType().equals("Other")) {
                    OtherEvent otherEvent = (OtherEvent) event;
                    line.append(otherEvent.getEventCategory()).append("|");
                    line.append(otherEvent.getSpecialRequirements());
                }


                writer.write(line.toString());
                writer.newLine();
            }

            return true;


        } catch (IOException e) {
            System.out.println("Error when writing to file" + e.getMessage());
            return false;
        }
    }

    // this is the method used to save Events
    public boolean saveEvent(Event event){

        List<Event> events = getAllEvents();
        boolean exists = false;

        for (int i = 0; i < events.size(); i++) {
            if (events.get(i).getId().equals(event.getId())) {
                events.set(i, event); // replace event -> useful for updates
                exists = true;
                break;
            }

        }

        if (!exists) {
            events.add(event); // Add only if not found
        }

        //save events to file
        return saveAllEvents(events);

    }

    public boolean updateEvent(Event updatedEvent) {
        if (updatedEvent == null) {
            return false;
        }
        return saveEvent(updatedEvent);  // saveEvent handles updates too
    }


    public boolean deleteEvent(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }

        List<Event> events = getAllEvents();
        List<Event> updatedEvents = new ArrayList<>();
        boolean removed = false;

        // Copy all events except the one to be removed
        for (Event event : events) {
            if (! event.getId().equals(id)) {
                updatedEvents.add(event);
            } else {
                removed = true;
            }
        }

        if (removed) {
            return saveAllEvents(updatedEvents);
        }

        return false; // Event not found
    }





}
