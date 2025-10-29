CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'mentor', 'mentee') NOT NULL DEFAULT 'mentee',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email, password_hash, role)
VALUES (
    'Admin_1',
    'admin1@trong.com',
    '$2b$10$sXTZE1aVfMyndf7ePHzroemNL4YlqmK8ig5TBsNPDofw9uyi/t.Li',
    'admin'
)

CREATE TABLE mentor_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    apply_email VARCHAR(100) NOT NULL UNIQUE,
    aplly_job VARCHAR(100) NOT NULL,
    specialized VARCHAR(100) NOT NULL,
    yearstudy VARCHAR(100) NOT NULL,
    gpa DECIMAL(3,2),
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);









SELECT * FROM users

SELECT * FROM mentor_applications

-- DROP TABLE mentor_applications

DELETE FROM mentor_applications WHERE id = 23

DELETE FROM users;