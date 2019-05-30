DROP USER 'administrator'@'localhost';
DROP USER 'headLibrary'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'headLibrary'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'worker'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO
'administrator'@'localhost';
REVOKE CREATE, DROP, ALTER ON *.* FROM
'administrator'@'localhost';

FLUSH PRIVILEGES;

DROP DATABASE VAR10;

CREATE DATABASE VAR10;

USE VAR10;

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS `Экземпляры книг`;
DROP TABLE IF EXISTS `Книги`;
DROP TABLE IF EXISTS `Читательские билеты`;

CREATE TABLE `Читательские билеты` (
    `№ читательского билета` INT NULL,
    `ФИО читателя` VARCHAR(35) NOT NULL,
    `Домашний телефон` VARCHAR(20) NOT NULL,
    `№ группы` VARCHAR(10) NOT NULL,
    PRIMARY KEY(`№ читательского билета`)
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Users\\Student\\Desktop\\workdesk\\SQL_homework\\var10\\LibRead.csv" IGNORE
INTO TABLE `Читательские билеты`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Книги` (
    `ISBN` VARCHAR(35) NOT NULL,
    `ФИО автора` VARCHAR(35) NOT NULL,
    `Название книги` VARCHAR(45) NOT NULL,
    `Год издания` INT NOT NULL,
    `Цена,руб` INT NULL,
    PRIMARY KEY(`ISBN`)
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Users\\Student\\Desktop\\workdesk\\SQL_homework\\var10\\Book.csv" IGNORE
INTO TABLE `Книги`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

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

LOAD DATA INFILE "C:\\Users\\Student\\Desktop\\workdesk\\SQL_homework\\var10\\ExBook.csv" IGNORE
INTO TABLE `Экземпляры книг`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

GRANT ALL ON *.* TO
'headLibrary'@'localhost';
REVOKE DROP, CREATE ON *.* FROM
'headLibrary'@'localhost';

FLUSH PRIVILEGES;

GRANT INSERT, SELECT(`№ читательского билета`) ON `VAR10`.`Читательские билеты` TO
'worker'@'localhost';
GRANT INSERT, SELECT, UPDATE ON `VAR10`.`Читательские билеты` TO
'worker'@'localhost'; 
GRANT INSERT, SELECT ON `VAR10`.`Книги` TO
'worker'@'localhost';
GRANT UPDATE(`Цена,руб`) ON `VAR10`.`Книги` TO
'worker'@'localhost';

CREATE VIEW `Просмотр` AS 
SELECT `Читательские билеты`.`№ читательского билета`, `Читательские билеты`.`ФИО читателя`, `Читательские билеты`.`№ группы`, 
`Книги`.`Название книги`, `Книги`.`Год издания`, `Книги`.`Цена,руб` FROM
((`Читательские билеты` INNER JOIN `Экземпляры книг` ON `Читательские билеты`.`№ читательского билета`=`Экземпляры книг`.`№ читательского билета`) INNER JOIN `Книги`
ON `Экземпляры книг`.`ISBN`=`Книги`.`ISBN`);

GRANT SELECT ON `VAR10`.`Просмотр` TO
'visitor'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'headLibrary'@'localhost';
SHOW GRANTS FOR 'worker'@'localhost';
SHOW GRANTS FOR 'visitor'@'localhost';