DROP DATABASE work_2;
CREATE DATABASE work_2;

SET foreign_key_checks = 0;

USE work_1;
DROP TABLE IF EXISTS `Марки автомобилей`;
DROP TABLE IF EXISTS `Водители`;
DROP TABLE IF EXISTS `Поездки`;
DROP TABLE IF EXISTS `Поездки1`;
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
	`Модель автомобиля` VARCHAR(35) NOT NULL,
	PRIMARY KEY(`Гос.номер`),
	FOREIGN KEY(`Модель автомобиля`) 
	REFERENCES `Марки автомобилей`(`Модель автомобиля`)
	ON DELETE NO ACTION ON UPDATE CASCADE
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
	ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;
CREATE TABLE `Поездки1` (
	`Гос.номер` VARCHAR(12) NOT NULL,
	`Дата` DATE NOT NULL,
	`Время вызова` TIME NOT NULL,
	`Время завершения` TIME NOT NULL,
	`Время ожидания у клиента` INT NOT NULL,
	`Расстояние` INT NOT NULL,
	FOREIGN KEY(`Гос.номер`) 
	REFERENCES `Поездки`(`Гос.номер`) 
	ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;
/* -1- */
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
	('C734XK750', '2020.02.02', '122000', '131000', 2, 90),
	('C734XK750', '2020.02.02', '144500', '155000', 5, 50),
	('M777KM777', '2020.02.03', '183000', '202000', 5, 70),
	('C865MP750', '2020.02.02', '100000', '102000', 2, 30);
INSERT INTO `Поездки1`
	(`Гос.номер`, `Дата`, `Время вызова`, `Время завершения`, `Время ожидания у клиента`, `Расстояние`)
	VALUES
	('C865MP750', '2020.02.02', '122000', '134500', 5, 80),
	('C865MP750', '2020.02.03', '103000', '114500', 10, 45),
	('C865MP750', '2020.02.03', '234000', '011000', 12, 88);
/* -2- */
INSERT INTO `Поездки` 
	(`Гос.номер`, `Дата`, `Время вызова`, `Время завершения`, `Время ожидания у клиента`, `Расстояние`)
	SELECT * FROM `Поездки1` GROUP BY 1,2;
/* -3- */
/* -4- */ 
UPDATE `Марки автомобилей` SET `Километра проезда`=`Километра проезда` + `Километра проезда` * 0.1;
/* -5- */
/* -6- */
DROP TABLE `Поездки1` IF EXISTS;
/* -7- */
SELECT `Гос.номер`, `Дата`, `Время вызова` 
FROM `Поездки` 
WHERE `Расстояние`  
BETWEEN 50 AND 80;
/* -8- */
