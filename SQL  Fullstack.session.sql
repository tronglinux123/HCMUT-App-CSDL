CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'mentor', 'mentee') NOT NULL DEFAULT 'mentee',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE mentor_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    apply_email VARCHAR(100) NOT NULL UNIQUE,
    aplly_job VARCHAR(100) NOT NULL,
    specialized VARCHAR(100) NOT NULL,
    yearstudy VARCHAR(100) NOT NULL,
    gpa DECIMAL(3,2),
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);




SELECT * FROM mentor_applications

-- DROP TABLE mentor_applications

DELETE FROM mentor_applications WHERE id = 23

DELETE FROM users;







--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `adminID` varchar(50) NOT NULL,
  PRIMARY KEY (`adminID`),
  UNIQUE KEY `admminID_UNIQUE` (`adminID`),
  CONSTRAINT `FK_Admin_User` FOREIGN KEY (`adminID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * FROM admin
--
-- Table structure for table `enroll`
--

DROP TABLE IF EXISTS `enroll`;
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

CREATE TRIGGER `trg_check_subject_faculty_on_insert` BEFORE INSERT ON `enroll` FOR EACH ROW BEGIN
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
END;

CREATE TRIGGER `trg_check_subject_faculty_on_update` BEFORE UPDATE ON `enroll` FOR EACH ROW BEGIN
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
END;

CREATE TRIGGER `trg_process_enroll_status` AFTER UPDATE ON `enroll` FOR EACH ROW BEGIN
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
END;

SELECT * FROM enroll


--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
CREATE TABLE `faculty` (
  `FacultyID` int NOT NULL,
  `Faculty_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`FacultyID`),
  UNIQUE KEY `FacultyID_UNIQUE` (`FacultyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM faculty

--
-- Table structure for table `feedback_system`
--

DROP TABLE IF EXISTS `feedback_system`;
CREATE TABLE `feedback_system` (
  `menteeID` varchar(50) NOT NULL,
  `date_submit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `context` text,
  PRIMARY KEY (`menteeID`),
  KEY `FK_mentee_feedback_system` (`menteeID`),
  CONSTRAINT `FK_mentee_feedback_system` FOREIGN KEY (`menteeID`) REFERENCES `mentee` (`menteeID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM feedback_system


--
-- Table structure for table `feedback_tutor`
--

DROP TABLE IF EXISTS `feedback_tutor`;
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

SELECT * FROM feedback_tutor


--
-- Table structure for table `mentee`
--

DROP TABLE IF EXISTS `mentee`;
CREATE TABLE `mentee` (
  `menteeID` varchar(50) NOT NULL,
  PRIMARY KEY (`menteeID`),
  UNIQUE KEY `menteeID_UNIQUE` (`menteeID`),
  CONSTRAINT `FK_Mentee_User` FOREIGN KEY (`menteeID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM mentee

--
-- Table structure for table `mentee_list`
--

DROP TABLE IF EXISTS `mentee_list`;
CREATE TABLE `mentee_list` (
  `pairID` int NOT NULL,
  `menteeID` varchar(50) NOT NULL,
  PRIMARY KEY (`pairID`,`menteeID`),
  KEY `FK_mentee_list_mentee` (`menteeID`),
  CONSTRAINT `FK_mentee_list_mentee` FOREIGN KEY (`menteeID`) REFERENCES `mentee` (`menteeID`) ON DELETE CASCADE,
  CONSTRAINT `FK_mentee_list_pair` FOREIGN KEY (`pairID`) REFERENCES `tutor_pair` (`pairID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER `trg_check_mentee_capacity` BEFORE INSERT ON `mentee_list` FOR EACH ROW BEGIN
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
END;

CREATE TRIGGER `trg_update_mentee_count_on_insert` AFTER INSERT ON `mentee_list` FOR EACH ROW BEGIN
    UPDATE `tutor_pair`
    SET `mentee_current_count` = `mentee_current_count` + 1
    WHERE `pairID` = NEW.pairID;
END;

CREATE TRIGGER `trg_update_mentee_count_on_delete` AFTER DELETE ON `mentee_list` FOR EACH ROW BEGIN
    UPDATE `tutor_pair`
    SET `mentee_current_count` = `mentee_current_count` - 1
    WHERE `pairID` = OLD.pairID;
END;

SELECT * FROM mentee_list


--
-- Table structure for table `mentor`
--

DROP TABLE IF EXISTS `mentor`;
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

SELECT * FROM mentor


--
-- Table structure for table `outline`
--

DROP TABLE IF EXISTS `outline`;
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

SELECT * FROM outline

--
-- Table structure for table `subject`
--

DROP TABLE IF EXISTS `subject`;
CREATE TABLE `subject` (
  `Subject_PK` int NOT NULL AUTO_INCREMENT,
  `Subject_name` varchar(255) NOT NULL,
  `FacultyID` int NOT NULL,
  PRIMARY KEY (`Subject_PK`),
  UNIQUE KEY `UK_Subject_Name` (`Subject_name`),
  KEY `FK_Subject_Faculty_idx` (`FacultyID`),
  CONSTRAINT `FK_Subject_Faculty` FOREIGN KEY (`FacultyID`) REFERENCES `faculty` (`FacultyID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM subject


--
-- Table structure for table `tutor_application`
--

DROP TABLE IF EXISTS `tutor_application`;
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

CREATE TRIGGER `trg_after_application_accept` AFTER UPDATE ON `tutor_application` FOR EACH ROW BEGIN
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
END;

SELECT * FROM tutor_application


--
-- Table structure for table `tutor_pair`
--

DROP TABLE IF EXISTS `tutor_pair`;
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

SELECT * FROM tutor_pair


--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
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
  UNIQUE KEY `UserID_UNIQUE` (`UserID`),
  CONSTRAINT `CHK_User_gender` CHECK ((`Gender` in (_utf8mb4'M',_utf8mb4'F'))),
  CONSTRAINT `CHK_User_Role` CHECK ((`Role` in (_utf8mb4'admin',_utf8mb4'mentee',_utf8mb4'mentor')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TRIGGER IF EXISTS user_AFTER_INSERT;

CREATE TRIGGER user_AFTER_INSERT AFTER INSERT ON `user` FOR EACH ROW BEGIN
  IF NEW.Role = 'admin' THEN
      INSERT INTO admin (adminID) VALUES (NEW.UserID);
  ELSEIF NEW.Role = 'mentee' THEN
      INSERT INTO mentee (menteeID) VALUES (NEW.UserID);
  END IF;
END;

SELECT * FROM user

SHOW TRIGGERS IN my_fullstack_db

SHOW TABLES IN my_fullstack_db

DELETE FROM user;

INSERT INTO user (UserID, FullName, DateOfBirth, Gender, Phone, Email, Password, Role)
VALUES (
    'admin001',
    'Admin Quản Trị 1',
    '1990-01-01',
    'M',
    '0801111111',
    'admin1@hcmut.edu.vn',
    '$2b$10$sXTZE1aVfMyndf7ePHzroemNL4YlqmK8ig5TBsNPDofw9uyi/t.Li',
    'admin'
)

INSERT INTO user (UserID, FullName, DateOfBirth, Gender, Phone, Email, Password, Role)
VALUES (
    'a',
    'Admin Quản Trị 1',
    '1990-01-01',
    'M',
    '0801111111',
    'mentor@hcmut.edu.vn',
    '$2b$10$sXTZE1aVfMyndf7ePHzroemNL4YlqmK8ig5TBsNPDofw9uyi/t.Li',
    'mentor'
)
