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
import java.util.Date;


@WebServlet("/PaymentProcessServlet")
public class PaymentProcessServlet extends HttpServlet {

    // Encapsulated controllers - private fields
    private final PaymentController paymentController = new PaymentController();
    private final BookingController bookingController = new BookingController();


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return;
        }

        // Get parameters
        String bookingId = request.getParameter("bookingId");
        String paymentMethod = request.getParameter("paymentMethod");

        // Validate parameters
        if (!validateParameters(request, response, bookingId, paymentMethod)) {
            return;
        }

        // Process payment
        String paymentId = processPaymentByMethod(bookingId, paymentMethod);

        // Handle result
        handlePaymentResult(response, session, bookingId, paymentId);
    }


    private boolean validateParameters(HttpServletRequest request, HttpServletResponse response,
                                       String bookingId, String paymentMethod)
            throws ServletException, IOException {
        if (bookingId == null || paymentMethod == null) {
            request.setAttribute("error", "Missing payment information");
            request.getRequestDispatcher("paymentForm.jsp").forward(request, response);
            return false;
        }
        return true;
    }


    private String processPaymentByMethod(String bookingId, String paymentMethod) {
        Booking booking = bookingController.getBookingById(bookingId);

        if (Payment.METHOD_CASH.equals(paymentMethod)) {
            // For cash payments, use createPayment with STATUS_WAITING_CONFIRMATION
            return paymentController.createPayment(
                    bookingId,
                    booking.getTotalPrice(),
                    Payment.METHOD_CASH,
                    Payment.STATUS_WAITING_CONFIRMATION,
                    new Date()
            );
        } else {
            // For card payments, process normally
            return paymentController.processPayment(bookingId, paymentMethod);
        }
    }


    private void handlePaymentResult(HttpServletResponse response, HttpSession session,
                                     String bookingId, String paymentId)
            throws IOException {
        if (paymentId != null) {
            // Payment recorded successfully
            session.setAttribute("currentBookingId", bookingId);
            response.sendRedirect("ConfirmPaymentServlet?bookingId=" + bookingId);
        } else {
            // Payment failed
            response.sendRedirect("PaymentFormServlet?bookingId=" + bookingId);
        }
    }
}