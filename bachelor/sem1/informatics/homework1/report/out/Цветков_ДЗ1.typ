#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Три метода сортировки массива", author: "Е. Д. Цветков")
#set page(paper: "a4", margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
  footer: context {
    let n = counter(page).get().first()
    if n > 1 { align(center, text(size: SIZE, str(n))) }
  }, footer-descent: 35%)
#set text(font: "Times New Roman", size: SIZE, lang: "ru", hyphenate: true, fill: black)
#set par(justify: true, leading: LEAD, spacing: LEAD, first-line-indent: (amount: IND, all: true))
#show raw: set text(font: "Courier New", size: 10pt)
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
#par[#"ПО ДОМАШНЕМУ ЗАДАНИЮ № 1"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ТРИ МЕТОДА СОРТИРОВКИ МАССИВА"]]
]
#v(1fr)
#grid(columns: (1fr, 3.5cm, 1fr), column-gutter: 0.6cm, row-gutter: 1.2em,
  [#"Выполнил" \
#"студент гр. АСУ-26-1б"],
  align(bottom)[#box(width: 100%, repeat[\_])],
  align(bottom)[#"Е. Д. Цветков"],
  [#"Проверил" \
#"доцент кафедры ИТАС"],
  align(bottom)[#box(width: 100%, repeat[\_])],
  align(bottom)[#"О. А. Полякова"])

#v(1fr)
#align(center)[#"Пермь 2026"]
]



#let report-figure(file, width, number, label) = block(
  breakable: false, width: 100%, above: LEAD + LINE * 0.5, below: LEAD + LINE * 0.5,
)[
  #align(center, image(file, width: width))
  #v(0.4em)
  #cap(align(center)[Рисунок #number – #label])
]
#let listing(source) = block(
  breakable: true, width: 100%, above: LEAD, below: LEAD,
  stroke: 0.5pt + black, inset: 6pt,
  {
    set par(justify: false, first-line-indent: 0pt, leading: 0.35em)
    raw(source, block: true, lang: "cpp")
  },
)
#gost-toc()
#gost-h(1, "1", (text: "Постановка задачи", body: [Постановка задачи]), newpage: true)
#par[#"Цель работы — реализовать и сравнить три алгоритма сортировки целочисленного массива: пузырьком, вставками и выбором."]
#par[#"Пользователь вводит количество элементов и сами числа. Каждый метод получает копию одного и того же массива и выводит результат сортировки по возрастанию. Совпадающие значения сохраняются."]
#gost-h(1, "2", (text: "Анализ задачи", body: [Анализ задачи]), newpage: true)
#par[#"Сортировка пузырьком сравнивает соседние элементы. Если левый больше правого, элементы меняются местами. В конце прохода наибольший элемент необработанной части занимает своё окончательное место. Проход без обменов завершает сортировку."]
#par[#"Сортировка вставками поддерживает упорядоченное начало массива. Очередной элемент сохраняется в переменной key. Большие элементы сдвигаются вправо, после чего key записывается в освободившуюся позицию."]
#par[#"Сортировка выбором ищет наименьший элемент в необработанной части массива. Один обмен ставит его на первую свободную позицию. Затем граница отсортированной части сдвигается вправо."]
#align(center, table(columns: 3, align: center + horizon, [Метод], [Лучший случай], [Худший случай], [Пузырьком], [$Theta(n)$], [$Theta(n^2)$], [Вставками], [$Theta(n)$], [$Theta(n^2)$], [Выбором], [$Theta(n^2)$], [$Theta(n^2)$]))
#par[#"В таблице n — число элементов. Каждая функция сортирует переданный массив на месте и использует постоянный объём дополнительной памяти. Копия исходных данных в main нужна для сравнения трёх запусков."]
#gost-h(2, "2.1", (text: "Блок-схемы алгоритмов", body: [Блок-схемы алгоритмов]), newpage: true)
#report-figure("img/homework1_bubbleSort.svg", 119.86mm, "1", "Сортировка пузырьком")
#report-figure("img/homework1_insertionSort.svg", 114.40mm, "2", "Сортировка вставками")
#report-figure("img/homework1_selectionSort.svg", 130.31mm, "3", "Сортировка выбором")
#gost-h(2, "2.2", (text: "Код на C++", body: [Код на C++]), newpage: true)
#listing("#include <iostream>\n#include <utility>\n#include <vector>\n\nusing Array = std::vector<int>;\n\nvoid bubbleSort(Array& a) {\n    for (int end = static_cast<int>(a.size()) - 1; end > 0; --end) {\n        bool changed = false;\n        for (int j = 0; j < end; ++j) {\n            if (a[j] > a[j + 1]) {\n                std::swap(a[j], a[j + 1]);\n                changed = true;\n            }\n        }\n        if (!changed) break;\n    }\n}\n\nvoid insertionSort(Array& a) {\n    for (int i = 1; i < static_cast<int>(a.size()); ++i) {\n        int key = a[i];\n        int j = i;\n        while (j > 0 && a[j - 1] > key) {\n            a[j] = a[j - 1];\n            --j;\n        }\n        a[j] = key;\n    }\n}\n\nvoid selectionSort(Array& a) {\n    int n = static_cast<int>(a.size());\n    for (int i = 0; i < n - 1; ++i) {\n        int smallest = i;\n        for (int j = i + 1; j < n; ++j) {\n            if (a[j] < a[smallest]) smallest = j;\n        }\n        if (smallest != i) std::swap(a[i], a[smallest]);\n    }\n}\n\nvoid print(const char* label, const Array& a) {\n    std::cout << label << ':';\n    for (int x : a) std::cout << ' ' << x;\n    std::cout << '\\n';\n}\n\nint main() {\n    int n;\n    std::cout << \"Number of elements: \" << std::endl;\n    if (!(std::cin >> n) || n < 0) {\n        std::cerr << \"Expected a nonnegative size.\\n\";\n        return 1;\n    }\n    Array original(n);\n    std::cout << \"Enter the elements:\" << std::endl;\n    for (int& x : original) {\n        if (!(std::cin >> x)) {\n            std::cerr << \"Expected an integer.\\n\";\n            return 1;\n        }\n    }\n    print(\"Input\", original);\n    Array a = original;\n    bubbleSort(a);\n    print(\"Bubble\", a);\n    a = original;\n    insertionSort(a);\n    print(\"Insertion\", a);\n    a = original;\n    selectionSort(a);\n    print(\"Selection\", a);\n    return 0;\n}\n")
#gost-h(2, "2.3", (text: "Контрольный запуск", body: [Контрольный запуск]), newpage: true)
#par[#"Входные данные: 7 элементов, затем значения 4, −2, 7, 4, 0, −5, 1."]
#align(left, raw("Number of elements: \nEnter the elements:\nInput: 4 -2 7 4 0 -5 1\nBubble: -5 -2 0 1 4 4 7\nInsertion: -5 -2 0 1 4 4 7\nSelection: -5 -2 0 1 4 4 7", block: true))
#par[#"Все методы дали последовательность −5, −2, 0, 1, 4, 4, 7. Отрицательные значения оказались в начале, обе четвёрки сохранились. Также проверены пустой массив, один элемент, одинаковые числа, прямой и обратный порядок."]
#gost-h(1, "3", (text: "Выводы", body: [Выводы]), newpage: true)
#par[#"Реализованы три сортировки по возрастанию. На уже упорядоченном массиве вставки и пузырёк с досрочным выходом выполняют один линейный проход. Метод выбора при любом исходном порядке просматривает оставшуюся часть массива для каждой позиции."]
