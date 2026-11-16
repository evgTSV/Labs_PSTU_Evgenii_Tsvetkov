// Сгенерировано gostgen.py — ГОСТ 7.32-2017. Требуется Typst >= 0.13
#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 6. Строки. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 6"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 6 ВАРИАНТ № 25"]]
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

#par[#"Цель работы – изучение символьных и строковых переменных и способов их обработки в языке Си "#"[1]"#"."]

#par[#"Общая постановка задачи: задана строка, состоящая из символов, которые объединяются в слова; слова отделяются друг от друга одним или несколькими пробелами. Текст содержит не более 255 символов. Выполнить ввод строки и её обработку в соответствии со своим вариантом."]

#par[#"Вариант 25 практикума отсылает к задаче «Вариант 27» из пособия В. В. Подбельского и С. С. Фомина "#"[2, с. 518]"#": с клавиатуры вводится предложение. Вывести это предложение на экран, расположив буквы «по вашей любимой функции» (экспонента, квадратный корень и т. п.). Допустимые символы – прописные русские буквы и знаки препинания. В примере из пособия выбрана синусоида, а пробелы показаны знаком подчёркивания."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Предложение хранится в массиве "#emph("s")#" типа "#emph("char")#" длиной 256 (255 символов и завершающий нуль). Строка вводится функцией "#emph("std::cin.getline")#": она читает строку целиком вместе с пробелами и не даёт выйти за границу массива. Функция "#emph("gets")#" из методических указаний исключена из современных стандартов C и C++ как небезопасная, поэтому не используется."]

#par[#"Чтобы каждая русская буква занимала один байт и одну позицию на экране, консоль переключается на кодовую страницу Windows-1251 (функция "#emph("setupConsole")#"). В этой кодировке прописные буквы А–Я имеют коды от 0xC0 до 0xDF, а буква Ё – код 0xA8. Функция "#emph("isAllowed")#" проверяет один символ: это прописная русская буква, пробел или знак препинания из набора "#emph(". , ! ? ; : - \" ' ( )")#". Функция "#emph("isValid")#" проверяет всю строку; если в ней есть недопустимый символ или она пуста, ввод повторяется."]

#par[#"Символ с номером "$i$#" выводится в столбце "$i$#", а номер строки экрана определяется выбранной функцией. Аргумент функции нормируется на отрезок "$[0; 1]$#": "$#box[$x = i \/ (n - 1)$]$#", где "$n$#" – длина предложения. Функция "#emph("func")#" возвращает значение "$y ( x )$#" в пределах от 0 до 1:"]

#par[#"1) "#"синусоида "$#box[$y = (sin 4 pi x + 1) \/ 2$]$#" – два периода на всё предложение;"]
#par[#"2) "#"квадратный корень "$y = sqrt(x)$#";"]
#par[#"3) "#"экспонента "$#box[$y = (e^(3x) - 1) \/ (e^3 - 1)$]$#"."]

#par[#"Высота рисунка "$H = 9$#" строк. Номер строки экрана для символа равен "$#box[$r = H - 1 - op("round")(y (H - 1))$]$#", так что большим значениям функции соответствуют верхние строки. Функция "#emph("draw")#" заполняет двумерный массив-экран "#emph("scr")#" размером "$H times n$#" пробелами, расставляет в нём символы предложения (пробел заменяется знаком «_», чтобы он был виден, как в примере) и печатает экран построчно, отбрасывая пробелы в конце каждой строки."]

#par[#"Алгоритм решения:"]

#par[#"1) "#"переключить консоль на кодировку Windows-1251;"]
#par[#"2) "#"ввести предложение и проверить символы, при ошибке повторить ввод;"]
#par[#"3) "#"ввести номер функции от 1 до 3, при ошибке повторить ввод;"]
#par[#"4) "#"для каждого символа вычислить номер строки экрана и поместить символ в массив-экран;"]
#par[#"5) "#"напечатать массив-экран."]

#gost-h(2, "2.1", (text: "Блок-схема", body: [#"Блок-схема"]), newpage: false, toc: true)

#par[#"Блок-схемы алгоритмов, выполненные по ГОСТ 19.701-90 "#"[3]"#", приведены ниже. Функция "#emph("main")#" показана на рисунке "#"1"#", "#emph("setupConsole")#" – на рисунке "#"2"#", "#emph("isAllowed")#" – на рисунке "#"3"#", "#emph("isValid")#" – на рисунке "#"4"#", "#emph("func")#" – на рисунке "#"5"#". Схема функции "#emph("draw")#" разделена на три листа: рисунок "#"6"#", рисунок "#"7"#" и рисунок "#"8"#"."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_main.png", width: 50%))
#v(0.4em)
#cap(align(center)[#"Рисунок 1 – "#"Блок-схема алгоритма функции main"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_setupConsole.png", width: 36%))
#v(0.4em)
#cap(align(center)[#"Рисунок 2 – "#"Блок-схема алгоритма функции setupConsole"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_isAllowed.png", width: 59%))
#v(0.4em)
#cap(align(center)[#"Рисунок 3 – "#"Блок-схема алгоритма функции isAllowed"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_isValid.png", width: 46%))
#v(0.4em)
#cap(align(center)[#"Рисунок 4 – "#"Блок-схема алгоритма функции isValid"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_func.png", width: 80%))
#v(0.4em)
#cap(align(center)[#"Рисунок 5 – "#"Блок-схема алгоритма функции func"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_draw_p1.png", width: 57%))
#v(0.4em)
#cap(align(center)[#"Рисунок 6 – "#"Блок-схема алгоритма функции draw (лист 1 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_draw_p2.png", width: 57%))
#v(0.4em)
#cap(align(center)[#"Рисунок 7 – "#"Блок-схема алгоритма функции draw (лист 2 из 3)"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/lab6_draw_p3.png", width: 57%))
#v(0.4em)
#cap(align(center)[#"Рисунок 8 – "#"Блок-схема алгоритма функции draw (лист 3 из 3)"])
]

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: false, toc: true)

#par[#"Текст программы на языке C++ (стандарт C++20) приведён ниже. Для работы со строками используются функции "#emph("std::strlen")#" и "#emph("std::strchr")#" из заголовочного файла "#emph("<cstring>")#". Переключение кодировки выполняется функциями "#emph("SetConsoleCP")#" и "#emph("SetConsoleOutputCP")#" из "#emph("<windows.h>")#" и компилируется только под Windows (директива "#emph("#ifdef _WIN32")#"). Строки передаются в функции как массивы "#emph("const char[]")#", длина строки определяется по завершающему нулю."]

#block(width: 100%, above: LEAD, below: LEAD, fill: white, stroke: 0.5pt + black, inset: 6pt, { set par(justify: false, first-line-indent: 0pt, leading: 0.35em); raw(block: true, lang: "cpp", "#include <iostream>\n#include <cstring>\n#include <cmath>\n#ifdef _WIN32\n#include <windows.h>\n#endif\n\nconst int LEN = 256;\nconst int H = 9;\nconst double PI = 3.14159265358979;\n\nvoid setupConsole() {\n#ifdef _WIN32\n    SetConsoleCP(1251);\n    SetConsoleOutputCP(1251);\n#endif\n}\n\nbool isAllowed(unsigned char c) {\n    if (c >= 0xC0 && c <= 0xDF)\n        return true;\n    if (c == 0xA8)\n        return true;\n    return std::strchr(\" .,!?;:-\\\"'()\", c) != nullptr;\n}\n\nbool isValid(const char s[]) {\n    int n = std::strlen(s);\n    if (n == 0)\n        return false;\n    for (int i = 0; i < n; i++)\n        if (!isAllowed(s[i]))\n            return false;\n    return true;\n}\n\ndouble func(int f, double x) {\n    switch (f) {\n    case 1:\n        return (std::sin(4 * PI * x) + 1) / 2;\n    case 2:\n        return std::sqrt(x);\n    default:\n        return (std::exp(3 * x) - 1) / (std::exp(3.0) - 1);\n    }\n}\n\nvoid draw(const char s[], int f) {\n    char scr[H][LEN];\n    int n = std::strlen(s);\n    for (int r = 0; r < H; r++)\n        for (int c = 0; c < n; c++)\n            scr[r][c] = ' ';\n    for (int i = 0; i < n; i++) {\n        double x = 0;\n        if (n > 1)\n            x = (double)i / (n - 1);\n        int r = H - 1 - (int)std::lround(func(f, x) * (H - 1));\n        if (s[i] == ' ')\n            scr[r][i] = '_';\n        else\n            scr[r][i] = s[i];\n    }\n    for (int r = 0; r < H; r++) {\n        int last = n - 1;\n        while (last >= 0 && scr[r][last] == ' ')\n            last--;\n        for (int c = 0; c <= last; c++)\n            std::cout << scr[r][c];\n        std::cout << std::endl;\n    }\n}\n\nint main() {\n    char s[LEN];\n    int f;\n    setupConsole();\n\n    std::cout << \"Enter a sentence (capital Russian letters\"\n              << \" and punctuation):\" << std::endl;\n    std::cin.getline(s, LEN);\n    while (!isValid(s)) {\n        std::cout << \"Wrong symbols, enter again:\" << std::endl;\n        std::cin.getline(s, LEN);\n    }\n\n    std::cout << \"Function: 1 - sine, 2 - square root, 3 - exponent: \";\n    std::cin >> f;\n    while (f < 1 || f > 3) {\n        std::cout << \"Wrong number, enter again: \";\n        std::cin >> f;\n    }\n\n    draw(s, f);\n    return 0;\n}") })

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: false, toc: true)

#par[#"Программа скомпилирована командой "#emph("g++ -std=c++20 -O2 -Wall -Wextra lab6.cpp -o lab6.exe")#", предупреждений нет. Во всех запусках вводилось предложение «ПРОГРАММИРОВАНИЕ НА ЯЗЫКЕ СИ ‑ ЭТО ИНТЕРЕСНО!» длиной "$n = 45$#" символов. Результат для синусоиды показан на рисунке "#"9"#"; в этом запуске сначала была введена строка латиницей, и программа потребовала повторить ввод."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console1.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 9 – "#"Результат работы программы для синусоиды"])
]

#par[#"Проверим результат. Первый символ ("$x = 0$#") и последний ("$x = 1$#") находятся на средней, пятой строке, так как "$#box[$sin 0 = sin 4 pi = 0$]$#". Максимумы синусоиды приходятся на "$x = 1\/8$#" и "$x = 5\/8$#", то есть на символы с номерами около 5,5 и 27,5; в верхней строке действительно стоят «РАММ» (символы 4–7) и «СИ_-» (символы 26–29). Минимумы при "$x = 3\/8$#" и "$x = 7\/8$#" дают нижнюю строку с «Е_НА» и «ТЕРЕ»."]

#par[#"Результаты для квадратного корня и экспоненты показаны на рисунке "#"10"#" и рисунке "#"11"#". Корень быстро растёт в начале и медленно в конце, поэтому первые символы поднимаются почти на строку каждый, а конец предложения лежит длинными отрезками. У экспоненты наоборот: начало предложения идёт по нижней строке, а последние символы поднимаются круто вверх."]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console2.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 10 – "#"Результат работы программы для квадратного корня"])
]

#block(breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5)[
#align(center, image("img/console3.png", width: 85%))
#v(0.4em)
#cap(align(center)[#"Рисунок 11 – "#"Результат работы программы для экспоненты"])
]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"В ходе лабораторной работы изучены способы ввода, проверки и обработки строк в языке C++: строка хранится в массиве символов с завершающим нулём, читается целиком функцией "#emph("getline")#", а её символы проверяются по кодам и с помощью функции "#emph("strchr")#"."]

#par[#"Предложение выведено на экран по графику выбранной функции через промежуточный двумерный массив символов. Для правильного вывода русских букв понадобилось согласовать кодировку консоли с однобайтовым представлением символов. Ручная проверка положения символов для синусоиды подтвердила правильность работы программы."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)
#par[#"1. "#"Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]
#par[#"2. "#"Подбельский, В. В. Программирование на языке Си : учебное пособие / В. В. Подбельский, С. С. Фомин. – Москва : Финансы и статистика, 1998. – 600 с. – Текст : непосредственный."]
#par[#"3. "#"ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
