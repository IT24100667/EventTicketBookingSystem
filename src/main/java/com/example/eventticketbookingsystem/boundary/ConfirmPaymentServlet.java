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

@WebServlet("/ConfirmPaymentServlet")
public class ConfirmPaymentServlet extends HttpServlet {

    // Encapsulating controllers as private fields
    private final BookingController bookingController = new BookingController();
    private final PaymentController paymentController = new PaymentController();
    private final EventController eventController = new EventController();

    // Overriding methods from parent class - Polymorphism
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Authentication check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String bookingId = getBookingIdFromRequestOrSession(request, session);

        if (bookingId == null) {
            request.setAttribute("error", "Invalid booking reference");
            request.getRequestDispatcher("ViewBookingsServlet").forward(request, response);
            return;
        }

        // READ operation - Get booking details
        Booking booking = bookingController.getBookingById(bookingId);
        if (booking == null || !booking.getUserId().equals(user.getId())) {
            handleInvalidBooking(request, response, booking == null ?
                    "Booking not found" : "Unauthorized access to booking");
            return;
        }

        // READ operation - Get payment for booking
        Payment payment = paymentController.getPaymentByBookingId(bookingId);

        // READ operation - Check booking queue status
        boolean inQueue = bookingController.isBookingInQueue(bookingId);

        // READ operation - Get event details if available
        Event event = null;
        if (booking.getEventId() != null) {
            event = eventController.getEventById(booking.getEventId());
        }

        prepareResponseAttributes(request, session, booking, payment, event, inQueue);

        // Forward to confirmation page
        request.getRequestDispatcher("paymentConfirmation.jsp").forward(request, response);
    }


    private String getBookingIdFromRequestOrSession(HttpServletRequest request, HttpSession session) {
        String bookingId = request.getParameter("bookingId");
        if (bookingId == null || bookingId.isEmpty()) {
            bookingId = (String) session.getAttribute("currentBookingId");
        }
        return (bookingId == null || bookingId.isEmpty()) ? null : bookingId;
    }


    private void handleInvalidBooking(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("ViewBookingsServlet").forward(request, response);
    }


    private void prepareResponseAttributes(HttpServletRequest request, HttpSession session,
                                           Booking booking, Payment payment, Event event, boolean inQueue) {

        // Set message based on payment method
        String message = "Your payment has been received. Your booking is under processing and will be confirmed shortly.";
        if (payment != null && Payment.METHOD_CASH.equals(payment.getPaymentMethod())) {
            message = "Your cash payment option has been registered. Please pay at the venue on the event date.";
        }

        // Set attributes for JSP
        request.setAttribute("booking", booking);
        request.setAttribute("payment", payment);
        request.setAttribute("event", event);
        request.setAttribute("inQueue", inQueue);
        request.setAttribute("message", message);

        // Clear the current booking ID from session
        session.removeAttribute("currentBookingId");
    }
}