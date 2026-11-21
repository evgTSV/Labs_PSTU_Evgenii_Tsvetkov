// Сгенерировано gostgen.py — ГОСТ 7.32-2017. Требуется Typst >= 0.13
#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 5. Функции и массивы. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 5"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 5 ВАРИАНТ № 25"]]
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

#par[#"Цель работы – организовать обработку массивов с использованием функций и научиться передавать массивы как параметры функций "#"[1]"#"."]

#par[#"Используя функции, решить указанную в варианте задачу; массив должен передаваться в функцию как параметр."]

#par[#"Задание (вариант 25): из двумерного массива в одномерный записали сначала строки в произвольном порядке, затем столбцы в произвольном порядке. Написать программу, восстанавливающую исходный двумерный массив по одномерному, если известна размерность двумерного массива и элементы в нём не повторяются."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Пусть исходная матрица "#emph("a")#" имеет "$n$#" строк и "$m$#" столбцов. Одномерный массив "#emph("b")#" содержит "$2 n m$#" элементов: первые "$n m$#" – это "$n$#" строк по "$m$#" элементов, записанных в произвольном порядке, следующие "$n m$#" – это "$m$#" столбцов по "$n$#" элементов, также в произвольном порядке. Порядок элементов внутри каждой строки и каждого столбца сохраняется, перемешаны только сами строки и столбцы."]

#par[#"Строка матрицы, записанная в "#emph("b")#", уже содержит свои элементы в правильном порядке, поэтому неизвестен только её номер. Его можно определить по любому элементу строки, например по первому. Элемент "$x = a_(i 0)$#" встречается в столбцовой части "#emph("b")#" ровно один раз, так как элементы не повторяются. Он стоит в некотором столбце на позиции с номером "$i$#", потому что столбец записан сверху вниз. Если "$x$#" найден в столбцовой части на месте "$k$#" (отсчёт от начала этой части), то номер строки равен "$#box[$i = k mod n$]$#"."]

#par[#"Таким образом, для каждой из "$n$#" строк одномерного массива достаточно найти номер строки функцией "#emph("rowIndex")#" и переписать строку на это место. Восстановление выполняет функция "#emph("restore")#". Порядок столбцов в одномерном массиве для восстановления не нужен."]

#par[#"Для проверки программа сама формирует исходные данные. Функция "#emph("makeMatrix")#" заполняет матрицу различными числами "$10, 11, dots, 10 + n m - 1$#", расставленными в случайном порядке; случайную перестановку строит функция "#emph("shuffle")#" (алгоритм Фишера – Йетса). Функция "#emph("buildLine")#" записывает строки, а затем столбцы матрицы в одномерный массив, каждый раз в порядке новой случайной перестановки. После восстановления функция "#emph("isEqual")#" сравнивает полученную матрицу с исходной, а "#emph("printMatrix")#" печатает матрицы."]

#par[#"Все массивы статические, с псевдопеременными границами: объявляется массив размера "$10 times 10$#", а пользователь вводит реальные "$n$#" и "$m$#". Двумерный массив передаётся в функции как параметр вида "#emph("int a[][MAX]")#": вторая размерность должна быть известна при компиляции, чтобы функция могла вычислить адрес элемента "$a_(i j)$#"."]

#par[#"Алгоритм решения:"]

#par[#"1) "#"ввести размеры "$n$#" и "$m$#" ("$1 lt.eq n, m lt.eq 10$#"), при ошибке повторить ввод;"]
#par[#"2) "#"сформировать матрицу из неповторяющихся элементов и напечатать её;"]
#par[#"3) "#"записать в одномерный массив строки, а затем столбцы матрицы в случайном порядке и напечатать его;"]
#par[#"4) "#"для каждой строки одномерного массива найти её номер по первому элементу и переписать её в новую матрицу;"]
#par[#"5) "#"напечатать восстановленную матрицу и сравнить её с исходной."]

#gost-h(2, "2.1", (text: "Блок-схема", body: [#"Блок-схема"]), newpage: false, toc: true)

#par[#"Блок-схемы алгоритмов, выполненные по ГОСТ 19.701-90 "#"[2]"#", приведены ниже. Схема функции "#emph("main")#" разделена на три листа: рисунок "#"1"#", рисунок "#"2"#" и рисунок "#"3"#"; места разрыва обозначены соединителями. Функция "#emph("shuffle")#" показана на рисунке "#"4"#", "#emph("makeMatrix")#" – на рисунке "#"5"#", "#emph("buildLine")#" – на рисунке "#"6"#", "#emph("rowIndex")#" – на рисунке "#"7"#", "#emph("restore")#" – на рисунке "#"8"#", "#emph("printMatrix")#" – на рисунке "#"9"#", "#emph("isEqual")#" – на рисунке "#"10"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_main_p1.png", width: 40.94%))
#v(0.4em)
#cap(align(center)[#"Рисунок 1 – "#"Блок-схема алгоритма функции main (лист 1 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_main_p2.png", width: 66.72%))
#v(0.4em)
#cap(align(center)[#"Рисунок 2 – "#"Блок-схема алгоритма функции main (лист 2 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_main_p3.png", width: 98.79%))
#v(0.4em)
#cap(align(center)[#"Рисунок 3 – "#"Блок-схема алгоритма функции main (лист 3 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_shuffle.png", width: 50.27%))
#v(0.4em)
#cap(align(center)[#"Рисунок 4 – "#"Блок-схема алгоритма функции shuffle"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_makeMatrix.png", width: 56.24%))
#v(0.4em)
#cap(align(center)[#"Рисунок 5 – "#"Блок-схема алгоритма функции makeMatrix"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_buildLine.png", width: 39.00%))
#v(0.4em)
#cap(align(center)[#"Рисунок 6 – "#"Блок-схема алгоритма функции buildLine"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_rowIndex.png", width: 81.59%))
#v(0.4em)
#cap(align(center)[#"Рисунок 7 – "#"Блок-схема алгоритма функции rowIndex"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_restore.png", width: 57.30%))
#v(0.4em)
#cap(align(center)[#"Рисунок 8 – "#"Блок-схема алгоритма функции restore"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_printMatrix.png", width: 64.68%))
#v(0.4em)
#cap(align(center)[#"Рисунок 9 – "#"Блок-схема алгоритма функции printMatrix"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab5_isEqual.png", width: 80.54%))
#v(0.4em)
#cap(align(center)[#"Рисунок 10 – "#"Блок-схема алгоритма функции isEqual"])
]

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: false, toc: true)

#par[#"Текст программы на языке C++ (стандарт C++20) приведён ниже. Одномерные массивы передаются в функции через указатель на первый элемент, двумерные – через указатель на строку из "#emph("MAX")#" элементов, поэтому изменения массивов в функциях видны в "#emph("main")#". Массивы, которые функция только читает, объявлены с модификатором "#emph("const")#"."]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <iomanip>\n#include <cstdlib>\n#include <ctime>\n\nconst int MAX = 10;\n\nvoid shuffle(int p[], int k) {\n    for (int i = 0; i < k; i++)\n        p[i] = i;\n    for (int i = k - 1; i > 0; i--) {\n        int r = std::rand() % (i + 1);\n        int t = p[i];\n        p[i] = p[r];\n        p[r] = t;\n    }\n}\n\nvoid makeMatrix(int a[][MAX], int n, int m) {\n    int p[MAX * MAX];\n    shuffle(p, n * m);\n    for (int i = 0; i < n; i++)\n        for (int j = 0; j < m; j++)\n            a[i][j] = 10 + p[i * m + j];\n}\n\nint buildLine(int a[][MAX], int n, int m, int b[]) {\n    int p[MAX];\n    int k = 0;\n    shuffle(p, n);\n    for (int t = 0; t < n; t++)\n        for (int j = 0; j < m; j++) {\n            b[k] = a[p[t]][j];\n            k++;\n        }\n    shuffle(p, m);\n    for (int t = 0; t < m; t++)\n        for (int i = 0; i < n; i++) {\n            b[k] = a[i][p[t]];\n            k++;\n        }\n    return k;\n}\n\nint rowIndex(const int b[], int n, int m, int x) {\n    for (int k = 0; k < m * n; k++)\n        if (b[n * m + k] == x)\n            return k % n;\n    return -1;\n}\n\nvoid restore(const int b[], int n, int m, int c[][MAX]) {\n    for (int r = 0; r < n; r++) {\n        int i = rowIndex(b, n, m, b[r * m]);\n        for (int j = 0; j < m; j++)\n            c[i][j] = b[r * m + j];\n    }\n}\n\nvoid printMatrix(int a[][MAX], int n, int m) {\n    for (int i = 0; i < n; i++) {\n        for (int j = 0; j < m; j++)\n            std::cout << std::setw(4) << a[i][j];\n        std::cout << std::endl;\n    }\n}\n\nbool isEqual(int a[][MAX], int c[][MAX], int n, int m) {\n    for (int i = 0; i < n; i++)\n        for (int j = 0; j < m; j++)\n            if (a[i][j] != c[i][j])\n                return false;\n    return true;\n}\n\nint main() {\n    int a[MAX][MAX], c[MAX][MAX];\n    int b[2 * MAX * MAX];\n    int n, m;\n    std::srand(std::time(nullptr));\n\n    std::cout << \"Enter n and m (1..\" << MAX << \"): \";\n    std::cin >> n >> m;\n    while (n < 1 || n > MAX || m < 1 || m > MAX) {\n        std::cout << \"Wrong size, enter again: \";\n        std::cin >> n >> m;\n    }\n\n    makeMatrix(a, n, m);\n    std::cout << \"Source matrix:\" << std::endl;\n    printMatrix(a, n, m);\n\n    int len = buildLine(a, n, m, b);\n    std::cout << \"One-dimensional array (rows, then columns):\"\n              << std::endl;\n    for (int k = 0; k < len; k++) {\n        std::cout << b[k] << \" \";\n        if (k == n * m - 1)\n            std::cout << std::endl;\n    }\n    std::cout << std::endl;\n\n    restore(b, n, m, c);\n    std::cout << \"Restored matrix:\" << std::endl;\n    printMatrix(c, n, m);\n\n    if (isEqual(a, c, n, m))\n        std::cout << \"Restored matrix matches the source\" << std::endl;\n    else\n        std::cout << \"Restored matrix differs\" << std::endl;\n    return 0;\n}") })

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: false, toc: true)

#par[#"Программа скомпилирована командой "#emph("g++ -std=c++20 -O2 -Wall -Wextra lab5.cpp -o lab5.exe")#", предупреждений нет. Результат её работы при "$n = 4$#" и "$m = 5$#" показан на рисунке "#"11"#". Первая строка одномерного массива – это строки матрицы, вторая – её столбцы."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 11 – "#"Результат работы программы"])
]

#par[#"Проверим восстановление вручную. Первая записанная строка 27, 19, 13, 28, 22 начинается с числа 27. В столбцовой части число 27 стоит в столбце 25, 24, 27, 17 на третьем месте (индекс 2), значит, это строка с индексом 2, то есть третья строка матрицы. Аналогично число 25 стоит в том же столбце на первом месте, 24 – на втором, 17 – на четвёртом, поэтому строки 25, 14, 11, 20, 26, затем 24, 29, 15, 12, 10 и 17, 16, 18, 23, 21 встают на места с индексами 0, 1 и 3. Полученная матрица совпадает с исходной, что подтверждает и последняя строка вывода программы."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"В ходе лабораторной работы получены навыки обработки массивов с помощью функций: одномерные и двумерные массивы передавались в функции как параметры, функции изменяли их содержимое и возвращали результат через имя функции."]

#par[#"Для восстановления матрицы оказалось достаточно столбцовой части одномерного массива: номер каждой строки определяется по положению её первого элемента в столбце, поскольку элементы не повторяются. Программа сама проверяет результат, сравнивая восстановленную матрицу с исходной, а ручная проверка подтвердила правильность работы."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)
#par[#"1. "#"Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]
#par[#"2. "#"ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
