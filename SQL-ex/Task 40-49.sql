--Задание 40.  Найти производителей, которые выпускают более одной модели,
--при этом все выпускаемые производителем модели являются продуктами одного типа.
--Вывести: maker, type
SELECT maker, type FROM Product WHERE maker IN(
SELECT maker FROM(
SELECT maker, type
FROM Product
GROUP BY maker, type
) table_1
GROUP BY maker
HAVING COUNT(*) = 1
) GROUP BY maker, type
HAVING COUNT(*) > 1


--Задание 41. Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
--определить максимальную цену на его продукцию.
--Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL,
--то выводить для этого производителя NULL, иначе максимальную цену.
SELECT maker, CASE
WHEN MAX(CASE WHEN price IS NULL THEN 1 ELSE 0 END) = 0
THEN MAX(price) END price FROM(
SELECT maker, price
FROM Product JOIN PC ON product.model = PC.model
UNION
SELECT maker, price
FROM Product JOIN Laptop ON product.model = Laptop.model
UNION
SELECT maker, price
FROM Product JOIN Printer ON product.model = Printer.model
) table_1 GROUP BY maker


--Задание 42. Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.
SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk'


--Задание 43. Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
SELECT name
FROM Battles
WHERE YEAR([date]) NOT IN (SELECT launched FROM Ships WHERE launched IS NOT NULL)


--Задание 44. Найдите названия всех кораблей в базе данных, начинающихся с буквы R.
SELECT name
FROM Ships
WHERE name LIKE 'R%'
UNION
SELECT name
FROM Battles
WHERE name LIKE 'R%'
UNION
SELECT ship
FROM Outcomes
WHERE ship LIKE 'R%'


--Задание 45. Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
--Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.
SELECT name
FROM Ships
WHERE name LIKE '% % %'
UNION
SELECT name
FROM Battles
WHERE name LIKE '% % %'
UNION
SELECT ship
FROM Outcomes
WHERE ship LIKE '% % %'


--Задание 46. Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal).
--Вывести название, водоизмещение и число орудий.
SELECT name, displacement, numGuns
FROM Classes RIGHT JOIN(
SELECT COALESCE(name, ship) name, class, battle
FROM Outcomes FULL JOIN Ships ON ship = name
) table_1 ON Classes.class = table_1.class OR Classes.class = table_1.name
WHERE battle = 'Guadalcanal'


--Задание 48. Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.
SELECT Classes.class
FROM Classes JOIN Ships ON Classes.class = Ships.class
WHERE name IN (SELECT ship FROM Outcomes WHERE result = 'sunk')
UNION
SELECT class
FROM Classes JOIN Outcomes ON class = ship
WHERE result = 'sunk'


--Задание 49. Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).
SELECT name FROM(
SELECT name, bore
FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION 
SELECT ship, bore
FROM Classes JOIN Outcomes ON class = ship
) table_1
WHERE bore = '16'







