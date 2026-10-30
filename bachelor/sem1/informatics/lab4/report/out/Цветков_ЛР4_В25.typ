// Сгенерировано gostgen.py — ГОСТ 7.32-2017. Требуется Typst >= 0.13
#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 4. Работа с одномерными массивами. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 4"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 4 ВАРИАНТ № 25"]]
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

#par[#"Цель работы – получение навыков обработки одномерных массивов "#"[1]"#"."]

#par[#"Задание (вариант 25):"]

#par[#"1) "#"реализовать с использованием массива однонаправленное кольцо (просмотр возможен справа налево, от первого элемента можно перейти к последнему);"]
#par[#"2) "#"распечатать полученный массив, начиная с элемента с номером "$K$#" и до элемента с номером "$K + 1$#";"]
#par[#"3) "#"упорядочить элементы по убыванию;"]
#par[#"4) "#"удалить из кольца нечётные элементы;"]
#par[#"5) "#"распечатать полученный массив, начиная с элемента с номером "$K$#" и до элемента с номером "$K + 1$#"."]

#par[#"Согласно методическим указаниям "#"[1]"#" используется статический массив с псевдопеременными границами: объявляется массив достаточно большой длины "$N = 100$#", а пользователь вводит реальную длину кольца "$n lt.eq N$#", и программа работает только с первыми "$n$#" элементами."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Элементы кольца хранятся в массиве "#emph("a")#" в позициях с индексами от 0 до "$n - 1$#"; элемент с номером "$K$#" (нумерация с единицы) имеет индекс "$K - 1$#". Значения элементов задаются датчиком случайных чисел "#emph("std::rand")#" в диапазоне от 0 до 99, датчик инициализируется текущим временем."]

#par[#"Однонаправленный просмотр справа налево означает, что от элемента с индексом "$i$#" переходят к элементу с индексом "$i - 1$#", а от первого элемента ("$i = 0$#") – к последнему ("$i = n - 1$#"). Обход, начатый с "$K$#"-го элемента, проходит элементы "$K, K-1, dots, 1, n, n-1, dots, K+1$#" и заканчивается на "$#box[$(K+1)$]$#"-м элементе, после чего кольцо замыкается; всего печатается "$n$#" элементов. Эту печать выполняет функция "#emph("printRing(a, n, k)")#"."]

#par[#"Упорядочивание по убыванию выполняется методом пузырька в функции "#emph("sortDesc(a, n)")#": на каждом проходе сравниваются соседние элементы, и если левый меньше правого, они меняются местами. После "$i$#"-го прохода "$i$#" наименьших элементов стоят в конце массива на своих местах, поэтому внутренний цикл сокращается на единицу с каждым проходом."]

#par[#"Под нечётными элементами понимаются элементы с нечётным значением (так же, как в других вариантах этой работы, где «чётный элемент» означает элемент с чётным значением). Удаление выполняется функцией "#emph("removeOdd(a, n)")#" за один проход: чётные элементы переписываются в начало массива с сохранением порядка, а новая длина "$m$#" – число оставшихся элементов – возвращается в вызывающую функцию. Так реальная длина массива изменяется при удалении, как требуют методические указания."]

#par[#"После удаления длина кольца может стать меньше "$K$#". Поскольку структура кольцевая, номер "$K$#" отсчитывается по кольцу: "$#box[$K' = ((K-1) mod n) + 1$]$#". Если же все элементы были нечётными и кольцо стало пустым, программа сообщает об этом. Введённые "$n$#" и "$K$#" проверяются: при выходе за допустимые границы ввод повторяется."]

#par[#"Алгоритм решения:"]

#par[#"1) "#"ввести длину кольца "$n$#" ("$1 lt.eq n lt.eq 100$#") и заполнить массив случайными числами;"]
#par[#"2) "#"ввести номер "$K$#" ("$1 lt.eq K lt.eq n$#");"]
#par[#"3) "#"распечатать кольцо от "$K$#"-го до "$#box[$(K+1)$]$#"-го элемента справа налево;"]
#par[#"4) "#"упорядочить массив по убыванию и распечатать его;"]
#par[#"5) "#"удалить нечётные элементы, пересчитать "$K$#" для новой длины и распечатать кольцо от "$K$#"-го до "$#box[$(K+1)$]$#"-го элемента."]

#gost-h(2, "2.1", (text: "Блок-схема", body: [#"Блок-схема"]), newpage: false, toc: true)

#par[#"Блок-схемы алгоритмов, выполненные по ГОСТ 19.701-90 "#"[2]"#", приведены ниже. Схема функции "#emph("main")#" не помещается на одном листе, поэтому разделена на три листа: рисунок "#"1"#", рисунок "#"2"#" и рисунок "#"3"#"; места разрыва обозначены соединителями «А» и «Б». Функция "#emph("printRing")#" показана на рисунке "#"4"#", функция "#emph("sortDesc")#" – на рисунке "#"5"#", функция "#emph("removeOdd")#" – на рисунке "#"6"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab4_main_p1.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 1 – "#"Блок-схема алгоритма функции main (лист 1 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab4_main_p2.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 2 – "#"Блок-схема алгоритма функции main (лист 2 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab4_main_p3.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 3 – "#"Блок-схема алгоритма функции main (лист 3 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab4_printRing.png", width: 52%))
#v(0.4em)
#cap(align(center)[#"Рисунок 4 – "#"Блок-схема алгоритма функции printRing"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab4_sortDesc.png", width: 49%))
#v(0.4em)
#cap(align(center)[#"Рисунок 5 – "#"Блок-схема алгоритма функции sortDesc"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab4_removeOdd.png", width: 43%))
#v(0.4em)
#cap(align(center)[#"Рисунок 6 – "#"Блок-схема алгоритма функции removeOdd"])
]

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: false, toc: true)

#par[#"Текст программы на языке C++ (стандарт C++20) приведён ниже. Для датчика случайных чисел используются функции "#emph("std::srand")#" и "#emph("std::rand")#" из заголовочного файла "#emph("<cstdlib>")#" и функция "#emph("std::time")#" из "#emph("<ctime>")#". Массив передаётся в функции через указатель на первый элемент, поэтому изменения, сделанные в "#emph("sortDesc")#" и "#emph("removeOdd")#", видны в "#emph("main")#"."]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <cstdlib>\n#include <ctime>\n\nvoid printRing(const int a[], int n, int k) {\n    int i = k - 1;\n    for (int c = 0; c < n; c++) {\n        std::cout << a[i] << \" \";\n        if (i == 0)\n            i = n - 1;\n        else\n            i--;\n    }\n    std::cout << std::endl;\n}\n\nvoid sortDesc(int a[], int n) {\n    for (int i = 0; i < n - 1; i++) {\n        for (int j = 0; j < n - 1 - i; j++) {\n            if (a[j] < a[j + 1]) {\n                int t = a[j];\n                a[j] = a[j + 1];\n                a[j + 1] = t;\n            }\n        }\n    }\n}\n\nint removeOdd(int a[], int n) {\n    int m = 0;\n    for (int i = 0; i < n; i++) {\n        if (a[i] % 2 == 0) {\n            a[m] = a[i];\n            m++;\n        }\n    }\n    return m;\n}\n\nint main() {\n    const int N = 100;\n    int a[N];\n    int n, k;\n    std::srand(std::time(nullptr));\n\n    std::cout << \"Enter ring length (1..\" << N << \"): \";\n    std::cin >> n;\n    while (n < 1 || n > N) {\n        std::cout << \"Wrong length, enter again: \";\n        std::cin >> n;\n    }\n    for (int i = 0; i < n; i++)\n        a[i] = std::rand() % 100;\n\n    std::cout << \"Enter K (1..\" << n << \"): \";\n    std::cin >> k;\n    while (k < 1 || k > n) {\n        std::cout << \"Wrong K, enter again: \";\n        std::cin >> k;\n    }\n\n    std::cout << \"Ring from K-th to (K+1)-th, right to left:\" << std::endl;\n    printRing(a, n, k);\n\n    sortDesc(a, n);\n    std::cout << \"Sorted in descending order (a[1]..a[n]):\" << std::endl;\n    for (int i = 0; i < n; i++)\n        std::cout << a[i] << \" \";\n    std::cout << std::endl;\n\n    n = removeOdd(a, n);\n    if (n == 0) {\n        std::cout << \"All elements were odd, the ring is empty\"\n                  << std::endl;\n    } else {\n        k = (k - 1) % n + 1;\n        std::cout << \"Odd elements removed, K = \" << k\n                  << \", ring from K-th to (K+1)-th:\" << std::endl;\n        printRing(a, n, k);\n    }\n\n    return 0;\n}") })

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: false, toc: true)

#par[#"Программа скомпилирована командой "#emph("g++ -std=c++20 -O2 lab4.cpp -o lab4.exe")#". Результат её работы при "$n = 12$#" и "$K = 4$#" показан на рисунке "#"7"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 7 – "#"Результат работы программы"])
]

#par[#"Проверим результат. Первая строка начинается с 4-го элемента (значение 4), затем идут 3-й, 2-й и 1-й элементы (71, 86, 76), после первого элемента обход переходит к последнему, 12-му (29), и заканчивается на 5-м элементе (58). Следовательно, массив до сортировки имел вид 76, 86, 71, 4, 58, 14, 20, 9, 91, 2, 61, 29. После сортировки элементы расположены по убыванию: 91, 86, 76, …, 4, 2."]

#par[#"После удаления нечётных значений (91, 71, 61, 29, 9) осталось 7 чётных элементов: 86, 76, 58, 20, 14, 4, 2. Так как "$K = 4 lt.eq 7$#", номер "$K$#" не изменился. Обход начинается с 4-го элемента (20), проходит 3-й, 2-й, 1-й (58, 76, 86), затем последний, 7-й (2), и заканчивается на 5-м (14), что совпадает с выводом программы."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"В ходе лабораторной работы получены навыки обработки одномерных массивов: на статическом массиве с псевдопеременной границей реализовано однонаправленное кольцо с просмотром справа налево, выполнены печать кольца от "$K$#"-го до "$#box[$(K+1)$]$#"-го элемента, сортировка методом пузырька по убыванию и удаление элементов с изменением реальной длины массива."]

#par[#"Переход от первого элемента к последнему реализован проверкой индекса в функции печати, а номер "$K$#" после уменьшения длины кольца пересчитывается по кольцу. Ручная проверка вывода программы подтвердила правильность порядка обхода, сортировки и удаления."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)
#par[#"1. "#"Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]
#par[#"2. "#"ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
