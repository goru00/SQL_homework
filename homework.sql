/* 1 */
CREATE DATABASE varfive;
USE varfive;
CREATE TABLE `Авторы(художники)` (
	`Идентификационный №` INT NOT NULL PRIMARY KEY,
	`ФИО художника` VARCHAR(30) NOT NULL
);
CREATE TABLE `Разделы` (
	`№ раздела` INT NOT NULL PRIMARY KEY,
	`Название раздела` VARCHAR(20) NOT NULL
);
CREATE TABLE `Картины` (
	`№ картины` INT NOT NULL,
	`Название картины` VARCHAR(25) NOT NULL,
	`Идентификационный №` INT NOT NULL,
	`№ раздела` INT NOT NULL, 
	`Техника` VARCHAR(20) NOT NULL,
	`Размеры картины (см ШхВ)` VARCHAR(8) NOT NULL,
	`Стоимость (руб.)` INT NOT NULL,
	FOREIGN KEY (`№ раздела`) REFERENCES `Разделы` (`№ раздела`) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (`Идентификационный №`) REFERENCES `Авторы(художники)`(`Идентификационный №`) ON UPDATE CASCADE ON DELETE CASCADE 
);
CREATE TABLE `Картины1` (
	`№ картины` INT NOT NULL,
	`Название картины` VARCHAR(25) NOT NULL,
	`Идентификационный №` INT NOT NULL,
	`№ раздела` INT NOT NULL, 
	`Техника` VARCHAR(20) NOT NULL,
	`Размеры картины (см ШхВ)` CHAR(8) NOT NULL,
	`Стоимость (руб.)` INT NOT NULL,
	FOREIGN KEY (`№ раздела`) REFERENCES `Разделы` (`№ раздела`) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (`Идентификационный №`) REFERENCES `Авторы(художники)`(`Идентификационный №`) ON UPDATE CASCADE ON DELETE CASCADE
);

/* 3 */
INSERT INTO `Авторы(художники)` (`Идентификационный №`,`ФИО художника`) VALUES
	(100, 'Крупень С'),
	(101, 'Беляев Р.Х'),
	(103, 'Кручинкин Ю'),
	(104, 'Малевич П');
INSERT INTO `Разделы` (`№ раздела`, `Название раздела`) VALUES 
	(10, 'Городской пейзаж'),
	(11, 'Натюрморт');
INSERT INTO `Картины` (`№ картины`,`Название картины`,`Идентификационный №`,`№ раздела`,`Техника`,`Размеры картины (см ШхВ)`,`Стоимость (руб.)`) VALUES
	(1001, 'Даниловский монастырь', 101, 10, 'Пастель', '40x50', 40000),
	(1002, 'Веселый денек', 101, 11, 'Масло,холст', '45x70', 15000),
	(1003, 'Старая Москва', 103, 10, 'Акварель', '30x60', 12000);

INSERT INTO `Картины1` (`№ картины`,`Название картины`,`Идентификационный №`,`№ раздела`,`Техника`,`Размеры картины (см ШхВ)`,`Стоимость (руб.)`) VALUES
	(1004, 'Старая Москва', 100, 10, 'Масло,холст', '30x50', 20000),
	(1005, 'Пионы', 100, 11, 'Масло,холст', '80x70', 50000),
	(1006, 'Таганский парк', 101, 10, 'Акварель', '60x40', 25000);
/* 4 */
INSERT INTO `Картины` SELECT * FROM `Картины1`;
/* 5 */ 
DROP TABLE `Картина1`;
/* 6 */
UPDATE `Авторы(художники)` SET 
`Идентификационный №` = 102 WHERE 
`Идентификационный №` = 100;
/* 7 */
DELETE FROM `Авторы(художники)` WHERE 
`Идентификационный №` = 103;
/* 8 */
SELECT `Картины1`.`№ картины`,`Картины1`.`Название картины`,`Картины1`.`№ раздела`,`Авторы(художники)`.`ФИО художника`,`Картины1`.`Стоимость (руб.)` FROM 
`Картины1`,`Авторы(художники)` WHERE 
`Стоимость (руб.)` BETWEEN 
20000 AND 40000 ORDER BY 
`Стоимость (руб.)`;
/* 9 */
SELECT `Авторы(художники)`.`Идентификационный №`,`Авторы(художники)`.`ФИО художника`,`Картины`.`№ картины`,`Картины`.`Название картины`,`Картины`.`№ раздела`,`Картины`.`Техника`, `Картины`.`Стоимость (руб.)` FROM
`Картины`,`Авторы(художники)` WHERE 
`Авторы(художники)`.`Идентификационный №`=101;
/* 10 */
SELECT `Авторы(художники)`.`Идентификационный №`, `Авторы(художники)`.`ФИО художника` FROM 
`Картины` RIGHT JOIN 
`Авторы(художники)` ON 
`Картины`.`Идентификационный №`=`Авторы(художники)`.`Идентификационный №` WHERE 
`Картины`.`Идентификационный №` IS NULL;
/* 11 */
SELECT `Картины`.`Идентификационный №`,`Авторы(художники)`.`ФИО художника`, COUNT(DISTINCT `Картины`.`№ картины`) AS 
`Кол-во картин` FROM 
`Картины` INNER JOIN 
`Авторы(художники)` ON 
`Картины`.`Идентификационный №`=`Авторы(художники)`.`Идентификационный №` GROUP BY 
`Картины`.`Идентификационный №` HAVING 
COUNT(DISTINCT `Картины`.`№ картины`) >= 3;
/* 13 */
SELECT `Картины`.`№ раздела`, `Разделы`.`Название раздела`, COUNT(DISTINCT `Картины`.`№ картины`) as 
`Кол-во картин в данном разделе` FROM 
`Картины`, `Разделы` GROUP BY 
`Картины`.`№ раздела`;
/* 12 */
SELECT `Разделы`.`Название раздела`, AVG(DISTINCT `Картины`.`Стоимость (руб.)`) as 
`Средняя цена` FROM 
`Разделы`, `Картины` GROUP BY
`Картины`.`№ раздела`; 
/* 14 */
SELECT `Картины`.`Идентификационный №`, `Авторы(художники)`.`ФИО художника`, `Картины`.`Название картины`, MAX(`Картины`.`Стоимость (руб.)`) as 
`Макс.стоимость` FROM 
`Картины`, `Авторы(художники)`;
