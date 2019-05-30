DROP USER 'administrator'@'localhost';
DROP USER 'headLibrary'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'headLibrary'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'worker'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'visitor'@'localhost';

DROP DATABASE `tretyakov_VAR10`;

CREATE DATABASE `tretyakov_VAR10`;

USE `tretyakov_VAR10`;

DROP TABLE IF EXISTS `Экземпляры книг`;
DROP TABLE IF EXISTS `Книги`;
DROP TABLE IF EXISTS `Читательские билеты`;

CREATE TABLE `Читательские билеты` (
    `№ читательского билета` INT NULL,
    `ФИО читателя` VARCHAR(35) NOT NULL,
    `Домашний телефон` VARCHAR(20) NOT NULL,
    `№ группы` VARCHAR(10) NOT NULL,
    PRIMARY KEY(`# читательского билета`)
) ENGINE=InnoDB;

CREATE TABLE `Книги` (
    `ISBN` VARCHAR(35) NOT NULL,
    `ФИО автора` VARCHAR(35) NOT NULL,
    `Название книги` VARCHAR(45) NOT NULL,
    `Год издания` INT NOT NULL,
    `Цена,руб` INT NULL,
    PRIMARY KEY(`ISBN`)
) ENGINE=InnoDB;

CREATE TABLE `Экземпляры книг` (
    `Инвентарный №` INT NOT NULL,
    `ISBN` VARCHAR(35) NOT NULL,
    `№ читательского билета` INT NULL,
    PRIMARY KEY(`Инвентарный №`),
    FOREIGN KEY(`ISBN`) REFERENCES `Книги`(`ISBN`) 
    ON DELETE NO ACTION 
    ON UPDATE CASCADE,
    FOREIGN KEY(`№ читательского билета`) REFERENCES `Читательские билеты`(`№ читательского билета`) 
    ON DELETE NO ACTION 
    ON UPDATE CASCADE
) ENGINE=InnoDB;