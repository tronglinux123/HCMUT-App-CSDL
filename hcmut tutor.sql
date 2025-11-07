CREATE DATABASE  IF NOT EXISTS `hcmut_tutor` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hcmut_tutor`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: hcmut_tutor
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `adminID` varchar(50) NOT NULL,
  PRIMARY KEY (`adminID`),
  UNIQUE KEY `admminID_UNIQUE` (`adminID`),
  CONSTRAINT `FK_Admin_User` FOREIGN KEY (`adminID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('admin001'),('admin002'),('admin003'),('admin004'),('admin005');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enroll`
--

DROP TABLE IF EXISTS `enroll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enroll` (
  `mentorID` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `Subject_name` varchar(255) DEFAULT NULL,
  `begin_session` int NOT NULL,
  `end_session` int NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `day` varchar(100) DEFAULT NULL,
  KEY `FK_Enroll_mentee_idx` (`mentorID`),
  CONSTRAINT `FK_Enroll_mentor` FOREIGN KEY (`mentorID`) REFERENCES `mentor` (`mentorID`) ON DELETE CASCADE,
  CONSTRAINT `chk_day_of_week` CHECK ((`day` in (_utf8mb4'Thứ Hai',_utf8mb4'Thứ Ba',_utf8mb4'Thứ Tư',_utf8mb4'Thứ Năm',_utf8mb4'Thứ Sáu',_utf8mb4'Thứ Bảy',_utf8mb4'CN'))),
  CONSTRAINT `chk_enroll_status` CHECK ((`status` in (_utf8mb4'pending',_utf8mb4'rejected',_utf8mb4'approved'))),
  CONSTRAINT `chk_session_order` CHECK ((`end_session` >= `begin_session`)),
  CONSTRAINT `chk_session_range` CHECK (((`begin_session` >= 1) and (`begin_session` <= 15) and (`end_session` >= 1) and (`end_session` <= 15)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enroll`
--

LOCK TABLES `enroll` WRITE;
/*!40000 ALTER TABLE `enroll` DISABLE KEYS */;
INSERT INTO `enroll` VALUES ('mentor001','pending','Cấu trúc dữ liệu và giải thuật',1,3,'H1-201','Thứ Hai'),('mentor002','pending','Mạch điện tử',4,6,'H2-302','Thứ Ba'),('mentor003','pending','Hóa hữu cơ',7,9,'H3-403','Thứ Tư'),('mentor004','pending','Nhập môn Trí tuệ nhân tạo',10,12,'H1-201','Thứ Năm'),('mentor005','pending','Sức bền vật liệu',13,15,'H4-504','Thứ Sáu');
/*!40000 ALTER TABLE `enroll` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_subject_faculty_on_insert` BEFORE INSERT ON `enroll` FOR EACH ROW BEGIN
    DECLARE v_mentor_faculty_id INT;
    DECLARE v_subject_faculty_id INT;
    
    -- 1. Lấy FacultyID của Mentor
    SELECT FacultyID INTO v_mentor_faculty_id
    FROM mentor
    WHERE mentorID = NEW.mentorID;
    
    -- 2. Lấy FacultyID của Subject (SỬA Ở ĐÂY)
    -- Thay vì 'SELECT SubjectID', chúng ta 'SELECT FacultyID'
    SELECT FacultyID INTO v_subject_faculty_id
    FROM subject
    WHERE Subject_name = NEW.Subject_name
    LIMIT 1;
    
    -- 3. Kiểm tra môn học
    IF v_subject_faculty_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Tên môn học không tồn tại trong bảng subject.';
    
    -- 4. So sánh FacultyID
    ELSEIF v_mentor_faculty_id != v_subject_faculty_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Môn học này không thuộc khoa mà mentor đang phụ trách.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_subject_faculty_on_update` BEFORE UPDATE ON `enroll` FOR EACH ROW BEGIN
    DECLARE v_mentor_faculty_id INT;
    DECLARE v_subject_faculty_id INT;

    IF NEW.mentorID != OLD.mentorID OR NEW.Subject_name != OLD.Subject_name THEN
        
        -- 1. Lấy FacultyID của Mentor
        SELECT FacultyID INTO v_mentor_faculty_id
        FROM mentor
        WHERE mentorID = NEW.mentorID;

        -- 2. Lấy FacultyID của Subject (SỬA Ở ĐÂY)
        -- Thay vì 'SELECT SubjectID', chúng ta 'SELECT FacultyID'
        SELECT FacultyID INTO v_subject_faculty_id
        FROM subject
        WHERE Subject_name = NEW.Subject_name
        LIMIT 1;

        -- 3. Kiểm tra môn học
        IF v_subject_faculty_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Tên môn học không tồn tại trong bảng subject.';
        
        -- 4. So sánh FacultyID
        ELSEIF v_mentor_faculty_id != v_subject_faculty_id THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Môn học này không thuộc khoa mà mentor đang phụ trách.';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_process_enroll_status` AFTER UPDATE ON `enroll` FOR EACH ROW BEGIN
	IF NEW.status = 'approved' != OLD.status = 'approved' THEN
		INSERT INTO `tutor_pair` (
                `mentorID`,
                `Subject_name`,
                `begin_session`,
                `end_session`,
                `location`,
                `day`
            )
            VALUES (
                NEW.mentorID,       
                NEW.Subject_name,   
                NEW.begin_session,  
                NEW.end_session,    
                NEW.location,       
                NEW.day             
            );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculty` (
  `FacultyID` int NOT NULL,
  `Faculty_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`FacultyID`),
  UNIQUE KEY `FacultyID_UNIQUE` (`FacultyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty`
--

LOCK TABLES `faculty` WRITE;
/*!40000 ALTER TABLE `faculty` DISABLE KEYS */;
INSERT INTO `faculty` VALUES (10,'Khoa Kỹ thuật Xây dựng'),(11,'Khoa Công nghệ Vật liệu'),(12,'Khoa Điện - Điện tử'),(13,'Khoa Khoa học và Kỹ thuật Máy tính'),(14,'Khoa Kỹ thuật Hóa học');
/*!40000 ALTER TABLE `faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_system`
--

DROP TABLE IF EXISTS `feedback_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback_system` (
  `menteeID` varchar(50) NOT NULL,
  `date_submit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `context` text,
  PRIMARY KEY (`menteeID`),
  KEY `FK_mentee_feedback_system` (`menteeID`),
  CONSTRAINT `FK_mentee_feedback_system` FOREIGN KEY (`menteeID`) REFERENCES `mentee` (`menteeID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback_system`
--

LOCK TABLES `feedback_system` WRITE;
/*!40000 ALTER TABLE `feedback_system` DISABLE KEYS */;
INSERT INTO `feedback_system` VALUES ('2110001','2025-11-01 09:00:00','Hệ thống chạy tốt, dễ sử dụng.'),('2110002','2025-11-02 10:00:00','Giao diện tìm kiếm hơi chậm.'),('2110003','2025-11-03 11:00:00','Nên thêm tính năng chat.'),('2110004','2025-11-04 12:00:00','Màu sắc giao diện đẹp.'),('2110005','2025-11-05 13:00:00','Không tìm thấy nút đăng xuất.');
/*!40000 ALTER TABLE `feedback_system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback_tutor`
--

DROP TABLE IF EXISTS `feedback_tutor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback_tutor` (
  `mentorID` varchar(50) NOT NULL,
  `menteeID` varchar(50) NOT NULL,
  `Context` text,
  `Date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mentorID`,`menteeID`),
  KEY `FK_FeedbackTutor_Mentee` (`menteeID`),
  CONSTRAINT `FK_FeedbackTutor_Mentee` FOREIGN KEY (`menteeID`) REFERENCES `mentee` (`menteeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_FeedbackTutor_Mentor` FOREIGN KEY (`mentorID`) REFERENCES `mentor` (`mentorID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback_tutor`
--

LOCK TABLES `feedback_tutor` WRITE;
/*!40000 ALTER TABLE `feedback_tutor` DISABLE KEYS */;
INSERT INTO `feedback_tutor` VALUES ('mentor001','2110001','Mentor giảng bài hay, dễ hiểu.','2025-11-10 14:00:00'),('mentor001','2110002','Mentor nhiệt tình, nhưng đôi khi đi hơi nhanh.','2025-11-11 15:00:00'),('mentor002','2110003','Rất hài lòng với mentor.','2025-11-12 16:00:00'),('mentor003','2110004','Mentor cung cấp nhiều tài liệu hay.','2025-11-13 17:00:00'),('mentor004','2110005','Mentor trả lời tin nhắn chậm.','2025-11-14 18:00:00');
/*!40000 ALTER TABLE `feedback_tutor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mentee`
--

DROP TABLE IF EXISTS `mentee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mentee` (
  `menteeID` varchar(50) NOT NULL,
  PRIMARY KEY (`menteeID`),
  UNIQUE KEY `menteeID_UNIQUE` (`menteeID`),
  CONSTRAINT `FK_Mentee_User` FOREIGN KEY (`menteeID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mentee`
--

LOCK TABLES `mentee` WRITE;
/*!40000 ALTER TABLE `mentee` DISABLE KEYS */;
INSERT INTO `mentee` VALUES ('2110001'),('2110002'),('2110003'),('2110004'),('2110005');
/*!40000 ALTER TABLE `mentee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mentee_list`
--

DROP TABLE IF EXISTS `mentee_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mentee_list` (
  `pairID` int NOT NULL,
  `menteeID` varchar(50) NOT NULL,
  PRIMARY KEY (`pairID`,`menteeID`),
  KEY `FK_mentee_list_mentee` (`menteeID`),
  CONSTRAINT `FK_mentee_list_mentee` FOREIGN KEY (`menteeID`) REFERENCES `mentee` (`menteeID`) ON DELETE CASCADE,
  CONSTRAINT `FK_mentee_list_pair` FOREIGN KEY (`pairID`) REFERENCES `tutor_pair` (`pairID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mentee_list`
--

LOCK TABLES `mentee_list` WRITE;
/*!40000 ALTER TABLE `mentee_list` DISABLE KEYS */;
INSERT INTO `mentee_list` VALUES (1,'2110001'),(1,'2110002'),(2,'2110003'),(3,'2110004'),(4,'2110005');
/*!40000 ALTER TABLE `mentee_list` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_mentee_capacity` BEFORE INSERT ON `mentee_list` FOR EACH ROW BEGIN
    DECLARE v_current_count INT;
    DECLARE v_max_capacity INT;

    -- 1. Lấy sĩ số TỐI ĐA và HIỆN TẠI (đọc từ bảng tutor_pair, KHÔNG phải mentee_list)
    SELECT `mentee_capacity`, `mentee_current_count`
    INTO v_max_capacity, v_current_count
    FROM `tutor_pair`
    WHERE `pairID` = NEW.pairID
    FOR UPDATE; -- Khóa hàng này lại

    -- 2. So sánh
    IF v_current_count >= v_max_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Lớp học này đã đủ sĩ số. Không thể thêm mentee.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_mentee_count_on_insert` AFTER INSERT ON `mentee_list` FOR EACH ROW BEGIN
    UPDATE `tutor_pair`
    SET `mentee_current_count` = `mentee_current_count` + 1
    WHERE `pairID` = NEW.pairID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_mentee_count_on_delete` AFTER DELETE ON `mentee_list` FOR EACH ROW BEGIN
    UPDATE `tutor_pair`
    SET `mentee_current_count` = `mentee_current_count` - 1
    WHERE `pairID` = OLD.pairID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `mentor`
--

DROP TABLE IF EXISTS `mentor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mentor` (
  `mentorID` varchar(50) NOT NULL,
  `GPA` decimal(3,2) NOT NULL,
  `FacultyID` int NOT NULL,
  `job` varchar(50) NOT NULL,
  `sinh_vien_nam` varchar(50) NOT NULL,
  PRIMARY KEY (`mentorID`),
  UNIQUE KEY `mentorID_UNIQUE` (`mentorID`),
  CONSTRAINT `FK_Mentor_User` FOREIGN KEY (`mentorID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE,
  CONSTRAINT `chk_gpa_scale_mentor` CHECK (((`GPA` >= 0) and (`GPA` <= 4))),
  CONSTRAINT `CHK_job_check_mentor` CHECK ((`job` in (_utf8mb4'nghien_cuu_sinh',_utf8mb4'sinh_vien',_utf8mb4'sinh_vien_sau_dh',_utf8mb4'giang_vien'))),
  CONSTRAINT `CHK_year_check_mentor` CHECK ((`sinh_vien_nam` in (_utf8mb4'none',_utf8mb4'nam_2',_utf8mb4'nam_3',_utf8mb4'nam_4')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mentor`
--

LOCK TABLES `mentor` WRITE;
/*!40000 ALTER TABLE `mentor` DISABLE KEYS */;
INSERT INTO `mentor` VALUES ('mentor001',3.00,13,'sinh_vien','nam_4'),('mentor002',4.00,12,'sinh_vien_sau_dh','none'),('mentor003',4.00,14,'giang_vien','none'),('mentor004',4.00,13,'sinh_vien','nam_3'),('mentor005',3.00,10,'nghien_cuu_sinh','none');
/*!40000 ALTER TABLE `mentor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outline`
--

DROP TABLE IF EXISTS `outline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `outline` (
  `OutlineID` int NOT NULL,
  `PairID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Context` text,
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`OutlineID`),
  UNIQUE KEY `OutlineID_UNIQUE` (`OutlineID`),
  KEY `FK_Outline_pair` (`PairID`),
  CONSTRAINT `FK_Outline_pair` FOREIGN KEY (`PairID`) REFERENCES `tutor_pair` (`pairID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outline`
--

LOCK TABLES `outline` WRITE;
/*!40000 ALTER TABLE `outline` DISABLE KEYS */;
INSERT INTO `outline` VALUES (1,1,'Chương 1: Cấu trúc dữ liệu cơ bản','Nội dung về stack, queue, list.','2025-11-01 10:00:00'),(2,1,'Chương 2: Cây và Đồ thị','Nội dung về cây nhị phân, BFS, DFS.','2025-11-02 11:00:00'),(3,2,'Bài 1: Mạch Diode','Nội dung về các loại mạch diode.','2025-11-03 12:00:00'),(4,3,'Chuyên đề 1: Hóa hữu cơ 1','Nội dung về alkan, anken.','2025-11-04 13:00:00'),(5,4,'Chương 1: Giới thiệu AI','Nội dung về lịch sử AI.','2025-11-05 14:00:00');
/*!40000 ALTER TABLE `outline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject` (
  `Subject_PK` int NOT NULL AUTO_INCREMENT,
  `Subject_name` varchar(255) NOT NULL,
  `FacultyID` int NOT NULL,
  PRIMARY KEY (`Subject_PK`),
  UNIQUE KEY `UK_Subject_Name` (`Subject_name`),
  KEY `FK_Subject_Faculty_idx` (`FacultyID`),
  CONSTRAINT `FK_Subject_Faculty` FOREIGN KEY (`FacultyID`) REFERENCES `faculty` (`FacultyID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject`
--

LOCK TABLES `subject` WRITE;
/*!40000 ALTER TABLE `subject` DISABLE KEYS */;
INSERT INTO `subject` VALUES (1,'Cấu trúc dữ liệu và giải thuật',13),(2,'Nhập môn Trí tuệ nhân tạo',13),(3,'Mạch điện tử',12),(4,'Hóa hữu cơ',14),(5,'Sức bền vật liệu',10);
/*!40000 ALTER TABLE `subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tutor_application`
--

DROP TABLE IF EXISTS `tutor_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tutor_application` (
  `applicationID` varchar(50) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) DEFAULT 'M',
  `Address` varchar(255) NOT NULL,
  `Phone` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `GPA` decimal(3,2) NOT NULL,
  `FacultyID` int NOT NULL,
  `job` varchar(50) NOT NULL,
  `sinh_vien_nam` varchar(50) NOT NULL,
  `status` varchar(255) DEFAULT 'waiting',
  PRIMARY KEY (`FacultyID`,`applicationID`),
  UNIQUE KEY `applicationID` (`applicationID`),
  CONSTRAINT `FK_faculty_application_form` FOREIGN KEY (`FacultyID`) REFERENCES `faculty` (`FacultyID`) ON DELETE CASCADE,
  CONSTRAINT `chk_application_status` CHECK ((`status` in (_utf8mb4'waiting',_utf8mb4'accepted',_utf8mb4'denied'))),
  CONSTRAINT `chk_gpa_scale_application` CHECK (((`GPA` >= 0) and (`GPA` <= 4))),
  CONSTRAINT `CHK_job_check` CHECK ((`job` in (_utf8mb4'nghien_cuu_sinh',_utf8mb4'sinh_vien',_utf8mb4'sinh_vien_sau_dh',_utf8mb4'giang_vien'))),
  CONSTRAINT `CHK_year_check` CHECK ((`sinh_vien_nam` in (_utf8mb4'none',_utf8mb4'nam_2',_utf8mb4'nam_3',_utf8mb4'nam_4')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tutor_application`
--

LOCK TABLES `tutor_application` WRITE;
/*!40000 ALTER TABLE `tutor_application` DISABLE KEYS */;
INSERT INTO `tutor_application` VALUES ('app004','Võ Thị Kim','1998-02-13','F','A4 Bách Khoa','0914444444','vtk@email.com','pass_vtk',4.00,10,'nghien_cuu_sinh','none','waiting'),('app005','Huỳnh Minh Đạt','1997-03-14','M','A5 Bách Khoa','0915555555','hmd@email.com','pass_hmd',4.00,11,'giang_vien','none','waiting'),('app002','Lý Thị Hoa','2000-12-11','F','A2 Bách Khoa','0912222222','lth@email.com','pass_lth',3.00,12,'sinh_vien','nam_4','waiting'),('app001','Nguyễn Hữu Trí','2001-11-10','M','A1 Bách Khoa','0911111111','nht@email.com','pass_nht',3.00,13,'sinh_vien','nam_3','waiting'),('app003','Trần Trung Tín','1999-01-12','M','A3 Bách Khoa','0913333333','ttt@email.com','pass_ttt',4.00,14,'sinh_vien_sau_dh','none','waiting');
/*!40000 ALTER TABLE `tutor_application` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_application_accept` AFTER UPDATE ON `tutor_application` FOR EACH ROW BEGIN
-- Chỉ thực thi khi trạng thái (status) được CẬP NHẬT thành 'accepted'
    -- và trạng thái trước đó (OLD.status) không phải là 'accepted'
    IF NEW.status = 'accepted' AND OLD.status != 'accepted' THEN
    
        -- 1. Thêm bản ghi mới vào bảng `user`
        -- Trigger này giả định rằng `applicationID` sẽ được dùng làm `UserID`
        INSERT INTO `user` (
            `UserID`, 
            `FullName`, 
            `DateOfBirth`, 
            `Gender`, 
            `Phone`, 
            `Email`, 
            `Password`,
            `Role`
        ) 
        VALUES (
            NEW.applicationID,  -- Lấy ID từ đơn đăng ký
            NEW.FullName, 
            NEW.DateOfBirth, 
            NEW.Gender, 
            NEW.Phone, 
            NEW.Email, 
            NEW.Password,
            'mentor'            -- Gán vai trò là 'mentor'
        );
        
        -- 2. Thêm bản ghi mới vào bảng `mentor`
        -- `mentorID` phải khớp với `UserID` vừa được tạo
        INSERT INTO `mentor` (
            `mentorID`, 
            `GPA`, 
            `FacultyID`, 
            `job`, 
            `sinh_vien_nam`
        ) 
        VALUES (
            NEW.applicationID, -- Dùng chung ID với `user.UserID`
            NEW.GPA, 
            NEW.FacultyID, 
            NEW.job, 
            NEW.sinh_vien_nam
        );
        
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tutor_pair`
--

DROP TABLE IF EXISTS `tutor_pair`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tutor_pair` (
  `pairID` int NOT NULL AUTO_INCREMENT,
  `mentorID` varchar(50) NOT NULL,
  `Subject_name` varchar(255) DEFAULT NULL,
  `begin_session` int NOT NULL,
  `end_session` int NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `day` varchar(100) DEFAULT NULL,
  `mentee_capacity` int DEFAULT '15',
  `mentee_current_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`pairID`,`mentorID`),
  UNIQUE KEY `pairID_UNIQUE` (`pairID`),
  KEY `FK_tutor_pair_mentor` (`mentorID`),
  CONSTRAINT `FK_tutor_pair_mentor` FOREIGN KEY (`mentorID`) REFERENCES `mentor` (`mentorID`) ON DELETE CASCADE,
  CONSTRAINT `chk_tutor_pair_day_of_week` CHECK ((`day` in (_utf8mb4'Thứ Hai',_utf8mb4'Thứ Ba',_utf8mb4'Thứ Tư',_utf8mb4'Thứ Năm',_utf8mb4'Thứ Sáu',_utf8mb4'Thứ Bảy',_utf8mb4'CN'))),
  CONSTRAINT `chk_tutor_pair_session_order` CHECK ((`end_session` >= `begin_session`)),
  CONSTRAINT `chk_tutor_pair_session_range` CHECK (((`begin_session` >= 1) and (`begin_session` <= 15) and (`end_session` >= 1) and (`end_session` <= 15)))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tutor_pair`
--

LOCK TABLES `tutor_pair` WRITE;
/*!40000 ALTER TABLE `tutor_pair` DISABLE KEYS */;
INSERT INTO `tutor_pair` VALUES (1,'mentor001','Cấu trúc dữ liệu và giải thuật',1,3,'H1-201','Thứ Hai',15,2),(2,'mentor002','Mạch điện tử',4,6,'H2-302','Thứ Ba',15,1),(3,'mentor003','Hóa hữu cơ',7,9,'H3-403','Thứ Tư',15,1),(4,'mentor004','Nhập môn Trí tuệ nhân tạo',10,12,'H1-201','Thứ Năm',15,1),(5,'mentor005','Sức bền vật liệu',13,15,'H4-504','Thứ Sáu',15,0);
/*!40000 ALTER TABLE `tutor_pair` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `UserID` varchar(50) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) DEFAULT 'M',
  `Phone` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` varchar(50) DEFAULT 'mentee',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `Password` (`Password`),
  UNIQUE KEY `UserID_UNIQUE` (`UserID`),
  CONSTRAINT `CHK_User_gender` CHECK ((`Gender` in (_utf8mb4'M',_utf8mb4'F'))),
  CONSTRAINT `CHK_User_Role` CHECK ((`Role` in (_utf8mb4'admin',_utf8mb4'mentee',_utf8mb4'mentor')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
-- SELECT * FROM user
--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('2110001','Nguyễn Văn A','2003-01-15','M','0901111111','nva@hcmut.edu.vn','pass_nva','mentee'),('2110002','Trần Thị B','2003-02-20','F','0902222222','ttb@hcmut.edu.vn','pass_ttb','mentee'),('2110003','Lê Văn C','2003-03-25','M','0903333333','lvc@hcmut.edu.vn','pass_lvc','mentee'),('2110004','Phạm Thị D','2003-04-30','F','0904444444','ptd@hcmut.edu.vn','pass_ptd','mentee'),('2110005','Hoàng Văn E','2003-05-05','M','0905555555','hve@hcmut.edu.vn','pass_hve','mentee'),
('admin001','Admin Quản Trị 1','1990-01-01','M','0801111111','admin1@hcmut.edu.vn','pass_admin1','admin'),('admin002','Admin Quản Trị 2','1991-02-02','F','0802222222','admin2@hcmut.edu.vn','pass_admin2','admin'),('admin003','Admin Quản Trị 3','1992-03-03','M','0803333333','admin3@hcmut.edu.vn','pass_admin3','admin'),('admin004','Admin Quản Trị 4','1993-04-04','F','0804444444','admin4@hcmut.edu.vn','pass_admin4','admin'),('admin005','Admin Quản Trị 5','1994-05-05','M','0805555555','admin5@hcmut.edu.vn','pass_admin5','admin'),('mentor001','Trần Hoài Nam','1998-06-10','M','0701111111','thn@hcmut.edu.vn','pass_thn','mentor'),('mentor002','Lê Thị Thu Thủy','1999-07-15','F','0702222222','lttt@hcmut.edu.vn','pass_lttt','mentor'),('mentor003','Đặng Văn Kiên','1997-08-20','M','0703333333','dvk@hcmut.edu.vn','pass_dvk','mentor'),('mentor004','Bùi Thị Lan','2000-09-25','F','0704444444','btl@hcmut.edu.vn','pass_btl','mentor'),('mentor005','Vũ Đức Long','1996-10-30','M','0705555555','vdl@hcmut.edu.vn','pass_vdl','mentor');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
-- /*!50003 SET @saved_cs_client      = @@character_set_client */ ;
-- /*!50003 SET @saved_cs_results     = @@character_set_results */ ;
-- /*!50003 SET @saved_col_connection = @@collation_connection */ ;
-- /*!50003 SET character_set_client  = utf8mb4 */ ;
-- /*!50003 SET character_set_results = utf8mb4 */ ;
-- /*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
-- /*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
-- /*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;
/*!50003 CREATE*/ /*!50017 DEFINER=`trong`@`localhost`*/ /*!50003 TRIGGER `user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW BEGIN
	IF NEW.Role = 'admin' THEN
        -- Thêm UserID vào bảng admin
        INSERT INTO `admin` (adminID) VALUES (NEW.UserID);
	ELSEIF NEW.Role = 'mentee' THEN
        -- Thêm UserID vào bảng mentee
        INSERT INTO `mentee` (menteeID) VALUES (NEW.UserID);
	END IF;
END */;;
DELIMITER ;

-- 
-- /*!50003 SET sql_mode              = @saved_sql_mode */ ;
-- /*!50003 SET character_set_client  = @saved_cs_client */ ;
-- /*!50003 SET character_set_results = @saved_cs_results */ ;
-- /*!50003 SET collation_connection  = @saved_col_connection */ ;
-- /*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

-- /*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
-- /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
-- /*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
-- /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
-- /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
-- /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- /*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-04  0:16:50

DROP TABLE IF EXISTS `user`;
SHOW TRIGGERS IN my_fullstack_db
DROP TRIGGER IF EXISTS after_insert_user;