// Сгенерировано gostgen.py — ГОСТ 7.32-2017. Требуется Typst >= 0.13
#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 1. Знакомство с Си++. Выполнение программы простой структуры. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 1"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 1 ВАРИАНТ № 25"]]
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

#par[#"Цель работы – знакомство со средой программирования, создание, отладка и выполнение простой программы, содержащей ввод и вывод информации и простейшие вычисления "#"[1]"#"."]

#par[#"Задание 1 (вариант 25). Вычислить значение выражения"]

#block(above: LEAD + LINE * 0.6, below: LEAD + LINE * 0.6, grid(columns: (1fr, auto, 1fr), align: (left, center + horizon, right + horizon), [], $ y = ((a-b)^3 - (a^3 - 3a^2 b)) / (b^3 - 3a b^2) $, [(1)]))

#par[#"при a = 1000, b = 0,0001 для вещественных типов данных "#emph("float")#" и "#emph("double")#". Вычисления выполнить с использованием промежуточных переменных. Сравнить и объяснить полученные результаты."]

#par[#"Задание 2 (вариант 25). Для целых чисел m и n, вводимых с клавиатуры, вычислить значения выражений и объяснить полученные результаты:"]

#par[#"1) "#"--m-++n;"]
#par[#"2) "#"m*n<n++;"]
#par[#"3) "#"n-- > m++."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Задание 1. Раскроем куб разности в числителе выражения "#"(1)"#": "$(a-b)^3 = a^3 - 3a^2 b + 3a b^2 - b^3$#". Тогда числитель равен "$3a b^2 - b^3$#", а знаменатель "$b^3 - 3a b^2$#" отличается от него только знаком. Следовательно, при любых "$a$#" и "$b$#", для которых знаменатель не равен нулю, точное значение выражения"]

#block(above: LEAD + LINE * 0.6, below: LEAD + LINE * 0.6, grid(columns: (1fr, auto, 1fr), align: (left, center + horizon, right + horizon), [], $ y = -1 . $, [(2)]))

#par[#"Однако при a = 1000 и b = 0,0001 слагаемые "$(a-b)^3$#" и "$a^3 - 3a^2 b$#" имеют порядок "$10^9$#", а их разность – порядок "$10^(-5)$#". При вычитании двух близких больших чисел старшие значащие цифры взаимно уничтожаются, и в результате остаются только погрешности округления. Насколько велики эти погрешности, зависит от разрядности мантиссы типа. Характеристики типов приведены в таблице "#"1"#"."]

#block(sticky: true, above: LEAD + LINE * 0.5, below: 0.3em, cap[#"Таблица 1 – "#"Характеристики вещественных типов"])
#block(below: LEAD + LINE * 0.5, { set text(size: 12pt, hyphenate: true); set par(justify: false, first-line-indent: 0pt, leading: SINGLE)
table(columns: (1.2fr, 1.2fr, 1.3fr, 1.8fr, 1.9fr), stroke: 0.5pt + black, inset: (x: 4pt, y: 3pt), align: (x, y) => if y < 1 { center + horizon } else { (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon).at(x) },
table.header([#"Тип"], [#"Размер, бит"], [#"Мантисса, бит"], [#"Значащих десятичных цифр"], [#"Шаг сетки чисел около 10⁹"]),
[#"float"], [#"32"], [#"24"], [#"6–7"], [#"64"], [#"double"], [#"64"], [#"53"], [#"15–16"], [#"1,19·10⁻⁷"]) })

#par[#"Для типа "#emph("float")#" шаг между соседними представимыми числами около "$10^9$#" равен 64, что на шесть порядков больше искомой разности "$3 dot.op 10^(-5)$#": результат вычитания будет случайным. Для типа "#emph("double")#" шаг равен "$1","19 dot.op 10^(-7)$#", поэтому разность вычисляется с относительной погрешностью порядка десятых долей процента."]

#par[#"Как требуют методические указания "#"[1]"#", вычисление разбито на промежуточные переменные: "$c = (a-b)^3$#", "$d = a^3$#", "$e = 3a^2 b$#", "$f = b^3$#", "$g = 3a b^2$#", числитель "$c - ( d - e )$#", знаменатель "$f - g$#". Степени вычисляются умножением, а не функцией "#emph("pow")#": вызов "#emph("pow(float, int)")#" в C++ возвращает "#emph("double")#", и вычисления для "#emph("float")#" фактически шли бы в двойной точности. Чтобы не дублировать код для двух типов, вычисление оформлено шаблонной функцией "#emph("calculate<T>")#", которая вызывается для "#emph("float")#" и для "#emph("double")#"."]

#par[#"Задание 2. Префиксные операции ++x и --x сначала изменяют переменную, а затем возвращают её новое значение. Постфиксные x++ и x-- возвращают старое значение, а переменную изменяют после этого. Каждое выражение вычисляется в отдельной функции над копиями введённых m и n, поэтому выражения не влияют друг на друга. После вычисления программа выводит значение выражения и новые значения m и n."]

#par[#"В выражении m*n<n++ переменная n и читается (в произведении), и изменяется (постфиксным инкрементом) без точки следования между этими действиями. По стандарту C++ это неопределённое поведение, и компилятор g++ выдаёт предупреждение -Wsequence-point. Поэтому в программе выражение записано в эквивалентной форме с явным порядком действий: сначала сравнивается произведение со старым значением n, затем n увеличивается на 1. Такой смысл выражения подразумевает задание."]

#gost-h(2, "2.1", (text: "Блок-схема", body: [#"Блок-схема"]), newpage: false, toc: true)

#par[#"Блок-схемы алгоритмов выполнены по ГОСТ 19.701-90 "#"[2]"#". Для задания 1 схема функции "#emph("main")#" приведена на рисунке "#"1"#", схема функции "#emph("calculate")#" – на рисунке "#"2"#". Для задания 2 схема функции "#emph("main")#" приведена на рисунке "#"3"#", схемы функций "#emph("first")#", "#emph("second")#" и "#emph("third")#" – на рисунке "#"4"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/t1_main.png", width: 50%))
#v(0.4em)
#cap(align(center)[#"Рисунок 1 – "#"Блок-схема функции main (задание 1)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/t1_calculate.png", width: 45%))
#v(0.4em)
#cap(align(center)[#"Рисунок 2 – "#"Блок-схема функции calculate (задание 1)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/t2_main.png", width: 50%))
#v(0.4em)
#cap(align(center)[#"Рисунок 3 – "#"Блок-схема функции main (задание 2)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/t2_funcs.png", width: 100%))
#v(0.4em)
#cap(align(center)[#"Рисунок 4 – "#"Блок-схемы функций first, second и third (задание 2)"])
]

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: false, toc: true)

#par[#"Текст программы для задания 1 (файл "#emph("lab1_1.cpp")#"):"]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <iomanip>\n\ntemplate <typename T>\nvoid calculate(const char* type, T a, T b) {\n    T c = (a - b) * (a - b) * (a - b), d = a * a * a, e = 3 * a * a * b;\n    T f = b * b * b, g = 3 * a * b * b;\n\n    T numerator = c - (d - e), denominator = f - g;\n    T res = numerator / denominator;\n\n    std::cout << type << \": c = \" << c << \", d - e = \" << d - e\n              << std::endl;\n    std::cout << \"  num = \" << numerator << \", den = \" << denominator\n              << \", res = \" << res << std::endl;\n}\n\nint main() {\n    std::cout << \"Lab 1, Task 1: \"\n              << \"((a - b)^3 - (a^3 - 3a^2b)) / (b^3 - 3ab^2)\"\n              << std::endl;\n    std::cout << \"a = 1000, b = 0.0001\" << std::endl;\n    std::cout << std::setprecision(12);\n\n    calculate<float>(\"float\", 1000.0f, 0.0001f);\n    calculate<double>(\"double\", 1000.0, 0.0001);\n\n    return 0;\n}") })

#par[#"Текст программы для задания 2 (файл "#emph("lab1_2.cpp")#"):"]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <format>\n\nvoid first(int m, int n) {\n    int res = --m - ++n;\n    std::cout << std::format(\"1) --m - ++n = {}  (now m = {}, n = {})\",\n                             res, m, n) << std::endl;\n}\n\nvoid second(int m, int n) {\n    // m * n < n++ reads and modifies n without a sequence point\n    // (undefined behavior), so n++ is applied after the comparison\n    bool res = m * n < n;\n    n++;\n    std::cout << std::format(\"2) m * n < n++ = {}  (now m = {}, n = {})\",\n                             res, m, n) << std::endl;\n}\n\nvoid third(int m, int n) {\n    bool res = n-- > m++;\n    std::cout << std::format(\"3) n-- > m++ = {}  (now m = {}, n = {})\",\n                             res, m, n) << std::endl;\n}\n\nint main() {\n    int m = 0, n = 0;\n\n    std::cout << \"Enter the two integers m and n: m <space> n\"\n              << std::endl;\n    std::cin >> m >> n;\n\n    std::cout << std::format(\"Accepted: m = {}  n = {}\", m, n)\n              << std::endl;\n\n    first(m, n);\n    second(m, n);\n    third(m, n);\n\n    std::cout << \"Lab 1, Task 2: Completed successfully!\" << std::endl;\n\n    return 0;\n}") })

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: false, toc: true)

#par[#"Программы скомпилированы компилятором g++ (стандарт C++20, флаги -Wall и -Wextra), предупреждений нет. Результат работы программы для задания 1 показан на рисунке "#"5"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console1.png", width: 82%))
#v(0.4em)
#cap(align(center)[#"Рисунок 5 – "#"Результат работы программы для задания 1"])
]

#par[#"Для типа "#emph("float")#" оба слагаемых числителя округлились до соседних представимых чисел 999999616 и 999999680, и числитель оказался равен −64, то есть ровно одному шагу сетки. Знаменатель вычислен почти верно, а результат 2133333,75 не имеет ничего общего с точным значением −1. Для типа "#emph("double")#" числитель равен 3,004·10⁻⁵ вместо точного 2,9999999·10⁻⁵, и результат −1,00136 отличается от точного значения "#"(2)"#" примерно на 0,14 %. Таким образом, точности "#emph("float")#" для этого выражения недостаточно, а "#emph("double")#" даёт приемлемый результат."]

#par[#"Результаты двух запусков программы для задания 2 показаны на рисунке "#"6"#". Проверка вручную для m = 5, n = 3 приведена в таблице "#"2"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console2.png", width: 55%))
#v(0.4em)
#cap(align(center)[#"Рисунок 6 – "#"Результат работы программы для задания 2"])
]

#block(sticky: true, above: LEAD + LINE * 0.5, below: 0.3em, cap[#"Таблица 2 – "#"Ручная проверка выражений задания 2 при m = 5, n = 3"])
#block(below: LEAD + LINE * 0.5, { set text(size: 12pt, hyphenate: true); set par(justify: false, first-line-indent: 0pt, leading: SINGLE)
table(columns: (1.4fr, 3.6fr, 1.1fr, 1.2fr), stroke: 0.5pt + black, inset: (x: 4pt, y: 3pt), align: (x, y) => if y < 1 { center + horizon } else { (left + horizon, left + horizon, center + horizon, center + horizon).at(x) },
table.header([#"Выражение"], [#"Порядок вычисления"], [#"Результат"], [#"m, n после"]),
[#"--m-++n"], [#"m становится 4, n становится 4; 4 − 4"], [#"0"], [#"4, 4"], [#"m*n<n++"], [#"15 < 3 (старое n); затем n становится 4"], [#"false"], [#"5, 4"], [#"n-- > m++"], [#"3 > 5 (старые значения); затем n = 2, m = 6"], [#"false"], [#"6, 2"]) })

#par[#"При m = −2, n = 4 получено: −3 − 5 = −8; −8 < 4 – истина; 4 > −2 – истина. Все результаты программы совпадают с ручным расчётом."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"В ходе лабораторной работы созданы, отлажены и выполнены две программы простой структуры с вводом и выводом данных через потоки "#emph("cin")#" и "#emph("cout")#"."]

#par[#"В задании 1 выражение, точное значение которого равно −1, вычислено для типов "#emph("float")#" и "#emph("double")#". Из-за вычитания близких чисел порядка "$10^9$#" тип "#emph("float")#" дал бессмысленный результат 2133333,75, а тип "#emph("double")#" – значение −1,00136 с погрешностью около 0,14 %. Выбор типа данных должен учитывать порядок величин и потерю значащих цифр при вычитании; там, где это возможно, выражение лучше упростить аналитически."]

#par[#"В задании 2 изучено действие префиксных и постфиксных операций инкремента и декремента. Установлено, что выражение, в котором одна переменная читается и изменяется без точки следования (m*n<n++), имеет неопределённое поведение, и его нужно записывать с явным порядком вычислений."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)
#par[#"1. "#"Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]
#par[#"2. "#"ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
