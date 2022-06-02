--Задание 1. Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в
--отсортированном по фамилиям виде.
SELECT name_enrollee
FROM enrollee INNER JOIN program_enrollee ON enrollee.enrollee_id = program_enrollee.enrollee_id INNER JOIN program ON
program_enrollee.program_id = program.program_id
WHERE name_program = 'Мехатроника и робототехника'
ORDER BY name_enrollee


--Задание 2. Вывести образовательные программы, на которые для поступления необходим предмет «Информатика».
--Программы отсортировать в обратном алфавитном порядке.
SELECT name_program
FROM subject INNER JOIN program_subject ON subject.subject_id = program_subject.subject_id INNER JOIN program ON
program_subject.program_id = program.program_id
WHERE name_subject = 'Информатика'
ORDER BY name_program DESC


--Задание 3. Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение
--баллов по предмету ЕГЭ. Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее.
--Информацию отсортировать по названию предмета в алфавитном порядке, среднее значение округлить до одного знака после запятой.
SELECT name_subject, COUNT(enrollee_id) AS Количество, MAX(result) AS Максимум, MIN(result) AS Минимум, ROUND(AVG(result), 1) AS Среднее
FROM subject INNER JOIN enrollee_subject ON subject.subject_id = enrollee_subject.subject_id
GROUP BY name_subject
ORDER BY name_subject


--Задание 4. Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам.
--Программы вывести в отсортированном по алфавиту виде.
SELECT name_program
FROM program INNER JOIN program_subject ON program.program_id = program_subject.program_id
GROUP BY name_program
HAVING MIN(min_result) >= 40
ORDER BY name_program


--Задание 5. Вывести образовательные программы, которые имеют самый большой план набора,  вместе с этой величиной.
SELECT name_program, plan
FROM program
WHERE plan = (SELECT MAX(plan) FROM program)


--Задание 6. Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами назвать Бонус.
--Информацию вывести в отсортированном по фамилиям виде.
SELECT enrollee.name_enrollee, COALESCE(SUM(achievement.bonus), 0) AS Бонус
FROM achievement INNER JOIN enrollee_achievement ON achievement.achievement_id = enrollee_achievement.achievement_id
RIGHT JOIN enrollee ON enrollee_achievement.enrollee_id = enrollee.enrollee_id
GROUP BY name_enrollee
ORDER BY enrollee.name_enrollee Asc


--Задание 7. Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее
--(число поданных заявлений деленное на количество мест по плану), округленный до 2-х знаков после запятой.
--В запросе вывести название факультета, к которому относится образовательная программа, название образовательной программы,
--план набора абитуриентов на образовательную программу (plan), количество поданных заявлений (Количество) и Конкурс.
--Информацию отсортировать в порядке убывания конкурса.
SELECT name_department, name_program, plan, COUNT(enrollee_id) AS 'Количество', ROUND(COUNT(enrollee_id)/plan, 2) AS 'Конкурс'
FROM department INNER JOIN program ON department.department_id = program.department_id INNER JOIN program_enrollee ON
program.program_id = program_enrollee.program_id
GROUP BY name_department, name_program, plan
ORDER BY Конкурс DESC


--Задание 8. Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика»
--в отсортированном по названию программ виде.
select name_program
from subject
join program_subject using (subject_id)
join program using (program_id)
where name_subject in ('Математика','Информатика')
group by name_program
having count(*) = 2
order by name_program


--Задание 9. Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление,
--по результатам ЕГЭ. В результат включить название образовательной программы, фамилию и имя абитуриента, а также столбец с
--суммой баллов, который назвать itog. Информацию вывести в отсортированном сначала по образовательной программе, а потом по
--убыванию суммы баллов виде.
SELECT name_program, name_enrollee, SUM(result) AS itog
FROM enrollee INNER JOIN program_enrollee ON enrollee.enrollee_id = program_enrollee.enrollee_id INNER JOIN program ON
program_enrollee.program_id = program.program_id INNER JOIN program_subject ON program.program_id = program_subject.program_id
INNER JOIN subject ON program_subject.subject_id = subject.subject_id INNER JOIN enrollee_subject ON
subject.subject_id = enrollee_subject.subject_id  and enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY name_program, name_enrollee
ORDER BY name_program, itog DESC


--Задание 10. Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную
--программу, но не могут быть зачислены на нее. Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ,
--необходимым для поступления на эту образовательную программу, меньше минимального балла. Информацию вывести в отсортированном 
--сначала по программам, а потом по фамилиям абитуриентов виде.
--Например, Баранов Павел по «Физике» набрал 41 балл, а  для образовательной программы «Прикладная механика» минимальный балл
--по этому предмету определен в 45 баллов. Следовательно, абитуриент на данную программу не может поступить.
SELECT DISTINCT name_program, name_enrollee
FROM enrollee INNER JOIN program_enrollee ON enrollee.enrollee_id = program_enrollee.enrollee_id INNER JOIN program ON
program_enrollee.program_id = program.program_id INNER JOIN program_subject ON program.program_id = program_subject.program_id 
INNER JOIN subject ON program_subject.subject_id = subject.subject_id INNER JOIN enrollee_subject ON
subject.subject_id = enrollee_subject.subject_id  and enrollee_subject.enrollee_id = enrollee.enrollee_id
WHERE result < min_result
GROUP BY name_program, name_enrollee
ORDER BY name_program, name_enrollee
