#Задание 1.Напишите программу, которая считывает с консоли числа (по одному в строке) до тех пор, пока сумма введённых чисел
#не будет равна 0 и сразу после этого выводит сумму квадратов всех считанных чисел.
#Гарантируется, что в какой-то момент сумма введённых чисел окажется равной 0, после этого считывание продолжать не нужно.
x = 0
z = 0
while True:
    y = int(input())
    x += y
    z += y**2
    if x == 0:
        break
print(z)


#Задание 2. Напишите программу, которая выводит часть последовательности 1 2 2 3 3 3 4 4 4 4 5 5 5 5 5 ...
#(число повторяется столько раз, чему равно). На вход программе передаётся неотрицательное целое число n — столько элементов 
#последовательности должна отобразить программа. На выходе ожидается последовательность чисел,
#записанных через пробел в одну строку.
n = int(input())
x = []
num1 = num = 1
for i in range(n):
    if num1 == 0:
        num += 1
        num1 = num
    num1 -= 1
    x.append(str(num))
print(' '.join(x))


#Задание 3. Напишите программу, которая считывает список чисел lstlst из первой строки и число xx из второй строки,
#которая выводит все позиции, на которых встречается число xx в переданном списке lstlst.
#Позиции нумеруются с нуля, если число xx не встречается в списке, вывести строку "Отсутствует"(без кавычек, с большой буквы).
#Позиции должны быть выведены в одну строку, по возрастанию абсолютного значения.
lst, x = input().split(), input()
if x in lst:
    for i in range(len(lst)):
        if lst[i] == x:
            print(i, end=' ')
else:
    print('Отсутствует')



