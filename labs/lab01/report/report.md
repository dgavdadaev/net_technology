---
## Front matter
title: "Отчёт по лабораторной работе 1"
subtitle: "Методы кодирования и модуляция сигналов"
author: "Абдуллахи Шугофа"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
lot: true # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: IBM Plex Serif
romanfont: IBM Plex Serif
sansfont: IBM Plex Sans
monofont: IBM Plex Mono
mathfont: STIX Two Math
mainfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
romanfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
sansfontoptions: Ligatures=Common,Ligatures=TeX,Scale=MatchLowercase,Scale=0.94
monofontoptions: Scale=MatchLowercase,Scale=0.94,FakeStretch=0.9
mathfontoptions:
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Основная задача заключалась в освоении методов кодирования и модуляции сигналов с применением языка Octave. В рамках работы предстояло изучить их спектральные характеристики, параметры, а также проверить механизмы самосинхронизации.

---

# Выполнение заданий

## Визуализация функций в Octave

### Задача
Необходимо было построить графики двух функций:

$$
y_1(x) = \sin(x) + \tfrac{1}{3}\sin(3x) + \tfrac{1}{5}\sin(5x),
$$

$$
y_2(x) = \cos(x) + \tfrac{1}{3}\cos(3x) + \tfrac{1}{5}\cos(5x),
$$

на интервале $$[-10; 10]$$ и сохранить результаты в формате `.eps` и `.png`.

### Этапы решения
- В скрипте был задан диапазон изменения аргумента $$x$$.  
- Определены выражения для функций $$y_1$$ и $$y_2$$.  
- Построен график функции $$y_1$$ и сохранён в нужных форматах.  
- На одном графике совместно изображены обе функции с добавлением легенды.  

### Итоги
График первой функции представлен на рис. 1, а изображение обеих функций одновременно — на рис. 2.

![График функции y1](octave-files/plot-sin.png){ width=80% }

![Графики функций y1 и y2](octave-files/plot-sin-cos.png){ width=80% }

---

## Приближение меандра рядом Фурье

### Задача
Нужно было исследовать приближения меандра при увеличении числа нечётных гармоник, рассматривая разложения через ряды синусов и косинусов.

### Параметры моделирования
- количество гармоник: 8;  
- временной диапазон: $$[-1; 1]$$ с шагом 0.01;  
- амплитуда сигнала: 1;  
- период: 1.  

Амплитуда каждой нечётной гармоники обратно пропорциональна её номеру.

### Ход работы
1. Построены частичные суммы ряда Фурье при числе гармоник от 1 до 8.  
2. Получены два набора графиков: для cos-разложения (с чередующимися знаками) и для sin-разложения (только положительные члены).  
3. Каждый вариант показан в отдельной области окна для наглядного сравнения.  
4. Результаты сохранены в виде `.png` изображений.  

### Выводы
- При малом числе гармоник сигнал близок к синусоидальной форме.  
- С ростом числа гармоник фронты становятся более крутыми, сигнал всё больше напоминает прямоугольный.  
- Вблизи точек разрыва наблюдается эффект Гиббса, сохраняющийся при любом числе гармоник.  
- Оба варианта разложения дают одинаковое качество приближения.  

![Меандр через cos-ряд](octave-files/meandr-cos.png){ width=80% }

![Меандр через sin-ряд](octave-files/meandr-sin.png){ width=80% }

---

## Спектры и параметры сигналов

### Задача
Рассмотреть два гармонических сигнала с разными частотами, их спектры и спектр их суммы. Дополнительно исследовать влияние уменьшения частоты дискретизации ниже 80 Гц.

### Этапы
- В каталоге `spectre1` заданы параметры: длительность 0.5 с, частота дискретизации 512 Гц, частоты 10 и 40 Гц, амплитуды 1 и 0.7.  
- Сгенерированы два сигнала:  
  $$s_1(t) = a_1\sin(2\pi f_1 t), \quad s_2(t) = a_2\sin(2\pi f_2 t).$$  
- Выполнено построение графиков и расчёт спектров с применением БПФ.  
- Произведена нормировка и удаление отрицательных частот.  
- Для суммарного сигнала в каталоге `spectre_sum` вычислен спектр.  

### Результаты и выводы
- При дискретизации 512 Гц спектры отображаются корректно, пики чётко выделяются.  
- Суммарный спектр совпадает с суперпозицией отдельных спектров.  
- При снижении частоты дискретизации ниже 80 Гц возникает эффект алиасинга: сигнал 40 Гц отображается искажённо.  
- Для корректной дискретизации необходимо соблюдать критерий Найквиста–Котельникова.  

![Два синусоидальных сигнала](octave-files/spectre1/signal/spectre.png){ width=80% }

![Спектры сигналов](octave-files/spectre1/spectre/spectre.png){ width=80% }

![Исправленный спектр](octave-files/spectre1/spectre/spectre_fix.png){ width=80% }

![Суммарный сигнал](octave-files/spectre_sum/signal/spectre_sum.png){ width=80% }

![Спектр суммы](octave-files/spectre_sum/spectre/spectre_sum.png){ width=80% }

---

## Демонстрация амплитудной модуляции

### Задача
Исследовать АМ путём модуляции низкочастотного сигнала синусоидой высокой частоты и рассмотреть его спектр.

### Ход работы
1. В файле `am.m` определены параметры: длительность 0.5 с, дискретизация 512 Гц, частоты: модулирующая — 5 Гц, несущая — 50 Гц.  
2. Построены: модулирующий сигнал, несущая и АМ-сигнал:  
   $$s(t) = s_1(t) \cdot s_2(t).$$  
3. Выполнено построение огибающей.  
4. Получен спектр модулированного сигнала через БПФ.  

### Итоги
- На графике видна огибающая, совпадающая с модулирующим сигналом.  
- Спектр состоит из несущей и двух боковых полос, расположенных симметрично.  
- Результаты подтверждают принцип свёртки спектров.  

![АМ-сигнал и огибающая](octave-files/modulation/signal/am.png){ width=80% }

![Спектр АМ-сигнала](octave-files/modulation/spectre/am.png){ width=80% }

---

## Линейное кодирование и самосинхронизация

### Задача
Создать кодированные сигналы по заданным битовым последовательностям для разных схем кодирования, проверить устойчивость к длинным сериям одинаковых символов и сравнить спектры.

### Проведённые шаги
- Сформированы три последовательности: основная, тестовая для длинных серий и набор для расчёта спектров.  
- Для каждого кода построены: форма сигнала, демонстрация самосинхронизации, спектр.  
- Рассмотренные методы: Unipolar, AMI, Bipolar NRZ, Bipolar RZ, Manchester, Differential Manchester.  

### Анализ
- **Unipolar**: отсутствие переходов при длинных сериях нулей, выраженная DC-составляющая.  
- **AMI**: единицы чередуют полярность, что устраняет DC. Проблема — длинные серии нулей.  
- **Bipolar NRZ**: синхронизация теряется при сериях одинаковых битов, подавление DC слабое.  
- **Bipolar RZ**: возврат к нулю в каждом такте повышает самосинхронизацию, но увеличивает ширину спектра.  
- **Manchester**: переход в середине такта обеспечивает надёжную синхронизацию, но удваивает эффективную полосу.  
- **Differential Manchester**: сохраняет свойства Manchester и устойчив к инверсии полярности канала.  

### Результаты: формы сигналов
![Unipolar](octave-files/coding/signal/unipolar.png){ width=80% }
![AMI](octave-files/coding/signal/ami.png){ width=80% }
![Bipolar NRZ](octave-files/coding/signal/bipolarnrz.png){ width=80% }
![Bipolar RZ](octave-files/coding/signal/bipolarrz.png){ width=80% }
![Manchester](octave-files/coding/signal/manchester.png){ width=80% }
![Differential Manchester](octave-files/coding/signal/diffmanc.png){ width=80% }

### Результаты: самосинхронизация
![Unipolar](octave-files/coding/sync/unipolar.png){ width=80% }
![AMI](octave-files/coding/sync/ami.png){ width=80% }
![Bipolar NRZ](octave-files/coding/sync/bipolarnrz.png){ width=80% }
![Bipolar RZ](octave-files/coding/sync/bipolarrz.png){ width=80% }
![Manchester](octave-files/coding/sync/manchester.png){ width=80% }
![Differential Manchester](octave-files/coding/sync/diffmanc.png){ width=80% }

### Результаты: спектры сигналов
![Unipolar](octave-files/coding/spectre/unipolar.png){ width=80% }
![AMI](octave-files/coding/spectre/ami.png){ width=80% }
![Bipolar NRZ](octave-files/coding/spectre/bipolarnrz.png){ width=80% }
![Bipolar RZ](octave-files/coding/spectre/bipolarrz.png){ width=80% }
![Manchester](octave-files/coding/spectre/manchester.png){ width=80% }
![Differential Manchester](octave-files/coding/spectre/diffmanc.png){ width=80% }

---

# Заключение

Выполненная работа охватила ключевые методы формирования сигналов, их спектральный анализ, амплитудную модуляцию и линейное кодирование. Эксперименты в Octave подтвердили теоретические положения о разложении в ряд Фурье, критерии Найквиста, свойства самосинхронизации и спектральное распределение энергии. Полученные результаты закрепили практические навыки в области цифровой обработки сигналов.


