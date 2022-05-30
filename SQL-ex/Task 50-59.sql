--Задание 50. Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
SELECT DISTINCT battle
FROM Outcomes
WHERE ship IN(SELECT name FROM Ships WHERE class = 'Kongo')


--Задание 51. Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей такого же водоизмещения
--(учесть корабли из таблицы Outcomes).
SELECT name FROM(
SELECT name, numGuns, displacement
FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT ship, numGuns, displacement
FROM Classes JOIN Outcomes ON class = ship
) table_1 JOIN (
SELECT MAX(numGuns) numGuns, displacement FROM(
SELECT name, numGuns, displacement
FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT ship, numGuns, displacement
FROM Classes JOIN Outcomes ON class = ship
) table_2 GROUP BY displacement
) table_3 ON table_1.numGuns = table_3.numGuns AND table_1.displacement = table_3.displacement


--Задание 52. Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
--имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн
SELECT DISTINCT name FROM(
SELECT  CASE
WHEN (type = 'bb' OR type IS NULL)
AND (country = 'Japan' OR country IS NULL)
AND (numGuns >= 9 OR numGuns IS NULL)
AND (bore < 19 OR bore IS NULL)
AND (displacement <= 65000 OR displacement IS NULL)
THEN NAME 
END name 
FROM(
SELECT name, type, country, numGuns, bore, displacement
FROM Classes JOIN Ships ON Classes.class = Ships.class
) table_1
) table_2 WHERE name IS NOT NULL


--Задание 53. Определите среднее число орудий для классов линейных кораблей.
--Получить результат с точностью до 2-х десятичных знаков.
SELECT CAST(AVG(numGuns*1.0) AS NUMERIC(4,2)) AS AVG_numGuns
FROM Classes
WHERE type = 'bb'


--Задание 54. С точностью до 2-х десятичных знаков определите среднее число орудий всех линейных кораблей
--(учесть корабли из таблицы Outcomes).
SELECT CAST(AVG(numGuns*1.0) AS NUMERIC(6,2)) Avg_numG
FROM(
SELECT name, type, numGuns 
FROM Classes JOIN Ships ON Classes.class = Ships.class
WHERE type = 'bb'
UNION
SELECT ship, type, numGuns 
FROM Classes JOIN Outcomes ON ship = class
WHERE type = 'bb'
) table_1


--Задание 55. Для каждого класса определите год, когда был спущен на воду первый корабль этого класса.
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса.
--Вывести: класс, год.
SELECT Classes.class, MIN(launched) FROM Classes LEFT JOIN(
SELECT class, launched
FROM Outcomes FULL JOIN Ships ON name = ship
) table_1 ON Classes.class = table_1.class
GROUP BY Classes.class


--Задание 56. Для каждого класса определите число кораблей этого класса, потопленных в сражениях.
--Вывести: класс и число потопленных кораблей.
SELECT classes.class, COUNT(name)
FROM Classes LEFT JOIN(
SELECT Classes.class, name
FROM Classes JOIN Ships ON Classes.class = Ships.class
WHERE name IN(SELECT ship FROM Outcomes WHERE result = 'sunk')
UNION
SELECT class, ship 
FROM Classes JOIN Outcomes ON class = ship
WHERE result = 'sunk'
) table_1 ON Classes.class = table_1.class
GROUP BY Classes.class


--Задание 57. Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных.
--Вывести имя класса и число потопленных кораблей.
SELECT class, COUNT(name) sunken FROM(
SELECT Classes.class, name
FROM Classes JOIN Ships ON Classes.class = Ships.class
WHERE name IN(SELECT ship FROM Outcomes WHERE result = 'sunk')
UNION
SELECT class, ship 
FROM Classes JOIN Outcomes ON class = ship
WHERE result = 'sunk'
) table_1 WHERE class IN(
SELECT class 
FROM(
SELECT Classes.class, name
FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT class, ship 
FROM Classes JOIN Outcomes ON class = ship
) table_2
GROUP BY class
HAVING COUNT(*) >= 3
) GROUP BY class


--Задание 58. Для каждого типа продукции и каждого производителя из таблицы Product c точностью до двух десятичных знаков,
--найти процентное отношение числа моделей данного типа данного производителя к общему числу моделей этого производителя.
--Вывод: maker, type, процентное отношение числа моделей данного типа к общему числу моделей производителя
WITH skelet AS(
SELECT maker, type
FROM (SELECT DISTINCT maker FROM Product) maker,
(SELECT DISTINCT type FROM Product) type
), kosti AS(
SELECT Product.maker, type, CAST((CAST(COUNT(model) AS NUMERIC)/AVG(knigga.cnt)*100) AS NUMERIC(37,2)) AS prc
FROM Product INNER JOIN (SELECT maker, COUNT(model) as cnt FROM Product GROUP BY maker) knigga ON Product.maker = knigga.maker
GROUP BY Product.maker, type
)
SELECT skelet.maker, skelet.type, COALESCE(prc, 0) AS prc
FROM skelet LEFT JOIN kosti ON skelet.maker = kosti.maker AND skelet.type = kosti.type


--Задание 59. Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день.
--Вывод: пункт, остаток.
SELECT point, SUM(Remain) as remain FROM(
SELECT point, SUM(inc) as Remain
FROM Income_o 
GROUP BY point
UNION
SELECT point, -SUM(out) as Remain
FROM Outcome_o
GROUP BY point
) table_1
GROUP BY point
