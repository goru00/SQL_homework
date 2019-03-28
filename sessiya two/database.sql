CREATE DATABASE LAB2;
USE LAB2;
CREATE TABLE `Книги` (
    `ISBN` VARCHAR(32) NOT NULL PRIMARY KEY,
    `Порядковый № автора` INT(11) NOT NULL,
    `Название книги` VARCHAR(25) NOT NULL,
    `Порядковый № издательства` INT(11) NOT NULL,
    `Год издания` INT NOT NULL,
    `Цена` INT NOT NULL,
	FOREIGN KEY (`Порядковый № автора`) REFERENCES `Авторы` (`Порядковый № автора`) ON UPDATE CASCADE,
	FOREIGN KEY (`Порядковый № издательства`) REFERENCES `Издательства`(`Порядковый № издательства`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Авторы` (
    `Порядковый № автора` INT(11) NOT NULL, 
    `ФИО автора` VARCHAR(60) NOT NULL,
    `Пол` VARCHAR(1) NOT NULL, 
    `Дата рождения` CHAR(14) NOT NULL,
	PRIMARY KEY(`Порядковый № автора`)
);

CREATE TABLE `Издательства` (
    `Порядковый № издательства` INT(11) NOT NULL PRIMARY KEY, 
    `Название издательства` VARCHAR(30) NOT NULL,
    `Город` VARCHAR(15) NOT NULL
) ENGINE=InnoDB;

INSERT INTO `Книги` (`ISBN`,`Порядковый № автора`, `Название книги`, `Порядковый № издательства`, `Год издания`, `Цена`) VALUES 
    ('978-5-388-00003', 1001, 'Самоучитель JAVA', 101, 2012, 300),
    ('978-5-699-58103', 1001, 'JAVA за 21 день', 102, 2013, 600),
    ('758-3-004-87105', 1002, 'Сопромат', 103, 2013, 350),
    ('758-3-004-87105', 1003, 'Физика', 102, 2013, 450);

INSERT INTO `Авторы` (`Порядковый № автора`,`ФИО автора`, `Пол`, `Дата рождения`) VALUES 
    (1001, 'Иванов Сергей Степанович', 'М', 22.09.2013),
    (1002, 'Сидорова Ольга Юрьевна', 'Ж', 22.09.2013),
    (1003, 'Петров Иван Петрович', 'М', 23.09.2013);

INSERT INTO `Издательства` (`Порядковый № издательства`, `Название издательства`, `Город`) VALUES
    (101, 'Питер', 'Петербург'),
    (102, 'Лори', 'Москва'),
    (103, 'БХВ-Петербург', 'Петербург');
	
CREATE USER 'administrator'@'localhost' IDENTIFIED BY '123';
CREATE USER 'director'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'visitor'@'localhost' IDENTIFIED BY '';

GRANT ALL PRIVILEGES ON * . * TO 'administrator'@'localhost';

GRANT ALL PRIVILEGES ON * . * TO 'worker'@'localhost';

REVOKE 
