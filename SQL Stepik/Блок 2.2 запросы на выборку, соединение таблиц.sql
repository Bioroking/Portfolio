--Задание 1. Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
SELECT title, name_genre, price
FROM genre INNER JOIN book ON genre.genre_id = book.genre_id
WHERE amount > 8
ORDER BY price DESC


--Задание 2. Вывести все жанры, которые не представлены в книгах на складе.
SELECT name_genre
FROM genre LEFT JOIN book ON genre.genre_id = book.genre_id
WHERE amount IS NULL


--Задание 3. Есть список городов, хранящийся в таблице city.
--Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. Дату проведения выставки выбрать
--случайным образом. Создать запрос, который выведет город, автора и дату проведения выставки. 
--Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов,
--а потом по убыванию дат проведения выставок.
SELECT name_city, name_author, DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY) AS Дата
FROM city CROSS JOIN author
ORDER BY name_city ASC, Дата DESC


--Задание 4. Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в
--отсортированном по названиям книг виде.
SELECT name_genre, title, name_author
FROM genre INNER JOIN book ON genre.genre_id = book.genre_id 
           INNER JOIN author ON book.author_id = author.author_id
WHERE name_genre = 'Роман'
ORDER BY title


--Задание 5. Посчитать количество экземпляров  книг каждого автора из таблицы author.  Вывести тех авторов,
--количество книг которых меньше 10, в отсортированном по возрастанию количества виде. Последний столбец назвать Количество.
SELECT name_author, IF(SUM(amount) IS NULL, NULL, SUM(amount)) AS Количество
FROM author LEFT JOIN book ON author.author_id = book.author_id
GROUP BY name_author
HAVING Количество < 10 OR COUNT(title) = 0
ORDER BY Количество


--Задание 6. Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. Поскольку у нас в таблицах так
--занесены данные, что у каждого автора книги только в одном жанре,  для этого запроса внесем изменения в таблицу book. 
--Пусть у нас  книга Есенина «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям»
--(эти изменения в таблицы уже внесены).
SELECT name_author
FROM author INNER JOIN book ON author.author_id = book.author_id INNER JOIN genre ON book.genre_id = genre.genre_id
GROUP BY name_author
HAVING COUNT(DISTINCT(name_genre)) = 1


--Задание 7. Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество 
--экземпляров книги), написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде.
--Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.
SELECT title, name_author, name_genre, price, amount
FROM 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
WHERE genre.genre_id in 
        (select genre_id
        from book
        group by genre_id
        having  sum(amount) = (
            select sum(amount) as sum_amount
            from book
            group by genre_id
            having sum_amount
            limit 1))
ORDER BY title


--Задание 8. Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,  вывести их название и автора,
--а также посчитать общее количество экземпляров книг в таблицах supply и book,  столбцы назвать Название, Автор  и Количество.
SELECT book.title AS Название, name_author AS Автор, book.amount+supply.amount AS Количество
FROM author INNER JOIN book USING(author_id) INNER JOIN supply ON book.title = supply.title AND author.name_author = supply.author
WHERE book.price = supply.price
