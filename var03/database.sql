/* удаляем пользователей для reload sql-файла. */
DROP USER 'administrator'@'localhost';
DROP USER 'director'@'localhost';
DROP USER 'teacher'@'localhost';
DROP USER 'visitor'@'localhost';

/* создаем пользователей administrator, director, teacher, visitor.
** для первых 3 пользователей задаем пароль для доступа.
*/
CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'director'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'teacher'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'visitor'@'localhost';

/* выдаем права для пользователя администратор(через GRANT) и лишаем некоторые другие(через REVOKE).
** WITH GRANT OPTION - дополнительные права для создания, удаления и модификации других пользователей. 
*/
GRANT ALL PRIVILEGES ON *.* TO
'administrator'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, DROP, UPDATE ON *.* FROM
'administrator'@'localhost';

/* Чтобы сообщить серверу о перезагрузке таблиц предоставления. */
FLUSH PRIVILEGES; 

/* удаляем базу данных для reload sql-файла. */
DROP DATABASE VAR03;

/* создаем базу данных VAR03. */
CREATE DATABASE VAR03;

USE VAR03;

/* удаляем таблицы для reload sql-файла.
** если таблица существует, удаляем её.
*/
DROP TABLE IF EXISTS `Работники школы`;
DROP TABLE IF EXISTS `Школьники`;
DROP TABLE IF EXISTS `Классы`;

/* создаем таблицы.*/
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

/* вбиваем данные для таблиц через INSERT INTO. */
/* указываем название таблицы, а затем в скобках название столбцов, для которых будем задавать значения. */
INSERT INTO `Работники школы`
	(`Табельный № учителя`,
	`ФИО учителя`,
	`Должность/профессия`,
	`Пол`) VALUES /* VALUES - значение */
	/* задаем данные для столбцов в строгой последовательности, как они идут 70-73 строчках! */
	(100, 'Петров Станислав Васильевич', 'Учитель', 'М'), 
	(101, 'Петрова Валентина Григорьевна', 'Учитель', 'Ж'),
	(102, 'Рыбакова Анна Ивановна', 'Завуч', 'Ж'),
	(103, 'Федоров Юрий Васильевич', 'Директор', 'М'),
	(104, 'Смирнов Антон Юрьевич', 'Учитель', 'М');

INSERT INTO `Классы` 
	(`№ класса`,
	`Табельный № учителя`,
	`Специализация класса`,
	`Классная комната`) VALUES
	('10А', 101, 'Иностранные языки (английский и немецкий)', 203),
	('11Б', 100, 'Математика и физика', 212);

INSERT INTO `Школьники`
	(`№ класса`,
	`Порядковый № в журнале`,
	`ФИО школьника`,
	`Пол`) VALUES
	('10А', 1, 'Иванов Сергей Петрович', 'М'),
	('10А', 2, 'Костин Петр Васильевич', 'М'),
	('10А', 3, 'Матросова Елена Ивановна', 'Ж'),
	('11Б', 1, 'Богданов Юрий Степанович', 'М'),
	('11Б', 2, 'Потапов Юлия Петровна', 'Ж'),
	('11Б', 3, 'Сорокина Ольга Петровна', 'Ж'),
	('11Б', 4, 'Сидоров Андрей Петрович', 'М');

/* Виртуальное представление `Просмотр`. */
CREATE VIEW `Просмотр` AS 
SELECT `Школьники`.`№ класса`, `Школьники`.`Порядковый № в журнале`, `Школьники`.`ФИО школьника`, `Работники школы`.`ФИО учителя`, `Классы`.`Специализация класса` FROM 
(( `Школьники` INNER JOIN `Классы` ON 
`Школьники`.`№ класса`=`Классы`.`№ класса`) INNER JOIN
`Работники школы` ON 
`Классы`.`Табельный № учителя`=`Работники школы`.`Табельный № учителя`);

/* Выдаем права просмотра на таблицу Просмотр пользователю visitor. */
GRANT SELECT ON `VAR03`.`Просмотр` TO
'visitor'@'localhost';

FLUSH PRIVILEGES;

/* задаем права для пользователя director. */
GRANT ALL PRIVILEGES ON `VAR03`.* TO
'director'@'localhost' WITH GRANT OPTION;
REVOKE CREATE, ALTER, DROP ON `VAR03`.* FROM
'director'@'localhost';

FLUSH PRIVILEGES;

/* задаем права для пользователя teacher. */
GRANT SELECT ON `VAR03`.`Работники школы` TO
'teacher'@'localhost';
GRANT INSERT, SELECT ON `VAR03`.`Классы` TO
'teacher'@'localhost';
GRANT INSERT, SELECT ON `VAR03`.`Школьники` TO
'teacher'@'localhost';
/* насчет удаления и модификации пока не разобрался. */
FLUSH PRIVILEGES;

/* запрос для просмотра прав доступа конкретных пользователей. */
SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'director'@'localhost';
SHOW GRANTS FOR 'teacher'@'localhost';
SHOW GRANTS FOR 'visitor'@'localhost';