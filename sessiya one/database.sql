CREATE DATABASE LAB;
USE LAB;
CREATE TABLE `Изделие` (
    `Артикул` VARCHAR(20) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(53) NOT NULL,
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    `Изображение` VARCHAR(100),
    `Комментарий` VARCHAR(80) 
) ENGINE=InnoDB;

CREATE TABLE `Пользователь` (
    `Логин` VARCHAR(30) NOT NULL,
    `Пароль` VARCHAR(30) NOT NULL,
    PRIMARY KEY(`Логин`, `Пароль`),
    `Роль` VARCHAR(15) NOT NULL,
    `Наименование` VARCHAR(25)
) ENGINE=InnoDB;

CREATE TABLE `Заказ` (
    `Номер` INT NOT NULL AUTO_INCREMENT,
    `Дата` DATE NOT NULL,
    PRIMARY KEY(`Номер`, `Дата`),
    `Этап выполнения` CHAR(20) NOT NULL,
    `Заказчик` VARCHAR(25) NOT NULL,
    `Менеджер` VARCHAR(25),
    `Стоимость` FLOAT,
    FOREIGN KEY (`Заказчик`) REFERENCES `Пользователь`(`Логин`) ON UPDATE CASCADE,
    FOREIGN KEY (`Менеджер`) REFERENCES `Пользователь`(`Логин`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Заказанные изделия` (
    `Артикул изделия` VARCHAR(25) NOT NULL,
    `Номер заказа` INT NOT NULL, 
    PRIMARY KEY(`Артикул изделия`, `Номер заказа`),
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (`Номер заказа`) REFERENCES `Заказ`(`Номер`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Ткань` (
    `Артикул` VARCHAR(20) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(30) NOT NULL,
    `Цвет` VARCHAR(15),
    `Рисунок` VARCHAR(15),
    `Изображение` VARCHAR(100),
    `Состав` VARCHAR(25),
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    `Цена` FLOAT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Склад ткани` (
    `Рулон` INT NOT NULL AUTO_INCREMENT,
    `Артикул ткани` VARCHAR(25) NOT NULL,
    PRIMARY KEY(`Рулон`, `Артикул ткани`),
    `Ширина` FLOAT NOT NULL,
    `Длина` FLOAT NOT NULL,
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Ткани изделия` (
    `Артикул ткани` VARCHAR(20) NOT NULL,
    `Артикул изделия` VARCHAR(20) NOT NULL,
    PRIMARY KEY(`Артикул ткани`, `Артикул изделия`),
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON UPDATE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Фурнитура` (
    `Артикул` VARCHAR(20) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(30) NOT NULL,
    `Тип` VARCHAR(15) NOT NULL,
    `Ширина` FLOAT NOT NULL,
    `Длина` FLOAT,
    `Вес` INT,
    `Изображение` VARCHAR(100),
    `Цена` FLOAT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Склад фурнитуры` (
    `Партия` INT NOT NULL AUTO_INCREMENT,
    `Артикул фурнитуры` VARCHAR(25) NOT NULL,
    PRIMARY KEY(`Партия`, `Артикул фурнитуры`),
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Фурнитура изделия` (
    `Артикул фурнитуры` VARCHAR(20) NOT NULL,
    `Артикул изделия` VARCHAR(20) NOT NULL,
    PRIMARY KEY(`Артикул фурнитуры`,`Артикул изделия`),
    `Размещение` VARCHAR(60) NOT NULL,
    `Ширина` INT,
    `Длина` INT,
    `Поворот` INT,
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON UPDATE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\tkani.csv"
INTO TABLE `Ткань`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE "C:\\izdeliya.csv"
INTO TABLE `Изделие`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE "C:\\furnitura.csv"
INTO TABLE `Фурнитура`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';