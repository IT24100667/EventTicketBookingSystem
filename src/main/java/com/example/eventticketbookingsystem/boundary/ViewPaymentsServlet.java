package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.controller.PaymentController;
import com.example.eventticketbookingsystem.model.Booking;
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
import java.util.List;


@WebServlet("/ViewPaymentsServlet")
public class ViewPaymentsServlet extends HttpServlet {

    // Encapsulated controllers - private fields
    private final PaymentController paymentController = new PaymentController();
    private final BookingController bookingController = new BookingController();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // READ operation - Get all payments
        List<Payment> userPayments = getUserPayments(user.getId());

        // READ operation - Get related bookings
        List<Booking> bookings = getRelatedBookings(userPayments);

        // Set attributes for the view
        request.setAttribute("payments", userPayments);
        request.setAttribute("bookings", bookings);

        // Forward to the view
        request.getRequestDispatcher("userPayments.jsp").forward(request, response);
    }


    private List<Payment> getUserPayments(String userId) {
        List<Payment> allPayments = paymentController.getAllPayments();
        List<Payment> userPayments = new ArrayList<>();

        // Filter payments for this user's bookings
        for (Payment payment : allPayments) {
            Booking booking = bookingController.getBookingById(payment.getBookingId());
            if (booking != null && booking.getUserId().equals(userId)) {
                userPayments.add(payment);
            }
        }

        return userPayments;
    }


    private List<Booking> getRelatedBookings(List<Payment> payments) {
        List<Booking> bookings = new ArrayList<>();

        for (Payment payment : payments) {
            Booking booking = bookingController.getBookingById(payment.getBookingId());
            if (booking != null) {
                bookings.add(booking);
            }
        }

        return bookings;
    }
}