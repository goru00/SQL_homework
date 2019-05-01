
DROP USER 'administrator'@'localhost';
DROP USER 'headLibrary'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'headLibrary'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'worker'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON `VAR11`.* TO
'administrator'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, DROP ON *.* FROM
'administrator'@'localhost'; 

FLUSH PRIVILEGES;

DROP DATABASE VAR10;

CREATE DATABASE VAR10;
USE VAR10;

DROP TABLE IF EXISTS `Ингредиенты`;
DROP TABLE IF EXISTS `Продукты`;
DROP TABLE IF EXISTS `Рецепты блюд`;

CREATE TABLE `Читательские билеты` (
	`№ читательского билета` INT NOT NULL PRIMARY KEY,
	`ФИО читателя` VARCHAR(36) NOT NULL,
	`Домашний телефон` VARCHAR(16) NULL,
	`№ группы` VARCHAR(10) NOT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\" IGNORE
INTO TABLE `Читательские билеты`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Книги` (
	`ISBN` VARCHAR(40) NOT NULL PRIMARY KEY,
	`ФИО автора` VARCHAR(36) NOT NULL,
	`Название книги` VARCHAR(30) NOT NULL,
	`Год издания` INT NOT NULL,
	`Цена, руб` INT NOT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\" IGNORE
INTO TABLE `Книги`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Экземпляры книг` (
	`Инвентарный №` INT NOT NULL PRIMARY KEY,
	`ISBN` VARCHAR(40) NOT NULL,
	`№ читательского билета` INT NULL,
	FOREIGN KEY (`ISBN`) REFERENCES `Книги`(`ISBN`) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`№ читательского билета`) REFERENCES `Читательские билеты`(`№ читательского билета`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\" IGNORE
INTO TABLE `Экземпляры книг`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

GRANT ALL PRIVILEGES ON *.* TO
'headLibrary'@'localhost';
REVOKE CREATE, DROP, ALTER ON *.* FROM
'headLibrary'@'localhost';
GRANT DROP ON `VAR22`.* ON
'headLibrary'@'localhost';

FLUSH PRIVILEGES;

