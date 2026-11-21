// Сгенерировано gostgen.py — ГОСТ 7.32-2017. Требуется Typst >= 0.13
#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 7. Перегрузка функций. Функции с переменным числом параметров. Вариант 25", author: "Е. Д. Цветков")
#set page(paper: "a4", margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
  footer: context {
    let n = counter(page).get().first()
    if n > 1 { align(center, text(size: SIZE, str(n))) }
  }, footer-descent: 35%)
#set text(font: ("Times New Roman", "Liberation Serif", "TeX Gyre Termes"), size: SIZE, lang: "ru", hyphenate: true, fill: black)
#set par(justify: true, leading: LEAD, spacing: LEAD, first-line-indent: (amount: IND, all: true))
#show raw: set text(font: ("Courier New", "Liberation Mono", "DejaVu Sans Mono"), size: 10pt)
#show math.equation: set text(font: ("New Computer Modern Math", "Latin Modern Math", "STIX Two Math"))
#let toc-mark(level, title) = [#metadata((level: level, title: title))<gost-toc>]
#let hd(body, centered: false, indent: true) = block(sticky: true, width: 100%, above: LEAD + LINE, below: LEAD + LINE,
  {
    set text(weight: "bold", hyphenate: false)
    set par(justify: false, first-line-indent: (amount: if indent and not centered { IND } else { 0pt }, all: true))
    if centered { align(center, body) } else { par(body) }
  })
#let gost-struct(title, toc: true) = { pagebreak(weak: true); if toc { toc-mark(1, title) }; hd(centered: true, upper(title)) }
#let gost-h(level, num, title, newpage: false, toc: true) = {
  if newpage { pagebreak(weak: true) }
  if toc { toc-mark(level, num + " " + title.text) }
  hd([#num #title.body])
}
#let cap(body) = {
  set par(justify: false, first-line-indent: 0pt, leading: if true { SINGLE } else { LEAD })
  set text(hyphenate: false)
  body
}
#let gost-toc() = {
  pagebreak(weak: true)
  hd(centered: true)[СОДЕРЖАНИЕ]
  context {
    for m in query(<gost-toc>) {
      let v = m.value
      let pg = counter(page).at(m.location()).first()
      let ind = if v.level == 1 { 0cm } else if v.level == 2 { 0.5cm } else { 1cm }
      block(above: LEAD, below: LEAD, pad(left: ind,
        par(justify: false, first-line-indent: 0pt)[#v.title #h(1fr) #str(pg)]))
    }
  }
}

#page(footer: none)[
#set par(justify: false, first-line-indent: 0pt, leading: SINGLE, spacing: SINGLE)
#set text(hyphenate: false)
#align(center)[
#"МИНИСТЕРСТВО НАУКИ И ВЫСШЕГО ОБРАЗОВАНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ" \
#"«ПЕРМСКИЙ НАЦИОНАЛЬНЫЙ ИССЛЕДОВАТЕЛЬСКИЙ ПОЛИТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ»" \
#"(ПНИПУ)"]
#v(1fr)
#align(center)[
#par[#strong[#"ОТЧЁТ"]]
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 7"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 7 ВАРИАНТ № 25"]]
]
#v(1fr)
#grid(columns: (1fr, 3.5cm, 1fr), column-gutter: 0.6cm, row-gutter: 1.2em,
  [#"Выполнил" \
#"студент гр. ____________"],
  align(bottom)[#box(width: 100%, repeat[\_])],
  align(bottom)[#"Е. Д. Цветков"],
  [#"Проверил" \
#"доцент кафедры ИТАС"],
  align(bottom)[#box(width: 100%, repeat[\_])],
  align(bottom)[#"О. А. Полякова"])

#v(1fr)
#align(center)[#"Пермь 2026"]
]

#gost-toc()

#gost-h(1, "1", (text: "Постановка задачи", body: [#"Постановка задачи"]), newpage: true, toc: true)

#par[#"Лабораторная работа состоит из двух частей "#"[1]"#". Цель части 7.1 «Перегрузка функций в Си++» – знакомство с организацией перегруженных функций; цель части 7.2 «Функции с переменным числом параметров» – знакомство с организацией функций с переменным числом параметров."]

#par[#"Задание 1 (часть 7.1, вариант 25). Написать перегруженные функции и основную программу, которая их вызывает:"]

#par[#"а) "#"для двумерного массива функция удаляет все чётные строки;"]
#par[#"б) "#"для одномерного массива функция удаляет все элементы, заключённые между двумя нулевыми элементами."]

#par[#"Задание 2 (часть 7.2, вариант 25). Написать функцию (или макроопределение), которая находит длину стороны по координатам её точек. Написать функцию "#emph("square")#", которая вычисляет площадь треугольника, заданного координатами вершин. Написать функцию "#emph("square1")#" с переменным числом параметров, которая определяет площадь треугольника, содержащего диагональ наибольшей длины выпуклого многоугольника, заданного координатами своих вершин."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Задание 1. Обе функции названы одинаково – "#emph("del")#", а различаются списком параметров: "#emph("del(int a[][MAX], int n, int m)")#" для матрицы и "#emph("del(int a[], int n)")#" для одномерного массива. Компилятор выбирает нужную функцию по типам и числу фактических параметров. Обе функции изменяют массив на месте и возвращают его новую длину (число строк или элементов)."]

#par[#"Под чётными строками понимаются строки с чётными номерами при нумерации с единицы, то есть вторая, четвёртая и так далее; им соответствуют нечётные индексы 1, 3, …. Функция для матрицы переписывает строки с индексами 0, 2, 4, … подряд в начало массива и возвращает их количество."]

#par[#"Элемент заключён между двумя нулевыми элементами, если левее него есть нуль и правее него есть нуль. Это в точности элементы, лежащие между первым нулём (индекс "$f$#") и последним нулём (индекс "$l$#"). Сами нули при этом сохраняются, так как они служат границами. Функция для одномерного массива находит "$f$#" и "$l$#" за один проход, а вторым проходом оставляет элементы с индексом "$i lt.eq f$#", "$i gt.eq l$#" и нулевые элементы. Если нулей меньше двух, ни один элемент не удаляется."]

#par[#"Задание 2. Длина отрезка вычисляется функцией "#emph("length")#" по формуле "$#box[$d = sqrt((x_2 - x_1)^2 + (y_2 - y_1)^2)$]$#". Функция "#emph("square")#" находит длины сторон треугольника "$a$#", "$b$#", "$c$#" с помощью "#emph("length")#" и вычисляет площадь по формуле Герона "$#box[$S = sqrt(p(p-a)(p-b)(p-c))$]$#", где "$p$#" – полупериметр; отрицательное подкоренное выражение, возможное из-за погрешности округления у вырожденного треугольника, заменяется нулём."]

#par[#"Функция "#emph("square1(int k, ...)")#" получает число вершин "$k$#" и затем "$2 k$#" координат типа "#emph("double")#". Доступ к переменному списку параметров выполняется средствами заголовочного файла "#emph("<cstdarg>")#" ("#emph("va_list")#", "#emph("va_start")#", "#emph("va_arg")#", "#emph("va_end")#"): приём из методических указаний, когда указатель сдвигается по адресам параметров, в современных компиляторах не работает, так как параметры не обязаны лежать в памяти подряд. Поскольку "#emph("va_arg")#" читает значения типа "#emph("double")#", при вызове координаты записываются как вещественные константы (0.0, а не 0)."]

#par[#"Диагональ соединяет две несоседние вершины "$i$#" и "$j$#", поэтому перебираются пары "$j gt.eq i + 2$#", кроме пары первой и последней вершин. Наибольшую диагональ находит функция "#emph("longestDiagonal")#". Треугольников, одной из сторон которых является эта диагональ, а третьей вершиной – вершина многоугольника, несколько, и условие не уточняет, какой из них нужен. В программе принято, что ищется наибольший по площади из них; его площадь вычисляет функция "#emph("maxTriangle")#". Диагональ существует только при "$k gt.eq 4$#", поэтому при меньшем числе вершин "#emph("square1")#" возвращает 0."]

#par[#"Функция "#emph("main")#" обращается к "#emph("square1")#" три раза: для прямоугольника (4 вершины), пятиугольника (5 вершин) и шестиугольника (6 вершин)."]

#gost-h(2, "2.1", (text: "Блок-схема", body: [#"Блок-схема"]), newpage: false, toc: true)

#par[#"Блок-схемы алгоритмов, выполненные по ГОСТ 19.701-90 "#"[2]"#", приведены ниже. Для задания 1 схема функции "#emph("main")#" разделена на четыре листа: рисунок "#"1"#", рисунок "#"2"#", рисунок "#"3"#" и рисунок "#"4"#". Функция "#emph("del")#" для двумерного массива показана на рисунке "#"5"#", функция "#emph("del")#" для одномерного массива – на рисунке "#"6"#" и рисунке "#"7"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_1_main_p1.png", width: 47.39%))
#v(0.4em)
#cap(align(center)[#"Рисунок 1 – "#"Блок-схема алгоритма функции main, задание 1 (лист 1 из 4)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_1_main_p2.png", width: 52.90%))
#v(0.4em)
#cap(align(center)[#"Рисунок 2 – "#"Блок-схема алгоритма функции main, задание 1 (лист 2 из 4)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_1_main_p3.png", width: 45.81%))
#v(0.4em)
#cap(align(center)[#"Рисунок 3 – "#"Блок-схема алгоритма функции main, задание 1 (лист 3 из 4)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_1_main_p4.png", width: 48.51%))
#v(0.4em)
#cap(align(center)[#"Рисунок 4 – "#"Блок-схема алгоритма функции main, задание 1 (лист 4 из 4)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_1_delRows.png", width: 56.24%))
#v(0.4em)
#cap(align(center)[#"Рисунок 5 – "#"Блок-схема алгоритма функции del для двумерного массива"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_1_delZeros_p1.png", width: 72.82%))
#v(0.4em)
#cap(align(center)[#"Рисунок 6 – "#"Блок-схема алгоритма функции del для одномерного массива (лист 1 из 2)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_1_delZeros_p2.png", width: 79.83%))
#v(0.4em)
#cap(align(center)[#"Рисунок 7 – "#"Блок-схема алгоритма функции del для одномерного массива (лист 2 из 2)"])
]

#par[#"Для задания 2 функция "#emph("main")#" показана на рисунке "#"8"#", "#emph("length")#" – на рисунке "#"9"#", "#emph("square")#" – на рисунке "#"10"#", "#emph("square1")#" – на рисунке "#"11"#", "#emph("longestDiagonal")#" – на рисунке "#"12"#", "#emph("maxTriangle")#" – на рисунке "#"13"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_2_main.png", width: 38.52%))
#v(0.4em)
#cap(align(center)[#"Рисунок 8 – "#"Блок-схема алгоритма функции main, задание 2"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_2_length.png", width: 42.88%))
#v(0.4em)
#cap(align(center)[#"Рисунок 9 – "#"Блок-схема алгоритма функции length"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_2_square.png", width: 49.92%))
#v(0.4em)
#cap(align(center)[#"Рисунок 10 – "#"Блок-схема алгоритма функции square"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_2_square1.png", width: 55.72%))
#v(0.4em)
#cap(align(center)[#"Рисунок 11 – "#"Блок-схема алгоритма функции square1"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_2_longestDiagonal.png", width: 69.68%))
#v(0.4em)
#cap(align(center)[#"Рисунок 12 – "#"Блок-схема алгоритма функции longestDiagonal"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab7_2_maxTriangle.png", width: 63.54%))
#v(0.4em)
#cap(align(center)[#"Рисунок 13 – "#"Блок-схема алгоритма функции maxTriangle"])
]

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: false, toc: true)

#par[#"Текст программы для задания 1 (файл "#emph("lab7_1.cpp")#", стандарт C++20):"]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <iomanip>\n\nconst int MAX = 10;\n\nint del(int a[][MAX], int n, int m) {\n    int k = 0;\n    for (int i = 0; i < n; i += 2) {\n        for (int j = 0; j < m; j++)\n            a[k][j] = a[i][j];\n        k++;\n    }\n    return k;\n}\n\nint del(int a[], int n) {\n    int f = -1, l = -1;\n    for (int i = 0; i < n; i++)\n        if (a[i] == 0) {\n            if (f == -1)\n                f = i;\n            l = i;\n        }\n    int k = 0;\n    for (int i = 0; i < n; i++)\n        if (i <= f || i >= l || a[i] == 0) {\n            a[k] = a[i];\n            k++;\n        }\n    return k;\n}\n\nint main() {\n    int a[MAX][MAX];\n    int v[MAX * MAX];\n    int n, m, len;\n\n    std::cout << \"Enter rows and columns (1..\" << MAX << \"): \";\n    std::cin >> n >> m;\n    while (n < 1 || n > MAX || m < 1 || m > MAX) {\n        std::cout << \"Wrong size, enter again: \";\n        std::cin >> n >> m;\n    }\n    std::cout << \"Enter the matrix:\" << std::endl;\n    for (int i = 0; i < n; i++)\n        for (int j = 0; j < m; j++)\n            std::cin >> a[i][j];\n\n    n = del(a, n, m);\n    std::cout << \"Even rows removed:\" << std::endl;\n    for (int i = 0; i < n; i++) {\n        for (int j = 0; j < m; j++)\n            std::cout << std::setw(4) << a[i][j];\n        std::cout << std::endl;\n    }\n\n    std::cout << \"Enter array length (1..\" << MAX * MAX << \"): \";\n    std::cin >> len;\n    while (len < 1 || len > MAX * MAX) {\n        std::cout << \"Wrong length, enter again: \";\n        std::cin >> len;\n    }\n    std::cout << \"Enter the array:\" << std::endl;\n    for (int i = 0; i < len; i++)\n        std::cin >> v[i];\n\n    len = del(v, len);\n    std::cout << \"Elements between zeros removed:\" << std::endl;\n    for (int i = 0; i < len; i++)\n        std::cout << v[i] << \" \";\n    std::cout << std::endl;\n    return 0;\n}") })

#par[#"Текст программы для задания 2 (файл "#emph("lab7_2.cpp")#"). Функция "#emph("longestDiagonal")#" возвращает номера вершин диагонали через параметры-ссылки "#emph("di")#" и "#emph("dj")#":"]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <cmath>\n#include <cstdarg>\n\nconst int MAXV = 20;\n\ndouble length(double x1, double y1, double x2, double y2) {\n    return std::sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));\n}\n\ndouble square(double x1, double y1, double x2, double y2,\n              double x3, double y3) {\n    double a = length(x1, y1, x2, y2);\n    double b = length(x2, y2, x3, y3);\n    double c = length(x3, y3, x1, y1);\n    double p = (a + b + c) / 2;\n    double s = p * (p - a) * (p - b) * (p - c);\n    if (s < 0)\n        s = 0;\n    return std::sqrt(s);\n}\n\nvoid longestDiagonal(const double x[], const double y[], int k,\n                     int &di, int &dj) {\n    double dmax = 0;\n    for (int i = 0; i < k; i++)\n        for (int j = i + 2; j < k; j++) {\n            if (i == 0 && j == k - 1)\n                continue;\n            double d = length(x[i], y[i], x[j], y[j]);\n            if (d > dmax) {\n                dmax = d;\n                di = i;\n                dj = j;\n            }\n        }\n}\n\ndouble maxTriangle(const double x[], const double y[], int k,\n                   int di, int dj) {\n    double smax = 0;\n    for (int t = 0; t < k; t++) {\n        if (t == di || t == dj)\n            continue;\n        double s = square(x[di], y[di], x[dj], y[dj], x[t], y[t]);\n        if (s > smax)\n            smax = s;\n    }\n    return smax;\n}\n\ndouble square1(int k, ...) {\n    double x[MAXV], y[MAXV];\n    if (k < 4 || k > MAXV)\n        return 0;\n    va_list args;\n    va_start(args, k);\n    for (int i = 0; i < k; i++) {\n        x[i] = va_arg(args, double);\n        y[i] = va_arg(args, double);\n    }\n    va_end(args);\n    int di = 0, dj = 2;\n    longestDiagonal(x, y, k, di, dj);\n    return maxTriangle(x, y, k, di, dj);\n}\n\nint main() {\n    double r;\n    r = length(0, 0, 3, 4);\n    std::cout << \"length (0,0)-(3,4) = \" << r << std::endl;\n\n    r = square(0, 0, 4, 0, 0, 3);\n    std::cout << \"square (0,0),(4,0),(0,3) = \" << r << std::endl;\n\n    r = square1(4, 0.0, 0.0, 4.0, 0.0, 4.0, 2.0, 0.0, 2.0);\n    std::cout << \"Rectangle 4x2: square1 = \" << r << std::endl;\n\n    r = square1(5, 0.0, 0.0, 6.0, 0.0, 7.0, 3.0,\n                3.0, 5.0, -1.0, 3.0);\n    std::cout << \"Pentagon: square1 = \" << r << std::endl;\n\n    r = square1(6, 2.0, 0.0, 6.0, 0.0, 8.0, 3.0,\n                6.0, 6.0, 2.0, 6.0, 0.0, 3.0);\n    std::cout << \"Hexagon: square1 = \" << r << std::endl;\n    return 0;\n}") })

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: false, toc: true)

#par[#"Программы скомпилированы компилятором g++ (стандарт C++20, флаги -O2, -Wall и -Wextra), предупреждений нет. Результат работы программы для задания 1 показан на рисунке "#"14"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console1.png", width: 50%))
#v(0.4em)
#cap(align(center)[#"Рисунок 14 – "#"Результат работы программы для задания 1"])
]

#par[#"Из матрицы "$#box[$5 times 4$]$#" удалены вторая и четвёртая строки (5, 6, 7, 8 и 13, 14, 15, 16), остались первая, третья и пятая. В массиве 3, 0, 5, 7, 0, 4, 0, 8, 1, 9 первый нуль стоит на втором месте, последний – на седьмом; между ними удалены ненулевые элементы 5, 7 и 4, нули сохранены. Результат 3, 0, 0, 0, 8, 1, 9 совпадает с выводом программы."]

#par[#"Результат работы программы для задания 2 показан на рисунке "#"15"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console2.png", width: 42%))
#v(0.4em)
#cap(align(center)[#"Рисунок 15 – "#"Результат работы программы для задания 2"])
]

#par[#"Проверим результат. Отрезок от (0, 0) до (3, 4) имеет длину 5, а прямоугольный треугольник с катетами 4 и 3 – площадь 6. У прямоугольника "$#box[$4 times 2$]$#" обе диагонали равны "$sqrt(20)$#", и любой треугольник с диагональю в качестве стороны – это половина прямоугольника площадью 4."]

#par[#"У пятиугольника (0, 0), (6, 0), (7, 3), (3, 5), (−1, 3) наибольшая диагональ соединяет вершины (7, 3) и (−1, 3); её длина 8 больше длин остальных диагоналей ("$sqrt(58)$#" и "$sqrt(34)$#"). Вершины (0, 0) и (6, 0) удалены от прямой "$y = 3$#" на 3, поэтому наибольшая площадь равна "$8 dot.op 3 \/ 2 = 12$#". У шестиугольника (2, 0), (6, 0), (8, 3), (6, 6), (2, 6), (0, 3) наибольшая диагональ – от (8, 3) до (0, 3) длиной 8, все остальные вершины удалены от неё на 3, площадь также равна 12. Все значения совпадают с выводом программы."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"В ходе лабораторной работы изучены перегрузка функций и функции с переменным числом параметров. Две функции с одним именем "#emph("del")#" обрабатывают двумерный и одномерный массивы, и компилятор выбирает нужную по типам фактических параметров."]

#par[#"Функция "#emph("square1")#" принимает число вершин и произвольное количество координат; доступ к ним выполнен переносимым способом через макросы "#emph("va_start")#", "#emph("va_arg")#" и "#emph("va_end")#". Ручная проверка результатов обеих программ подтвердила их правильность."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)
#par[#"1. "#"Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]
#par[#"2. "#"ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
