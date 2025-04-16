const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;

// Load quotes from JSON file
const quotesPath = path.join(__dirname, 'quotes.json');
let quotes = [];

try {
  quotes = JSON.parse(fs.readFileSync(quotesPath, 'utf8'));
} catch (err) {
  console.error('Error reading quotes file:', err);
  process.exit(1);
}

// Endpoint to retrieve all quotes
app.get('/quotes', (req, res) => {
  res.json(quotes);
});

// Endpoint to retrieve a specific quote by index
app.get('/quotes/:index', (req, res) => {
  const index = parseInt(req.params.index, 10);
  if (isNaN(index) || index < 0 || index >= quotes.length) {
    return res.status(404).json({ error: 'Index out of bounds' });
  }
  res.json(quotes[index]);
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

