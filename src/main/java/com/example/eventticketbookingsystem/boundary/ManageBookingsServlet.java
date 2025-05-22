package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.controller.EventController;
import com.example.eventticketbookingsystem.controller.UserController;
import com.example.eventticketbookingsystem.controller.PaymentController; // Added import
import com.example.eventticketbookingsystem.model.Booking;
import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.model.User;
import com.example.eventticketbookingsystem.model.Payment; // Added import

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

 // Servlet for handling admin booking management operations

@WebServlet("/ManageBookingsServlet")
public class ManageBookingsServlet extends HttpServlet {

    private BookingController bookingController = new BookingController();
    private EventController eventController = new EventController();
    private UserController userController = new UserController();
    private PaymentController paymentController = new PaymentController(); // Added controller

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in as admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            // Default - show all bookings
            listBookings(request, response);
        } else if (action.equals("view")) {
            // View a specific booking
            viewBooking(request, response);
        } else if (action.equals("edit")) {
            // Edit a booking
            showEditForm(request, response);
        } else {
            listBookings(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in as admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            listBookings(request, response);
        } else if (action.equals("update")) {
            updateBooking(request, response);
        } else if (action.equals("cancel")) {
            cancelBooking(request, response);
        } else if (action.equals("confirm")) {
            confirmBooking(request, response);
        } else if (action.equals("processAll")) {
            processQueue(request, response);
        } else if (action.equals("prioritize")) {
            prioritizeBooking(request, response);
        } else {
            listBookings(request, response);
        }
    }

    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all bookings
        List<Booking> bookings = bookingController.getAllBookings();
        request.setAttribute("bookings", bookings);

        // Get bookings in queue
        List<Booking> queuedBookings = bookingController.getBookingsInQueue();
        request.setAttribute("queuedBookings", queuedBookings);

        // Get events and users for display
        List<Event> events = eventController.getAllEvents();
        List<User> users = userController.getAllUsers();
        request.setAttribute("events", events);
        request.setAttribute("users", users);

        // Create maps for faster lookup
        Map<String, Event> eventMap = new HashMap<>();
        Map<String, User> userMap = new HashMap<>();

        for (Event event : events) {
            eventMap.put(event.getId(), event);
        }

        for (User user : users) {
            userMap.put(user.getId(), user);
        }

        request.setAttribute("eventMap", eventMap);
        request.setAttribute("userMap", userMap);

        request.getRequestDispatcher("adminBookings.jsp").forward(request, response);
    }

    private void viewBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        Booking booking = bookingController.getBookingById(id);

        if (booking == null) {
            request.setAttribute("error", "Booking not found");
            listBookings(request, response);
            return;
        }

        Event event = eventController.getEventById(booking.getEventId());
        User user = userController.getUserById(booking.getUserId());
        boolean inQueue = bookingController.isBookingInQueue(id);

        request.setAttribute("booking", booking);
        request.setAttribute("event", event);
        request.setAttribute("bookingUser", user);
        request.setAttribute("inQueue", inQueue);

        request.getRequestDispatcher("viewBooking.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        Booking booking = bookingController.getBookingById(id);

        if (booking == null) {
            request.setAttribute("error", "Booking not found");
            listBookings(request, response);
            return;
        }

        Event event = eventController.getEventById(booking.getEventId());
        User user = userController.getUserById(booking.getUserId());
        boolean inQueue = bookingController.isBookingInQueue(id);

        request.setAttribute("booking", booking);
        request.setAttribute("event", event);
        request.setAttribute("bookingUser", user);
        request.setAttribute("inQueue", inQueue);

        request.getRequestDispatcher("editBooking.jsp").forward(request, response);
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String status = request.getParameter("status");
        int ticketQuantity = Integer.parseInt(request.getParameter("ticketQuantity"));

        boolean updated = bookingController.updateBookingByAdmin(id, status, ticketQuantity);

        if (updated) {
            // Update payment status if booking status changed
            if (Booking.STATUS_CONFIRMED.equals(status)) {
                paymentController.updatePaymentStatusForBooking(id, status);
            } else if (Booking.STATUS_CANCELLED.equals(status)) {
                paymentController.updatePaymentStatusForBooking(id, status);
            }

            request.setAttribute("message", "Booking updated successfully");
        } else {
            request.setAttribute("error", "Failed to update booking");
        }

        listBookings(request, response);
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        boolean cancelled = bookingController.cancelBookingByAdmin(id);

        if (cancelled) {
            // Update payment status when booking is cancelled
            paymentController.updatePaymentStatusForBooking(id, Booking.STATUS_CANCELLED);

            request.setAttribute("message", "Booking cancelled successfully");
        } else {
            request.setAttribute("error", "Failed to cancel booking");
        }

        listBookings(request, response);
    }

    private void confirmBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        Booking booking = bookingController.getBookingById(id);

        if (booking == null) {
            request.setAttribute("error", "Booking not found");
            listBookings(request, response);
            return;
        }

        // 1. Process this specific booking from the queue
        boolean success = false;

        // Check if booking is in queue
        if (bookingController.isBookingInQueue(id)) {
            // First, prioritize it to make it the next one to process
            bookingController.prioritizeBookingInQueue(id);

            // Then process the next booking (which should be this one)
            success = bookingController.processNextBooking();
        } else {
            // If not in queue for some reason, just update status directly
            success = bookingController.updateBookingStatus(id, Booking.STATUS_CONFIRMED);

            // Make sure it's not in the queue
            if (bookingController.isBookingInQueue(id)) {
                // This shouldn't happen, but just in case, remove it from queue
                bookingController.prioritizeBookingInQueue(id);
                bookingController.processNextBooking();
            }
        }

        if (success) {
            // IMPORTANT: Update the payment status to COMPLETED when booking is confirmed
            Payment payment = paymentController.getPaymentByBookingId(id);
            if (payment != null) {
                payment.setStatus(Payment.STATUS_COMPLETED);
                paymentController.updatePaymentStatusForBooking(id, Booking.STATUS_CONFIRMED);
            }

            request.setAttribute("message", "Booking confirmed successfully");
        } else {
            request.setAttribute("error", "Failed to confirm booking. Check available seats.");
        }

        listBookings(request, response);
    }

    private void processQueue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int processed = bookingController.processAllBookings();

        if (processed > 0) {
            // Update payment statuses for all processed bookings
            List<Booking> bookings = bookingController.getBookingsByStatus(Booking.STATUS_CONFIRMED);
            for (Booking booking : bookings) {
                paymentController.updatePaymentStatusForBooking(booking.getId(), Booking.STATUS_CONFIRMED);
            }

            request.setAttribute("message", processed + " bookings processed successfully");
        } else {
            request.setAttribute("message", "No bookings were processed");
        }

        listBookings(request, response);
    }

    private void prioritizeBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        boolean prioritized = bookingController.prioritizeBookingInQueue(id);

        if (prioritized) {
            request.setAttribute("message", "Booking prioritized successfully");
        } else {
            request.setAttribute("error", "Failed to prioritize booking");
        }

        listBookings(request, response);
    }
}