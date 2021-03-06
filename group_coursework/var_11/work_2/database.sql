DROP DATABASE VAR11;
CREATE DATABASE VAR11;
/* -1-2- */
USE VAR11;
DROP TABLE IF EXISTS `Расписание занятий`;
DROP TABLE IF EXISTS `Расписание занятий1`;
DROP TABLE IF EXISTS `Преподаватели`;
DROP TABLE IF EXISTS `Дисциплины`;
CREATE TABLE `Дисциплины` (
	`Код дисциплины` INT NOT NULL,
	`Название дисциплины` VARCHAR(25) NOT NULL,
	`Лекции` INT NOT NULL,
	`Семинары` INT NOT NULL,
	`Итоговый контроль` VARCHAR(20),
	PRIMARY KEY(`Код дисциплины`)
) ENGINE=InnoDB;
CREATE TABLE `Преподаватели` (
	`Табельный номер` INT NOT NULL,
	`Фамилия, имя и отчество` VARCHAR(40) NOT NULL,
	`Должность` VARCHAR(36),
	PRIMARY KEY(`Табельный номер`)
) ENGINE=InnoDB;
CREATE TABLE `Расписание занятий` (
	`Номер группы` CHAR(16) NOT NULL,
	`Дата` DATE NOT NULL,
	`№ пары` INT NOT NULL,
	`Табельный номер` INT NOT NULL,
	`Код дисциплины` INT NOT NULL,
	FOREIGN KEY(`Табельный номер`)
	REFERENCES `Преподаватели`(`Табельный номер`)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(`Код дисциплины`)
	REFERENCES `Дисциплины`(`Код дисциплины`)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB; 
CREATE TABLE `Расписание занятий1` (
	`Номер группы` CHAR(16) NOT NULL,
	`Дата` DATE NOT NULL,
	`№ пары` INT NOT NULL,
	`Табельный номер` INT NOT NULL,
	`Код дисциплины` INT NOT NULL,
	FOREIGN KEY(`Табельный номер`)
	REFERENCES `Преподаватели`(`Табельный номер`)
	ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY(`Код дисциплины`)
	REFERENCES `Дисциплины`(`Код дисциплины`)
	ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
/* -3- */
INSERT INTO `Дисциплины`
	(`Код дисциплины`,`Название дисциплины`,`Лекции`,`Семинары`,`Итоговый контроль`)
	VALUES
	(101,'Математика',68,68,'Зачет'),
	(102,'Математика',68,102,'Экзамен'),
	(121,'Информатика',34,102,'Экзамен'),
	(221,'Иностранный язык',0,144,'Зачет'),
	(222,'Иностранный язык',0,144,'Зачет с оценкой'),
	(322,'Экономика предриятий',68,34,'Зачет');
INSERT INTO `Преподаватели`
	(`Табельный номер`,`Фамилия, имя и отчество`,`Должность`)
	VALUES
	(1001,'Иванов Сергей Степанович','доцент'),
	(1002,'Степанов Василий Ильич','профессор'),
	(1003,'Петрова Ирина Олеговна','ст.преподаватель');
INSERT INTO `Расписание занятий`
	(`Номер группы`,`Дата`,`№ пары`,`Табельный номер`,`Код дисциплины`)
	VALUES
	('ГМУ-11','2018.11.23',1,1003,221),
	('ГМУ-11','2018.11.23',2,1001,101);
INSERT INTO `Расписание занятий1`
	(`Номер группы`,`Дата`,`№ пары`,`Табельный номер`,`Код дисциплины`)
	VALUES
	('ИВТ-24','2018.11.24',1,1001,121),
	('ИВТ-24','2018.11.23',3,1001,102),
	('ГМУ-21','2018.11.24',2,1002,322),
	('ГМУ-21','2018.11.23',3,1003,222);
/* -4- */
INSERT INTO `Расписание занятий`
	(`Номер группы`,`Дата`,`№ пары`,`Табельный номер`,`Код дисциплины`)
SELECT * FROM `Расписание занятий1`;
/* -5- */
UPDATE `Расписание занятий` 
SET `Дата`=DATA_ADD(`Расписание занятий`, INTERVAL 1 YEAR);
/* -6- */
START TRANSACTION;
DELETE FROM `Расписание занятий1` WHERE `Код дисциплины`=102;
DELETE FROM `Расписание занятий` WHERE `Код дисциплины`=102;
DELETE FROM `Дисциплины` WHERE `Код дисциплины`=102;
COMMIT;
/* -7- */
DROP TABLE IF EXISTS `Расписание занятий1`;
/* -8- */
SELECT `Код дисциплины`,
	`Название дисциплины`,
	`Лекции`,
	`Семинары`
FROM `Дисциплины`
WHERE `Лекции`
BETWEEN 30 AND 50
OR `Семинары`
BETWEEN 30 AND 50;
/* -9- */
SET @INDEX='ГМУ-21';
SELECT `Номер группы`,
	`Дата`,
	`№ пары`,
	`Название дисциплины`,
	`Фамилия, имя и отчество`,
	`Должность`
FROM `Дисциплины`
INNER JOIN `Расписание занятий`
ON `Расписание занятий`.`Код дисциплины`=`Дисциплины`.`Код дисциплины`
INNER JOIN `Преподаватели`
ON `Преподаватели`.`Табельный номер`=`Расписание занятий`.`Табельный номер`
WHERE `Номер группы`=@INDEX;
/* -10- */
SELECT `Табельный номер`,
	`Фамилия, имя и отчество`,
	`Должность`
FROM `Преподаватели`
WHERE NOT EXISTS
(SELECT * FROM `Расписание занятий`
WHERE `Расписание занятий`.`Табельный номер`=`Преподаватели`.`Табельный номер`);
/* -11- */
SELECT `Расписание занятий`.`Табельный номер`,
	`Преподаватели`.`Фамилия, имя и отчество`,
	`Преподаватели`.`Должность`,
	COUNT(*) AS `Кол-во групп`
FROM `Преподаватели`
INNER JOIN `Расписание занятий`
ON `Расписание занятий`.`Табельный номер`=`Преподаватели`.`Табельный номер`
GROUP BY 1,3 HAVING COUNT(*)>=2
ORDER BY `Кол-во групп`;
/* -12- */ /* Не понял прикола */
SELECT AVG(`Лекции`) AS `Лекции`,
	AVG(`Семинары`) AS `Семинары`
FROM `Дисциплины`;
/* -13- */
SELECT `Дисциплины`.`Код дисциплины`,
	`Дисциплины`.`Название дисциплины`,
	COUNT(DISTINCT `Расписание занятий`.`Номер группы`) AS `Кол-во`
FROM `Дисциплины`
INNER JOIN `Расписание занятий`
ON `Расписание занятий`.`Код дисциплины`=`Дисциплины`.`Код дисциплины`
GROUP BY `Дисциплины`.`Код дисциплины`;
/* -14- */
CREATE VIEW `Сум.кол-во часов` AS
SELECT `Преподаватели`.`Табельный номер`,
	`Фамилия, имя и отчество`,
	`Должность`,
	SUM(`Лекции` + `Семинары`) AS `Макс.нагрузка`
FROM `Расписание занятий`
INNER JOIN `Преподаватели`
ON `Преподаватели`.`Табельный номер`=`Расписание занятий`.`Табельный номер`
INNER JOIN `Дисциплины`
ON `Дисциплины`.`Код дисциплины`=`Расписание занятий`.`Код дисциплины`
GROUP BY `Расписание занятий`.`Табельный номер`;
SELECT * FROM `Сум.кол-во часов` 
WHERE `Макс.нагрузка`=(SELECT MAX(`Макс.нагрузка`) FROM `Сум.кол-во часов`);