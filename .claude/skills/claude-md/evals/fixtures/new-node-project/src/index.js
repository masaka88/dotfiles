const express = require('express');
const { Pool } = require('pg');

const app = express();
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

app.use(express.json());

app.get('/tasks', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM tasks ORDER BY id');
  res.json(rows);
});

app.listen(process.env.PORT || 3000);
