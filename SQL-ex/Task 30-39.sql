--Задание 30. В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз
--(первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату
--выполнения операций будет соответствовать одна строка.
--Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc).
--Отсутствующие значения считать неопределенными (NULL).
SELECT point, [date], SUM(outs), SUM(incs)
FROM (SELECT point, [date], SUM(out) outs, null incs FROM Outcome
GROUP BY point, [date]
UNION
SELECT point, [date], null, SUM(inc) FROM Income
GROUP BY point, [date]) table
GROUP BY point, [date];


--Задание 31. Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
SELECT class, country
FROM Classes
WHERE bore >= 16;


--Задание 32. Одной из характеристик корабля является половина куба калибра его главных орудий (mw). 
--С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных.
SELECT country, CAST(AVG(POWER(bore, 3) / 2) AS DECIMAL(6,2)) weight
FROM(
SELECT country, bore, name
FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT country, bore, ship
FROM Classes JOIN Outcomes ON class = ship) table
GROUP BY country;



--Задание 33. Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
SELECT ship
FROM Outcomes
WHERE result = 'sunk' AND battle = 'North Atlantic';



--Задание 34. По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн.
--Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду).
--Вывести названия кораблей.
SELECT name
FROM(SELECT name, type, launched, displacement
FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT ship, type, null, displacement
FROM Classes JOIN outcomes ON class = ship) table
WHERE type = 'bb' AND launched IS NOT NULL AND launched >= 1922 AND displacement > 35000;


--Задание 35. В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
--Вывод: номер модели, тип модели.
SELECT model, type
FROM Product
WHERE model NOT LIKE '%[^0-9]%' OR MODEL NOT LIKE '%[^a-z]%';


--Задание 36. Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
SELECT name
FROM(SELECT name
FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT ship
FROM Outcomes JOIN Classes ON class = ship) table
WHERE name IN (SELECT class FROM classes);


--Задание 37. Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
SELECT class FROM(
SELECT class, COUNT(name) qty
FROM(SELECT Classes.class, name FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT class, ship FROM Classes JOIN Outcomes ON class = ship)
table
GROUP BY class
HAVING COUNT(*) = 1
)table_2;


--Задание 38. Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').
SELECT country
FROM Classes
WHERE type = 'bb'
INTERSECT
SELECT country
FROM Classes
WHERE type = 'bc';


--Задание 39. Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged),
--они участвовали в другой, произошедшей позже.
SELECT DISTINCT ship
FROM(
SELECT ship, result, [date] FROM Outcomes JOIN Battles bat ON battle = name
WHERE result = 'damaged' AND ship IN (SELECT ship FROM Outcomes JOIN Battles ON battle = name WHERE bat.[date] < battles.[date])
) table_1
