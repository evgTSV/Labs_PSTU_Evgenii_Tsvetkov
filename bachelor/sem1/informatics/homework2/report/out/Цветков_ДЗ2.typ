#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Ханойские башни. Рекурсия и визуализация", author: "Е. Д. Цветков")
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
#par[#"ПО ДОМАШНЕМУ ЗАДАНИЮ № 2"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ХАНОЙСКИЕ БАШНИ. РЕКУРСИЯ И ВИЗУАЛИЗАЦИЯ"]]
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
#par[#"Цель работы — применить рекурсию для решения задачи о Ханойских башнях. Перенести все диски со стержня A на стержень C, используя B как вспомогательный. За один ход разрешено переносить один верхний диск. Класть больший диск на меньший запрещено."]
#par[#"Показать в консоли начальную конфигурацию и состояние всех трёх стержней после каждого хода. Количество дисков задаёт пользователь."]
#gost-h(1, "2", (text: "Анализ задачи", body: [Анализ задачи]), newpage: true)
#par[#"Состояние башен задаёт массив из трёх векторов. Первый элемент вектора — нижний диск, последний — верхний. Диск с номером 1 самый маленький. В начале диски лежат на A в порядке от n до 1."]
#par[#"Функция solve получает количество дисков и три роли стержней: откуда переносить, куда переносить и какой стержень использовать как вспомогательный. При n = 0 функция сразу возвращается. Для n > 0 выполняются три действия."]
#enum([Перенести верхние $n-1$ дисков с исходного стержня на вспомогательный.], [Переместить открывшийся диск на целевой стержень и вывести все три башни.], [Перенести $n-1$ дисков со вспомогательного стержня на целевой.])
#par[#"Для перемещения наибольшего диска все меньшие должны освободить исходный и целевой стержни. После переноса их нужно собрать поверх него. Поэтому минимальное число ходов удовлетворяет соотношению"]
$ T(0)=0, quad T(n)=2T(n-1)+1=2^n-1. $
#par[#"Функция draw строит три колонки. Знак | означает свободный стержень, а полоса из знаков равенства обозначает диск. Чем больше диск, тем шире полоса. Высота рисунка постоянна, поэтому положение дисков можно сравнивать от хода к ходу."]
#gost-h(2, "2.1", (text: "Блок-схемы алгоритмов", body: [Блок-схемы алгоритмов]), newpage: true)
#report-figure("img/homework2_solve.svg", 89.10mm, "1", "Рекурсивный перенос дисков")
#gost-h(2, "2.2", (text: "Код на C++", body: [Код на C++]), newpage: true)
#listing("#include <array>\n#include <iostream>\n#include <string>\n#include <vector>\n\nusing Towers = std::array<std::vector<int>, 3>;\n\nvoid draw(const Towers& towers, int height) {\n    int width = 2 * height + 1;\n    for (int row = height - 1; row >= 0; --row) {\n        for (const auto& tower : towers) {\n            int disk = 0;\n            if (row < static_cast<int>(tower.size())) disk = tower[row];\n            int padding = height - disk;\n            std::cout << std::string(padding, ' ');\n            if (disk == 0) std::cout << '|';\n            else std::cout << std::string(2 * disk + 1, '=');\n            std::cout << std::string(padding, ' ') << \"  \";\n        }\n        std::cout << '\\n';\n    }\n    for (int i = 0; i < 3; ++i)\n        std::cout << std::string(width, '-') << \"  \";\n    std::cout << '\\n';\n    for (char label : std::string(\"ABC\"))\n        std::cout << std::string(height, ' ') << label\n                  << std::string(height, ' ') << \"  \";\n    std::cout << \"\\n\\n\";\n}\n\nvoid solve(int n, int from, int to, int spare, Towers& towers,\n           int height, int& step) {\n    if (n == 0) return;\n    solve(n - 1, from, spare, to, towers, height, step);\n    int disk = towers[from].back();\n    towers[from].pop_back();\n    towers[to].push_back(disk);\n    ++step;\n    std::cout << \"Move \" << step << \": disk \" << disk << \", \"\n              << \"ABC\"[from] << \" -> \" << \"ABC\"[to] << '\\n';\n    draw(towers, height);\n    solve(n - 1, spare, to, from, towers, height, step);\n}\n\nint main() {\n    int n;\n    std::cout << \"Number of disks (1..10): \" << std::endl;\n    if (!(std::cin >> n) || n < 1 || n > 10) {\n        std::cerr << \"Enter an integer from 1 to 10.\\n\";\n        return 1;\n    }\n    Towers towers;\n    for (int disk = n; disk >= 1; --disk) towers[0].push_back(disk);\n    int step = 0;\n    std::cout << \"Initial state:\\n\";\n    draw(towers, n);\n    solve(n, 0, 2, 1, towers, n, step);\n    std::cout << \"Total moves: \" << step << '\\n';\n    return 0;\n}\n")
#gost-h(2, "2.3", (text: "Контрольный запуск", body: [Контрольный запуск]), newpage: true)
#par[#"Введено 2 диска. Ниже приведён полный вывод программы: начальное положение и все три хода."]
#align(left, raw("Number of disks (1..10): \nInitial state:\n ===     |      |    \n=====    |      |    \n-----  -----  -----  \n  A      B      C    \n\nMove 1: disk 1, A -> B\n  |      |      |    \n=====   ===     |    \n-----  -----  -----  \n  A      B      C    \n\nMove 2: disk 2, A -> C\n  |      |      |    \n  |     ===   =====  \n-----  -----  -----  \n  A      B      C    \n\nMove 3: disk 1, B -> C\n  |      |     ===   \n  |      |    =====  \n-----  -----  -----  \n  A      B      C    \n\nTotal moves: 3", block: true))
#par[#"Для трёх дисков программа выполнила 7 ходов, для десяти — 1023. При проверке каждого хода учитывались размер переносимого диска, доступность вершины и порядок дисков на целевом стержне. Допустимый ввод ограничен диапазоном 1–10, чтобы ограничить объём консольного вывода."]
#gost-h(1, "3", (text: "Выводы", body: [Выводы]), newpage: true)
#par[#"Рекурсивная функция переносит башню с A на C за минимальное число ходов. При каждом вызове роли стержней меняются, а правила одного переноса остаются прежними. Визуализация позволяет проследить каждый ход и проверить конечное расположение дисков."]
