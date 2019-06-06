CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'director'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'worker'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILIGIES ON *.* TO
'administrator'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, DROP ON *.* FROM 
'administrator'@'localhost';
GRANT CREATE, DROP `VAR18`.* TO
'administrator'@'localhost';

DROP DATABASE `VAR18`;

CREATE DATABASE `VAR18`;
USE `VAR18`;

DROP TABLE IF EXISTS `Спортсмены`;
DROP TABLE IF EXISTS `Спортивные секции`;
DROP TABLE IF EXISTS `Тренеры спортивной школы`;

CREATE TABLE `Тренеры спортивной школы` (
    `Табельный № тренера` INT NOT NULL,
    `ФИО работника` VARCHAR(35) NOT NULL,
    `Должность` VARCHAR(20) NOT NULL,
    `Оклад,руб` INT NOT NULL,
    PRIMARY KEY(`Табельный № тренера`)
) ENGINE=InnoDB;

CREATE TABLE `Спортивные секции` (
    `№ секции` VARCHAR(5) NOT NULL,
    `Название секции` VARCHAR(25) NOT NULL,
    `Табельный № тренера` INT NOT NULL,
    PRIMARY KEY(`№ секции`),
    CONSTRAINT FOREIGN KEY(`Табельный № тренера`) REFERENCES `Тренеры спортивной школы`(`Табельный № тренера`)
    ON DELETE NO ACTION 
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Спортсмены` (
    `№ порядковый спортсмена` INT NOT NULL,
    `ФИО спортсмена` VARCHAR(35) NOT NULL,
    `Дата рождения` VARCHAR(15) NOT NULL,
    `№ секции` VARCHAR(5) NOT NULL,
    PRIMARY KEY(`№ порядковый спортсмена`),
    CONSTRAINT FOREIGN KEY(`№ секции`) REFERENCES `Спортивные секции`(`№ секции`) 
    ON DELETE NO ACTION 
	ON UPDATE CASCADE
) ENGINE=InnoDB, AUTO_INCREMENT=1001;

GRANT ALL PRIVILEGIES ON `VAR18`.* TO
'director'@'localhost';
REVOKE CREATE, DROP, ALTER ON *.* TO
'director'@'localhost';

GRANT INSERT, SELECT, UPDATE ON `VAR18`.`Тренеры спортивной школы` TO
'worker'@'localhost';
REVOKE UPDATE(`Оклад,руб`) ON `VAR18`.`Тренеры спортивной школы` FROM
'worker'@'localhost';
GRANT INSERT, SELECT ON `VAR18`.`Спортивные секции` TO
'worker'@'localhost';
GRANT UPDATE(`Табельный № тренера`) ON `VAR18`.`Табельный № тренера` TO
'worker'@'localhost';
GRANT INSERT, SELECT, UPDATE, DELETE `VAR18`.`Спортсмены` TO
'worker'@'localhost';

INSERT INTO `Тренеры спортивной школы`
    (`Табельный № тренера`,
    `ФИО работника`,
    `Должность`,
    `Оклад,руб`) VALUES
    (102, 'Фролова Н.Г', 'Тренер', 27000),
    (110, 'Фирсов М.В', 'Тренер', 27000),
    (108, 'Самохина В.П', 'Ст.тренер', 32000),
    (120, 'Фурманова Н.И', 'Директор спортивной школы', 48000);

INSERT INTO `Спортивные секции` 
    (`№ секции`,
    `Название секции`, 
    `Табельный № тренера`) VALUES
    ('В', 'Волейбол', 102),
    ('Ш', 'Шахматы', 110),
    ('Н', 'Настольный теннис', 108),
    ('Б', 'Баскетбол', 102);

INSERT INTO `Спортсмены` 
    (`№ порядковый спортсмена`,
    `ФИО спортсмена`,
    `Дата рождения`,
    `№ секции`) VALUES
    (1001, 'Иванов Алексей', '2009-10-30', 'В'),
    (1002, 'Сидорова Наталья', '2008-02-27', 'В'),
    (1003, 'Сидорова Ольга', '2008-02-27', 'В'),
    (1004, 'Петров Артем', '2006-07-23', 'Ш'),
    (1005, 'Цукерман Артур', '2005-04-21', 'Ш'),
    (1006, 'Фролов Антон', '2008-12-31', 'Н'),
    (1007, 'Федорова Ирина', '2009-09-12', 'Б'),
    (1008, 'Симонова Света', '2008-06-22', 'Б');

CREATE VIEW `Просмотр` AS
SELECT `Спортивные секции`.`Название секции`,
`Тренеры спортивной школы`.`Должность`,
`Тренеры спортивной школы`.`ФИО работника`,
`Спортсмены`.`ФИО спортсмена`,
`Спортсмены`.`Дата рождения` FROM
((`Спортивные секции` INNER JOIN `Спортсмены` ON `Спортивные секции`.`№ секции`=`Спортсмены`.`№ секции`) INNER JOIN
`Тренеры спортивной школы` ON `Тренеры спортивной школы`.`Табельный № тренера`=`Спортивные секции`.`Табельный № тренера`);