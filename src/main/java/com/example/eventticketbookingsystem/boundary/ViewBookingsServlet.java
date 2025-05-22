package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.controller.EventController;
import com.example.eventticketbookingsystem.controller.PaymentController;
import com.example.eventticketbookingsystem.model.Booking;
import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.model.Payment;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

 // Servlet for viewing user's bookings

@WebServlet("/ViewBookingsServlet")
public class ViewBookingsServlet extends HttpServlet {

    private BookingController bookingController = new BookingController();
    private EventController eventController = new EventController();
    private PaymentController paymentController = new PaymentController(); // Added payment controller

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get user's bookings
        List<Booking> bookings = bookingController.getUserBookings(user.getId());

        // Get events for each booking
        Map<String, Event> eventMap = new HashMap<>();

        // NEW: Create payment map to store payment information
        Map<String, Payment> paymentMap = new HashMap<>();

        for (Booking booking : bookings) {
            // Only look up events we haven't seen yet
            if (!eventMap.containsKey(booking.getEventId())) {
                Event event = eventController.getEventById(booking.getEventId());
                if (event != null) {
                    eventMap.put(booking.getEventId(), event);
                }
            }

            // NEW: Get payment information for this booking
            Payment payment = paymentController.getPaymentByBookingId(booking.getId());
            if (payment != null) {
                paymentMap.put(booking.getId(), payment);
            }
        }

        // Set attributes and forward to JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("eventMap", eventMap);
        request.setAttribute("paymentMap", paymentMap); // NEW: Added payment map
        request.getRequestDispatcher("userBookings.jsp").forward(request, response);
    }
}