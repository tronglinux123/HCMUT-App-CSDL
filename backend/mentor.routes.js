const express = require('express');
const router = express.Router();
const mentorController = require('./mentor.controller');

router.post('/mentorApplication', mentorController.applicate);
router.post('/ApplicationCheck', mentorController.check);
router.post('/ApplicationCheckByAdmin', mentorController.select);
router.post('/deleteapply', mentorController.delete);
router.post('/accessapply', mentorController.access);


module.exports = router