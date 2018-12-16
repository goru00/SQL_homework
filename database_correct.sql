CREATE DATABASE WORKGROUP:
USE WORKGROUP;

CREATE TABLE `Издательства` (
	`Код издательства` INT PRIMARY KEY,
	`Название издательства` VARCHAR(60) NOT NULL,
	`Город` VARCHAR(30) NOT NULL,
	`Сайт издательства` VARCHAR(30),
	`Количество авторов` INT NOT NULL
);
CREATE TABLE `Книги` (
	`ISBN` CHAR(20) PRIMARY KEY,
	`ББК` VARCHAR (20), 
	`Название книги` VARCHAR (160) NOT NULL,
	`Код издательства` INT NOT NULL,
	`Год издания` INT NOT NULL,
	`Количество страниц` INT,
	`Цена` INT NOT NULL,
 	FOREIGN KEY (`Код издательства`) REFERENCES  `Издательства` (`Код издательства`) ON DELETE NO ACTION ON UPDATE CASCADE
);
CREATE TABLE `Книги-Авторы` (
	`ISBN` char(60) not null,
	`Код автора` int not null,
	primary key (`ISBN`, `Код автора`)
);
CREATE TABLE `Экземпляры` (
	`№ инвентарный` int not null primary key,
	`ISBN` char(60) not null,
	foreign key `№ инвентарный` references `Книговыдача` (`№ инвентарный`) on action no delete cascade
);
CREATE TABLE `Авторы` (
	`Код автора` int not null primary key,
	`ФИО` varchar(35) not null,
	foreign key `Код автора` references `Книги-Авторы` (`Код автора`) on action no delete cascade
);
CREATE TABLE `Книговыдача` (
	`№ инвентарный` int not null,
	`№ читательского билета` int not null,
	`Дата выдачи` char(15) null,
	`Дата возврата` char(15) null,
	primary key(`№ инвентарный`, `№ читательского билета`, `Дата выдачи`),
);
CREATE TABLE `Читательские билеты` (
	`№ читательского билета` int not null primary key,
	`ФИО` varchar(35) not null,
	`Телефон` char(20) null,
	`Код должности` int null,
	`Домашний адрес` char(60) null,
	foreign key `№ читательского билета` references `Книговыдача` (`№ инвентарный`) on action no delete cascade
);
CREATE TABLE `Должности` (
	`Код должности` int not null primary key,
	`Должность` varchar(30) not null,
	foreign key `Код должности` references `Настроечная`,`Читательский билеты` (`Код должности`) on action no delete cascade
);
CREATE TABLE `Настроечная` (
	`Название института` varchar(70) not null,
	`Юридический адрес` varchar(100) not null,
	`ФИО руководителя` varchar(45) not null,
	`Код должности` int not null
);




