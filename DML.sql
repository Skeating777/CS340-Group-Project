/*
DML file for Group 25:
Spencer Keating and Matthew Clarke.
Data Manipulation Queries for the Dirty Spokes Bike Rentals web application.
Covers SELECT, INSERT, UPDATE, and DELETE operations for all four entities:
Customers, Brands, Bikes, and Rentals.

Variable notation: @variableName denotes a value passed in from the backend.
For example, @firstName will be replaced with the actual first name value
submitted by the user via the web form.
*/

--Customers
--SELECT all customers for the Customers browse page
SELECT customerID, firstName, lastName, dateOfBirth, email, phone, waiverDate
FROM Customers;

--SELECT a single customer by ID for the edit form
SELECT customerID, firstName, lastName, dateOfBirth, email, phone, waiverDate
FROM Customers
WHERE customerID = @customerID;

--INSERT a new customer from the Add Customer form
INSERT INTO Customers (firstName, lastName, dateOfBirth, email, phone, waiverDate)
VALUES (@firstName, @lastName, @dateOfBirth, @email, @phone, @waiverDate);

--UPDATE an existing customer record
UPDATE Customers
SET firstName = @firstName,
    lastName = @lastName,
    dateOfBirth = @dateOfBirth,
    email = @email,
    phone = @phone,
    waiverDate = @waiverDate
WHERE customerID = @customerID;

--DELETE a customer by ID
DELETE FROM Customers WHERE customerID = @customerID;


--Brands
--SELECT all brands for the Brands browse page
SELECT brandID, brandName, countryOfOrigin, localDealer
FROM Brands;

--SELECT a single brand by ID for the edit form
SELECT brandID, brandName, countryOfOrigin, localDealer
FROM Brands
WHERE brandID = @brandID;

--INSERT a new brand from the Add Brand form
INSERT INTO Brands (brandName, countryOfOrigin, localDealer)
VALUES (@brandName, @countryOfOrigin, @localDealer);

--UPDATE an existing brand record
UPDATE Brands
SET brandName = @brandName,
    countryOfOrigin = @countryOfOrigin,
    localDealer = @localDealer
WHERE brandID = @brandID;

--DELETE a brand by ID
DELETE FROM Brands WHERE brandID = @brandID;


-- Bikes
/*
Bikes browse page displays brandName in place of brandID for readability,
requiring a JOIN to the Brands table.
*/
--SELECT all bikes with brand name for the Bikes browse page
SELECT
    Bikes.bikeID,
    Bikes.frameNumber,
    Brands.brandName,
    Bikes.modelName,
    Bikes.engineSize,
    Bikes.bikeYear,
    Bikes.engineHourMeter
FROM Bikes
JOIN Brands ON Bikes.brandID = Brands.brandID;

--SELECT a single bike by ID for the edit form
SELECT bikeID, frameNumber, brandID, modelName, engineSize, bikeYear, engineHourMeter
FROM Bikes
WHERE bikeID = @bikeID;

--SELECT all brands to populate the brand dropdown on the Add/Edit Bike form
SELECT brandID, brandName FROM Brands;

--INSERT a new bike from the Add Bike form
INSERT INTO Bikes (frameNumber, brandID, modelName, engineSize, bikeYear, engineHourMeter)
VALUES (@frameNumber, @brandID, @modelName, @engineSize, @bikeYear, @engineHourMeter);

--UPDATE an existing bike record
UPDATE Bikes
SET frameNumber = @frameNumber,
    brandID = @brandID,
    modelName = @modelName,
    engineSize = @engineSize,
    bikeYear = @bikeYear,
    engineHourMeter = @engineHourMeter
WHERE bikeID = @bikeID;

--DELETE a bike by ID
DELETE FROM Bikes WHERE bikeID = @bikeID;


-- Rentals
/*
Rentals browse page displays customer full name and bike model in place of
raw foreign key IDs, requiring JOINs to both Customers and Bikes tables.
*/

--SELECT all rentals with customer name and bike model for the Rentals browse page
SELECT
    Rentals.rentalID,
    Customers.firstName,
    Customers.lastName,
    Bikes.modelName,
    Rentals.rentalDate,
    Rentals.returnDate,
    Rentals.hourMeterOut,
    Rentals.hourMeterIn
FROM Rentals
JOIN Customers ON Rentals.customerID = Customers.customerID
JOIN Bikes ON Rentals.bikeID = Bikes.bikeID;

--SELECT a single rental by ID for the edit form
SELECT rentalID, customerID, bikeID, rentalDate, returnDate, hourMeterOut, hourMeterIn
FROM Rentals
WHERE rentalID = @rentalID;

--SELECT all customers to populate the customer dropdown on the Add/Edit Rental form
SELECT customerID, firstName, lastName FROM Customers;

--SELECT all bikes to populate the bike dropdown on the Add/Edit Rental form
SELECT bikeID, modelName, frameNumber FROM Bikes;

--INSERT a new rental from the Add Rental form
INSERT INTO Rentals (customerID, bikeID, rentalDate, returnDate, hourMeterOut, hourMeterIn)
VALUES (@customerID, @bikeID, @rentalDate, @returnDate, @hourMeterOut, @hourMeterIn);

--UPDATE an existing rental record
UPDATE Rentals
SET customerID = @customerID,
    bikeID = @bikeID,
    rentalDate = @rentalDate,
    returnDate = @returnDate,
    hourMeterOut = @hourMeterOut,
    hourMeterIn = @hourMeterIn
WHERE rentalID = @rentalID;

--DELETE a rental by ID
DELETE FROM Rentals WHERE rentalID = @rentalID;
