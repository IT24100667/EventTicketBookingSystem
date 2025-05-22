package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


@WebServlet("/InitiatePaymentServlet")
public class InitiatePaymentServlet extends HttpServlet {

    // Encapsulation - private controller instance
    private final BookingController bookingController = new BookingController();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get booking ID from request
        String bookingId = request.getParameter("bookingId");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendRedirect("ViewBookingsServlet");
            return;
        }

        // Store booking ID in session - preparation for CREATE operation
        HttpSession session = request.getSession();
        session.setAttribute("currentBookingId", bookingId);

        // READ operation - Get booking details
        Booking booking = bookingController.getBookingById(bookingId);

        if (booking == null) {
            request.setAttribute("error", "Booking not found.");
            request.getRequestDispatcher("ViewBookingsServlet").forward(request, response);
            return;
        }

        // Set booking for display in the booking details page
        request.setAttribute("booking", booking);

        // First show booking details
        request.getRequestDispatcher("bookingDetails.jsp").forward(request, response);
    }
}