/*
DDL file and sample data for Group 25:
Spencer Keating and Matthew Clarke.
Database for storage of operational information for Dirty Spokes
Bike Rentals. Tables are Brands, Bikes, Customers, and Rentals where
Rentals is an intersection table between Customers and Bikes.
*/

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

CREATE OR REPLACE TABLE Customers (
    customerID  INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    firstName   VARCHAR(50) NOT NULL,
    lastName    VARCHAR(50) NOT NULL,
    dateOfBirth DATE NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    phone       VARCHAR(20) NOT NULL,
    waiverDate  DATE NOT NULL
);

CREATE OR REPLACE TABLE Brands(
    brandID         INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    brandName       VARCHAR(100) UNIQUE NOT NULL,
    countryOfOrigin VARCHAR(100) NOT NULL,
    localDealer     VARCHAR(255) NOT NULL
);

CREATE OR REPLACE TABLE Bikes(
    bikeID          INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    frameNumber     VARCHAR(50) UNIQUE NOT NULL,
    brandID         INT UNSIGNED NOT NULL,
    modelName       VARCHAR(100) NOT NULL,
    engineSize      VARCHAR(10) NOT NULL,
    bikeYear        INT UNSIGNED NOT NULL,
    engineHourMeter DECIMAL(6,1) NOT NULL,
    FOREIGN KEY (brandID) REFERENCES Brands(brandID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE OR REPLACE TABLE Rentals(
    rentalID     INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    customerID   INT UNSIGNED NOT NULL,
    bikeID       INT UNSIGNED NOT NULL,
    rentalDate   DATETIME NOT NULL,
    returnDate   DATETIME NOT NULL,
    hourMeterOut DECIMAL(6,1) NOT NULL,
    hourMeterIn  DECIMAL(6,1) NOT NULL,
    FOREIGN KEY (customerID) REFERENCES Customers(customerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (bikeID) REFERENCES Bikes(bikeID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- Sample data
INSERT INTO Customers(
    firstName,
    lastName,
    dateOfBirth,
    email,
    phone,
    waiverDate
)
VALUES
(
    "Jeremy",
    "Stevens",
    '1989-06-11',
    "jsteve0@email.com",
    "555-0101",
    '2024-11-22'
),
(
    "Andrea",
    "Hernandez",
    '2003-11-25',
    "andreah44@email.com",
    "555-0202",
    '2025-04-17'
),
(
    "Roman",
    "Lutoslawski",
    '1978-08-26',
    "roman444@email.com",
    "555-0303",
    '2020-08-20'
);

INSERT INTO Brands(
    brandName,
    countryOfOrigin,
    localDealer
)
VALUES
(
    "Sherco",
    "France",
    "Trials Offroad"
),
(
    "KTM",
    "Austria",
    "SoCal Moto"
),
(
    "Yamaha",
    "Japan",
    "SoCal Moto"
);

INSERT INTO Bikes(
    frameNumber,
    brandID,
    modelName,
    bikeYear,
    engineSize,
    engineHourMeter
)
VALUES
/*
Bikes created with Foreign Key brandID by Selection of unique brandName
attribute from Brands table.
*/
(
    "JYACB11C0RA015607",
    (SELECT brandID from Brands where brandName = "Yamaha"),
    "YZ65",
    2024,
    "65cc",
    15.8
),
(
    "VBKXWM236MM321033",
    (SELECT brandID from Brands where brandName = "KTM"),
    "300 XC-W",
    2021,
    "293cc",
    71.4
),
(
    "VNBS648C4PB000307",
    (SELECT brandID from Brands where brandName = "Sherco"),
    "SE-F 500 Factory 4T",
    2023,
    "478cc",
    225.5
);

INSERT INTO Rentals(
    customerID,
    bikeID,
    rentalDate,
    returnDate,
    hourMeterOut,
    hourMeterIn
)
VALUES
/*
Rentals samples designed to demonstrate M:N relationship between Customers and Bikes,
i.e. Customer with Unique email "roman444@email.com" renting multiple bikes while
the Bike with Unique frame number "VBKXWM236MM321033" is rented by multiple customers.
*/
(
    (SELECT customerID from Customers where email = "roman444@email.com"),
    (SELECT bikeID from Bikes where frameNumber = "VNBS648C4PB000307"),
    '2025-04-06 11:22:56',
    '2025-04-08 16:43:16',
    219.9,
    225.5
),
(
    (SELECT customerID from Customers where email = "roman444@email.com"),
    (SELECT bikeID from Bikes where frameNumber = "VBKXWM236MM321033"),
    '2026-04-10 09:30:17',
    '2026-04-13 10:17:44',
    60.6,
    68.0
),
(
    (SELECT customerID from Customers where email = "andreah44@email.com"),
    (SELECT bikeID from Bikes where frameNumber = "VBKXWM236MM321033"),
    '2026-04-19 10:19:19',
    '2026-04-19 15:22:04',
    68.1,
    71.4
);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
