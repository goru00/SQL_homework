CREATE DATABASE LAB;
USE LAB;
CREATE TABLE `Книги` (
    `ISBN` VARCHAR(32) NOT NULL PRIMARY KEY,
    `Порядковый № автора` INT NOT NULL,
    `Название книги` VARCHAR(25) NOT NULL,
    `Порядковый № издательства` INT NOT NULL,
    `Год издания` DATA NOT NULL,
    `Цена` INT NOT NULL 
) ENGINE=InnoDB;
CREATE TABLE `Авторы` (

) ENGINE=InnoDB;
