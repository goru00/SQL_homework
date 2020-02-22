DROP DATABASE work_2;
CREATE DATABASE work_2;
/* -1-2- */
USE work_2;
DROP TABLE IF EXISTS `Поездки`;
DROP TABLE IF EXISTS `Поездки1`;
DROP TABLE IF EXISTS `Водители`;
DROP TABLE IF EXISTS `Марки автомобилей`;
CREATE TABLE `Марки автомобилей` (
	`Модель автомобиля` CHAR(35) NOT NULL,
	`Минуты простоя` INT NOT NULL,
	`Километра проезда` INT NOT NULL,
	PRIMARY KEY(`Модель автомобиля`)
) ENGINE=InnoDB;
CREATE TABLE `Водители` (
	`Гос.номер` VARCHAR(12) NOT NULL,
	`ФИО Водителя` VARCHAR(36) NOT NULL,
	`Телефон` CHAR(16) NOT NULL,
	`Модель автомобиля` CHAR(35) NOT NULL,
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
	FOREIGN KEY(`Гос.номер`) 
	REFERENCES `Водители`(`Гос.номер`) 
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
CREATE TABLE `Поездки1` (
	`Гос.номер` VARCHAR(12) NOT NULL,
	`Дата` DATE NOT NULL,
	`Время вызова` TIME NOT NULL,
	`Время завершения` TIME NOT NULL,
	`Время ожидания у клиента` INT NOT NULL,
	`Расстояние` INT NOT NULL,
	FOREIGN KEY(`Гос.номер`) 
	REFERENCES `Водители`(`Гос.номер`) 
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
/* -3- */
INSERT INTO `Марки автомобилей` 
	(`Модель автомобиля`, `Минуты простоя`, `километра проезда`)
	VALUES
	('Kia Rio', 5, 20),
	('Toyota Camry', 8, 30),
	('Ford Focus', 5, 20);
INSERT INTO `Водители`
	(`Гос.номер`, `ФИО водителя`, `Телефон`, `Модель автомобиля`)
	VALUES
	('C734XK750', 'Иванов Петр Васильевич', '908-891-78-92', 'Kia Rio'), 
	('C865MP750', 'Петров Андрей Иванович', '928-742-87-34', 'Kia Rio'),
	('M777KM777', 'Бендер Остап Ибрагомович', '916-758-34-90', 'Toyota Camry'),
	('C654PP7150', 'Фролов Виктор Валерьевич', '967-456-12-18', 'Ford Focus');
INSERT INTO `Поездки`
	(`Гос.номер`, `Дата`, `Время вызова`, `Время завершения`, `Время ожидания у клиента`, `Расстояние`)
	VALUES
	('C734XK750', '2020.02.02', '12:20:00', '13:10:00', 2, 90),
	('C734XK750', '2020.02.02', '14:45:00', '15:50:00', 5, 50),
	('M777KM777', '2020.02.03', '18:30:00', '20:20:00', 5, 70),
	('C865MP750', '2020.02.02', '10:00:00', '10:20:00', 2, 30);
INSERT INTO `Поездки1`
	(`Гос.номер`, `Дата`, `Время вызова`, `Время завершения`, `Время ожидания у клиента`, `Расстояние`)
	VALUES
	('C865MP750', '2020.02.02', '12:20:00', '13:45:00', 5, 80),
	('C865MP750', '2020.02.03', '10:30:00', '11:45:00', 10, 45),
	('C865MP750', '2020.02.03', '23:40:00', '01:10:00', 12, 88);
/* -4- */
INSERT INTO `Поездки` 
	SELECT * FROM `Поездки1`;
SELECT * FROM `Поездки`;
/* -5- */ 
UPDATE `Марки автомобилей` 
SET `Километра проезда`=`Километра проезда` * 1.1;
/* -6- */
START TRANSACTION;
DELETE FROM `Поездки` WHERE `Гос.номер`='M777KM777';
DELETE FROM `Поездки1` WHERE `Гос.номер`='M777KM777';
DELETE FROM `Водители` WHERE `Гос.номер`='M777KM777';
COMMIT;
/* -7- */
DROP TABLE IF EXISTS `Поездки1`;
/* -8- */
SELECT `Поездки`.`Гос.номер`, `Дата`, `Время вызова` 
FROM `Поездки`
WHERE `Расстояние`
BETWEEN 50 AND 80;
/* -9- */
SET @INDEX='C865MP750';
SELECT `Водители`.`Гос.номер`, 
	`Водители`.`ФИО водителя`, 
	`Водители`.`Модель автомобиля`, 
	`Марки автомобилей`.`Километра проезда`, /* Стоимость */
	`Поездки`.`Дата`, 
	`Поездки`.`Время вызова`,
	`Поездки`.`Расстояние`
FROM `Водители` 
INNER JOIN `Марки автомобилей` 
ON `Марки автомобилей`.`Модель автомобиля`=`Водители`.`Модель автомобиля`)
INNER JOIN `Поездки` 
ON `Поездки`.`Гос.номер`=`Водители`.`Гос.номер`
WHERE `Водители`.`Гос.номер`=@INDEX;
/* -10- */
SELECT `Гос.номер`, `ФИО водителя`, `Модель автомобиля`
FROM `Водители`
WHERE NOT EXISTS
(SELECT * FROM `Поездки` 
WHERE `Водители`.`Гос.номер`=`Гос.номер`); 
/* -11- */
SELECT `Поездки`.`Гос.номер`, 
	`Водители`.`ФИО водителя`, 
	`Поездки`.`Дата`, 
	COUNT(*) AS `Количество поездок`
FROM `Поездки` 
INNER JOIN `Водители` 
ON `Водители`.`Гос.номер`=`Поездки`.`Гос.номер` 
GROUP BY 1,3 HAVING COUNT(*)>=2;
/* -12- */
SELECT AVG(`Расстояние`) AS `Среднее расстояние`, 
	(SELECT SUM(`Километра проезда` * `Расстояние`)
FROM `Марки автомобилей`) AS `Суммарная стоимость`
FROM `Поездки`;
/* -13- */
SELECT `Марки автомобилей`.`Модель автомобиля`,
	COUNT(DISTINCT `Поездки`.`Гос.номер`) AS `Количество автомобилей`,
	SUM(`Время ожидания у клиента` * `Минуты простоя` + `Километра проезда` * `Расстояние`) AS `Суммарная выручка`
FROM `Марки автомобилей`
INNER JOIN `Водители` 
ON `Водители`.`Модель автомобиля`=`Марки автомобилей`.`Модель автомобиля`
LEFT JOIN `Поездки`
ON `Поездки`.`Гос.номер`=`Водители`.`Гос.номер`
GROUP BY `Марки автомобилей`.`Модель автомобиля`
ORDER BY `Суммарная выручка`;
/* -14- */
SELECT `Поездки`.`Гос.номер`, 
	`Водители`.`ФИО водителя`, 
	`Водители`.`Модель автомобиля`,
	`Поездки`.`Дата`,
	MAX(`Время ожидания у клиента` * `Минуты простоя` + `Километра проезда` * `Расстояние`) AS `Суммарная выручка`
FROM `Марки автомобилей`
INNER JOIN `Водители`
ON `Водители`.`Модель автомобиля`=`Марки автомобилей`.`Модель автомобиля`
LEFT JOIN `Поездки`
ON `Поездки`.`Гос.номер`=`Водители`.`Гос.номер`
GROUP BY `Поездки`.`Гос.номер`, `Дата`;