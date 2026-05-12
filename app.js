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
        // Format DATETIME columns as YYYY-MM-DDTHH:MM for datetime-local inputs
        formatDatetime: (d) => d ? new Date(d).toISOString().slice(0, 16) : '',
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

app.post('/customers/add', (req, res) => res.redirect('/customers'));       // TODO Step 4
app.post('/customers/update', (req, res) => res.redirect('/customers'));    // TODO Step 4
app.post('/customers/delete', (req, res) => res.redirect('/customers'));    // TODO Step 4


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

app.post('/brands/add', (req, res) => res.redirect('/brands'));             // TODO Step 4
app.post('/brands/update', (req, res) => res.redirect('/brands'));          // TODO Step 4
app.post('/brands/delete', (req, res) => res.redirect('/brands'));          // TODO Step 4


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

app.post('/bikes/add', (req, res) => res.redirect('/bikes'));               // TODO Step 4
app.post('/bikes/update', (req, res) => res.redirect('/bikes'));            // TODO Step 4
app.post('/bikes/delete', (req, res) => res.redirect('/bikes'));            // TODO Step 4


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

app.post('/rentals/add', (req, res) => res.redirect('/rentals'));           // TODO Step 4
app.post('/rentals/update', (req, res) => res.redirect('/rentals'));        // TODO Step 4
app.post('/rentals/delete', (req, res) => res.redirect('/rentals'));        // TODO Step 4


app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
