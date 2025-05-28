package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.algorithm.MergeSort;
import com.example.eventticketbookingsystem.controller.EventController;
import com.example.eventticketbookingsystem.model.CustomLinkedList;
import com.example.eventticketbookingsystem.model.Event;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Servlet for viewing events (user view)
 * Last updated: 2025-05-21 07:09:11
 */
@WebServlet("/ViewEventsServlet")
public class ViewEventsServlet extends HttpServlet {

    private EventController eventController = new EventController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventId = request.getParameter("eventId");
        String searchTerm = request.getParameter("searchTerm");
        String searchType = request.getParameter("searchType");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sortBy = request.getParameter("sortBy");
        String eventType = request.getParameter("type");

        // For viewing a single event
        if (eventId != null && !eventId.isEmpty()) {
            Event event = eventController.getEventById(eventId);
            if (event != null) {
                request.setAttribute("event", event);
                request.getRequestDispatcher("eventDetail.jsp").forward(request, response);
                return;
            }
        }

        // For searching/filtering events
        List<Event> events;

        // First, get events based on search criteria
        if (searchTerm != null && !searchTerm.isEmpty()) {
            if ("venue".equals(searchType)) {
                // Search by venue
                events = eventController.searchEventsByVenue(searchTerm);
            } else {
                // Default to search by name
                events = eventController.searchEvents(searchTerm);
            }
            // Set search parameters for the JSP
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("searchType", searchType);
        } else if (minPriceStr != null && !minPriceStr.isEmpty() &&
                maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try {
                double minPrice = Double.parseDouble(minPriceStr);
                double maxPrice = Double.parseDouble(maxPriceStr);

                // Search by price range
                events = eventController.searchEvents(minPrice, maxPrice);
                request.setAttribute("minPrice", minPrice);
                request.setAttribute("maxPrice", maxPrice);
            } catch (NumberFormatException e) {
                // Default to all events if price parsing fails
                events = eventController.getAllEvents();
            }
        } else {
            // Default to all events
            events = eventController.getAllEvents();
        }

        // Then, filter by event type if specified
        if (eventType != null && !eventType.isEmpty()) {
            List<Event> filteredEvents = new ArrayList<>();
            for (Event event : events) {
                if (event.getEventType().equals(eventType)) {
                    filteredEvents.add(event);
                }
            }
            events = filteredEvents;
            request.setAttribute("type", eventType);
        }

        // Apply sorting using CustomLinkedList (teacher requirement)
        if ("date".equals(sortBy)) {
            // Convert List<Event> to CustomLinkedList
            CustomLinkedList customEventList = new CustomLinkedList();
            for (Event event : events) {
                customEventList.addLast(event);
            }

            // Sort using CustomLinkedList merge sort (NO Java Collections!)
            CustomLinkedList sortedCustomList = MergeSort.sortByDate(customEventList);

            // Convert back to List<Event> for JSP compatibility
            List<Event> sortedEvents = new ArrayList<>();
            Object[] sortedArray = sortedCustomList.toArray();
            for (Object obj : sortedArray) {
                sortedEvents.add((Event) obj);
            }

            events = sortedEvents;
            request.setAttribute("sortBy", sortBy);
        }

        // Set the events list and forward to JSP
        request.setAttribute("events", events);

        // Forward to the correct JSP name
        request.getRequestDispatcher("events.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}