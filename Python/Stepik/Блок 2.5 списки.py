#Задание 1. Напишите программу, на вход которой подается одна строка с целыми числами. Программа должна вывести сумму этих чисел.
#Используйте метод split строки. 
a = [int(i) for i in input().split()]
print(sum(a))


#Задание 2. Напишите программу, на вход которой подаётся список чисел одной строкой.
#Программа должна для каждого элемента этого списка вывести сумму двух его соседей.
#Для элементов списка, являющихся крайними, одним из соседей считается элемент, находящий на противоположном конце этого
#списка. Например, если на вход подаётся список "1 3 5 6 10", то на выход ожидается список "13 6 9 15 7" (без кавычек).
#Если на вход пришло только одно число, надо вывести его же.
#Вывод должен содержать одну строку с числами нового списка, разделёнными пробелом.
a = [int(item) for item in input().split()]
a2 = []
for i in range(len(a)):
    if len(a) == 1:
        print(a[0])
    else:
        if i == 0:
            a2.append(a[-1] + a[i + 1])
        elif i > 0  and i != len(a) - 1:
            a2.append(a[i - 1] + a[i + 1])
        else:
            a2.append(a[i - 1] + a[0])
if a2 != 0:
    for i in a2:
        print(i, end=' ')
