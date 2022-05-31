--Задание 1. Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),
--необходимо в таблице book увеличить количество на значение, указанное в поставке,  и пересчитать цену.
--А в таблице  supply обнулить количество этих книг.
--Формула для пересчета цены: price = (p1*k1+p2*k2)/(k1+k2)
--где  p1, p2 - цена книги в таблицах book и supply;
--k1, k2 - количество книг в таблицах book и supply.
UPDATE book 
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title 
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    supply.amount = 0,
    book.price = (book.price * book.amount + supply.price * supply.amount)/(book.amount + supply.amount)
WHERE book.price <> supply.price


--Задание 2. Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы
--author.  Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.
INSERT INTO author (name_author)
SELECT supply.author
FROM 
    author 
    RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS Null


--Задание 3. Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса.
--Затем вывести для просмотра таблицу book.
INSERT INTO book (title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM 
    author 
    INNER JOIN supply ON author.name_author = supply.author
WHERE amount <> 0


--Задание 4. анести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ» Стивенсона - «Приключения».
--(Использовать два запроса).
UPDATE book
SET genre_id = 2
WHERE book_id = 10;
UPDATE book
SET genre_id = 3
WHERE book_id = 11


--Задание 5. Удалить всех авторов и все их книги, общее количество книг которых меньше 20.
DELETE FROM author
WHERE author_id in (select author_id from book 
group by author_id 
having sum(amount)<20);


--Задание 6. Удалить все жанры, к которым относится меньше 4-х книг. В таблице book для этих жанров установить значение Null.
DELETE FROM genre
WHERE genre_id IN(SELECT genre_id FROM book GROUP BY genre_id HAVING COUNT(title) < 4)


--Задание 7. Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов.
--В запросе для отбора авторов использовать полное название жанра, а не его id.
DELETE FROM author
USING author INNER JOIN book ON author.author_id = book.author_id INNER JOIN genre ON book.genre_id = genre.genre_id
WHERE name_genre = 'Поэзия'
