DROP USER 'administration'@'localhost';
DROP USER 'director'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administration'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'director'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'worker'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO
'administration'@'localhost' WITH GRANT OPTION;
REVOKE DROP, CREATE ON *.* FROM
'administration'@'localhost';
GRANT CREATE, DROP ON `LAB2`.* TO
'administration'@'localhost';

FLUSH PRIVILEGES;

DROP DATABASE LAB2;

CREATE DATABASE LAB2;
USE LAB2;

CREATE TABLE `Тренеры спортивной школы` (
    `Табельный № тренера` INT NOT NULL,
    `ФИО работника` VARCHAR(35) NOT NULL,
    `Должность` VARCHAR(35) NOT NULL,
    `Оклад,руб` INT NOT NULL,
    PRIMARY KEY(`Табельный № тренера`)
) ENGINE=InnoDB;

CREATE TABLE `Спортивные секции` (
    `№ секции` VARCHAR(2) NOT NULL,
    `Название секции` VARCHAR(20) NOT NULL,
    `Табельный № тренера` INT NOT NULL,
    PRIMARY KEY(`№ секции`),
    FOREIGN KEY(`Табельный № тренера`) 
    REFERENCES `Тренеры спортивной школы`(`Табельный № тренера`)
    ON DELETE NO ACTION 
    ON UPDATE CASCADE  
) ENGINE=InnoDB;

CREATE TABLE `Спортсмены` (
    `№ порядковый спортсмена` INT NOT NULL,
    `ФИО спортсмена` VARCHAR(35) NOT NULL,
    `Дата рождения` VARCHAR(15) NOT NULL,
    `№ секции` VARCHAR(2) NOT NULL,
    PRIMARY KEY(`№ порядковый спортсмена`),
    FOREIGN KEY(`№ секции`)
    REFERENCES `Спортивные секции`(`№ секции`)
    ON DELETE NO ACTION 
    ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `Тренеры спортивной школы`
    (`Табельный № тренера`,
    `ФИО работника`,
    `Должность`,
    `Оклад,руб`) VALUES
    (102, 'Фролова Н.Г', 'Тренер', 27000),
    (110, 'Фирсов М.В', 'Тренер', 27000),
    (108, 'Самохина В.П', 'Ст.тренер', 32000),
    (120, 'Фурманов Н.И', 'Директор спортивной школы', 48000);

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
    (1006, 'Фролов Артур', '2008-12-31', 'Н'),
    (1007, 'Федорова Ирина', '2009-09-12', 'Б'),
    (1008, 'Симонова Света', '2008-06-22', 'Б');
 
GRANT INSERT, SELECT ON `LAB2`.`Спортивные секции` TO
'worker'@'localhost';
GRANT UPDATE(`Табельный № тренера`) ON `LAB2`.`Спортивные секции` TO
'worker'@'localhost';
GRANT INSERT, SELECT, UPDATE, DELETE ON `LAB2`.`Спортсмены` TO
'worker'@'localhost';
GRANT INSERT, UPDATE, SELECT ON `LAB2`.`Тренеры спортивной школы` TO
'worker'@'localhost';
REVOKE UPDATE(`Оклад,руб`) ON `LAB2`.`Тренеры спортивной школы` FROM
'worker'@'localhost';

FLUSH PRIVILEGES;

CREATE VIEW `Просмотр` AS
SELECT `Спортивные секции`.`Название секции`, 
`Тренеры спортивной школы`.`Должность`, 
`Тренеры спортивной школы`.`ФИО работника`,
`Спортсмены`.`ФИО спортсмена`,
`Спортсмены`.`Дата рождения` FROM
((`Спортивные секции` INNER JOIN 
`Тренеры спортивной школы` ON 
`Спортивные секции`.`Табельный № тренера`=`Тренеры спортивной школы`.`Табельный № тренера`) INNER JOIN
`Спортсмены` ON `Спортивные секции`.`№ секции`=`Спортсмены`.`№ секции`);

GRANT SELECT ON `LAB2`.`Просмотр` TO
'visitor'@'localhost';

FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON *.* TO
'director'@'localhost';
REVOKE DROP, CREATE, ALTER ON *.* FROM
'director'@'localhost';

FLUSH PRIVILEGES;
