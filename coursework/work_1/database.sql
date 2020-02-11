DROP DATABASE work_1;
CREATE DATABASE work_1;

SET foreign_key_checks = 0;

USE work_1;

DROP TABLE IF EXISTS `Авторы`;
DROP TABLE IF EXISTS `Книги`;
DROP TABLE IF EXISTS `Заказы`;
DROP TABLE IF EXISTS `Доставка`;
CREATE TABLE `Авторы` (
	`№ автора` INT NOT NULL,
	`ФИО автора` VARCHAR(36) NOT NULL,
	PRIMARY KEY(`№ автора`)
) ENGINE=InnoDB;
CREATE TABLE `Книги` (
	`ISBN` VARCHAR(22) NOT NULL,
	`№ автора` INT NOT NULL,
	`Название книги` VARCHAR(48) NOT NULL,
	`Год издания` INT NOT NULL,
	`Цена` INT NOT NULL,
	PRIMARY KEY(`ISBN`),
	FOREIGN KEY(`№ автора`) 
	REFERENCES `Авторы`(`№ автора`) 
	ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;
CREATE TABLE `Заказ` (
	`№ заказа` INT NOT NULL, 
	`Адрес доставки` VARCHAR(100) NOT NULL,
	`Дата заказа` DATE NOT NULL,
	`Дата выполнения заказа` DATE NULL,
	PRIMARY KEY(`№ заказа`)
) ENGINE=InnoDB;
CREATE TABLE `Доставка` (
	`№ заказа` INT NOT NULL,
	`ISBN` VARCHAR(22) NOT NULL,
	FOREIGN KEY(`ISBN`) 
	REFERENCES `Книги`(`ISBN`)
	ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY(`№ заказа`)
	REFERENCES `Заказ`(`№ заказа`)
	ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;
INSERT INTO `Авторы` 
	(`№ автора`, `ФИО автора`)
	VALUES
	(1, 'Иванов Сергей Степанович'),
	(2, 'Сидорова Ольга Юрьевна'),
	(3, 'Петров Иван Петрович');
INSERT INTO `Книги` 
	(`ISBN`, `№ автора`, `Название книги`, `Год издания`, `Цена`)
	VALUES
	('978-5-388-00003', 1, 'Самоучитель JAVA', 2012, 300),
	('978-5-699-58103', 2, 'JAVA за 21 день', 2013, 600),
	('675-3-423-00375', 3, 'Физика', 2013, 450),
	('758-3-004-87105', 3, 'Сопромат', 2013, 350);
INSERT INTO `Заказ`
	(`№ заказа`, `Адрес доставки`, `Дата заказа`, `Дата выполнения заказа`)
	VALUES
	(123456, 'Малая Арнаутская ул., д.9, кв.16', '2013.09.20', '2013.09.22'),
	(222334, 'Курчатов бульвар, д.33, кв.9', '2013.09.21', NULL),
	(432152, 'Нахимовский проспект, д.12, кв.89', '2012.09.21', '2012.09.23');
INSERT INTO `Доставка`
	(`№ заказа`, `ISBN`)
	VALUES
	(123456, '978-5-388-00003'),
	(123456, '978-5-699-58103'),
	(222334, '978-5-388-00003'),
	(222334, '675-3-423-00375'),
	(432152, '758-3-004-87105');
SELECT `Книги`.`ISBN`, 
		`Авторы`.`ФИО автора`,
		`Книги`.`Название книги`,
		`Книги`.`Год издания`,
		`Книги`.`Цена`,
		`Доставка`.`№ заказа`,
		`Заказ`.`Адрес доставки`,
		`Заказ`.`Дата заказа`,
		`Заказ`.`Дата выполнения заказа`
FROM (((`Авторы` INNER JOIN `Книги` ON 
	`Авторы`.`№ автора`=`Книги`.`№ автора`) INNER JOIN `Доставка` ON
	`Книги`.`ISBN`=`Доставка`.`ISBN`) INNER JOIN `Заказ` ON
	`Доставка`.`№ заказа`=`Заказ`.`№ заказа`) ORDER BY `№ заказа`;