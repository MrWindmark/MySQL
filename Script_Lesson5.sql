-- ваяю тестовую таблицу
CREATE TABLE IF NOT EXISTS users (
  id SERIAL,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME,
  updated_at DATETIME
);
-- заполняю её в начале 4 тестовыми значениями, обновляю их, а затем добавляю ещё 4 и использую второй метод изменения NULL-строк
INSERT INTO users VALUES (5, 'Test5', NULL, NULL), (6, 'Test6', NULL, NULL), (7, 'Test7', NULL, NULL), (8, 'Test8', NULL, NULL);
-- первый метод
UPDATE users SET created_at = NOW() WHERE created_at <=> NULL;
UPDATE users SET updated_at = NOW() WHERE updated_at <=> NULL;
-- второй метод
UPDATE users SET created_at = NOW(), updated_at = NOW() WHERE created_at IS NULL and updated_at IS NULL;


CREATE TABLE IF NOT EXISTS users2 (
	id INT,
	name VARCHAR (255) NOT NULL UNIQUE,
	created_at VARCHAR(40),
	updated_at VARCHAR(40)
);

INSERT INTO users2 VALUES
	(1, 'One', '20.10.2017 8:10', '20.10.2017 9:10'),
	(2, 'Two', '19.10.2017 8:11', '20.10.2018 9:11'),
	(3, 'Three', '18.10.2017 8:12', '20.10.2019 9:12'),
	(4, 'Four', '17.10.2017 8:13', '20.10.2020 9:13'),
	(5, 'Five', '16.10.2017 8:14', '20.10.2021 9:14'),
	(6, 'Six', '15.10.2017 8:15', '20.10.2022 9:15');
-- формата даты для такого преобразования не нашёл, придётся кромсать
-- UPDATE users2 SET created_at = REPLACE (created_at, '.', '-');
-- UPDATE users2 SET updated_at = REPLACE (updated_at, '.', '-');

TRUNCATE users2;
-- допишем нолики
UPDATE users2 SET created_at = CONCAT(created_at, ':00');
UPDATE users2 SET updated_at = CONCAT(updated_at, ':00');
-- подгоняем строки под нужный вид
UPDATE users2 SET updated_at = CONCAT(	
	SUBSTRING(updated_at, 7, 4), '-',
	SUBSTRING(updated_at, 4, 2), '-',
	SUBSTRING(updated_at, 1, 2),
	SUBSTRING(updated_at, 11, 8) 
);
UPDATE users2 SET created_at = CONCAT(	
	SUBSTRING(created_at, 7, 4), '-',
	SUBSTRING(created_at, 4, 2), '-',
	SUBSTRING(created_at, 1, 2),
	SUBSTRING(created_at, 11, 8) 
);
-- преобразуем "правильные" строки в формат даты
ALTER TABLE users2 MODIFY COLUMN created_at DATETIME;
ALTER TABLE users2 CHANGE COLUMN updated_at updated_at DATETIME;



CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  -- storehouse_id INT UNSIGNED,
  -- product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (id, value) VALUES
	(1, 1500),
	(2, 1700),
	(3, 1750),
	(4, 100),
	(5, 150),
	(6, 0),
	(7, 15),
	(8, 0);
-- честно говоря, я не особо понимаю как это работает, примерно - понимаю, полностью - нет.
SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN (SELECT MAX(value) FROM storehouses_products) ELSE value END;


-- добавляем столбец даты рождения
ALTER TABLE users ADD birthday_at DATE NULL;
-- добавляем данные по дате рождения
UPDATE users SET birthday_at = (NOW() - INTERVAL FLOOR(10 + RAND() * 40) YEAR);
-- считаем среднее значение
SELECT AVG(YEAR(NOW()) - YEAR(birthday_at)) AS avg_user_age FROM users;



