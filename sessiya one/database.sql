/*DROP DATABASE IF EXISTS LAB;*/

CREATE DATABASE IF NOT EXISTS LAB;

USE LAB;

DROP TABLE IF EXISTS `Заказанные изделия`;
DROP TABLE IF EXISTS `Ткани изделия`;
DROP TABLE IF EXISTS `Фурнитура изделия`;
DROP TABLE IF EXISTS `Изделие`;
DROP TABLE IF EXISTS `Склад ткани`;
DROP TABLE IF EXISTS `Склад фурнитуры`;
DROP TABLE IF EXISTS `Заказ`;
DROP TABLE IF EXISTS `Пользователь`;
DROP TABLE IF EXISTS `Фурнитура`;
DROP TABLE IF EXISTS `Ткань`;

CREATE TABLE `Изделие` (
    `Артикул` VARCHAR(30) NOT NULL PRIMARY KEY, /* row - 13 */
    `Наименование` VARCHAR(64) NOT NULL, /* row - 11 */
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    `Изображение` VARCHAR(128) NULL,
    `Комментарий` TEXT NULL 
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\izdeliya.csv" IGNORE
INTO TABLE `Изделие`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Пользователь` (
    `Логин` VARCHAR(45) NOT NULL,
    `Пароль` VARCHAR(45) NOT NULL,
    PRIMARY KEY(`Логин`, `Пароль`),
    `Роль` ENUM('Дмитрий', 'Владимир'),
    `Наименование` INT NULL,
    AUTH INT UNIQUE KEY NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Заказ` (
    `Номер` INT NOT NULL,
    `Дата` DATE NOT NULL,
    PRIMARY KEY(`Номер`, `Дата`),
    `Этап выполнения` VARCHAR(16) NOT NULL,
    `Заказчик` INT NOT NULL,
    `Менеджер` INT NULL,
    `Стоимость` INT NULL,
    INDEX `FK_Orders_Users_1` (`Заказчик`),
	INDEX `FK_Orders_Users_2` (`Менеджер`),
    FOREIGN KEY (`Заказчик`) REFERENCES `Пользователь`(AUTH) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (`Менеджер`) REFERENCES `Пользователь`(AUTH) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Заказанные изделия` (
    `Артикул изделия` VARCHAR(32) NOT NULL,
    `Номер заказа` INT NOT NULL, 
    PRIMARY KEY(`Артикул изделия`, `Номер заказа`),
    `Количество` INT NOT NULL,
    INDEX `FK_OrderedProducts_Products` (`Артикул изделия`),
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (`Номер заказа`) REFERENCES `Заказ`(`Номер`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Ткань` (
    `Артикул` VARCHAR(15) NOT NULL PRIMARY KEY, /* row - 5 */
    `Наименование` VARCHAR(50) NULL, /* row - 10 */
    `Цвет` VARCHAR(35) NULL, /* row - 8 */
    `Рисунок` VARCHAR(25) NULL, /* row - 9 */
    `Изображение` VARCHAR(100) NULL,
    `Состав` VARCHAR(26) NULL,
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    `Цена` INT NOT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\tkani.csv" IGNORE
INTO TABLE `Ткань`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Склад ткани` (
    `Рулон` INT NOT NULL,
    `Артикул ткани` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Рулон`, `Артикул ткани`),
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    INDEX `FK_WarehouseFabric_Fabric` (`Артикул ткани`),
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Ткани изделия` (
    `Артикул ткани` VARCHAR(32) NOT NULL,
    `Артикул изделия` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Артикул ткани`, `Артикул изделия`),
    INDEX `FK_FabricProducts_Products` (`Артикул изделия`),
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Фурнитура` (
    `Артикул` VARCHAR(30) NOT NULL PRIMARY KEY, /* row - 10 */
    `Наименование` VARCHAR(110) NOT NULL, /* row - 12 */
    `Ширина` INT NOT NULL,
    `Длина` INT NULL,
    `Тип` VARCHAR(45) NOT NULL, /* row - 12 */
    `Цена` INT NOT NULL,
    `Вес` INT NULL,
    `Изображение` VARCHAR(25) NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\furnitura.csv" IGNORE
INTO TABLE `Фурнитура`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Склад фурнитуры` (
    `Партия` INT NOT NULL,
    `Артикул фурнитуры` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Партия`, `Артикул фурнитуры`),
    `Количество` INT NOT NULL,
    INDEX `FK_WarehouseFurniture_Furniture` (`Артикул фурнитуры`),
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Фурнитура изделия` (
    `Артикул фурнитуры` VARCHAR(32) NOT NULL,
    `Артикул изделия` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`Артикул фурнитуры`,`Артикул изделия`),
    `Размещение` VARCHAR(40) NOT NULL,
    `Ширина` INT NULL,
    `Длина` INT NULL,
    `Поворот` INT NULL,
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;
