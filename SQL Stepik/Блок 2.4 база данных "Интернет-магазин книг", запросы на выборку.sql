--Задание 1. Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал)
--в отсортированном по номеру заказа и названиям книг виде.
SELECT buy_book.buy_id, title, price, buy_book.amount
FROM client INNER JOIN buy ON client.client_id = buy.client_id
            INNER JOIN buy_book ON buy_book.buy_id = buy.buy_id
            INNER JOIN book ON buy_book.book_id=book.book_id
WHERE name_client = 'Баранов Павел'
ORDER BY buy_book.buy_id, title


--Задание 2. Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора 
--(нужно посчитать, в каком количестве заказов фигурирует каждая книга). Вывести фамилию и инициалы автора, название книги,
--последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
SELECT name_author, title, COUNT(buy_book.amount) AS Количество
FROM author INNER JOIN book ON author.author_id = book.author_id LEFT JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY name_author, title
ORDER BY name_author, title


--Задание 3. Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов
--в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов,
--а затем в алфавитном порядке по названию городов.
SELECT name_city, COUNT(buy.client_id) AS Количество
FROM city INNER JOIN client ON city.city_id = client.city_id LEFT JOIN buy ON client.client_id = buy.client_id
GROUP BY name_city
ORDER BY Количество DESC, name_city


--Задание 4. Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
SELECT buy_id, date_step_end
FROM step INNER JOIN buy_step ON step.step_id = buy_step.step_id AND buy_step.step_id = 1
WHERE date_step_end <> 0


--Задание 5. Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость 
--(сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде.
--Последний столбец назвать Стоимость.
SELECT buy_id, name_client, SUM(book.price * buy_book.amount) AS Стоимость
FROM buy_book
JOIN buy using(buy_id)
JOIN client using(client_id)
JOIN book using(book_id)
GROUP BY buy_id, name_client
ORDER BY buy_id


--Задание 6. Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся.
--Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
SELECT buy_id, name_step
FROM step
JOIN buy_step USING(step_id)
WHERE date_step_beg IS NOT NULL AND date_step_end IS NULL;


--Задание 7. В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город
--(рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап транспортировки, вывести количество
--дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать количество дней
--задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id),
--а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
SELECT buy.buy_id, datediff(date_step_end, date_step_beg) AS Количество_дней, 
IF(datediff(date_step_end, date_step_beg) > days_delivery,
DATEDIFF(date_step_end, date_step_beg)-days_delivery, 0) AS Опоздание 
FROM city INNER JOIN client ON city.city_id = client.city_id INNER JOIN buy ON client.client_id = buy.client_id INNER JOIN buy_step ON buy.buy_id = buy_step.buy_id INNER JOIN step ON buy_step.step_id = step.step_id
WHERE step.step_id = 3 AND date_step_end IS NOT NULL 
ORDER BY buy_id


--Задание 8. Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту
--виде. В решении используйте фамилию автора, а не его id.
SELECT DISTINCT name_client
FROM author INNER JOIN book ON author.author_id = book.author_id INNER JOIN buy_book ON book.book_id = buy_book.book_id INNER JOIN buy ON buy_book.buy_id = buy.buy_id INNER JOIN client ON buy.client_id = client.client_id
WHERE name_author = 'Достоевский Ф.М.'
ORDER BY name_client


--Задание 9. Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество.
--Последний столбец назвать Количество.
SELECT name_genre, SUM(buy_book.amount) AS Количество
FROM genre INNER JOIN book ON genre.genre_id = book.genre_id INNER JOIN buy_book ON book.book_id = buy_book.book_id
WHERE name_genre <> 'Поэзия'
GROUP BY name_genre


--задание 10. Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц,
--сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде.
--Название столбцов: Год, Месяц, Сумма.
SELECT YEAR(date_step_end) AS 'Год', MONTHNAME(date_step_end) AS 'Месяц', SUM(book.price*buy_book.amount) AS 'Сумма'
FROM buy_step
JOIN buy_book USING (buy_id)
JOIN book USING (book_id)
WHERE step_id = 1 AND date_step_end IS NOT NULL
GROUP BY YEAR(date_step_end),
         MONTHNAME(date_step_end)
UNION ALL
SELECT YEAR(date_payment),
       MONTHNAME(date_payment),
       SUM(price*amount)
FROM buy_archive
GROUP BY YEAR(date_payment),
         MONTHNAME(date_payment)
ORDER BY 2,1;
