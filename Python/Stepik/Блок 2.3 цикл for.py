#Задание 1. Напишите программу, на вход которой даются четыре числа a, b, c и d, каждое в своей строке.
#Программа должна вывести фрагмент таблицы умножения для всех чисел отрезка [a;b] на все числа отрезка [c;d].
a = int(input())
b = int(input())
c = int(input())
d = int(input())
for i in range(c, d+1):
    print('\t', i, end='')
print()
for j in range(a, b+1):
    print(j, end='')
    for g in range(c, d+1):
        print('\t', g*j, end='')
    print()
    
    
#задание 2. Напишите программу, которая считывает с клавиатуры два числа a и b,
#считает и выводит на консоль среднее арифметическое всех чисел из отрезка [a;b], которые кратны числу 3. 
a = int(input())
b = int(input())
x = []
for i in range(a, b+1):
    if i%3 ==0:
        x.append(i)
print(sum(x)/len(x))
    
    
    
    
