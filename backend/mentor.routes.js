const express = require('express');
const router = express.Router();
const mentorController = require('./mentor.controller');

router.post('/mentorApplication', mentorController.applicate);
router.post('/ApplicationCheck', mentorController.check);
router.get('/ApplicationCheckByAdmin', mentorController.select);

module.exports = router