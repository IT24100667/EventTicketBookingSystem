package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.EventController;
import com.example.eventticketbookingsystem.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Servlet for managing events (admin view)
 */
@WebServlet("/ManageEventsServlet")
public class ManageEventsServlet extends HttpServlet {

    private EventController eventController = new EventController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // gets session , if no session returns null
//        HttpSession session = request.getSession(); this does same but if no session it creates an unnecessary session taking up memory



        // check if admin is logged in if not send to adminLogin page (Admin Session Check)
        if (session == null || session.getAttribute("user") == null || ! (Boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action != null && action.equals("view")) {
            String eventId = request.getParameter("eventId");
            Event event = eventController.getEventById(eventId);

            if (event != null) {
                request.setAttribute("event", event);
            }
        }

        // Get all events for display
        List<Event> events = eventController.getAllEvents();
        request.setAttribute("events", events);

//        // Get the total event count using the static method
//        request.setAttribute("totalEventCount", Event.getTotalEvents());

        request.getRequestDispatcher("manageEvents.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !(session.getAttribute("user") instanceof Admin)) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addEvent(request, response);
        } else if ("delete".equals(action)) {
            deleteEvent(request, response);
        } else if ("edit".equals(action)) {
            editEvent(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void addEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventType = request.getParameter("eventType");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String venue = request.getParameter("venue");
        String dateStr = request.getParameter("date");
        String priceStr = request.getParameter("price");
        String capacityStr = request.getParameter("capacity");

        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = dateFormat.parse(dateStr);
            double price = Double.parseDouble(priceStr);
            int capacity = Integer.parseInt(capacityStr);

            boolean success = false;

            if ("concert".equals(eventType)) {
                String artist = request.getParameter("artist");
                int discountThreshold = 0;
                int discountPercentage = 0;

                try {
                    discountThreshold = Integer.parseInt(request.getParameter("discountThreshold"));
                    discountPercentage = Integer.parseInt(request.getParameter("discountPercentage"));
                } catch (NumberFormatException e) {
                    // Use default values if parsing fails
                }

                success = eventController.createConcert(name, description, venue, date, price,
                        capacity, artist, discountThreshold, discountPercentage);
            }
            else if ("sports".equals(eventType)) {
                String sportType = request.getParameter("sportType");
                String teams = request.getParameter("teams");

                success = eventController.createSports(name, description, venue, date, price,
                        capacity, sportType, teams);
            } else if ("other".equals(eventType)) {
                String eventCategory = request.getParameter("eventCategory");
                String specialRequirements = request.getParameter("specialRequirements");

                success = eventController.createOtherEvent(name, description, venue, date, price,
                        capacity, eventCategory, specialRequirements);
            }

            if (success) {
                request.setAttribute("message", "Event added successfully");
            } else {
                request.setAttribute("error", "Failed to add event");
            }

        } catch (ParseException | NumberFormatException e) {
            request.setAttribute("error", "Invalid input format");
        }

        doGet(request, response);
    }

    private void deleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventId = request.getParameter("eventId");

        boolean success = eventController.deleteEvent(eventId);

        if (success) {
            request.setAttribute("message", "Event deleted successfully");
        } else {
            request.setAttribute("error", "Failed to delete event");
        }

        doGet(request, response);
    }

    private void editEvent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventId = request.getParameter("eventId");
        Event event = eventController.getEventById(eventId);

        if (event == null) {
            request.setAttribute("error", "Event not found");
            doGet(request, response);
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String venue = request.getParameter("venue");
        String dateStr = request.getParameter("date");
        String priceStr = request.getParameter("price");
        String capacityStr = request.getParameter("capacity");

        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = dateFormat.parse(dateStr);
            double price = Double.parseDouble(priceStr);
            int capacity = Integer.parseInt(capacityStr);

            // Update common fields
            event.setName(name);
            event.setDescription(description);
            event.setVenue(venue);
            event.setDate(date);
            event.setPrice(price);
            event.setCapacity(capacity);

            // Update specific fields based on event type
            if (event instanceof Concert) {
                Concert concert = (Concert) event;
                String artist = request.getParameter("artist");
                int discountThreshold = 0;
                int discountPercentage = 0;

                try {
                    discountThreshold = Integer.parseInt(request.getParameter("discountThreshold"));
                    discountPercentage = Integer.parseInt(request.getParameter("discountPercentage"));
                } catch (NumberFormatException e) {
                    // Use default values if parsing fails
                }

                concert.setArtist(artist);
                concert.setDiscountThreshold(discountThreshold);
                concert.setDiscountPercentage(discountPercentage);
            } else if (event instanceof Sports) {
                Sports sports = (Sports) event;
                String sportType = request.getParameter("sportType");
                String teams = request.getParameter("teams");

                sports.setSportType(sportType);
                sports.setTeams(teams);
            } else if (event instanceof OtherEvent) {
                OtherEvent otherEvent = (OtherEvent) event;
                String eventCategory = request.getParameter("eventCategory");
                String specialRequirements = request.getParameter("specialRequirements");

                otherEvent.setEventCategory(eventCategory);
                otherEvent.setSpecialRequirements(specialRequirements);
            }

            boolean success = eventController.updateEvent(event);

            if (success) {
                request.setAttribute("message", "Event updated successfully");
            } else {
                request.setAttribute("error", "Failed to update event");
            }

        } catch (ParseException | NumberFormatException e) {
            request.setAttribute("error", "Invalid input format");
        }

        doGet(request, response);
    }
}