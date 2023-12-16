CREATE DATABASE IF NOT EXISTS study_organisation;

USE `study_organisation`;


DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `admission_year` INT(4) UNSIGNED NOT NULL CHECK(`admission_year` >= 2000),
  `graduation_year` INT(4) UNSIGNED NOT NULL CHECK(`admission_year` >= 2000 AND `admission_year` <= `graduation_year`),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`admission_year`,`graduation_year`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `marks`;

CREATE TABLE `marks` (
  `study` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `student` INT(11) UNSIGNED NOT NULL,
  `mark` INT(1) UNSIGNED NOT NULL CHECK(`mark` >= 1 AND `mark` <= 5),
  PRIMARY KEY (`study`,`student`),
  KEY `student_key` (`student`),
  CONSTRAINT `student_key` FOREIGN KEY (`student`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `study_key` FOREIGN KEY (`study`) REFERENCES `study` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `students`;

CREATE TABLE `students` (
  `group` INT(11) UNSIGNED NOT NULL,
  `user` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`group`,`user`),
  KEY `student` (`user`),
  CONSTRAINT `group` FOREIGN KEY (`group`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `student` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `study`;

CREATE TABLE `study` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `teacher_id` INT(11) UNSIGNED NOT NULL,
  `group_id` INT(11) UNSIGNED NOT NULL,
  `subject_id` INT(11) UNSIGNED NOT NULL,
  `year` INT(4) UNSIGNED NOT NULL CHECK(`year` >= 2000),
  PRIMARY KEY (`id`),
  UNIQUE KEY `study` (`teacher_id`,`group_id`,`subject_id`,`year`),
  KEY `group_key` (`group_id`),
  KEY `subject_key` (`subject_id`),
  CONSTRAINT `group_key` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `subject_key` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `teacher_key` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `subjects`;

CREATE TABLE `subjects` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `type` ENUM('математический','гуманитарный') NOT NULL DEFAULT 'математический',
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fio` VARCHAR(255) NOT NULL,
  `birth_date` DATE NOT NULL CHECK(`birth_date` >= '01-01-1900'),
  `email` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(11) DEFAULT NULL,
  `sex` ENUM('м','ж') NOT NULL DEFAULT 'м',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
