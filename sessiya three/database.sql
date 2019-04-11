DROP DATABASE LAB3;

CREATE DATABASE LAB3;
USE LAB3;

DROP TABLE IF EXISTS `Показание счетчиков`;
DROP TABLE IF EXISTS `Арендатор`;
DROP TABLE IF EXISTS `Дом`;

CREATE TABLE `Дом` (
	`Порядковый № дома` INT NOT NULL PRIMARY KEY,
	`Адрес местоположения` VARCHAR(128) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Арендатор` (
	`№ квартиры` INT NOT NULL PRIMARY KEY,
	`Фамилия, имя и отчество квартиросъемщика` VARCHAR(36) NOT NULL,
	`Наличие электроплиты` VARCHAR(3) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `Показание счетчиков` (
	`Порядковый № дома` INT NOT NULL,
	`№ квартиры` INT NOT NULL,
	`Фамилия, имя и отчество квартиросъемщика` VARCHAR(36) NOT NULL,
	`Месяц` INT NOT NULL,
	`День` INT NOT NULL,
	`Ночь` INT NOT NULL,
	FOREIGN KEY (`Порядковый № дома`) REFERENCES `Арендатор`(`№ квартиры`) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`№ квартиры`) REFERENCES `Дом`(`Порядковый № дома`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `Дом`(`Порядковый № дома`, `Адрес местоположения`) VALUES
	(10, 'г.Котельники, Белая дача, д.23'),
	(11, 'г.Котельники, Новая ул., 17б');

INSERT INTO `Арендатор`(`№ квартиры`, `Фамилия, имя и отчество квартиросъемщика`, `Наличие электроплиты`) VALUES
	(1, 'Иванов Иван Степанович', 'нет'),
	(12, 'Кузнецова Елена Семеновна', 'нет'),
	(8, 'Фридман Владимир Григорьевич', 'да');

INSERT INTO `Показание счетчиков`(`Порядковый № дома`, `№ квартиры`, `Фамилия, имя и отчество квартиросъемщика`, `Месяц`, `День`, `Ночь`) VALUES
	

