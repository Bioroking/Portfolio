--Задание 1. Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
INSERT INTO client (name_client, city_id, email)
VALUES ('Попов Илья', 1, 'popov@test')


--Задание 2. Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».
INSERT INTO buy(buy_description, client_id)
SELECT 'Связаться со мной по вопросу доставки', (SELECT client_id FROM client WHERE name_client = 'Попов Илья');



--Задание 3. В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» в
--количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
INSERT INTO buy_book (buy_id, book_id, amount)
VALUES 
(5, (SELECT book_id FROM book WHERE title = 'Лирика' AND author_id = (SELECT author_id FROM author WHERE name_author = 'Пастернак Б.Л.')), 2),
(5, (SELECT book_id FROM book WHERE title = 'Белая гвардия' AND author_id = (SELECT author_id FROM author WHERE name_author = 'Булгаков М.А.')), 1)


--Задание 4. Количество тех книг на складе, которые были включены в заказ с номером 5, уменьшить на то количество, которое в заказе с номером 5  указано.
UPDATE book INNER JOIN buy_book ON book.book_id = buy_book.book_id
SET book.amount = book.amount - buy_book.amount
WHERE buy_book.buy_id = 5


--Задание 5. Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену,
--количество заказанных книг и  стоимость. Последний столбец назвать Стоимость.
--Информацию в таблицу занести в отсортированном по названиям книг виде.
CREATE TABLE buy_pay AS 
SELECT title, name_author, price, buy_book.amount, price*buy_book.amount AS Стоимость
FROM author INNER JOIN book ON author.author_id = book.author_id INNER JOIN buy_book ON book.book_id = buy_book.book_id
WHERE buy_id = 5
ORDER BY title;

SELECT * FROM buy_pay


--Задание 6. Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, количество книг
--в заказе (название столбца Количество) и его общую стоимость (название столбца Итого).
--Для решения используйте ОДИН запрос.
CREATE TABLE buy_pay AS 
SELECT buy_id, SUM(buy_book.amount) AS Количество, SUM(price*buy_book.amount) AS Итого
FROM book INNER JOIN buy_book ON book.book_id = buy_book.book_id
WHERE buy_id = 5


--Задание 7. В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ.
--В столбцы date_step_beg и date_step_end всех записей занести Null.
INSERT INTO buy_step (buy_id, step_id, date_step_beg, date_step_end)
SELECT buy_id, step_id, null, null
FROM step
CROSS JOIN buy
WHERE buy.buy_id = 5;
Select * from buy_step


--Задание 8. В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.
--Правильнее было бы занести не конкретную, а текущую дату. Это можно сделать с помощью функции Now().
--Но при этом в разные дни будут вставляться разная дата, и задание нельзя будет проверить, поэтому  вставим дату 12.04.2020.
UPDATE buy_step
SET date_step_beg = '2020-04-12'
WHERE buy_id = 5 AND step_id = 1;

SELECT * FROM buy_step
