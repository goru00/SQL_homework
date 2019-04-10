DROP USER 'administrator'@'localhost';
DROP USER 'dean'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'dean'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'worker'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO
'administrator'@'localhost';
REVOKE CREATE, DROP, ALTER ON *.* FROM
'administrator'@'localhost';

FLUSH PRIVILEGES;

DROP DATABASE VAR08;

CREATE DATABASE VAR08;
USE VAR08;

DROP TABLE IF EXISTS `Успеваемость студентов`;
DROP TABLE IF EXISTS `Студенты`;
DROP TABLE IF EXISTS `Предметы(дисциплины)`;

CREATE TABLE `Студенты` (
	`№ зачетки` INT NOT NULL PRIMARY KEY,
	`ФИО студента` VARCHAR(25) NOT NULL,
	`№ группы` VARCHAR(10) NOT NULL 
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\stuyd.csv" IGNORE
INTO TABLE `Студенты`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Предметы(дисциплины)` (
	`Код дисциплины` VARCHAR(4) NOT NULL PRIMARY KEY,
	`Название дисциплины` VARCHAR(20) NOT NULL,
	`Семестр` INT NOT NULL,
	`Лекций` INT NULL,
	`Семинаров` INT NULL,
	`Экзамен` VARCHAR(2) NULL,
	`Зачет` VARCHAR(2) NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\classwork.csv" IGNORE
INTO TABLE `Предметы(дисциплины)`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Успеваемость студентов` (
	`Код дисциплины` VARCHAR(4) NOT NULL,
	`№ зачетки` INT NOT NULL,
	`Дата сдачи` VARCHAR(12) NOT NULL,
	`Оценка` VARCHAR(10) NOT NULL,
	FOREIGN KEY (`Код дисциплины`) REFERENCES `Предметы(дисциплины)`(`Код дисциплины`) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`№ зачетки`) REFERENCES `Студенты`(`№ зачетки`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\records.csv" IGNORE
INTO TABLE `Успеваемость студентов`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

GRANT ALL PRIVILEGES ON *.* TO
'dean'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, DROP, ALTER ON *.* FROM
'dean'@'localhost';

FLUSH PRIVILEGES;

GRANT INSERT, SELECT(`№ зачетки`) ON `VAR08`.`Студенты` TO
'worker'@'localhost';
GRANT INSERT, SELECT, UPDATE ON `VAR08`.`Студенты` TO
'worker'@'localhost';
GRANT INSERT, SELECT ON `VAR08`.`Предметы(дисциплины)` TO
'worker'@'localhost';
GRANT INSERT, SELECT(`Оценка`) ON `VAR08`.`Успеваемость студентов` TO
'worker'@'localhost';
GRANT INSERT, SELECT, UPDATE ON `VAR08`.`Успеваемость студентов` TO
'worker'@'localhost';

FLUSH PRIVILEGES;

CREATE VIEW `Просмотр` AS
SELECT `Студенты`.`№ зачетки`, `Студенты`.`ФИО студента`, `Предметы(дисциплины)`.`Название дисциплины`, `Предметы(дисциплины)`.`Семестр`,
`Успеваемость студентов`.`Дата сдачи` FROM
((`Студенты` INNER JOIN `Успеваемость студентов` ON `Студенты`.`№ зачетки`=`Успеваемость студентов`.`№ зачетки`) INNER JOIN `Предметы(дисциплины)` 
ON `Успеваемость студентов`.`Код дисциплины`=`Предметы(дисциплины)`.`Код дисциплины`);

GRANT SELECT ON `VAR08`.`Просмотр` TO
'visitor'@'localhost';

FLUSH PRIVILEGES;