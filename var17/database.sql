DROP USER 'director'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'administrator'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'director'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'worker'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'administrator'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO
'administrator'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, ALTER, DROP, DELETE ON *.* FROM
'administrator'@'localhost';

FLUSH PRIVILEGES;

DROP DATABASE VAR17;

CREATE DATABASE VAR17;
USE VAR17;

DROP TABLE IF EXISTS `Распределение мест`;
DROP TABLE IF EXISTS `Гонщики`;
DROP TABLE IF EXISTS `Автомобильные трассы`;

CREATE TABLE `Автомобильные трассы` (
	`№ трассы` VARCHAR(4) NOT NULL PRIMARY KEY,
	`Месторасположение трассы` VARCHAR(30) NOT NULL, /* row - 12 */
	`Протяженность, км` INT NOT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\tracerace.csv" IGNORE
INTO TABLE `Автомобильные трассы`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Гонщики` (
	`№ водителя` INT NOT NULL PRIMARY KEY,
	`ФИО водителя` VARCHAR(28) NOT NULL, /* row - 11 */
	`Марка автомобиля` VARCHAR(20) NOT NULL /* row - 8 */
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\races.csv" IGNORE
INTO TABLE `Гонщики`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Распределение мест` (
	`№ трассы` VARCHAR(4) NOT NULL,
	`№ водителя` INT NOT NULL,
	`Время прохождения трассы, мин` INT NOT NULL,
	FOREIGN KEY (`№ трассы`) REFERENCES `Автомобильные трассы`(`№ трассы`) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`№ водителя`) REFERENCES `Гонщики`(`№ водителя`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\changeloc.csv" IGNORE
INTO TABLE `Распределение мест`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

GRANT ALL PRIVILEGES ON *.* TO
'director'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, ALTER, DROP ON *.* FROM
'director'@'localhost';

FLUSH PRIVILEGES;

GRANT INSERT, UPDATE, SELECT, DELETE ON `VAR17`.`Автомобильные трассы` TO
'worker'@'localhost';
GRANT SELECT, INSERT ON `VAR17`.`Гонщики` TO
'worker'@'localhost';
GRANT UPDATE(`ФИО водителя`) ON `VAR17`.`Гонщики` TO
'worker'@'localhost';
GRANT SELECT, INSERT(`Время прохождения трассы, мин`) ON `VAR17`.`Распределение мест` TO
'worker'@'localhost';
GRANT INSERT, SELECT, UPDATE ON `VAR17`.`Распределение мест` TO
'worker'@'localhost';

FLUSH PRIVILEGES;

CREATE VIEW `Просмотр` AS
SELECT `Распределение мест`.`№ трассы`, `Автомобильные трассы`.`Месторасположение трассы`, `Автомобильные трассы`.`Протяженность, км`, `Гонщики`.`ФИО водителя`,
`Гонщики`.`Марка автомобиля`, `Распределение мест`.`Время прохождения трассы, мин` FROM ((`Распределение мест` INNER JOIN
`Автомобильные трассы` ON `Распределение мест`.`№ трассы`=`Автомобильные трассы`.`№ трассы`) INNER JOIN `Гонщики` ON `Распределение мест`.`№ водителя`=`Гонщики`.`№ водителя`);

GRANT SELECT ON `VAR17`.`Просмотр` TO
'visitor'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'worker'@'localhost';
SHOW GRANTS FOR 'visitor'@'localhost';
SHOW GRANTS FOR 'director'@'localhost';

