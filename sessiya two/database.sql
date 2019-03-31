
DROP USER 'administrator'@'localhost';
DROP USER 'director'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'director'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'worker'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO
'administrator'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, ALTER, DROP, UPDATE ON *.* FROM
'administrator'@'localhost';

DROP DATABASE LAB2;

CREATE DATABASE LAB2;
USE LAB2;

DROP TABLE IF EXISTS `Книги`;
DROP TABLE IF EXISTS `Авторы`;
DROP TABLE IF EXISTS `Издательства`;

CREATE TABLE `Издательства` (
    `Порядковый № издательства` INT NOT NULL PRIMARY KEY, 
    `Название издательства` VARCHAR(30) NOT NULL,
    `Город` VARCHAR(15) NOT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Redactor.csv" IGNORE
INTO TABLE `Издательства`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Авторы` (
    `Порядковый № автора` INT NOT NULL, 
    `ФИО автора` VARCHAR(60) NOT NULL,
    `Пол` VARCHAR(3) NOT NULL, 
    `Дата рождения` VARCHAR(14) NOT NULL,
    PRIMARY KEY(`Порядковый № автора`)
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Author.csv" IGNORE
INTO TABLE `Авторы`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Книги` (
    `ISBN` VARCHAR(25) NOT NULL PRIMARY KEY, /* row - 10 */
    `Порядковый № автора` INT NOT NULL,
    `Название книги` VARCHAR(25) NOT NULL,
    `Порядковый № издательства` INT NOT NULL,
    `Год издания` INT NOT NULL,
    `Цена` INT NOT NULL,
	FOREIGN KEY (`Порядковый № автора`) REFERENCES `Авторы` (`Порядковый № автора`) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`Порядковый № издательства`) REFERENCES `Издательства`(`Порядковый № издательства`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Knigi.csv" IGNORE
INTO TABLE `Книги`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE VIEW `Просмотр` AS 
SELECT `Авторы`.`ФИО автора`, `Книги`.`Название книги`, `Издательства`.`Название издательства`, `Издательства`.`Город`, `Книги`.`Год издания`, `Книги`.`Цена` from 
(( `Авторы` INNER JOIN `Книги` ON `Авторы`.`Порядковый № автора`=`Книги`.`Порядковый № автора`) INNER JOIN
`Издательства` ON `Книги`.`Порядковый № издательства`=`Издательства`.`Порядковый № издательства`);

GRANT ALL PRIVILEGES ON `LAB2`.* TO
'director'@'localhost';
REVOKE CREATE ON `LAB2`.* FROM
'director'@'localhost';

GRANT SELECT ON `LAB2`.`Просмотр` TO
'visitor'@'localhost';

GRANT UPDATE, INSERT, SELECT ON `LAB2`.`Книги` TO
'worker'@'localhost';
REVOKE UPDATE(`Цена`) ON `LAB2`.`Книги` FROM
'worker'@'localhost';
GRANT SELECT, INSERT ON `LAB2`.`Авторы` TO
'worker'@'localhost';
GRANT UPDATE(`Порядковый № автора`) ON `LAB2`.`Авторы` TO
'worker'@'localhost';
GRANT INSERT, SELECT, UPDATE, DELETE ON `LAB2`.`Издательства` TO
'worker'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'director'@'localhost';
SHOW GRANTS FOR 'worker'@'localhost';
SHOW GRANTS FOR 'visitor'@'localhost';

