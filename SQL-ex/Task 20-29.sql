--Задание 20. Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
SELECT maker, COUNT(model) AS число_моделей_ПК
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3;


--Задание 21. Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
--Вывести: maker, максимальная цена.
SELECT maker, MAX(PC.price) AS максимальная_цена
FROM PC INNER JOIN 
Product ON PC.model = Product.model
GROUP BY maker;


--Задание 22. Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью.
--Вывести: speed, средняя цена.
SELECT speed, AVG(price) AS средняя_цена
FROM PC
WHERE speed > 600
GROUP BY speed


--Задание 23. Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц,
--так и ПК-блокноты со скоростью не менее 750 МГц.
--Вывести: Maker
SELECT DISTINCT Product.maker
FROM Product INNER JOIN
PC ON Product.model = PC.model
WHERE speed >= 750
INTERSECT
SELECT DISTINCT Product.maker
FROM Product INNER JOIN
Laptop ON Product.model = Laptop.model
WHERE speed >= 750;


--Задание 24. Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
WITH LuL AS (
SELECT model, price
FROM PC
UNION ALL
SELECT model, price
FROM Laptop
UNION ALL
SELECT model, price
FROM Printer)
SELECT DISTINCT model
FROM LuL
WHERE price=(SELECT MAX(Price) from LuL)


--Задание 25. Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и
--с самым быстрым процессором среди всех ПК,имеющих наименьший объем RAM. Вывести: Maker
SELECT DISTINCT maker
FROM Product INNER JOIN 
PC ON Product.model = PC.model
WHERE ram IN (SELECT MIN(ram) FROM PC) AND speed IN (SELECT MAX(speed) FROM PC WHERE ram IN (SELECT MIN(ram) FROM PC))
INTERSECT
SELECT maker
FROM Product
WHERE type = 'Printer';


--Задание 26. Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква).
--Вывести: одна общая средняя цена.
WITH kek AS(
SELECT price, maker
FROM PC INNER JOIN 
Product ON PC.model = Product.model
UNION ALL
SELECT price, maker
FROM Laptop INNER JOIN 
Product ON Laptop.model = Product.model)
SELECT AVG(price) AS одна_общая_средняя_цена
FROM kek
WHERE maker = 'A';


--Задание 27. Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры.
--Вывести: maker, средний размер HD.
SELECT maker, AVG(hd) AS Avg_hd
FROM PC INNER JOIN Product ON
Product.model = PC.model
WHERE maker IN (SELECT maker
FROM Product
WHERE type = 'Printer')
GROUP BY maker;


--Задание 28. Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
SELECT COUNT(maker) AS qty
FROM (SELECT maker
FROM Product
GROUP BY maker
HAVING COUNT(*) = 1) AS table


--Задание 29. В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день
--[т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход).
--Использовать таблицы Income_o и Outcome_o.
SELECT Income_o.point, Income_o.date, inc, out
FROM Income_o LEFT JOIN
Outcome_o ON Outcome_o.point = Income_o.point AND Outcome_o.date = Income_o.date
UNION
SELECT Outcome_o.point, Outcome_o.date, inc, out
FROM Income_o RIGHT JOIN
Outcome_o ON Outcome_o.point = Income_o.point AND Outcome_o.date = Income_o.date
