const express = require('express');
const router = express.Router();
const authController = require('./auth.controller');

router.post('/register', authController.register);
router.post('/registermentor', authController.registermentor);
router.post('/login', authController.login);
module.exports = router