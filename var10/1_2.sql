CREATE TABLE `Работники школы` (
    `Табельный № учителя` INT NOT NULL PRIMARY KEY, 
    `ФИО учителя` VARCHAR(30) NOT NULL,
    `Должность/профессия` VARCHAR(15) NOT NULL,
    `Пол` VARCHAR(3) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Классы` (
	`№ класса` VARCHAR(5) NOT NULL PRIMARY KEY,
	`Табельный № учителя` INT NOT NULL,
	`Специализация класса` VARCHAR(50) NOT NULL,
	`Классная комната` INT NOT NULL,
	FOREIGN KEY(`Табельный № учителя`) REFERENCES `Работники школы`(`Табельный № учителя`) 
	ON DELETE NO ACTION 
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Школьники` (
	`№ класса` VARCHAR(5) NOT NULL,
	`Порядковый № в журнале` INT NOT NULL,
	`ФИО школьника` VARCHAR(50) NOT NULL,
	`Пол` VARCHAR(3) NOT NULL,
	FOREIGN KEY(`№ класса`) REFERENCES `Классы`(`№ класса`) 
	ON DELETE NO ACTION 
    ON UPDATE CASCADE
) ENGINE=InnoDB;