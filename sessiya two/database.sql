
DROP USER 'administrator'@'localhost';
DROP USER 'director'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost';
CREATE USER 'director'@'localhost';
CREATE USER 'worker'@'localhost';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO
'administrator'@'localhost';
REVOKE CREATE, ALTER, DROP *.* FROM
'administrator'@'localhost';

FLUSH PRIVILEGES;

DROP DATABASE LAB2;

CREATE DATABASE LAB2;
USE LAB2;

DROP TABLE IF EXISTS `Книги`;
DROP TABLE IF EXISTS `Авторы`;
DROP TABLE IF EXISTS `Издательства`;

CREATE TABLE `Издательства` (
    `Порядковый № издательства` INT NOT NULL PRIMARY KEY, 
    `Название издательства` VARCHAR(30) NOT NULL,
    `Город` VARCHAR(15) NOT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Redactor.csv" IGNORE
INTO TABLE `Издательства`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Авторы` (
    `Порядковый № автора` INT NOT NULL, 
    `ФИО автора` VARCHAR(60) NOT NULL,
    `Пол` VARCHAR(3) NOT NULL, 
    `Дата рождения` VARCHAR(14) NOT NULL,
    PRIMARY KEY(`Порядковый № автора`)
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Author.csv" IGNORE
INTO TABLE `Авторы`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Книги` (
    `ISBN` VARCHAR(25) NOT NULL PRIMARY KEY, /* row - 10 */
    `Порядковый № автора` INT NOT NULL,
    `Название книги` VARCHAR(25) NOT NULL,
    `Порядковый № издательства` INT NOT NULL,
    `Год издания` INT NOT NULL,
    `Цена` INT NOT NULL,
	FOREIGN KEY (`Порядковый № автора`) REFERENCES `Авторы` (`Порядковый № автора`) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`Порядковый № издательства`) REFERENCES `Издательства`(`Порядковый № издательства`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Knigi.csv" IGNORE
INTO TABLE `Книги`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';



