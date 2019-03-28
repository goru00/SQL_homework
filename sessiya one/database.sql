CREATE DATABASE LAB;
USE LAB;
CREATE TABLE `Изделие` (
    `Артикул` VARCHAR(32) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(64) NOT NULL,
    `Ширина` FLOAT NOT NULL,
    `Длина` FLOAT NOT NULL,
    `Изображение` VARCHAR(128) NULL,
    `Комментарий` TEXT NULL 
) ENGINE=InnoDB;

CREATE TABLE `Пользователь` (
    `Логин` VARCHAR(50) NOT NULL,
    `Пароль` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`Логин`, `Пароль`),
    `Роль` VARCHAR(16) NOT NULL,
    `Наименование` VARCHAR(25) NULL
) ENGINE=InnoDB;

CREATE TABLE `Заказ` (
    `Номер` INT NOT NULL AUTO_INCREMENT,
    `Дата` DATE NOT NULL,
    PRIMARY KEY(`Номер`, `Дата`),
    `Этап выполнения` VARCHAR(16) NOT NULL,
    `Заказчик` VARCHAR(50) NOT NULL,
    `Менеджер` VARCHAR(50) NULL,
    `Стоимость` INT NULL,
    INDEX `FK_Orders_Users_1` (`Заказчик`),
	INDEX `FK_Orders_Users_2` (`Менеджер`),
    FOREIGN KEY (`Заказчик`) REFERENCES `Пользователь`(`Логин`) ON UPDATE CASCADE,
    FOREIGN KEY (`Менеджер`) REFERENCES `Пользователь`(`Логин`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Заказанные изделия` (
    `Артикул изделия` VARCHAR(32) NOT NULL,
    `Номер заказа` INT NOT NULL, 
    PRIMARY KEY(`Артикул изделия`, `Номер заказа`),
    `Количество` INT NOT NULL,
    INDEX `FK_OrderedProducts_Products` (`Артикул изделия`),
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (`Номер заказа`) REFERENCES `Заказ`(`Номер`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Ткань` (
    `Артикул` VARCHAR(20) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(30) NOT NULL,
    `Цвет` VARCHAR(15) NULL,
    `Рисунок` VARCHAR(15) NULL,
    `Изображение` VARCHAR(100) NULL,
    `Состав` VARCHAR(25) NULL,
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    `Цена` FLOAT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Склад ткани` (
    `Рулон` INT NOT NULL AUTO_INCREMENT,
    `Артикул ткани` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Рулон`, `Артикул ткани`),
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    INDEX `FK_WarehouseFabric_Fabric` (`Артикул ткани`),
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Ткани изделия` (
    `Артикул ткани` VARCHAR(32) NOT NULL,
    `Артикул изделия` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Артикул ткани`, `Артикул изделия`),
    INDEX `FK_FabricProducts_Products` (`Артикул изделия`),
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON UPDATE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Фурнитура` (
    `Артикул` VARCHAR(32) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(160) NOT NULL,
    `Ширина` FLOAT NOT NULL,
    `Длина` FLOAT NULL,
    `Тип` VARCHAR(64) NOT NULL,
    `Цена` FLOAT NOT NULL,
    `Вес` INT NULL,
    `Изображение` VARCHAR(128) NULL
) ENGINE=InnoDB;

CREATE TABLE `Склад фурнитуры` (
    `Партия` INT NOT NULL AUTO_INCREMENT,
    `Артикул фурнитуры` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Партия`, `Артикул фурнитуры`),
    `Количество` INT NOT NULL,
    INDEX `FK_WarehouseFurniture_Furniture` (`Артикул фурнитуры`),
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Фурнитура изделия` (
    `Артикул фурнитуры` VARCHAR(32) NOT NULL,
    `Артикул изделия` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Артикул фурнитуры`,`Артикул изделия`),
    `Размещение` VARCHAR(64) NOT NULL,
    `Ширина` INT NULL,
    `Длина` INT NULL,
    `Поворот` INT NULL,
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON UPDATE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\tkani.csv" IGNORE
INTO TABLE `Ткань`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE "C:\\izdeliya.csv" IGNORE
INTO TABLE `Изделие`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

LOAD DATA INFILE "C:\\furnitura.csv" IGNORE
INTO TABLE `Фурнитура`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';