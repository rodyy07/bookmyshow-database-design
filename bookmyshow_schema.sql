USE bookmyshow_db;

CREATE TABLE IF NOT EXISTS cities (
    city_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (city_name, state_name)
);

CREATE TABLE IF NOT EXISTS theatres (
    theatre_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    theatre_name VARCHAR(150) NOT NULL,
    city_id BIGINT UNSIGNED NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_theatres_city
        FOREIGN KEY (city_id)
        REFERENCES cities(city_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

SHOW TABLES;

CREATE TABLE IF NOT EXISTS screens (
    screen_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    theatre_id BIGINT UNSIGNED NOT NULL,
    screen_name VARCHAR(100) NOT NULL,
    total_seats INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_screens_theatre
        FOREIGN KEY (theatre_id)
        REFERENCES theatres(theatre_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE (theatre_id, screen_name),
    CHECK (total_seats > 0)
);

CREATE TABLE IF NOT EXISTS seats (
    seat_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    screen_id BIGINT UNSIGNED NOT NULL,
    seat_row VARCHAR(10) NOT NULL,
    seat_number INT UNSIGNED NOT NULL,
    seat_type ENUM('REGULAR', 'PREMIUM', 'RECLINER')
        NOT NULL DEFAULT 'REGULAR',

    CONSTRAINT fk_seats_screen
        FOREIGN KEY (screen_id)
        REFERENCES screens(screen_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE (screen_id, seat_row, seat_number),
    CHECK (seat_number > 0)
);

DESCRIBE screens;
DESCRIBE seats;

SHOW CREATE TABLE seats;

USE bookmyshow_db;

CREATE TABLE IF NOT EXISTS movies (
    movie_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    language VARCHAR(50) NOT NULL,
    duration_minutes SMALLINT UNSIGNED NOT NULL,
    certification VARCHAR(10),
    release_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CHECK (duration_minutes > 0)
);

CREATE TABLE IF NOT EXISTS shows (
    show_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    movie_id BIGINT UNSIGNED NOT NULL,
    screen_id BIGINT UNSIGNED NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    status ENUM('SCHEDULED', 'CANCELLED', 'COMPLETED')
        NOT NULL DEFAULT 'SCHEDULED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_shows_movie
        FOREIGN KEY (movie_id)
        REFERENCES movies(movie_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_shows_screen
        FOREIGN KEY (screen_id)
        REFERENCES screens(screen_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE (screen_id, start_time),
    CHECK (end_time > start_time),
    CHECK (base_price >= 0)
);

DESCRIBE movies;

DESCRIBE shows;

CREATE TABLE IF NOT EXISTS bookings (
    booking_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    show_id BIGINT UNSIGNED NOT NULL,

    booking_reference VARCHAR(36) NOT NULL UNIQUE,

    status ENUM(
        'PENDING',
        'CONFIRMED',
        'CANCELLED',
        'EXPIRED'
    ) NOT NULL DEFAULT 'PENDING',

    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME,

    CONSTRAINT fk_bookings_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_bookings_show
        FOREIGN KEY (show_id)
        REFERENCES shows(show_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CHECK (total_amount >= 0)
);

CREATE TABLE IF NOT EXISTS booking_seats (
    booking_seat_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT UNSIGNED NOT NULL,
    seat_id BIGINT UNSIGNED NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_booking_seats_booking
        FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_booking_seats_seat
        FOREIGN KEY (seat_id)
        REFERENCES seats(seat_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE (booking_id, seat_id),
    CHECK (ticket_price >= 0)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT UNSIGNED NOT NULL,

    payment_reference VARCHAR(100) NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,

    status ENUM(
        'PENDING',
        'SUCCESS',
        'FAILED',
        'REFUNDED'
    ) NOT NULL DEFAULT 'PENDING',

    payment_method ENUM(
        'UPI',
        'CARD',
        'NETBANKING',
        'WALLET'
    ) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_booking
        FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CHECK (amount >= 0)
);

CREATE TABLE IF NOT EXISTS show_seats (
    show_seat_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    show_id BIGINT UNSIGNED NOT NULL,
    seat_id BIGINT UNSIGNED NOT NULL,

    price DECIMAL(10,2) NOT NULL,

    status ENUM(
        'AVAILABLE',
        'HELD',
        'BOOKED'
    ) NOT NULL DEFAULT 'AVAILABLE',

    held_until DATETIME NULL,

    CONSTRAINT fk_show_seats_show
        FOREIGN KEY (show_id)
        REFERENCES shows(show_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_show_seats_seat
        FOREIGN KEY (seat_id)
        REFERENCES seats(seat_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE (show_id, seat_id),

    CHECK (price >= 0)
);

INSERT INTO cities (city_name, state_name)
VALUES
    ('Ahmedabad', 'Gujarat'),
    ('Mumbai', 'Maharashtra'),
    ('Bengaluru', 'Karnataka');

SELECT * FROM cities;

INSERT INTO theatres (theatre_name, city_id, address)
VALUES
    ('PVR Nexus', 1, 'Ahmedabad One Mall, Ahmedabad'),
    ('INOX City Centre', 1, 'City Centre Mall, Ahmedabad'),
    ('PVR Phoenix', 2, 'Phoenix Mall, Mumbai'),
    ('Cinepolis Forum', 3, 'Forum Mall, Bengaluru');

SELECT * FROM theatres;

INSERT INTO screens (theatre_id, screen_name, total_seats)
VALUES
    (1, 'Screen 1', 6),
    (1, 'Screen 2', 6),
    (2, 'Screen 1', 6),
    (3, 'Screen 1', 6),
    (4, 'Screen 1', 6);

SELECT * FROM screens;

INSERT INTO seats (screen_id, seat_row, seat_number, seat_type)
VALUES
    (1, 'A', 1, 'REGULAR'),
    (1, 'A', 2, 'REGULAR'),
    (1, 'A', 3, 'REGULAR'),
    (1, 'B', 1, 'REGULAR'),
    (1, 'B', 2, 'PREMIUM'),
    (1, 'B', 3, 'PREMIUM');

SELECT * FROM seats;

INSERT INTO movies
    (title, language, duration_minutes, certification, release_date)
VALUES
    ('Interstellar', 'English', 169, 'UA', '2014-11-07'),
    ('3 Idiots', 'Hindi', 170, 'UA', '2009-12-25'),
    ('Dangal', 'Hindi', 161, 'U', '2016-12-23'),
    ('Inception', 'English', 148, 'UA', '2010-07-16');

SELECT * FROM movies;

INSERT INTO shows
    (movie_id, screen_id, start_time, end_time, base_price, status)
VALUES
    (1, 1, '2026-09-30 10:00:00', '2026-09-30 12:49:00', 250.00, 'SCHEDULED'),
    (2, 1, '2026-09-30 14:00:00', '2026-09-30 16:50:00', 200.00, 'SCHEDULED'),
    (3, 2, '2026-09-30 18:00:00', '2026-09-30 20:41:00', 220.00, 'SCHEDULED'),
    (4, 2, '2026-09-30 21:00:00', '2026-09-30 23:28:00', 250.00, 'SCHEDULED');

SELECT * FROM shows;


INSERT INTO show_seats
    (show_id, seat_id, price, status)
SELECT
    1,
    seat_id,
    CASE
        WHEN seat_type = 'PREMIUM' THEN 300.00
        ELSE 250.00
    END,
    'AVAILABLE'
FROM seats
WHERE screen_id = 1;

INSERT INTO show_seats
    (show_id, seat_id, price, status)
SELECT
    3,
    seat_id,
    CASE
        WHEN seat_type = 'PREMIUM' THEN 270.00
        ELSE 220.00
    END,
    'AVAILABLE'
FROM seats
WHERE screen_id = 2;

INSERT INTO show_seats
    (show_id, seat_id, price, status)
SELECT
    4,
    seat_id,
    CASE
        WHEN seat_type = 'PREMIUM' THEN 300.00
        ELSE 250.00
    END,
    'AVAILABLE'
FROM seats
WHERE screen_id = 2;

SELECT
    ss.show_seat_id,
    m.title AS movie,
    sc.screen_name,
    CONCAT(se.seat_row, se.seat_number) AS seat,
    se.seat_type,
    ss.price,
    ss.status
FROM show_seats ss
JOIN shows s
    ON ss.show_id = s.show_id
JOIN movies m
    ON s.movie_id = m.movie_id
JOIN screens sc
    ON s.screen_id = sc.screen_id
JOIN seats se
    ON ss.seat_id = se.seat_id
ORDER BY ss.show_id, se.seat_row, se.seat_number;

INSERT INTO users (full_name, email, phone)
VALUES
    ('Aarav Sharma', 'aarav@example.com', '9000000001'),
    ('Meera Patel', 'meera@example.com', '9000000002');

SELECT * FROM users;

SELECT
    ss.show_seat_id,
    m.title AS movie,
    CONCAT(se.seat_row, se.seat_number) AS seat,
    ss.price,
    ss.status
FROM show_seats ss
JOIN shows s
    ON ss.show_id = s.show_id
JOIN movies m
    ON s.movie_id = m.movie_id
JOIN seats se
    ON ss.seat_id = se.seat_id
WHERE ss.show_id = 1
  AND ss.status = 'AVAILABLE';

START TRANSACTION;

SELECT
    show_seat_id,
    show_id,
    seat_id,
    price,
    status
FROM show_seats
WHERE show_seat_id = 1
FOR UPDATE;

UPDATE show_seats
SET
    status = 'HELD',
    held_until = DATE_ADD(NOW(), INTERVAL 5 MINUTE)
WHERE show_seat_id = 1
  AND status = 'AVAILABLE';

SELECT
    show_seat_id,
    status,
    held_until,
    NOW() AS checked_at
FROM show_seats
WHERE show_seat_id = 1;

INSERT INTO bookings
    (user_id, show_id, booking_reference, status, total_amount, expires_at)
VALUES
    (1, 1, UUID(), 'PENDING', 250.00,
     DATE_ADD(NOW(), INTERVAL 5 MINUTE));

SELECT
    booking_id,
    booking_reference,
    user_id,
    show_id,
    status,
    total_amount,
    expires_at
FROM bookings
ORDER BY booking_id DESC
LIMIT 1;

SET @booking_id = (
    SELECT booking_id
    FROM bookings
    ORDER BY booking_id DESC
    LIMIT 1
);

SET @seat_id = (
    SELECT seat_id
    FROM show_seats
    WHERE show_seat_id = 1
);

INSERT INTO booking_seats
    (booking_id, seat_id, ticket_price)
SELECT
    @booking_id,
    @seat_id,
    price
FROM show_seats
WHERE show_seat_id = 1;


SELECT
    bs.booking_seat_id,
    bs.booking_id,
    bs.seat_id,
    bs.ticket_price
FROM booking_seats bs
WHERE bs.booking_id = @booking_id;

UPDATE show_seats
SET
    status = 'BOOKED',
    held_until = NULL
WHERE show_seat_id = 1
  AND status = 'HELD';

UPDATE bookings
SET status = 'CONFIRMED'
WHERE booking_id = @booking_id
  AND status = 'PENDING';

COMMIT;

SELECT
    b.booking_id,
    u.full_name,
    m.title AS movie,
    CONCAT(se.seat_row, se.seat_number) AS seat,
    bs.ticket_price,
    b.status AS booking_status,
    ss.status AS seat_status
FROM bookings b
JOIN users u
    ON b.user_id = u.user_id
JOIN shows s
    ON b.show_id = s.show_id
JOIN movies m
    ON s.movie_id = m.movie_id
JOIN booking_seats bs
    ON b.booking_id = bs.booking_id
JOIN seats se
    ON bs.seat_id = se.seat_id
JOIN show_seats ss
    ON ss.show_id = b.show_id
   AND ss.seat_id = bs.seat_id
WHERE b.booking_id = @booking_id;

INSERT INTO payments
    (booking_id, payment_reference, amount, status, payment_method)
SELECT
    booking_id,
    UUID(),
    total_amount,
    'SUCCESS',
    'UPI'
FROM bookings
WHERE booking_id = @booking_id
  AND status = 'CONFIRMED';

SELECT
    payment_id,
    booking_id,
    payment_reference,
    amount,
    status,
    payment_method
FROM payments
WHERE booking_id = @booking_id;

CREATE INDEX idx_theatres_city
ON theatres(city_id);

CREATE INDEX idx_screens_theatre
ON screens(theatre_id);

CREATE INDEX idx_seats_screen
ON seats(screen_id);

CREATE INDEX idx_shows_movie
ON shows(movie_id);

CREATE INDEX idx_shows_screen_time
ON shows(screen_id, start_time);

CREATE INDEX idx_bookings_user
ON bookings(user_id);

CREATE INDEX idx_bookings_show
ON bookings(show_id);

CREATE INDEX idx_booking_seats_seat
ON booking_seats(seat_id);

CREATE INDEX idx_show_seats_status
ON show_seats(show_id, status);

CREATE INDEX idx_payments_booking
ON payments(booking_id);

SELECT
    m.title AS movie,
    t.theatre_name,
    c.city_name,
    sc.screen_name,
    s.start_time,
    s.end_time,
    s.base_price
FROM shows s
JOIN movies m
    ON s.movie_id = m.movie_id
JOIN screens sc
    ON s.screen_id = sc.screen_id
JOIN theatres t
    ON sc.theatre_id = t.theatre_id
JOIN cities c
    ON t.city_id = c.city_id
WHERE m.title = 'Interstellar'
ORDER BY s.start_time;


SELECT
    ss.show_seat_id,
    CONCAT(se.seat_row, se.seat_number) AS seat,
    se.seat_type,
    ss.price
FROM show_seats ss
JOIN seats se
    ON ss.seat_id = se.seat_id
WHERE ss.show_id = 1
  AND ss.status = 'AVAILABLE'
ORDER BY se.seat_row, se.seat_number;

SELECT
    show_seat_id,
    status
FROM show_seats
WHERE show_seat_id = 1;

UPDATE show_seats
SET status = 'BOOKED'
WHERE show_seat_id = 1
  AND status = 'AVAILABLE';

SHOW TABLES;


SELECT COUNT(*) AS users_count
FROM users;

SELECT COUNT(*) AS cities_count
FROM cities;

SELECT COUNT(*) AS theatres_count
FROM theatres;

SELECT COUNT(*) AS screens_count
FROM screens;

SELECT COUNT(*) AS seats_count
FROM seats;

SELECT COUNT(*) AS movies_count
FROM movies;

SELECT COUNT(*) AS shows_count
FROM shows;

SELECT COUNT(*) AS show_seats_count
FROM show_seats;

SELECT COUNT(*) AS bookings_count
FROM bookings;

SELECT COUNT(*) AS booking_seats_count
FROM booking_seats;

SELECT COUNT(*) AS payments_count
FROM payments;

SHOW TABLES;

