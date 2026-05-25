const express = require('express');
const { engine } = require('express-handlebars');
const db = require('./database/db-connector');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 9124;

app.engine('handlebars', engine({
    helpers: {
        // Format DATE columns as YYYY-MM-DD for date inputs and display
        formatDate: (d) => d ? new Date(d).toISOString().split('T')[0] : '',
        // Format DATETIME columns as YYYY-MM-DDTHH:MM:SS for datetime-local inputs
        formatDatetime: (d) => d ? new Date(d).toISOString().slice(0, 19) : '',
        // Format DATETIME columns as YYYY-MM-DD HH:MM:SS for table display
        displayDatetime: (d) => d ? new Date(d).toISOString().slice(0, 19).replace('T', ' ') : '',
        // Mark the matching option as selected in a dropdown
        selected: (a, b) => a == b ? 'selected' : ''
    }
}));
app.set('view engine', 'handlebars');
app.set('views', './views');

app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// ---- Index ----
app.get('/', (req, res) => res.render('index'));

app.get('/reset', async (req, res) => {
    try {
        await db.query('CALL reset_db()');
        res.redirect('/');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});


// ---- Customers ----
app.get('/customers', async (req, res) => {
    try {
        const [customers] = await db.query(
            'SELECT customerID, firstName, lastName, dateOfBirth, email, phone, waiverDate FROM Customers ORDER BY customerID ASC'
        );
        res.render('customers', { customers });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.get('/customers/edit/:id', async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT customerID, firstName, lastName, dateOfBirth, email, phone, waiverDate FROM Customers WHERE customerID = ?',
            [req.params.id]
        );
        if (!rows.length) return res.redirect('/customers');
        res.render('edit-customer', { customer: rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.get('/customers/delete-jeremy', async (req, res) => {
    try {
        await db.query('CALL sp_DeleteSampleData()');
        res.redirect('/customers');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/customers/add', async (req, res) => {
    try {
        await db.query(
            'CALL sp_AddCustomer(?, ?, ?, ?, ?, ?)',
            [req.body.firstName, req.body.lastName, req.body.dateOfBirth,
             req.body.email, req.body.phone, req.body.waiverDate]
        );
        res.redirect('/customers');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/customers/update', async (req, res) => {
    try {
        await db.query(
            'CALL sp_UpdateCustomer(?, ?, ?, ?, ?, ?, ?)',
            [req.body.customerID, req.body.firstName, req.body.lastName,
             req.body.dateOfBirth, req.body.email, req.body.phone, req.body.waiverDate]
        );
        res.redirect('/customers');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/customers/delete', async (req, res) => {
    try {
        await db.query('CALL sp_DeleteCustomer(?)', [req.body.customerID]);
        res.redirect('/customers');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});


// ---- Brands ----
app.get('/brands', async (req, res) => {
    try {
        const [brands] = await db.query(
            'SELECT brandID, brandName, countryOfOrigin, localDealer FROM Brands ORDER BY brandID ASC'
        );
        res.render('brands', { brands });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.get('/brands/edit/:id', async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT brandID, brandName, countryOfOrigin, localDealer FROM Brands WHERE brandID = ?',
            [req.params.id]
        );
        if (!rows.length) return res.redirect('/brands');
        res.render('edit-brand', { brand: rows[0] });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/brands/add', async (req, res) => {
    try {
        await db.query(
            'CALL sp_AddBrand(?, ?, ?)',
            [req.body.brandName, req.body.countryOfOrigin, req.body.localDealer]
        );
        res.redirect('/brands');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/brands/update', async (req, res) => {
    try {
        await db.query(
            'CALL sp_UpdateBrand(?, ?, ?, ?)',
            [req.body.brandID, req.body.brandName, req.body.countryOfOrigin, req.body.localDealer]
        );
        res.redirect('/brands');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/brands/delete', async (req, res) => {
    try {
        await db.query('CALL sp_DeleteBrand(?)', [req.body.brandID]);
        res.redirect('/brands');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});


// ---- Bikes ----
app.get('/bikes', async (req, res) => {
    try {
        const [bikes] = await db.query(`
            SELECT Bikes.bikeID, Bikes.frameNumber, Brands.brandName,
                   Bikes.modelName, Bikes.engineSize, Bikes.bikeYear, Bikes.engineHourMeter
            FROM Bikes
            JOIN Brands ON Bikes.brandID = Brands.brandID
            ORDER BY Bikes.bikeID ASC`
        );
        const [brands] = await db.query('SELECT brandID, brandName FROM Brands ORDER BY brandName ASC');
        res.render('bikes', { bikes, brands });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.get('/bikes/edit/:id', async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT bikeID, frameNumber, brandID, modelName, engineSize, bikeYear, engineHourMeter FROM Bikes WHERE bikeID = ?',
            [req.params.id]
        );
        if (!rows.length) return res.redirect('/bikes');
        const [brands] = await db.query('SELECT brandID, brandName FROM Brands ORDER BY brandName ASC');
        res.render('edit-bike', { bike: rows[0], brands });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/bikes/add', async (req, res) => {
    try {
        await db.query(
            'CALL sp_AddBike(?, ?, ?, ?, ?, ?)',
            [req.body.frameNumber, req.body.brandID, req.body.modelName,
             req.body.engineSize, req.body.bikeYear, req.body.engineHourMeter]
        );
        res.redirect('/bikes');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/bikes/update', async (req, res) => {
    try {
        await db.query(
            'CALL sp_UpdateBike(?, ?, ?, ?, ?, ?, ?)',
            [req.body.bikeID, req.body.frameNumber, req.body.brandID, req.body.modelName,
             req.body.engineSize, req.body.bikeYear, req.body.engineHourMeter]
        );
        res.redirect('/bikes');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/bikes/delete', async (req, res) => {
    try {
        await db.query('CALL sp_DeleteBike(?)', [req.body.bikeID]);
        res.redirect('/bikes');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});


// ---- Rentals ----
app.get('/rentals', async (req, res) => {
    try {
        const [rentals] = await db.query(`
            SELECT Rentals.rentalID,
                   CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName,
                   Bikes.modelName, Rentals.rentalDate, Rentals.returnDate,
                   Rentals.hourMeterOut, Rentals.hourMeterIn
            FROM Rentals
            JOIN Customers ON Rentals.customerID = Customers.customerID
            JOIN Bikes ON Rentals.bikeID = Bikes.bikeID
            ORDER BY Rentals.rentalID ASC`
        );
        const [customers] = await db.query(
            "SELECT customerID, CONCAT(firstName, ' ', lastName) AS customerName FROM Customers ORDER BY firstName ASC, lastName ASC"
        );
        const [bikes] = await db.query(
            "SELECT bikeID, CONCAT(modelName, ' (', frameNumber, ')') AS bikeLabel FROM Bikes ORDER BY modelName ASC"
        );
        res.render('rentals', { rentals, customers, bikes });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.get('/rentals/edit/:id', async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT rentalID, customerID, bikeID, rentalDate, returnDate, hourMeterOut, hourMeterIn FROM Rentals WHERE rentalID = ?',
            [req.params.id]
        );
        if (!rows.length) return res.redirect('/rentals');
        const [customers] = await db.query(
            "SELECT customerID, CONCAT(firstName, ' ', lastName) AS customerName FROM Customers ORDER BY firstName ASC, lastName ASC"
        );
        const [bikes] = await db.query(
            "SELECT bikeID, CONCAT(modelName, ' (', frameNumber, ')') AS bikeLabel FROM Bikes ORDER BY modelName ASC"
        );
        res.render('edit-rental', { rental: rows[0], customers, bikes });
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/rentals/add', async (req, res) => {
    try {
        await db.query(
            'CALL sp_AddRental(?, ?, ?, ?, ?, ?)',
            [req.body.customerID, req.body.bikeID,
             req.body.rentalDate.replace('T', ' '), req.body.returnDate.replace('T', ' '),
             req.body.hourMeterOut, req.body.hourMeterIn]
        );
        res.redirect('/rentals');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/rentals/update', async (req, res) => {
    try {
        await db.query(
            'CALL sp_UpdateRental(?, ?, ?, ?, ?, ?, ?)',
            [req.body.rentalID, req.body.customerID, req.body.bikeID,
             req.body.rentalDate.replace('T', ' '), req.body.returnDate.replace('T', ' '),
             req.body.hourMeterOut, req.body.hourMeterIn]
        );
        res.redirect('/rentals');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/rentals/delete', async (req, res) => {
    try {
        await db.query('CALL sp_DeleteRental(?)', [req.body.rentalID]);
        res.redirect('/rentals');
    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});


app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
