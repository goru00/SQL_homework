
CREATE DATABASE `LAB3` COLLATE 'utf8_unicode_ci';
USE `LAB3`;

SET foreign_key_checks = 0;

CREATE TABLE `Авторы` (
	`Порядковый №` INT NOT NULL AUTO_INCREMENT,
	`ФИО автора` VARCHAR(64) NOT NULL,
	`Пол` VARCHAR(1) NULL DEFAULT NULL,
	`Дата рождения` DATE NULL,
	PRIMARY KEY (`Порядковый №`)
);

CREATE TABLE `Издательства` (
	`Порядковый №` INT NOT NULL AUTO_INCREMENT,
	`Название издательства` VARCHAR(32) NOT NULL,
	`Город` VARCHAR(32) NOT NULL,
	PRIMARY KEY (`Порядковый №`)
);

CREATE TABLE `Книги` (
	`ISBN` VARCHAR(16) NOT NULL,
	`№ автора` INT NOT NULL,
	`Название книги` VARCHAR(64) NOT NULL,
	`№ издательства` INT NOT NULL,
	`Год издания` YEAR NOT NULL,
	`Цена` INT NOT NULL,
	PRIMARY KEY (`ISBN`),
	FOREIGN KEY (`№ автора`) REFERENCES `авторы` (`Порядковый №`) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (`№ издательства`) REFERENCES `издательства` (`Порядковый №`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `Книги1` (
	`ISBN` VARCHAR(16) NOT NULL,
	`№ автора` INT NOT NULL,
	`Название книги` VARCHAR(64) NOT NULL,
	`№ издательства` INT NOT NULL,
	`Год издания` YEAR NOT NULL,
	`Цена` INT NOT NULL,
	PRIMARY KEY (`ISBN`),
	FOREIGN KEY (`№ автора`) REFERENCES `авторы` (`Порядковый №`) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (`№ издательства`) REFERENCES `издательства` (`Порядковый №`) ON UPDATE CASCADE ON DELETE CASCADE
);

/* 3. Заполнение данных */

INSERT INTO `Авторы` (`Порядковый №`, `ФИО автора`, `Пол`, `Дата рождения`) VALUES
	(1001, 'Иванов Сергей Степанович', 'М', '1963-09-22'),
	(1002, 'Сидорова Ольга Юрьевна', 'Ж', '1956-11-02'),
	(1003, 'Петров Иван Петрович', 'М', '1972-02-23'),
	(1004, 'Федоров Юрий Владимирович', 'М', '1954-08-11');

INSERT INTO `Издательства` (`Порядковый №`, `Название издательства`, `Город`) VALUES
	(101, 'Питер', 'Петербург'),
	(102, 'Лори', 'Москва'),
	(103, 'БХВ-Петербург', 'Петербург');

INSERT INTO `Книги` (`ISBN`, `№ автора`, `Название книги`, `№ издательства`, `Год издания`, `Цена`) VALUES
	('758-3-004-87105', 1002, 'Сопромат', 103, '2013', 350),
	('978-5-388-00003', 1001, 'Самоучитель JAVA', 101, '2012', 300),
	('978-5-699-58103', 1001, 'JAVA за 21 день', 102, '2013', 600);

INSERT INTO `Книги1` (`ISBN`, `№ автора`, `Название книги`, `№ издательства`, `Год издания`, `Цена`) VALUES
	('675-3-423-00375', 1003, 'Физика', 102, '2013', 450),
	('758-3-057-37854', 1002, 'Механика', 103, '2011', 270);

/* Запросы */

/* 4 */ INSERT INTO `книги` SELECT * FROM `книги1`;
/* 5 */ UPDATE `книги` SET `Цена` = `Цена` - (`Цена` * 10%) WHERE `Год издания` < 2012;
/* 6 */ DELETE FROM `книги` WHERE `Название книги` LIKE '%механ%';
/* 7 */ DROP TABLE `книги1`;
/* 8 */
SELECT
	`книги`.ISBN,
	`авторы`.`ФИО автора`,
	`книги`.`Название книги`
FROM
	`авторы` INNER JOIN `книги` ON `авторы`.`Порядковый №` = `книги`.`№ автора`
WHERE
	`Цена` BETWEEN 400 AND 600
;

/* 9 */
SELECT
	`книги`.`№ автора`,
	`авторы`.`ФИО автора`,
	`книги`.ISBN,
	`книги`.`Название книги`,
	`издательства`.`Название издательства`,
	`книги`.`Цена`
FROM
	`авторы` INNER JOIN `книги` ON `авторы`.`Порядковый №` = `книги`.`№ автора`
	INNER JOIN `издательства` ON `книги`.`№ издательства` = `издательства`.`Порядковый №`
WHERE
	`книги`.`№ автора` = 1001
;

/* 10 */
SELECT
	`авторы`.`Порядковый №`,
	`авторы`.`ФИО автора`,
	`авторы`.`Дата рождения`
FROM
	`авторы` LEFT JOIN `книги` ON `авторы`.`Порядковый №` = `книги`.`№ автора`
WHERE
	`книги`.`№ издательства` IS NULL
;

/* 11 */ 
SELECT
	`авторы`.`ФИО автора`,
	COUNT(`авторы`.`ФИО автора`) AS `Количество книг`
FROM
	`книги` INNER JOIN `авторы` ON `книги`.`№ автора` = `авторы`.`Порядковый №`
GROUP BY `книги`.`№ автора`
HAVING `Количество книг` > 1
;

/* 12 */
SELECT
	`№ издательства`,
	AVG(`Цена`) AS `Средняя стоимость книг`
FROM
	`книги`
GROUP BY 1
;

/* 13 */
SELECT
	`издательства`.`Порядковый №`,
	`издательства`.`Название издательства`,
	COUNT(`книги`.`№ автора`) AS `Количество авторов`
FROM
	`издательства` INNER JOIN `книги` ON `издательства`.`Порядковый №` = `книги`.`№ издательства`
GROUP BY 1
;

/* 14 */
SELECT
	`книги`.ISBN,
	`авторы`.`ФИО автора`,
	`книги`.`Название книги`,
	`книги`.`Цена`
FROM
	`книги` INNER JOIN `авторы` ON `книги`.`№ автора` = `авторы`.`Порядковый №`
GROUP BY `авторы`.`Порядковый №`
HAVING `книги`.`Цена` > (SELECT AVG(`Цена`) FROM `книги`)
;