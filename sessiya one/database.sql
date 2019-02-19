CREATE DATABASE LAB;
USE LAB;

CREATE TABLE `Фурнитура` (
    `Артикул` CHAR(25) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(30) NOT NULL,
    `Тип` VARCHAR(15) NOT NULL,
    `Ширина` INT NOT NULL,
    `Длина` INT,
    `Вес` INT,
    `Изображение` VARCHAR(100),
    `Цена` INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Ткань` (
    `Артикул` CHAR(20) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(30) NOT NULL,
    `Цвет` VARCHAR(15),
    `Рисунок` VARCHAR(15),
    `Изображение` VARCHAR(100),
    `Состав` VARCHAR(25),
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    `Цена` INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Склад фурнитуры` (
    `Партия` CHAR(25) NOT NULL,
    `Артикул фурнитуры` CHAR(25) NOT NULL,
    PRIMARY KEY(`Партия`, `Артикул фурнитуры`),
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Склад ткани` (
    `Рулон` CHAR(25) NOT NULL,
    `Артикул ткани` CHAR(25) NOT NULL,
    PRIMARY KEY(`Рулон`, `Артикул ткани`),
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Изделие` (
    `Артикул` CHAR(25) NOT NULL PRIMARY KEY,
    `Наименование` VARCHAR(30) NOT NULL,
    `Ширина` INT NOT NULL,
    `Длина` INT NOT NULL,
    `Изображение` VARCHAR(100),
    `Комментарий` VARCHAR(80) 
) ENGINE=InnoDB;

CREATE TABLE `Фурнитура изделия` (
    `Артикул фурнитуры` CHAR(20) NOT NULL,
    `Артикул изделия` CHAR(25) NOT NULL,
    PRIMARY KEY(`Артикул фурнитуры`,`Артикул изделия`),
    `Размещение` VARCHAR(60) NOT NULL,
    `Ширина` INT,
    `Длина` INT,
    `Поворот` INT,
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул фурнитуры`) REFERENCES `Фурнитура`(`Артикул`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Ткани изделия` (
    `Артикул ткани` CHAR(25) NOT NULL,
    `Артикул изделия` CHAR(25) NOT NULL,
    PRIMARY KEY(`Артикул ткани`, `Артикул изделия`),
    FOREIGN KEY (`Артикул ткани`) REFERENCES `Ткань`(`Артикул`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Пользователь` (
    `Логин` CHAR(30) NOT NULL,
    `Пароль` CHAR(30) NOT NULL,
    PRIMARY KEY(`Логин`, `Пароль`),
    `Роль` VARCHAR(15) NOT NULL,
    `Наименование` VARCHAR(25),
    UNIQUE INDEX `Логин_Пароль` (`Логин`, `Пароль`)
) ENGINE=InnoDB;

CREATE TABLE `Заказ` (
    `Номер` CHAR(20) NOT NULL,
    `Дата` CHAR(10) NOT NULL,
    PRIMARY KEY(`Номер`, `Дата`),
    `Этап выполнения` CHAR(20) NOT NULL,
    `Заказчик` VARCHAR(25) NOT NULL,
    `Менеджер` VARCHAR(25),
    `Стоимость` INT,
    FOREIGN KEY (`Заказчик`) REFERENCES `Пользователь`(`Логин`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Менеджер`) REFERENCES `Пользователь`(`Логин`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Заказанные изделия` (
    `Артикул изделия` CHAR(25) NOT NULL,
    `Номер заказа` CHAR(20) NOT NULL, 
    PRIMARY KEY(`Артикул изделия`, `Номер заказа`),
    `Количество` INT NOT NULL,
    FOREIGN KEY (`Артикул изделия`) REFERENCES `Изделие`(`Артикул`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Номер заказа`) REFERENCES `Заказ`(`Номер`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;



