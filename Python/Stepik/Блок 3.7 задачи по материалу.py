#Задание 1. Напишите программу, которая умеет шифровать и расшифровывать шифр подстановки.
#Программа принимает на вход две строки одинаковой длины, на первой строке записаны символы исходного алфавита,
#на второй строке — символы конечного алфавита, после чего идёт строка, которую нужно зашифровать переданным ключом,
#и ещё одна строка, которую нужно расшифровать.
#Пусть, например, на вход программе передано:
#abcd
#*d%#
#abacabadaba
# #*%*d*%
#Это значит, что символ a исходного сообщения заменяется на символ * в шифре, b заменяется на d, c — на % и d — на #.
#Нужно зашифровать строку abacabadaba и расшифровать строку #*%*d*% с помощью этого шифра. Получаем следующие строки,
#которые и передаём на вывод программы:
#*d*%*d*#*d*
#dacabac
key, value, str1, str2 = list(input()), list(input()), list(input()), list(input())
for i in str1:
    print(value[key.index(i)], end = '') # Для каждой буквы списка str1, выводим то значение Value,которое соответствует Key
print()
for j in str2:
    print(key[value.index(j)], end = '') # Для каждой буквы списка str2, выводим то значение Key,которое соответствует Value
print()


#Задание 2. Простейшая система проверки орфографии может быть основана на использовании списка известных слов.
#Если введённое слово не найдено в этом списке, оно помечается как "ошибка".
#Попробуем написать подобную систему.
#На вход программе первой строкой передаётся количество d известных нам слов, после чего на d строках указываются эти слова.
#Затем передаётся количество l строк текста для проверки, после чего l строк текста.
#Выведите уникальные "ошибки" в произвольном порядке. Работу производите без учёта регистра.
a = int(input())
b = []
for i in range(a):
    x = input().lower()
    if x not in b:
        b.append(x)
 
d = int(input())
e = []
for j in range(d):
    x = input().lower().split()
    for i in x:
        if i not in b and i not in e:
            e.append(i)

print('\n'.join(e))

