/*
PL/SQL file for Group 25:
Spencer Keating and Matthew Clarke.
Stored procedures for the Dirty Spokes Bike Rentals web application.
Includes sp_DeleteSampleData for verifying RESET, and Add/Update/Delete
procedures for Customers, Brands, Bikes, and Rentals.
*/

-- Demo CUD operation to verify RESET
DROP PROCEDURE IF EXISTS sp_DeleteSampleData;
DELIMITER //
CREATE PROCEDURE sp_DeleteSampleData()
BEGIN
DELETE FROM Customers WHERE email = 'jsteve0@email.com';
END //
DELIMITER ;


-- Customers
DROP PROCEDURE IF EXISTS sp_AddCustomer;
DELIMITER //
CREATE PROCEDURE sp_AddCustomer(
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_dateOfBirth DATE,
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_waiverDate DATE
)
BEGIN
INSERT INTO Customers (firstName, lastName, dateOfBirth, email, phone, waiverDate)
VALUES (p_firstName, p_lastName, p_dateOfBirth, p_email, p_phone, p_waiverDate);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateCustomer;
DELIMITER //
CREATE PROCEDURE sp_UpdateCustomer(
    IN p_customerID INT UNSIGNED,
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_dateOfBirth DATE,
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_waiverDate DATE
)
BEGIN
UPDATE Customers
SET firstName = p_firstName,
    lastName = p_lastName,
    dateOfBirth = p_dateOfBirth,
    email = p_email,
    phone = p_phone,
    waiverDate = p_waiverDate
WHERE customerID = p_customerID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteCustomer;
DELIMITER //
CREATE PROCEDURE sp_DeleteCustomer(
    IN p_customerID INT UNSIGNED
)
BEGIN
DELETE FROM Customers WHERE customerID = p_customerID;
END //
DELIMITER ;


-- Brands
DROP PROCEDURE IF EXISTS sp_AddBrand;
DELIMITER //
CREATE PROCEDURE sp_AddBrand(
    IN p_brandName VARCHAR(100),
    IN p_countryOfOrigin VARCHAR(100),
    IN p_localDealer VARCHAR(255)
)
BEGIN
INSERT INTO Brands (brandName, countryOfOrigin, localDealer)
VALUES (p_brandName, p_countryOfOrigin, p_localDealer);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateBrand;
DELIMITER //
CREATE PROCEDURE sp_UpdateBrand(
    IN p_brandID INT UNSIGNED,
    IN p_brandName VARCHAR(100),
    IN p_countryOfOrigin VARCHAR(100),
    IN p_localDealer VARCHAR(255)
)
BEGIN
UPDATE Brands
SET brandName = p_brandName,
    countryOfOrigin = p_countryOfOrigin,
    localDealer = p_localDealer
WHERE brandID = p_brandID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteBrand;
DELIMITER //
CREATE PROCEDURE sp_DeleteBrand(
    IN p_brandID INT UNSIGNED
)
BEGIN
DELETE FROM Brands WHERE brandID = p_brandID;
END //
DELIMITER ;


-- Bikes
DROP PROCEDURE IF EXISTS sp_AddBike;
DELIMITER //
CREATE PROCEDURE sp_AddBike(
    IN p_frameNumber VARCHAR(50),
    IN p_brandID INT UNSIGNED,
    IN p_modelName VARCHAR(100),
    IN p_engineSize VARCHAR(10),
    IN p_bikeYear INT UNSIGNED,
    IN p_engineHourMeter DECIMAL(6,1)
)
BEGIN
INSERT INTO Bikes (frameNumber, brandID, modelName, engineSize, bikeYear, engineHourMeter)
VALUES (p_frameNumber, p_brandID, p_modelName, p_engineSize, p_bikeYear, p_engineHourMeter);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateBike;
DELIMITER //
CREATE PROCEDURE sp_UpdateBike(
    IN p_bikeID INT UNSIGNED,
    IN p_frameNumber VARCHAR(50),
    IN p_brandID INT UNSIGNED,
    IN p_modelName VARCHAR(100),
    IN p_engineSize VARCHAR(10),
    IN p_bikeYear INT UNSIGNED,
    IN p_engineHourMeter DECIMAL(6,1)
)
BEGIN
UPDATE Bikes
SET frameNumber = p_frameNumber,
    brandID = p_brandID,
    modelName = p_modelName,
    engineSize = p_engineSize,
    bikeYear = p_bikeYear,
    engineHourMeter = p_engineHourMeter
WHERE bikeID = p_bikeID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteBike;
DELIMITER //
CREATE PROCEDURE sp_DeleteBike(
    IN p_bikeID INT UNSIGNED
)
BEGIN
DELETE FROM Bikes WHERE bikeID = p_bikeID;
END //
DELIMITER ;


-- Rentals
DROP PROCEDURE IF EXISTS sp_AddRental;
DELIMITER //
CREATE PROCEDURE sp_AddRental(
    IN p_customerID INT UNSIGNED,
    IN p_bikeID INT UNSIGNED,
    IN p_rentalDate DATETIME,
    IN p_returnDate DATETIME,
    IN p_hourMeterOut DECIMAL(6,1),
    IN p_hourMeterIn DECIMAL(6,1)
)
BEGIN
INSERT INTO Rentals (customerID, bikeID, rentalDate, returnDate, hourMeterOut, hourMeterIn)
VALUES (p_customerID, p_bikeID, p_rentalDate, p_returnDate, p_hourMeterOut, p_hourMeterIn);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_UpdateRental;
DELIMITER //
CREATE PROCEDURE sp_UpdateRental(
    IN p_rentalID INT UNSIGNED,
    IN p_customerID INT UNSIGNED,
    IN p_bikeID INT UNSIGNED,
    IN p_rentalDate DATETIME,
    IN p_returnDate DATETIME,
    IN p_hourMeterOut DECIMAL(6,1),
    IN p_hourMeterIn DECIMAL(6,1)
)
BEGIN
UPDATE Rentals
SET customerID = p_customerID,
    bikeID = p_bikeID,
    rentalDate = p_rentalDate,
    returnDate = p_returnDate,
    hourMeterOut = p_hourMeterOut,
    hourMeterIn = p_hourMeterIn
WHERE rentalID = p_rentalID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_DeleteRental;
DELIMITER //
CREATE PROCEDURE sp_DeleteRental(
    IN p_rentalID INT UNSIGNED
)
BEGIN
DELETE FROM Rentals WHERE rentalID = p_rentalID;
END //
DELIMITER ;
