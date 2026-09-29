# BookMyShow Database Design

## Project Overview
This project demonstrates the design of a relational database for a movie ticket booking platform inspired by BookMyShow. It uses MySQL to manage users, cities, theatres, screens, seats, movies, shows, bookings, and payments.

## Objectives
- Design a relational database using MySQL.
- Define primary keys, foreign keys, constraints, and indexes.
- Manage movie shows and seat availability.
- Demonstrate booking transactions and payment records.
- Write SQL queries for common movie-booking use cases.

## Technology Stack
- **Database:** MySQL 8.0
- **Database Client:** MySQL Workbench
- **Language:** SQL

  ## Future Improvements
- Validate the SQL schema on a fresh database.
- Improve concurrent seat-booking validation.
- Integrate a backend API and frontend.

## Database Schema
The database contains the following 11 tables:

1. `users` — User information
2. `cities` — City and state details
3. `theatres` — Theatre information
4. `screens` — Screens within theatres
5. `seats` — Seat details and categories
6. `movies` — Movie information
7. `shows` — Movie show schedules
8. `show_seats` — Seat availability and pricing for each show
9. `bookings` — Booking records and status
10. `booking_seats` — Seats associated with bookings
11. `payments` — Payment records and status

## Key Features
- Relational database design with primary and foreign keys.
- Unique constraints to prevent duplicate records.
- Indexes to support common lookup queries.
- Show-level seat inventory with `AVAILABLE`, `HELD`, and `BOOKED` states.
- Booking lifecycle with pending, confirmed, cancelled, and expired statuses.
- Payment tracking with success, failure, pending, and refund statuses.
- SQL joins and queries for movies, shows, seats, and booking history.

## Booking Workflow
1. Select a movie show.
2. Check seat availability.
3. Temporarily hold a seat.
4. Create a pending booking.
5. Associate the selected seat with the booking.
6. Update the booking and seat status after successful processing.
7. Record the payment.

Transactions and row locking can help maintain seat consistency during concurrent booking attempts.

## How to Run
1. Install MySQL Server 8.0 or a compatible version.
2. Open MySQL Workbench and connect to your local server.
3. Open the SQL script from this repository.
4. Select the `bookmyshow_db` database, or create it if needed.
5. Execute the table creation statements in dependency order.
6. Insert the sample data and execute the example queries.

**Note:** Review the script before running it on a fresh database. Ensure all required table definitions are present and execute sample-data inserts only once.

## Learning Outcomes
- Relational database modelling
- SQL DDL and DML
- Primary and foreign key relationships
- Constraints and indexing
- Joins and data retrieval
- Transactions and seat-inventory consistency

## Project Scope
This is a database design project. It focuses on the MySQL schema and SQL operations rather than a complete frontend or production booking application.
