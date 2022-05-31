#Задание 1. Сколько женщин (признак sex) представлено в этом наборе данных?
import pandas as pd
import numpy as np
file = pd.read_csv('/Users/bioal/Python/adult.data.csv')
file['sex'].value_counts()


#Задание 2.  Каков средний возраст (признак age) женщин?
file.groupby('sex').agg({'age': 'mean',})


#задание 3. Какова доля граждан Германии (признак native-country) в процентах?
file['native-country'].value_counts(normalize=True)


#задание 4. Каковы средние и среднеквадратичные отклонения возраста тех, кто получает более 50K в год (признак salary)?
file[file.salary == '>50K'].agg([np.mean, np.std, np.min, np.max])


#Задание 5. Каковы средние значения и среднеквадратичные отклонения возраста тех, кто получает менее 50K в год (признак salary)?
file[file.salary == '<=50K'].agg([np.mean, np.std, np.min, np.max])


#задание 6. Правда ли, что люди, которые получают больше 50k, имеют как минимум высшее образование?
#(признак education равен Bachelors, Prof-school, Assoc-acdm, Assoc-voc, Masters или Doctorate)
file[file.education.isin(['Bachelors', 'Prof-school', 'Assoc-acdm', 'Assoc-voc', 'Masters', 'Doctorate'])].groupby('education').salary.value_counts()


#Задание 7. Каков максимальный возраст мужчин расы Amer-Indian-Eskimo?
file[file.race == 'Amer-Indian-Eskimo'].agg({'age': 'max',})


#Задание 8. Среди кого больше доля зарабатывающих много (>50K): среди женатых или холостых мужчин
#(признак marital-status для женатых равен Married-civ-spouse, Married-spouse-absent или Married-AF-spouse)?
file[file['marital-status'].isin(['Married-civ-spouse', 'Married-spouse-absent', 'Married-AF-spouse'])].groupby('marital-status').salary.value_counts(normalize=True)


#Задание 9. Какое максимальное число часов человек работает в неделю (признак hours-per-week)?
#Сколько людей работают такое количество часов и каков среди них процент зарабатывающих много?
file.describe()
file[file['hours-per-week']==x].salary.value_counts(normalize=True)


#Задание 10. Каково среднее время работы (hours-per-week) зарабатывающих мало и много (salary) для Японии?
file[file['native-country'] == 'Japan'].groupby('salary').agg({'hours-per-week': 'mean'})
