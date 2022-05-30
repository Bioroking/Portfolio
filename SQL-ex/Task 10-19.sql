--Задание 10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
SELECT model, price
FROM Printer
WHERE price = (SELECT MAX(Price)
FROM Printer);


--Задание 11. Найдите среднюю скорость ПК.
SELECT AVG(speed) AS avg_speed
FROM PC;


--Задание 12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
SELECT AVG(speed) AS avg_speed
FROM Laptop
WHERE price > 1000;


--Задание 13. Найдите среднюю скорость ПК, выпущенных производителем A.
SELECT AVG(speed) AS avg_speed
FROM PC INNER JOIN 
Product ON Product.model = PC.model
WHERE maker = 'A';


--Задание 14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
SELECT Classes.class, name, country
FROM Ships INNER JOIN 
Classes ON Classes.class = Ships.class
WHERE Classes.numGuns >= '10';


--Задание 15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(hd) >= 2;


--Задание 16. Найдите пары моделей PC, имеющиходинаковые скорость и RAM. 
--В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i).
--Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
SELECT DISTINCT A.model, B.model, A.speed, A.ram
FROM PC AS A INNER JOIN
PC AS B ON A.speed = B.speed AND A.ram = B.ram AND B.model <> A.model
WHERE A.model > B.model;


--Задание 17. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed
SELECT DISTINCT type, Laptop.model, speed
FROM Laptop INNER JOIN 
Product ON Laptop.model = Product.model
WHERE speed < ALL (SELECT speed
FROM PC);


--Задание 18. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
SELECT DISTINCT maker, price
FROM Printer INNER JOIN 
Product ON Printer.model = Product.model
WHERE price = (SELECT MIN(price)
FROM Printer
WHERE color = 'y') AND color = 'y';


--Задание 19. Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
--Вывести: maker, средний размер экрана.
SELECT maker, AVG(screen) AS средний_размер_экрана
FROM Laptop INNER JOIN 
Product ON Laptop.model = Product.model
GROUP BY maker;
