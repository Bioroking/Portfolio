--Задание 60. Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных
--с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
--Замечание. Не учитывать пункты, информации о которых нет до указанной даты.
SELECT point, SUM(remain) AS Remain FROM(
SELECT point, SUM(inc) AS remain
FROM Income_o
WHERE date < '2001-04-15'
GROUP BY point
UNION
SELECT point, -SUM(out) AS remain
FROM Outcome_o
WHERE date < '2001-04-15'
GROUP BY point
) table_1
GROUP BY point


--Задание 61. Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.
SELECT SUM(remain) AS Remain FROM(
SELECT SUM(inc) AS remain
FROM Income_o
GROUP BY point
UNION
SELECT -SUM(out) AS remain
FROM Outcome_o
GROUP BY point
) table_1


--Задание 62. Посчитать остаток денежных средств на всех пунктах приема на начало дня 15/04/01 для базы данных
--с отчетностью не чаще одного раза в день.
SELECT SUM(remain) AS Remain FROM(
SELECT SUM(inc) AS remain
FROM Income_o
WHERE date < '2001-04-15'
GROUP BY point
UNION
SELECT -SUM(out) AS remain
FROM Outcome_o
WHERE date < '2001-04-15'
GROUP BY point
) table_1


--Задание 63. Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза.
SELECT name
FROM Passenger
WHERE ID_psg IN(
SELECT ID_psg FROM Pass_in_trip
GROUP BY place, ID_psg
HAVING COUNT(*)>1) 


--Задание 64. Используя таблицы Income и Outcome, для каждого пункта приема определить дни, когда был приход,
--но не было расхода и наоборот.
--Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день.
SELECT Income.point, Income.[date], 'inc', SUM(inc)
FROM Income LEFT JOIN Outcome ON Income.point = Outcome.point AND Income.[date] = Outcome.[date]
WHERE Outcome.[date] IS NULL
GROUP BY Income.point, Income.[date]
UNION
SELECT Outcome.point, Outcome.[date], 'out', SUM(out)
FROM Income RIGHT JOIN Outcome ON Income.point = Outcome.point AND Outcome.[date] = Income.[date]
WHERE Income.[date] IS NULL
GROUP BY Outcome.point, Outcome.[date]


--Задание 65. Пронумеровать уникальные пары {maker, type} из Product, упорядочив их следующим образом:
-- имя производителя (maker) по возрастанию;
-- тип продукта (type) в порядке PC, Laptop, Printer.
--Если некий производитель выпускает несколько типов продукции, то выводить его имя только в первой строке;
--остальные строки для ЭТОГО производителя должны содержать пустую строку символов ('').
WITH skelet AS(
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY maker, CASE WHEN type = 'PC' THEN 1 WHEN type = 'Laptop' THEN 2 WHEN type = 'Printer' THEN 3 END) num, maker, type
FROM Product
GROUP BY maker, type)
SELECT sk1.num, CASE WHEN sk1.maker = sk2.maker THEN '' ELSE sk1.maker END AS maker, sk1.type
FROM skelet sk1 LEFT JOIN skelet sk2 ON sk2.num = sk1.num - 1


--Задание 66. Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov.
--Вывод: дата, количество рейсов
WITH skelet AS(
SELECT generate_series(MIN(date), MAX(date), '1 day') dt
FROM Pass_in_trip)
SELECT dt, COUNT(DISTINCT Trip.trip_no)
FROM skelet LEFT JOIN Pass_in_trip ON skelet.dt = Pass_in_trip.date 
LEFT JOIN Trip ON Trip.trip_no = Pass_in_trip.trip_no AND town_from = 'Rostov'
WHERE dt BETWEEN '2003-04-01' AND '2003-04-07'
GROUP BY dt


--Задание 67. Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--Замечания.
--1) A - B и B - A считать РАЗНЫМИ маршрутами.
--2) Использовать только таблицу Trip
SELECT COUNT(*) FROM(
SELECT TOP 1 WITH TIES COUNT(*) qty, town_from, town_to
FROM Trip
GROUP BY town_from, town_to
ORDER BY qty desc) table_1

