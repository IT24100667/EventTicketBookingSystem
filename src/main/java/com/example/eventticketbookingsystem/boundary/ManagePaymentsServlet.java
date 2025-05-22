package com.example.eventticketbookingsystem.boundary;

import com.example.eventticketbookingsystem.controller.BookingController;
import com.example.eventticketbookingsystem.controller.EventController;
import com.example.eventticketbookingsystem.controller.PaymentController;
import com.example.eventticketbookingsystem.controller.UserController;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@WebServlet("/ManagePaymentsServlet")
public class ManagePaymentsServlet extends HttpServlet {

    // Encapsulated controllers - private fields
    private final PaymentController paymentController = new PaymentController();
    private final BookingController bookingController = new BookingController();
    private final UserController userController = new UserController();
    private final EventController eventController = new EventController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verify admin access
        if (!verifyAdminAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        // Route to appropriate method based on action parameter
        if (action == null) {
            // Update payment statuses for cancelled bookings before listing
            updatePaymentStatusesForCancelledBookings();
            listPayments(request, response);
        } else if (action.equals("view")) {
            viewPayment(request, response);
        } else if (action.equals("exportCSV")) {
            exportPaymentsCSV(request, response);
        } else {
            updatePaymentStatusesForCancelledBookings();
            listPayments(request, response);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verify admin access
        if (!verifyAdminAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            updatePaymentStatusesForCancelledBookings();
            listPayments(request, response);
        } else if (action.equals("markAsFailed")) {
            markPaymentAsCancelled(request, response); // Renamed method
        } else {
            updatePaymentStatusesForCancelledBookings();
            listPayments(request, response);
        }
    }


    private void updatePaymentStatusesForCancelledBookings() {
        // Get all cancelled bookings
        List<Booking> cancelledBookings = bookingController.getBookingsByStatus(Booking.STATUS_CANCELLED);

        // Update payment status for each cancelled booking
        for (Booking booking : cancelledBookings) {
            Payment payment = paymentController.getPaymentByBookingId(booking.getId());
            if (payment != null && !"CANCELLED".equals(payment.getStatus())) {
                payment.setStatus("CANCELLED"); // Always set to CANCELLED, never FAILED
                paymentController.updatePayment(payment);
            }
        }
    }


    private boolean verifyAdminAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("userLogin.jsp");
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("index.jsp");
            return false;
        }

        return true;
    }


    private void listPayments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // READ operation - Get all payments
        List<Payment> payments = paymentController.getAllPayments();

        // Calculate card revenue statistics
        List<Payment> cardPayments = payments.stream()
                .filter(payment -> Payment.METHOD_CARD.equals(payment.getPaymentMethod()))
                .collect(Collectors.toList());

        // Calculate revenue stats (only completed payments)
        double cardRevenue = calculateCardRevenue(cardPayments);
        int totalCompletedPayments = countCompletedPayments(payments);
        int totalConfirmedPayments = countConfirmedPayments(payments);
        int pendingPaymentsCount = countPendingPayments(payments);
        double pendingAmount = calculatePendingAmount(payments);

        // Load related data for display
        Map<String, Booking> bookingMap = new HashMap<>();
        Map<String, User> userMap = new HashMap<>();
        Map<String, Event> eventMap = new HashMap<>();

        loadRelatedData(payments, bookingMap, userMap, eventMap);

        // Set attributes for JSP
        setListAttributes(request, payments, bookingMap, userMap, eventMap,
                cardRevenue, totalConfirmedPayments, totalCompletedPayments,
                pendingPaymentsCount, pendingAmount);

        // Forward to the JSP
        request.getRequestDispatcher("adminPayments.jsp").forward(request, response);
    }


    private double calculateCardRevenue(List<Payment> cardPayments) {
        return cardPayments.stream()
                .filter(payment -> "COMPLETED".equals(payment.getStatus()))
                .mapToDouble(Payment::getAmount)
                .sum();
    }


    private int countCompletedPayments(List<Payment> payments) {
        return (int) payments.stream()
                .filter(payment -> "COMPLETED".equals(payment.getStatus()))
                .count();
    }


    private int countConfirmedPayments(List<Payment> payments) {
        return (int) payments.stream()
                .filter(payment -> {
                    Booking booking = bookingController.getBookingById(payment.getBookingId());
                    return booking != null && "CONFIRMED".equals(booking.getStatus());
                })
                .count();
    }


    private int countPendingPayments(List<Payment> payments) {
        return (int) payments.stream()
                .filter(payment -> "PENDING".equals(payment.getStatus()) ||
                        "WAITING_CONFIRMATION".equals(payment.getStatus()))
                .count();
    }


    private double calculatePendingAmount(List<Payment> payments) {
        return payments.stream()
                .filter(payment -> "PENDING".equals(payment.getStatus()) ||
                        "WAITING_CONFIRMATION".equals(payment.getStatus()))
                .mapToDouble(Payment::getAmount)
                .sum();
    }


    private void loadRelatedData(List<Payment> payments, Map<String, Booking> bookingMap,
                                 Map<String, User> userMap, Map<String, Event> eventMap) {
        for (Payment payment : payments) {
            String bookingId = payment.getBookingId();
            Booking booking = bookingController.getBookingById(bookingId);

            if (booking != null) {
                bookingMap.put(bookingId, booking);

                // Ensure payment status is CANCELLED if booking is cancelled
                if (Booking.STATUS_CANCELLED.equals(booking.getStatus()) &&
                        !"CANCELLED".equals(payment.getStatus())) {
                    payment.setStatus("CANCELLED"); // Always use CANCELLED instead of FAILED
                    paymentController.updatePayment(payment);
                }

                // Load user and event if not already loaded
                String userId = booking.getUserId();
                String eventId = booking.getEventId();

                if (!userMap.containsKey(userId)) {
                    User paymentUser = userController.getUserById(userId);
                    if (paymentUser != null) {
                        userMap.put(userId, paymentUser);
                    }
                }

                if (!eventMap.containsKey(eventId)) {
                    Event event = eventController.getEventById(eventId);
                    if (event != null) {
                        eventMap.put(eventId, event);
                    }
                }
            }
        }
    }


    private void setListAttributes(HttpServletRequest request, List<Payment> payments,
                                   Map<String, Booking> bookingMap, Map<String, User> userMap,
                                   Map<String, Event> eventMap, double cardRevenue,
                                   int totalConfirmedPayments, int totalCompletedPayments,
                                   int pendingPaymentsCount, double pendingAmount) {
        request.setAttribute("payments", payments);
        request.setAttribute("bookingMap", bookingMap);
        request.setAttribute("userMap", userMap);
        request.setAttribute("eventMap", eventMap);

        request.setAttribute("cardRevenue", cardRevenue);
        request.setAttribute("totalRevenue", cardRevenue); // Total revenue is CARD ONLY
        request.setAttribute("totalConfirmedPayments", totalConfirmedPayments);
        request.setAttribute("completedPayments", totalCompletedPayments);
        request.setAttribute("pendingPaymentsCount", pendingPaymentsCount);
        request.setAttribute("pendingAmount", pendingAmount);
    }


    private void viewPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        Payment payment = paymentController.getPaymentById(id);

        if (payment == null) {
            request.setAttribute("error", "Payment not found");
            listPayments(request, response);
            return;
        }

        // READ operations - Load related data
        Booking booking = bookingController.getBookingById(payment.getBookingId());
        User paymentUser = null;
        Event event = null;

        if (booking != null) {
            paymentUser = userController.getUserById(booking.getUserId());
            event = eventController.getEventById(booking.getEventId());

            // Ensure payment status is CANCELLED if booking is cancelled
            if (Booking.STATUS_CANCELLED.equals(booking.getStatus()) &&
                    !"CANCELLED".equals(payment.getStatus())) {
                payment.setStatus("CANCELLED"); // Always use CANCELLED instead of FAILED
                paymentController.updatePayment(payment);
            }
        }

        request.setAttribute("payment", payment);
        request.setAttribute("booking", booking);
        request.setAttribute("paymentUser", paymentUser);
        request.setAttribute("event", event);

        request.getRequestDispatcher("viewPayment.jsp").forward(request, response);
    }


    private void markPaymentAsCancelled(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        Payment payment = paymentController.getPaymentById(id);

        if (payment == null) {
            request.setAttribute("error", "Payment not found");
            listPayments(request, response);
            return;
        }

        // UPDATE operation - Change payment status to CANCELLED
        payment.setStatus("CANCELLED"); // Always use CANCELLED instead of FAILED
        boolean updated = paymentController.updatePayment(payment);

        // UPDATE operation - Cancel associated booking
        String bookingId = payment.getBookingId();
        boolean cancelSuccess = bookingController.cancelBookingByAdmin(bookingId);

        setUpdateResultMessage(request, updated, cancelSuccess);
        listPayments(request, response);
    }


    private void setUpdateResultMessage(HttpServletRequest request, boolean paymentUpdated, boolean bookingCancelled) {
        if (paymentUpdated && bookingCancelled) {
            request.setAttribute("message", "Payment marked as cancelled and booking cancelled successfully");
        } else if (paymentUpdated) {
            request.setAttribute("message", "Payment marked as cancelled but booking could not be cancelled");
        } else {
            request.setAttribute("error", "Failed to update payment status");
        }
    }


    private void exportPaymentsCSV(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // READ operation - Get all payments
        List<Payment> payments = paymentController.getAllPayments();
        Map<String, Booking> bookingMap = new HashMap<>();

        // Load all bookings for these payments
        for (Payment payment : payments) {
            String bookingId = payment.getBookingId();
            Booking booking = bookingController.getBookingById(bookingId);

            if (booking != null) {
                bookingMap.put(bookingId, booking);

                // Ensure payment status is CANCELLED if booking is cancelled
                if (Booking.STATUS_CANCELLED.equals(booking.getStatus()) &&
                        !"CANCELLED".equals(payment.getStatus())) {
                    payment.setStatus("CANCELLED"); // Always use CANCELLED instead of FAILED
                    paymentController.updatePayment(payment);
                }
            }
        }

        // Set content type and header for CSV
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"payments.csv\"");

        // Generate and write CSV content
        String csvContent = generatePaymentsCsv(payments, bookingMap);
        response.getWriter().write(csvContent);
    }


    private String generatePaymentsCsv(List<Payment> payments, Map<String, Booking> bookingMap) {
        StringBuilder csv = new StringBuilder();
        csv.append("Payment ID,Booking ID,Amount,Method,Status,Booking Status,Payment Date\n");

        for (Payment payment : payments) {
            String bookingStatus = "Unknown";
            Booking booking = bookingMap.get(payment.getBookingId());

            if (booking != null) {
                bookingStatus = booking.getStatus();

                // Ensure consistent status in CSV export
                if (Booking.STATUS_CANCELLED.equals(booking.getStatus()) &&
                        !"CANCELLED".equals(payment.getStatus())) {
                    payment.setStatus("CANCELLED");
                }
            }

            csv.append(payment.getId()).append(",");
            csv.append(payment.getBookingId()).append(",");
            csv.append(payment.getAmount()).append(",");
            csv.append(payment.getPaymentMethod()).append(",");
            csv.append(payment.getStatus()).append(",");
            csv.append(bookingStatus).append(",");
            csv.append(payment.getPaymentDate().toString()).append("\n");
        }

        return csv.toString();
    }
}