package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.model.Booking;
import com.example.eventticketbookingsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

 // Servlet for cancelling bookings

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {

    private BookingController bookingController = new BookingController();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get booking ID from request
        String bookingId = request.getParameter("bookingId");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            request.setAttribute("error", "Invalid booking ID");
            request.getRequestDispatcher("ViewBookingsServlet").forward(request, response);
            return;
        }

        // Try to cancel booking
        boolean cancelled = bookingController.cancelBooking(bookingId, user.getId());

        if (cancelled) {
            // IMPORTANT CHANGE: Redirect to the success page instead of forwarding to ViewBookingsServlet
            response.sendRedirect("bookingCancelled.jsp");
        } else {
            request.setAttribute("error", "Failed to cancel booking. It may already be processed.");
            request.getRequestDispatcher("ViewBookingsServlet").forward(request, response);
        }
    }
}