--Задание 1. Создать таблицу fine.
CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8,2),
    date_violation DATE,
    date_payment DATE
);


--Задание 2. В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8.
INSERT INTO fine (name, number_plate, violation, date_violation)
VALUES
('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', '2020-02-14'),
('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', '2020-02-23'),
('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', '2020-03-03');


--Задание 3. Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы
--traffic_violation. При этом суммы заносить только в пустые поля столбца  sum_fine.
UPDATE fine, traffic_violation AS tv
SET fine.sum_fine = tv.sum_fine
WHERE (fine.sum_fine IS NULL) AND fine.violation=tv.violation


--Задание 4. Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то
--же правило два и более раз. При этом учитывать все нарушения, независимо от того оплачены они или нет.
--Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(number_plate) >= 2
ORDER BY name, number_plate, violation


--Задание 5. В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 
UPDATE fine,(
    SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(number_plate) > 1
ORDER BY name, number_plate, violation) query_in
SET sum_fine = sum_fine * 2
WHERE date_payment IS NULL AND
fine.name = query_in.name AND
fine.number_plate = query_in.number_plate AND
fine.violation = query_in.violation


--Задание 6. Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты.
--Необходимо: в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
--уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment),
--если оплата произведена не позднее 20 дней со дня нарушения.
UPDATE fine AS f, payment AS p 
SET f.date_payment = p.date_payment,
f.sum_fine = IF(DATEDIFF(p.date_payment, p.date_violation) <= 20, f.sum_fine/2, f.sum_fine) 
WHERE f.name = p.name AND f.number_plate = p.number_plate AND f.violation = p.violation AND f.date_violation = p.date_violation AND f.date_payment IS NULL


--Задание 7. Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах 
--(Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;

SELECT * FROM back_payment
