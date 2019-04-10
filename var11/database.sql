
DROP USER 'administrator'@'localhost';
DROP USER 'director'@'localhost';
DROP USER 'worker'@'localhost';
DROP USER 'visitor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'director'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'worker'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'visitor'@'localhost';

GRANT ALL PRIVILEGES ON `VAR11`.* TO
'administrator'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, DROP ON *.* FROM
'administrator'@'localhost'; 

FLUSH PRIVILEGES;

DROP DATABASE VAR11;

CREATE DATABASE VAR11;
USE VAR11;

DROP TABLE IF EXISTS `Ингредиенты`;
DROP TABLE IF EXISTS `Продукты`;
DROP TABLE IF EXISTS `Рецепты блюд`;

CREATE TABLE `Продукты` (
	`№ позиции` INT NOT NULL PRIMARY KEY,
	`Наименование продукта` VARCHAR(20) NOT NULL, /* row - 6 */
	`Единицы измерения` VARCHAR(10) NOT NULL /* row - 4 */
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Producti.csv" IGNORE
INTO TABLE `Продукты`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Рецепты блюд` (
	`№ рецепта` INT NOT NULL PRIMARY KEY,
	`Название блюда` VARCHAR(25) NOT NULL /* row - 7 */
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Recepti_blud.csv" IGNORE
INTO TABLE `Рецепты блюд`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

CREATE TABLE `Ингредиенты` (
	`№ рецепта` INT NOT NULL,
	`Номенклатурный №` INT NOT NULL,
	`Количество` INT NOT NULL,
	FOREIGN KEY (`№ рецепта`) REFERENCES `Рецепты блюд`(`№ рецепта`) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (`Номенклатурный №`) REFERENCES `Продукты` (`№ позиции`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

LOAD DATA INFILE "C:\\Ingridienti.csv" IGNORE
INTO TABLE `Ингредиенты`
COLUMNS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY ""
ESCAPED BY ""
LINES TERMINATED BY '\r\n';

GRANT ALL PRIVILEGES ON *.* TO
'director'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, DELETE, ALTER, DROP ON *.* FROM
'director'@'localhost';
GRANT ALL PRIVILEGES ON `VAR11`.* TO
'director'@'localhost';
REVOKE CREATE, DROP, ALTER ON `VAR11`.* FROM
'director'@'localhost';

FLUSH PRIVILEGES;

GRANT INSERT, SELECT, UPDATE ON `VAR11`.`Продукты` TO
'worker'@'localhost';
GRANT UPDATE, SELECT, INSERT ON `VAR11`.`Рецепты блюд` TO
'worker'@'localhost';
REVOKE UPDATE(`№ рецепта`) ON `VAR11`.`Рецепты блюд` FROM
'worker'@'localhost';
GRANT SELECT, INSERT ON `VAR11`.`Ингредиенты` TO
'worker'@'localhost';
GRANT UPDATE(`Количество`) ON `VAR11`.`Ингредиенты` TO
'worker'@'localhost';

FLUSH PRIVILEGES;

CREATE VIEW `Просмотр` AS
SELECT `Рецепты блюд`.`Название блюда`,`Продукты`.`Наименование продукта`,`Продукты`.`Единицы измерения`, `Ингредиенты`.`Количество` FROM
(( `Рецепты блюд` INNER JOIN `Ингредиенты` ON `Рецепты блюд`.`№ рецепта`=`Ингредиенты`.`№ рецепта`) INNER JOIN 
`Продукты` ON `Ингредиенты`.`Номенклатурный №`=`Продукты`.`№ позиции`);

GRANT SELECT ON `VAR11`.`Просмотр` TO
'visitor'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'director'@'localhost';
SHOW GRANTS FOR 'worker'@'localhost';
SHOW GRANTS FOR 'visitor'@'localhost';