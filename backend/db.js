const mysql = require('mysql2/promise');

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
})

pool.getConnection()
    .then(connection => {
        console.log('successfully connect to database');
        connection.release();
    })
    .catch(err => {
        console.error('Error to connect to database', err.code);
    });

module.exports = pool;
