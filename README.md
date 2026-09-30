# BookMyShow Database Design

## Project Overview
This project demonstrates the design of a relational database for a movie ticket booking platform inspired by BookMyShow. It uses MySQL to manage users, cities, theatres, screens, seats, movies, shows, bookings, and payments.

## Technology Stack
- MySQL 8.0
- MySQL Workbench
- SQL

## Database Tables
The database contains 11 tables:

1. `users` — Customer details
2. `cities` — City and state information
3. `theatres` — Theatre details
4. `screens` — Screens within theatres
5. `seats` — Physical seat details and categories
6. `movies` — Movie information
7. `shows` — Movie show schedules
8. `show_seats` — Show-specific seat availability and pricing
9. `bookings` — Booking details and status
10. `booking_seats` — Seats associated with bookings
11. `payments` — Payment records and status

## Key Features
- Relational schema with primary and foreign keys
- Unique constraints and data integrity checks
- Indexes for common lookup operations
- Seat inventory states: `AVAILABLE`, `HELD`, and `BOOKED`
- Booking and payment lifecycle tracking
- SQL joins and business queries
- Transaction and row-locking demonstration

## Booking Workflow
1. Check seat availability for a show.
2. Hold the selected seat.
3. Create a pending booking.
4. Associate the seat with the booking.
5. Confirm the booking and update seat status.
6. Record the payment.

## Learning Outcomes
- Relational database design
- SQL DDL and DML
- Keys, constraints, and indexes
- Multi-table joins
- Transactions and seat-inventory consistency

## Future Improvements
- Validate the complete SQL schema on a fresh database.
- Improve concurrent seat-booking validation.
- Integrate a backend API and frontend.

## Project Scope
This is a database-focused project and does not include a complete frontend or backend application.

**Note:** Before running the SQL script on a fresh database, verify that all required table definitions and sample-data statements are present, including the `users` table definition.
