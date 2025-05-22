package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.controller.EventController;
import com.example.eventticketbookingsystem.model.Booking;
import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

 // Servlet for handling ticket booking requests

@WebServlet("/BookTicketsServlet")
public class BookTicketsServlet extends HttpServlet {

    private BookingController bookingController = new BookingController();
    private EventController eventController = new EventController();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get form parameters
        String eventId = request.getParameter("eventId");
        String ticketQuantityStr = request.getParameter("ticketQuantity");

        try {
            int ticketQuantity = Integer.parseInt(ticketQuantityStr);

            // Get event to check availability
            Event event = eventController.getEventById(eventId);

            if (event == null) {
                request.setAttribute("error", "Event not found");
                request.getRequestDispatcher("ViewEventsServlet").forward(request, response);
                return;
            }

            if (event.getAvailableSeats() < ticketQuantity) {
                request.setAttribute("error", "Not enough tickets available");
                request.getRequestDispatcher("ViewEventsServlet?eventId=" + eventId).forward(request, response);
                return;
            }

            // Create booking
            String bookingId = bookingController.createBooking(user.getId(), eventId, ticketQuantity);

            if (bookingId != null) {
                // Store booking ID for next step
                session.setAttribute("currentBookingId", bookingId);

                // Get the booking object
                Booking booking = bookingController.getBookingById(bookingId);
                request.setAttribute("booking", booking);

                // Forward to the booking details page first instead of direct payment
                request.getRequestDispatcher("bookingDetails.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to create booking. Please try again.");
                request.getRequestDispatcher("ViewEventsServlet?eventId=" + eventId).forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ticket quantity");
            request.getRequestDispatcher("ViewEventsServlet?eventId=" + eventId).forward(request, response);
        }
    }
}