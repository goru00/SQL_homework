CREATE DATABASE WORKGROUP;
USE SOSAMBA;
CREATE TABLE `Издательства` (
	`Код издательства` INT PRIMARY KEY,
	`Название издательства` VARCHAR(60) NOT NULL,
	`Город` VARCHAR(30) NOT NULL,
	`Сайт издательства` VARCHAR(30)
);

CREATE TABLE `Книги` (
	ISBN CHAR(20) PRIMARY KEY,
	`ББК` VARCHAR (20), 
	`Название книги` VARCHAR (160) NOT NULL,
	`Код издательства` INT NOT NULL,
	`Год издания` INT NOT NULL,
	`Количество страниц` INT,
	`Цена` INT NOT NULL,
 	FOREIGN KEY (`Код издательства`) REFERENCES  `Издательства` (`Код издательства`) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE `Авторы` (
	`Код автора` INT NOT NULL PRIMARY KEY,
	`ФИО` VARCHAR(40) NOT NULL	
);

CREATE TABLE `Книги-Авторы` (
	ISBN CHAR(20),
	`Код автора` INT NOT NULL,
	PRIMARY KEY (ISBN, `Код автора`),
	FOREIGN KEY (ISBN) REFERENCES `Книги` (ISBN) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`Код автора`) REFERENCES `Авторы` (`Код автора`) ON DELETE NO ACTION ON UPDATE CASCADE
);
CREATE TABLE `Экземпляры` (
	`№ инвентарный` INT NOT NULL PRIMARY KEY, 
	ISBN CHAR(20),
	FOREIGN KEY (ISBN) REFERENCES `Книги` (ISBN) ON DELETE NO ACTION ON UPDATE CASCADE 
);
CREATE TABLE `Должности` (
	`Код должности` INT PRIMARY KEY NOT NULL,
	`Наименование должности` VARCHAR(60) NOT NULL
);
CREATE TABLE `Читательский билет` (
	`№ читательского билета` INT NOT NULL PRIMARY KEY,
	`ФИО` VARCHAR(40) NOT NULL,
	`Телефон` VARCHAR(20),
	`Код должности` INT NOT NULL,
	`Домашний адрес` VARCHAR(120),
	FOREIGN KEY (`Код должности`) REFERENCES `Должности` (`Код должности`) ON DELETE NO ACTION ON UPDATE CASCADE
);
CREATE TABLE `Книговыдача` ( 
	`№ инвентарный` INT NOT NULL,
	`№ читательского билета` INT NOT NULL,
	`Дата выдачи` DATE NOT NULL,
	`Дата возврата` DATE,
	PRIMARY KEY (`№ инвентарный`, `№ читательского билета`, `Дата выдачи`),
	FOREIGN KEY (`№ читательского билета`) REFERENCES `Читательский билет` (`№ читательского билета`) ON DELETE NO ACTION ON UPDATE CASCADE
);
CREATE TABLE `Настроечная` (
	`Название института` CHAR(30) NOT NULL,
	`Юридический адрес` CHAR(60) NOT NULL,
	`ФИО руководителя` CHAR(30) NOT NULL,
	`Код должности` INT NOT NULL,
	FOREIGN KEY (`Код должности`) REFERENCES `Должности` (`Код должности`) ON DELETE NO ACTION ON UPDATE CASCADE
);