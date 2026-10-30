// Сгенерировано gostgen.py — ГОСТ 7.32-2017. Требуется Typst >= 0.13
#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 3. Вычисление функций с использованием их разложения в степенной ряд. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 3"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 3 ВАРИАНТ № 25"]]
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

#par[#"Цель работы – практика в организации итерационных и арифметических циклов "#"[1]"#"."]

#par[#"Задание: для "$x$#", изменяющегося от "$a$#" до "$b$#" с шагом "$(b-a)\/k$#", где "$k = 10$#", вычислить функцию "$f ( x )$#", используя её разложение в степенной ряд, в двух случаях: для заданного "$n$#" и для заданной точности "$epsilon = 0","0001$#". Для сравнения найти точное значение функции."]

#par[#"Вариант 25: функция"]

#block(above: LEAD + LINE * 0.6, below: LEAD + LINE * 0.6, grid(columns: (1fr, auto, 1fr), align: (left, center + horizon, right + horizon), [], $ y = (e^x - e^(-x)) / 2 , $, [(1)]))

#par[#"диапазон изменения аргумента "$0","1 lt.eq x lt.eq 1$#", число слагаемых "$n = 20$#", разложение в ряд"]

#block(above: LEAD + LINE * 0.6, below: LEAD + LINE * 0.6, grid(columns: (1fr, auto, 1fr), align: (left, center + horizon, right + horizon), [], $ S = x + x^3 / 3! + dots + x^(2n+1) / (2n+1)! . $, [(2)]))

#par[#"Результаты требуется напечатать в виде строк «X=… SN=… SE=… Y=…», где X – значение параметра, SN – значение суммы для заданного "$n$#", SE – значение суммы для заданной точности, Y – точное значение функции."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Функция "#"(1)"#" – гиперболический синус "$op("sh") x$#". Её ряд Маклорена "#"(2)"#" содержит только нечётные степени "$x$#", общий член ряда"]

#block(above: LEAD + LINE * 0.6, below: LEAD + LINE * 0.6, grid(columns: (1fr, auto, 1fr), align: (left, center + horizon, right + horizon), [], $ a_n = x^(2n+1) / (2n+1)! , quad n = 0, 1, 2, dots $, [(3)]))

#par[#"Общий член содержит факториал и степень, то есть относится к типу а) по классификации методических указаний "#"[1]"#": его выгодно вычислять по рекуррентному соотношению, выражая следующий член через предыдущий. Найдём отношение соседних членов:"]

#block(above: LEAD + LINE * 0.6, below: LEAD + LINE * 0.6, grid(columns: (1fr, auto, 1fr), align: (left, center + horizon, right + horizon), [], $ a_(n+1) / a_n = x^(2n+3) / (2n+3)! dot.op (2n+1)! / x^(2n+1) = x^2 / ((2n+2)(2n+3)) , $, [(4)]))

#par[#"откуда"]

#block(above: LEAD + LINE * 0.6, below: LEAD + LINE * 0.6, grid(columns: (1fr, auto, 1fr), align: (left, center + horizon, right + horizon), [], $ a_0 = x , wide a_(n+1) = a_n x^2 / ((2n+2)(2n+3)) . $, [(5)]))

#par[#"При заданном "$n = 20$#" суммируются члены с номерами от 0 до 20 (последний член – "$x^41\/41!$#"), то есть 21 слагаемое; число повторений известно заранее, поэтому используется арифметический цикл "#emph("for")#". При заданной точности число слагаемых заранее неизвестно, поэтому используется итерационный цикл "#emph("while")#": члены ряда прибавляются к сумме, пока выполняется условие "$|a_n| gt.eq epsilon$#", то есть суммирование прекращается на первом члене, меньшем "$epsilon$#" по модулю."]

#par[#"Шаг изменения аргумента "$h = (b-a)\/k = (1 - 0","1)\/10 = 0","09$#", значение аргумента на "$i$#"-м шаге "$x_i = a + i h$#", "$i = 0, 1, dots, 10$#". Значение "$x$#" вычисляется через номер шага, а не накоплением "$x = x + h$#", чтобы ошибки округления не накапливались и последнее значение "$x = 1$#" не терялось."]

#par[#"Согласно методическим указаниям "#"[1]"#" алгоритм сводится к трём циклам, два из которых вложены в третий. Внешний цикл изменяет "$x$#", внутренние суммируют ряд при фиксированном "$x$#". Внутренние циклы оформлены отдельными функциями:"]

#par[#"– "#emph("sumN(x, N)")#" – сумма членов ряда с номерами от 0 до "$N$#" (арифметический цикл);"]
#par[#"– "#emph("sumEps(x, eps)")#" – сумма членов ряда, модуль которых не меньше "$epsilon$#" (итерационный цикл)."]

#par[#"Точное значение "$y$#" вычисляется по формуле "#"(1)"#" с помощью функции "#emph("std::exp")#". В обоих внутренних циклах перед входом задаются начальные значения: первый член "$a = x$#" и сумма "$S = 0$#"."]

#gost-h(2, "2.1", (text: "Блок-схема", body: [#"Блок-схема"]), newpage: false, toc: true)

#par[#"Блок-схемы алгоритмов, выполненные по ГОСТ 19.701-90 "#"[2]"#", приведены ниже. На рисунке "#"1"#" показана функция "#emph("main")#" с внешним циклом по "$x$#". Функции "#emph("sumN")#" и "#emph("sumEps")#", вызываемые из неё как предопределённые процессы, показаны соответственно на рисунке "#"2"#" и на рисунке "#"3"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab3_main.png", width: 45%))
#v(0.4em)
#cap(align(center)[#"Рисунок 1 – "#"Блок-схема алгоритма функции main"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab3_sumN.png", width: 45%))
#v(0.4em)
#cap(align(center)[#"Рисунок 2 – "#"Блок-схема алгоритма функции sumN"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab3_sumEps.png", width: 45%))
#v(0.4em)
#cap(align(center)[#"Рисунок 3 – "#"Блок-схема алгоритма функции sumEps"])
]

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: false, toc: true)

#par[#"Текст программы на языке C++ (стандарт C++20) приведён ниже. Для форматированного вывода используется функция "#emph("std::format")#" из заголовочного файла "#emph("<format>")#", для математических функций – заголовочный файл "#emph("<cmath>")#". В знаменателе рекуррентной формулы произведение "$( 2 n + 2 ) ( 2 n + 3 )$#" целое, но деление выполняется вещественно, так как числитель "$x^2$#" имеет тип "#emph("double")#"."]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <cmath>\n#include <format>\n\ndouble sumN(double x, int N) {\n    double a = x;\n    double s = 0;\n    for (int n = 0; n <= N; n++) {\n        s += a;\n        a *= x * x / ((2 * n + 2) * (2 * n + 3));\n    }\n    return s;\n}\n\ndouble sumEps(double x, double eps) {\n    double a = x;\n    double s = 0;\n    int n = 0;\n    while (std::fabs(a) >= eps) {\n        s += a;\n        a *= x * x / ((2 * n + 2) * (2 * n + 3));\n        n++;\n    }\n    return s;\n}\n\nint main() {\n    const double A = 0.1, B = 1.0;\n    const int K = 10;\n    const int N = 20;\n    const double EPS = 0.0001;\n    double step = (B - A) / K;\n\n    std::cout << \"Lab 3, Variant 25: y = (e^x - e^(-x)) / 2, \"\n              << \"S = x + x^3/3! + ... + x^(2n+1)/(2n+1)!\" << std::endl;\n    std::cout << std::format(\"n = {}, eps = {:.4f}\", N, EPS) << std::endl;\n\n    for (int i = 0; i <= K; i++) {\n        double x = A + i * step;\n        double sn = sumN(x, N);\n        double se = sumEps(x, EPS);\n        double y = (std::exp(x) - std::exp(-x)) / 2;\n        std::cout << std::format(\"X={:.2f}  SN={:.6f}  \", x, sn)\n                  << std::format(\"SE={:.6f}  Y={:.6f}\", se, y)\n                  << std::endl;\n    }\n\n    return 0;\n}") })

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: false, toc: true)

#par[#"Программа скомпилирована командой "#emph("g++ -std=c++20 -O2 lab3.cpp -o lab3.exe")#". Результат её работы в консоли показан на рисунке "#"4"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console.png", width: 95%))
#v(0.4em)
#cap(align(center)[#"Рисунок 4 – "#"Результат работы программы"])
]

#par[#"Результаты сведены в таблицу "#"1"#", в последнем столбце приведена погрешность суммы для заданной точности."]

#block(sticky: true, above: LEAD + LINE * 0.5, below: 0.3em, cap[#"Таблица 1 – "#"Результаты вычисления функции"])
#block(below: LEAD + LINE * 0.5, { set text(size: 12pt, hyphenate: true); set par(justify: false, first-line-indent: 0pt, leading: SINGLE)
table(columns: (1fr, 1fr, 1fr, 1fr, 1fr), stroke: 0.5pt + black, inset: (x: 4pt, y: 3pt), align: (x, y) => if y < 1 { center + horizon } else { (center + horizon, center + horizon, center + horizon, center + horizon, center + horizon).at(x) },
table.header([#"X"], [#"SN"], [#"SE"], [#"Y"], [#"|SE – Y|"]),
[#"0,10"], [#"0,100167"], [#"0,100167"], [#"0,100167"], [#"0,000000"], [#"0,19"], [#"0,191145"], [#"0,191143"], [#"0,191145"], [#"0,000002"], [#"0,28"], [#"0,283673"], [#"0,283659"], [#"0,283673"], [#"0,000014"], [#"0,37"], [#"0,378500"], [#"0,378442"], [#"0,378500"], [#"0,000058"], [#"0,46"], [#"0,476395"], [#"0,476394"], [#"0,476395"], [#"0,000001"], [#"0,55"], [#"0,578152"], [#"0,578149"], [#"0,578152"], [#"0,000003"], [#"0,64"], [#"0,684594"], [#"0,684585"], [#"0,684594"], [#"0,000009"], [#"0,73"], [#"0,796586"], [#"0,796564"], [#"0,796586"], [#"0,000022"], [#"0,82"], [#"0,915034"], [#"0,914984"], [#"0,915034"], [#"0,000050"], [#"0,91"], [#"1,040899"], [#"1,040898"], [#"1,040899"], [#"0,000001"], [#"1,00"], [#"1,175201"], [#"1,175198"], [#"1,175201"], [#"0,000003"]) })

#par[#"Сумма SN из 21 слагаемого совпадает с точным значением Y во всех выведенных знаках: при "$x lt.eq 1$#" отброшенный остаток ряда меньше "$1\/43! approx 1","7 dot.op 10^(-53)$#". Погрешность суммы SE не превышает "$6 dot.op 10^(-5)$#", то есть меньше заданной точности "$epsilon$#". Она примерно равна первому отброшенному члену ряда, поэтому меняется скачками: например, при "$x = 0","37$#" суммирование останавливается на члене "$x^5\/5! approx 5","8 dot.op 10^(-5)$#", а при "$x = 0","46$#" этот член уже больше "$epsilon$#" и входит в сумму."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"В ходе лабораторной работы получена практика организации арифметических и итерационных циклов: функция "$y = (e^x - e^(-x))\/2$#" вычислена с помощью разложения в степенной ряд для заданного числа слагаемых (цикл "#emph("for")#") и для заданной точности (цикл "#emph("while")#"), а внешний цикл "#emph("for")#" перебирает значения аргумента."]

#par[#"Члены ряда вычислялись по рекуррентной формуле "#"(5)"#", что исключило вычисление факториалов и степеней. Сумма для "$n = 20$#" совпала с точным значением во всех шести знаках после запятой, сумма для "$epsilon = 0","0001$#" отличается от точного значения не более чем на "$6 dot.op 10^(-5)$#", что подтверждает правильность программы."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)
#par[#"1. "#"Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]
#par[#"2. "#"ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
