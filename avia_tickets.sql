CREATE OR REPLACE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    login VARCHAR(50) UNIQUE NOT NULL, -- New column for login/username
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role ENUM('User', 'Admin') NOT NULL DEFAULT 'User'
);

-- Insert sample data
INSERT INTO users (user_id, login, first_name, last_name, email, phone_number, password, role)
VALUES
    (1, 'admin', 'Admin', 'User', 'admin@example.com', '1234567890', 'admin_hashed_password', 'Admin'),
    (2, 'testuser', 'Test', 'User', 'test_user@example.com', '0987654321', 'test_user_hashed_password', 'User');
    
    

-- Table for cities
CREATE OR REPLACE TABLE cities (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

-- Table for airports
CREATE OR REPLACE TABLE airports (
    airport_code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city_id INT NOT NULL, -- Foreign key to cities
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- Table for airlinesavia_tickets
CREATE OR REPLACE TABLE airlines (
    airline_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    iata_code VARCHAR(10) UNIQUE NOT NULL
);


-- Junction table for airports and airlines (many-to-many)
CREATE OR REPLACE TABLE airport_airlines (
    airport_code VARCHAR(10) NOT NULL,
    airline_id INT NOT NULL,
    PRIMARY KEY (airport_code, airline_id),
    FOREIGN KEY (airport_code) REFERENCES airports(airport_code),
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id)
);

-- Table for flights
CREATE OR REPLACE TABLE flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(10) NOT NULL UNIQUE,
    departure_airport VARCHAR(10) NOT NULL,
    arrival_airport VARCHAR(10) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    airline_id INT NOT NULL, -- Foreign key to airlines
    aircraft_type VARCHAR(50),
    FOREIGN KEY (departure_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (arrival_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id)
);

-- Table for bookings
CREATE OR REPLACE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    booking_date DATETIME NOT NULL,
    flight_id INT NOT NULL,
    status ENUM('Confirmed', 'Pending', 'Cancelled') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Table for tickets
CREATE OR REPLACE TABLE tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    ticket_class ENUM('Economy', 'Business', 'First') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Table for payments
CREATE OR Replace TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME NOT NULL,
    status ENUM('Completed', 'Failed', 'Pending') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);
-- Table for luggage
CREATE OR REPLACE TABLE luggage (
    luggage_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    weight DECIMAL(5, 2) NOT NULL,
    type ENUM('Checked-in', 'Hand') NOT NULL,
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);
CREATE Or replace TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT, -- NULL if the user is not logged in
    name VARCHAR(100) NOT NULL, -- For non-logged-in users
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE OR REPLACE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert data into cities table
INSERT INTO cities (name, country)
VALUES
('London', 'UK'),
('Paris', 'France'),
('Frankfurt', 'Germany'),
('Amsterdam', 'Netherlands'),
('Madrid', 'Spain'),
('Rome', 'Italy'),
('Prague', 'Czech Republic'),
('Vienna', 'Austria'),
('Brussels', 'Belgium'),
('Warsaw', 'Poland');

-- Insert data into airports table
INSERT INTO airports (airport_code, name, city_id)
VALUES
('FRA', 'Frankfurt Airport', 3),  -- Frankfurt (Germany)
('CGH', 'Congonhas Airport', 2), -- Paris (France)
('MAD', 'Madrid-Barajas Airport', 5), -- Madrid (Spain)
('AMS', 'Amsterdam Airport Schiphol', 4), -- Amsterdam (Netherlands)
('LHR', 'Heathrow Airport', 1), -- London (UK)
('CDG', 'Charles de Gaulle Airport', 2), -- Paris (France)
('ROM', 'Rome Fiumicino Airport', 6), -- Rome (Italy)
('PRG', 'Václav Havel Airport Prague', 7), -- Prague (Czech Republic)
('BRU', 'Brussels Airport', 9), -- Brussels (Belgium)
('VIE', 'Vienna International Airport', 8), -- Vienna (Austria)
('WAW', 'Warsaw Chopin Airport', 10); -- Warsaw (Poland)

-- Insert data into airlines table

-- Insert data into airport_airlines (many-to-many) table
INSERT INTO airport_airlines (airport_code, airline_id)
VALUES
('LHR', 1), ('LHR', 2), ('LHR', 3), -- London (British Airways, Air France, Lufthansa)
('CDG', 2), ('CDG', 3), ('CDG', 4), -- Paris (Air France, Lufthansa, KLM)
('FRA', 3), ('FRA', 5), -- Frankfurt (Lufthansa, Iberia)
('AMS', 4), ('AMS', 5), -- Amsterdam (KLM, Iberia)
('MAD', 5), ('MAD', 6), -- Madrid (Iberia, Alitalia)
('ROM', 6), ('ROM', 7), -- Rome (Alitalia, Czech Airlines)
('PRG', 7), ('PRG', 1), -- Prague (Czech Airlines, British Airways)
('VIE', 8), ('VIE', 9), -- Vienna (Austrian Airlines, Brussels Airlines)
('BRU', 9), ('BRU', 10), -- Brussels (Brussels Airlines, LOT Polish Airlines)
('WAW', 10), ('WAW', 3); -- Warsaw (LOT Polish Airlines, Lufthansa)




INSERT INTO airport_airlines (airport_code, airline_id)
VALUES
('LHR', 1), ('LHR', 2), ('LHR', 3),
('CDG', 2), ('CDG', 3), ('CDG', 4),
('FRA', 3), ('FRA', 5),
('AMS', 4), ('AMS', 5),
('MAD', 5), ('MAD', 6),
('ROM', 6), ('ROM', 7),
('PRG', 7), ('PRG', 1),
('VIE', 8), ('VIE', 9),
('BRU', 9), ('BRU', 10),
('WAW', 10), ('WAW', 3);
INSERT INTO airlines (name, iata_code)
VALUES
('British Airways', 'BA'),
('Air France', 'AF'),
('Lufthansa', 'LH'),
('KLM', 'KL'),
('Iberia', 'IB'),
('Alitalia', 'AZ'),
('Czech Airlines', 'OK'),
('Austrian Airlines', 'OS'),
('Brussels Airlines', 'SN'),
('LOT Polish Airlines', 'LO');


INSERT INTO flights (flight_number, departure_airport, arrival_airport, departure_time, arrival_time, airline_id, aircraft_type)
VALUES
('FL119', 'FRA', 'CGH', '2025-01-27 09:00:00', '2025-01-27 12:00:00', 3, 'A321'),
('FL120', 'MAD', 'AMS', '2025-01-21 06:00:00', '2025-01-12 09:00:00', 4, 'B737'),
('FL123', 'LHR', 'CDG', '2025-01-10 08:00:00', '2025-01-10 09:30:00', 1, 'A320'),
('FL124', 'CDG', 'LHR', '2025-01-10 15:00:00', '2025-01-10 16:30:00', 2, 'B737'),
('FL125', 'LHR', 'FRA', '2025-01-11 09:00:00', '2025-01-11 11:00:00', 1, 'A320'),
('FL126', 'AMS', 'MAD', '2025-01-12 06:00:00', '2025-01-12 09:00:00', 4, 'B737'),
('FL127', 'MAD', 'AMS', '2025-01-12 17:00:00', '2025-01-12 20:00:00', 5, 'A321'),
('FL128', 'LHR', 'ROM', '2025-01-13 08:00:00', '2025-01-13 11:00:00', 6, 'A320'),
('FL129', 'ROM', 'LHR', '2025-01-13 19:00:00', '2025-01-13 22:00:00', 6, 'A320'),
('FL130', 'CDG', 'AMS', '2025-01-14 10:00:00', '2025-01-14 11:30:00', 2, 'E190'),
('FL131', 'AMS', 'CDG', '2025-01-14 15:00:00', '2025-01-14 16:30:00', 4, 'E190'),
('FL132', 'LHR', 'PRG', '2025-01-15 07:00:00', '2025-01-15 09:30:00', 7, 'A319'),
('FL133', 'PRG', 'LHR', '2025-01-15 19:00:00', '2025-01-15 21:30:00', 7, 'A319'),
('FL134', 'BRU', 'VIE', '2025-01-16 09:00:00', '2025-01-16 12:00:00', 9, 'Q400'),
('FL135', 'VIE', 'BRU', '2025-01-16 18:00:00', '2025-01-16 21:00:00', 8, 'A320'),
('FL136', 'WAW', 'FRA', '2025-01-17 06:00:00', '2025-01-17 08:30:00', 10, 'B737'),
('FL137', 'FRA', 'WAW', '2025-01-17 18:00:00', '2025-01-17 20:30:00', 3, 'A320'),
('FL138', 'MAD', 'FRA', '2025-01-18 09:00:00', '2025-01-18 12:00:00', 5, 'A321'),
('FL139', 'FRA', 'MAD', '2025-01-18 16:00:00', '2025-01-18 19:00:00', 3, 'A320'),
('FL140', 'CDG', 'LHR', '2025-01-19 10:00:00', '2025-01-19 11:30:00', 2, 'B737');

CREATE TABLE IF NOT EXISTS flights_archive (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    departure_airport VARCHAR(10) NOT NULL,
    arrival_airport VARCHAR(10) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    airline_id INT NOT NULL,
    aircraft_type VARCHAR(50),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (departure_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (arrival_airport) REFERENCES airports(airport_code),
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id)
);

CREATE TABLE IF NOT EXISTS users_archive (
    user_id INT PRIMARY KEY,
    login VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role ENUM('User', 'Admin') NOT NULL DEFAULT 'User',
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);