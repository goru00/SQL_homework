DROP DATABASE WORK_3;
CREATE DATABASE WORK_3;
USE WORK_3;

DROP TABLE IF EXISTS `Поездки`;
DROP TABLE IF EXISTS `Водители`;
DROP TABLE IF EXISTS `Марки автомобилей`;
DROP TRIGGER IF EXISTS `updateTrack`;
DROP TRIGGER IF EXISTS `deleteTrack`;
DROP TRIGGER IF EXISTS `insertTrack`;
DROP PROCEDURE IF EXISTS `setCursor`;
DROP PROCEDURE IF EXISTS `setSummary`;
DROP FUNCTION IF EXISTS `getSummary`;
/* -1- */
CREATE TABLE `Марки автомобилей` (
	`Модель автомобиля` CHAR(35) NOT NULL,
	`Минуты простоя` INT NOT NULL,
	`Километра проезда` INT NOT NULL,
	PRIMARY KEY(`Модель автомобиля`)
) ENGINE=InnoDB;

CREATE TABLE `Водители` (
	`Гос.номер` VARCHAR(12) NOT NULL,
	`ФИО водителя` VARCHAR(36) NOT NULL,
	`Телефон` CHAR(16) NOT NULL,
	`Модель автомобиля` CHAR(35) NOT NULL,
	`Итоговая выручка` INT NOT NULL,
	PRIMARY KEY(`Гос.номер`),
	FOREIGN KEY(`Модель автомобиля`) 
	REFERENCES `Марки автомобилей`(`Модель автомобиля`)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Поездки` (
	`Гос.номер` VARCHAR(12) NOT NULL,
	`Дата` DATE NOT NULL,
	`Время вызова` TIME NOT NULL,
	`Время завершения` TIME NOT NULL,
	`Время ожидания у клиента` INT NOT NULL,
	`Расстояние` INT NOT NULL,
	PRIMARY KEY(`Гос.номер`, `Дата`, `Время вызова`),
	FOREIGN KEY(`Гос.номер`) 
	REFERENCES `Водители`(`Гос.номер`) 
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `Марки автомобилей` 
	(`Модель автомобиля`, `Минуты простоя`, `километра проезда`)
	VALUES
	('Kia Rio', 5, 20),
	('Toyota Camry', 8, 30);
INSERT INTO `Водители`
	(`Гос.номер`, `ФИО водителя`, `Телефон`, `Модель автомобиля`, `Итоговая выручка`)
	VALUES
	('C734XK750', 'Иванов Петр Васильевич', '908-891-78-92', 'Kia Rio', 0), 
	('C865MP750', 'Петров Андрей Иванович', '928-742-87-34', 'Kia Rio', 0),
	('M777KM777', 'Бендер Остап Ибрагомович', '916-758-34-90', 'Toyota Camry', 0);
INSERT INTO `Поездки`
	(`Гос.номер`, `Дата`, `Время вызова`, `Время завершения`, `Время ожидания у клиента`, `Расстояние`)
	VALUES
	('C734XK750', '2020.02.02', '12:20', '13:10', 2, 90),
	('C734XK750', '2020.02.02', '14:45', '15:50', 5, 50),
	('M777KM777', '2020.02.03', '18:30', '20:20', 5, 70),
	('C865MP750', '2020.02.02', '10:00', '10:20', 2, 30),
	('C865MP750', '2020.02.02', '12:20', '13:45', 5, 80),
	('C865MP750', '2020.02.03', '10:30', '11:45', 10, 45),
	('C865MP750', '2020.02.03', '23:40', '01:10', 12, 88);	

/* -2- */
DELIMITER $$
CREATE FUNCTION getSummary(car_number VARCHAR(12)) 
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE SUMMARY INT DEFAULT 0;
	/* мы суммируем сущности из разных таблиц */
	/* то есть "Марки автомобилей содержат "минуты простоя" и "километры проезда" */
	/* а "Поездки" содержат "Время ожидания у клиента" и "Расстояние" */
	/* поэтому я связываю таблицы "Поездки" и "Водители" с "Марки автомобилей" */
	SELECT SUM(`Время ожидания у клиента` * `Минуты простоя` + `Километра проезда` * `Расстояние`) AS `Суммарная выручка`
	INTO SUMMARY
	FROM `Марки автомобилей`
	INNER JOIN `Водители` 
	ON `Водители`.`Модель автомобиля`=`Марки автомобилей`.`Модель автомобиля`
	LEFT JOIN `Поездки`
	ON `Поездки`.`Гос.номер`=`Водители`.`Гос.номер`
	WHERE `Водители`.`Гос.номер`= car_number
	GROUP BY `Водители`.`Гос.номер`;
	RETURN IFNULL(SUMMARY, 0);
END$$
DELIMITER ;

SELECT * FROM `Поездки`;
SELECT getSummary('C734XK750') AS `Суммарная выручка`;

/* -3- */
/* если водитель не выйдет на линию, то его "Итоговая выручка" будет равна 0 */
DELIMITER $$
CREATE PROCEDURE setSummary()
BEGIN
	UPDATE `Водители` SET `Итоговая выручка` = getSummary(`Гос.номер`);
END$$
DELIMITER ;

CALL setSummary();
SELECT * FROM `Водители`;

/* -4-5- */
DELIMITER $$
CREATE PROCEDURE `setCursor`()
BEGIN
	DECLARE car_number VARCHAR(12);
	DECLARE SUMMARY, base INT DEFAULT 0;
	/* здесь тоже самое что и при реализации функции */
	DECLARE cursor1 CURSOR FOR SELECT `Водители`.`Гос.номер`,
		SUM(`Время ожидания у клиента` * `Минуты простоя` + `Километра проезда` * `Расстояние`) AS `Суммарная выручка`
	FROM `Марки автомобилей`
	INNER JOIN `Водители` 
	ON `Водители`.`Модель автомобиля` = `Марки автомобилей`.`Модель автомобиля`
	INNER JOIN `Поездки`
	ON `Поездки`.`Гос.номер` = `Водители`.`Гос.номер`
	GROUP BY `Водители`.`Гос.номер`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET base = 1;
	UPDATE `Водители` 
	SET `Итоговая выручка` = 0;
	OPEN cursor1;
	WHILE base = 0 DO
		FETCH cursor1 INTO car_number, SUMMARY;
		UPDATE `Водители` SET `Итоговая выручка` = SUMMARY
		WHERE `Гос.номер` = car_number;
	END WHILE;
	CLOSE cursor1;
END$$  
DELIMITER ;

CALL setCursor();
SELECT * FROM `Водители`;

DELIMITER $$
CREATE TRIGGER `deleteTrack` 
AFTER DELETE ON `Поездки` FOR EACH ROW
BEGIN
	UPDATE `Водители` 
	SET `Итоговая выручка` = getSummary(`Гос.номер`)
	WHERE `Гос.номер` = OLD.`Гос.номер`;
END$$
DELIMITER ;

DELETE FROM `Поездки` WHERE `Гос.номер` = 'C734XK750'
AND `Дата` = '2020.02.02'
AND `Время вызова` = '12:20';
SELECT * FROM `Поездки`;
SELECT * FROM `Водители`;

/* -6- */
DELIMITER $$
CREATE TRIGGER `insertTrack`
AFTER INSERT ON `Поездки` FOR EACH ROW
BEGIN 
	UPDATE `Водители` 
	SET `Итоговая выручка` = getSummary(`Гос.номер`)
	WHERE `Гос.номер` = NEW.`Гос.номер`;
END$$
DELIMITER ;

INSERT INTO `Поездки`
	(`Гос.номер`, `Дата`, `Время вызова`, `Время завершения`, `Время ожидания у клиента`, `Расстояние`)
	VALUES
	('M777KM777', '2020.02.03', '18:35', '20:25', 6, 75);
SELECT * FROM `Поездки`;
SELECT * FROM `Водители`;

/* -7- */
DELIMITER $$
CREATE TRIGGER `updateTrack`
AFTER UPDATE ON `Поездки` FOR EACH ROW
BEGIN
	if OLD.`Гос.номер` != NEW.`Гос.номер` THEN
		UPDATE `Водители` SET `Итоговая выручка` = getSummary(`Гос.номер`)
		WHERE `Гос.номер` = OLD.`Гос.номер`;
	END IF;
		UPDATE `Водители` SET `Итоговая выручка` = getSummary(`Гос.номер`)
		WHERE `Гос.номер` = NEW.`Гос.номер`;
END$$
DELIMITER ;

UPDATE `Поездки`
SET `Время ожидания у клиента` = 5, `Расстояние` = 45
WHERE `Гос.номер` = 'C734XK750' AND `Дата` = '2020.02.02'
AND `Время вызова` = '12:20';
SELECT * FROM `Поездки`;
SELECT * FROM `Водители`;

/* -8- */
DROP USER 'administrator'@'localhost';
DROP USER 'director'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'director'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'worker'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'visitor'@'localhost';

/* -9- */
GRANT ALL PRIVILEGES ON `WORK_3`.* 
TO 'administrator'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;

/* -10- */
GRANT ALL PRIVILEGES ON `WORK_3`.* 
TO 'director'@'localhost';
REVOKE CREATE, ALTER, DROP ON `WORK_3`.* 
FROM 'director'@'localhost';

FLUSH PRIVILEGES;

/* -11- */
GRANT INSERT, SELECT ON `WORK_3`.`Марки автомобилей` 
TO 'worker'@'localhost';
GRANT UPDATE(`Модель автомобиля`) ON `WORK_3`.`Марки автомобилей` 
TO 'worker'@'localhost';
GRANT INSERT, SELECT ON `WORK_3`.`Водители` 
TO 'worker'@'localhost';
GRANT UPDATE(`Время ожидания у клиента`, `Расстояние`), INSERT, SELECT ON `WORK_3`.`Поездки` 
TO 'worker'@'localhost';

FLUSH PRIVILEGES;

/* -12- */
DROP VIEW IF EXISTS `Просмотр`;
CREATE VIEW `Просмотр` AS
SELECT `Водители`.`Модель автомобиля`, 
	`Водители`.`Гос.номер`,
	`Водители`.`ФИО водителя`,
	`Поездки`.`Дата`,
	`Поездки`.`Время вызова`
FROM `Водители`
INNER JOIN `Поездки`
ON `Поездки`.`Гос.номер`=`Водители`.`Гос.номер`;
/* -13- */
GRANT SELECT ON `WORK_3`.`Просмотр` TO
'visitor'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'director'@'localhost';
SHOW GRANTS FOR 'worker'@'localhost';
SHOW GRANTS FOR 'visitor'@'localhost';