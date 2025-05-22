package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.controller.EventController;
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


@WebServlet("/PaymentFormServlet")
public class PaymentFormServlet extends HttpServlet {

    // Encapsulated controllers - private fields
    private final BookingController bookingController = new BookingController();
    private final EventController eventController = new EventController();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verify user authentication
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get booking ID from request or session
        String bookingId = getBookingId(request, session);
        if (bookingId == null) {
            response.sendRedirect("ViewBookingsServlet");
            return;
        }

        // READ operation - Get booking details
        Booking booking = bookingController.getBookingById(bookingId);
        if (!validateBooking(request, response, booking, user.getId())) {
            return;
        }

        // Store booking ID for form submission
        session.setAttribute("currentBookingId", bookingId);

        // READ operation - Get event details if available
        loadEventDetails(request, booking);

        // Set attributes for the payment form
        request.setAttribute("booking", booking);

        // Handle payment method selection
        String paymentMethod = request.getParameter("paymentMethod");
        if (routeToPaymentForm(request, response, paymentMethod)) {
            return;
        }

        // Forward to payment selection form if no specific method chosen
        request.getRequestDispatcher("paymentForm.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get payment method from form
        String paymentMethod = request.getParameter("paymentMethod");
        String bookingId = request.getParameter("bookingId");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendRedirect("ViewBookingsServlet");
            return;
        }

        // Redirect to appropriate form based on payment method selected
        response.sendRedirect("PaymentFormServlet?bookingId=" + bookingId + "&paymentMethod=" + paymentMethod);
    }


    private String getBookingId(HttpServletRequest request, HttpSession session) {
        String bookingId = request.getParameter("bookingId");

        if (bookingId == null) {
            bookingId = (String) session.getAttribute("currentBookingId");
        }

        return bookingId;
    }


    private boolean validateBooking(HttpServletRequest request, HttpServletResponse response,
                                    Booking booking, String userId) throws ServletException, IOException {
        if (booking == null) {
            request.setAttribute("error", "Booking not found.");
            request.getRequestDispatcher("ViewBookingsServlet").forward(request, response);
            return false;
        }

        if (!booking.getUserId().equals(userId)) {
            request.setAttribute("error", "You don't have permission to pay for this booking.");
            request.getRequestDispatcher("ViewBookingsServlet").forward(request, response);
            return false;
        }

        return true;
    }


    private void loadEventDetails(HttpServletRequest request, Booking booking) {
        Event event = null;
        if (booking.getEventId() != null) {
            event = eventController.getEventById(booking.getEventId());
            request.setAttribute("event", event);
        }
    }

    private boolean routeToPaymentForm(HttpServletRequest request, HttpServletResponse response,
                                       String paymentMethod) throws ServletException, IOException {
        if (paymentMethod != null) {
            if (Payment.METHOD_CASH.equals(paymentMethod)) {
                request.getRequestDispatcher("cashPaymentForm.jsp").forward(request, response);
                return true;
            } else if (Payment.METHOD_CARD.equals(paymentMethod)) {
                request.getRequestDispatcher("cardPaymentForm.jsp").forward(request, response);
                return true;
            }
        }
        return false;
    }
}