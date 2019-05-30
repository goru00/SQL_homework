DROP USER 'administrator'@'localhost';
DROP USER 'director'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'director'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'worker'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO
'administrator'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, DROP ON *.* TO
'administrator'@'localhost';

FLUSH PRIVILEGES;

DROP DATABASE VAR07;

CREATE DATABASE VAR07;

USE VAR07;

CREATE TABLE `Книги` (
    `ISBN` VARCHAR(35) NOT NULL,
    `ФИО автора` VARCHAR(35) NOT NULL,
    `Название книги` VARCHAR(45) NOT NULL,
    `Год издания` INT NOT NULL,
    `Цена` INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Заказы` (
    `№ заказа` INT NOT NULL,
    `Адрес доставки` VARCHAR(75) NOT NULL,
    `Дата заказа` VARCHAR(12) NOT NULL,
    `Дата выполнения заказа` VARCHAR(12) NULL
) ENGINE=InnoDB;

CREATE TABLE `Книги заказа` (
    `№ заказа` INT NOT NULL,
    `ISBN` VARCHAR(35) NOT NULL,
    `Количество` INT NOT NULL
) ENGINE=InnoDB;


