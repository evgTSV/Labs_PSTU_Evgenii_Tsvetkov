#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 9. Строковый ввод-вывод. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 9"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 9 ВАРИАНТ № 25"]]
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


#gost-h(1, "1", (text: "Постановка задачи", body: [#"Постановка задачи"]), newpage: true, toc: true)

#par[#"Цель работы – освоить построчный ввод и вывод текстовой информации и её хранение во внешних файлах [1]."]

#par[#"Вариант 25. Создать текстовый файл F1 из десяти или более строк. Скопировать из F1 в файл F2 все строки, в которых содержится не менее двух одинаковых слов. Определить номер слова, в котором больше всего цифр."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Строка представлена типом std::string. Файлы F1.txt и F2.txt открываются текстовыми потоками std::ifstream и std::ofstream. Строки считываются с помощью std::getline, а при записи после каждой строки ставится перевод строки. Функции createFile, printFile и copyMatchingLines отвечают за формирование, печать и копирование."]

#par[#"Функция splitWords выделяет слова между пробельными символами и знаками пунктуации, перечисленными в SEPARATORS и UTF8_SEPARATORS. Регистр учитывается. Цифры включаются в состав слова, поэтому book12 и page9 считаются отдельными словами, содержащими цифры. Пустая строка не содержит слов."]

#par[#"Для каждой строки функция hasRepeatedWord создаёт множество std::unordered_set. Если очередное слово уже было в множестве, в строке есть как минимум два одинаковых слова. В F2 строка переносится целиком. Порядок строк и их содержимое сохраняются."]

#par[#"Функция findMostDigits читает F2 и нумерует слова подряд с единицы, продолжая нумерацию на следующей строке. Для каждого слова подсчитываются символы от 0 до 9. При равенстве максимумов сохраняется первое найденное слово. Номер, количество цифр и само слово хранятся в структуре WordResult. Если слов нет, номер результата равен нулю."]

#gost-h(2, "2.1", (text: "Блок-схемы", body: [#"Блок-схемы"]), newpage: true, toc: true)

#par[#"В блок-схемах по ГОСТ 19.701-90 [2] приведены операторы C++ из листинга. Обработчик catch функции main показан отдельно."]

#par[#"Основной алгоритм показан на рисунке 1, на рисунке 2."]

#report-figure("img/lab9_main_p1.svg", 56.737%, "1", "Блок-схема алгоритма функции main (лист 1 из 2)")

#report-figure("img/lab9_main_p2.svg", 91.550%, "2", "Блок-схема алгоритма функции main (лист 2 из 2)")

#report-figure("img/lab9_handleMainError.svg", 30.909%, "3", "Блок-схема алгоритма обработчика исключений функции main")

#report-figure("img/lab9_createFile.svg", 80.944%, "4", "Блок-схема алгоритма функции createFile")

#report-figure("img/lab9_printFile.svg", 62.744%, "5", "Блок-схема алгоритма функции printFile")

#report-figure("img/lab9_copyMatchingLines.svg", 74.883%, "6", "Блок-схема алгоритма функции copyMatchingLines")

#report-figure("img/lab9_hasRepeatedWord.svg", 68.822%, "7", "Блок-схема алгоритма функции hasRepeatedWord")

#report-figure("img/lab9_splitWords_p1.svg", 79.445%, "8", "Блок-схема алгоритма функции splitWords (лист 1 из 2)")

#report-figure("img/lab9_splitWords_p2.svg", 53.671%, "9", "Блок-схема алгоритма функции splitWords (лист 2 из 2)")

#report-figure("img/lab9_separatorLength_p1.svg", 99.091%, "10", "Блок-схема алгоритма функции separatorLength (лист 1 из 2)")

#report-figure("img/lab9_separatorLength_p2.svg", 15.758%, "11", "Блок-схема алгоритма функции separatorLength (лист 2 из 2)")

#report-figure("img/lab9_findMostDigits_p1.svg", 81.550%, "12", "Блок-схема алгоритма функции findMostDigits (лист 1 из 2)")

#report-figure("img/lab9_findMostDigits_p2.svg", 18.788%, "13", "Блок-схема алгоритма функции findMostDigits (лист 2 из 2)")

#report-figure("img/lab9_readLines_p1.svg", 80.944%, "14", "Блок-схема алгоритма функции readLines (лист 1 из 2)")

#report-figure("img/lab9_readLines_p2.svg", 18.788%, "15", "Блок-схема алгоритма функции readLines (лист 2 из 2)")

#report-figure("img/lab9_writeLines.svg", 55.168%, "16", "Блок-схема алгоритма функции writeLines")

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: true, toc: true)

#par[#"Текст программы приведён в листинге. Исходный файл – lab9.cpp."]

#listing("#include <algorithm>\n#include <fstream>\n#include <iostream>\n#include <limits>\n#include <stdexcept>\n#include <string>\n#include <string_view>\n#include <unordered_set>\n#include <vector>\n\nconst char* const SOURCE = \"F1.txt\";\nconst char* const DESTINATION = \"F2.txt\";\nconst std::string_view SEPARATORS =\n    \" \\t\\r\\n\\f\\v.,;:!?()[]{}<>\\\"'/-_\\\\@#%&*+=|\";\nconst std::string_view UTF8_SEPARATORS[] = {\n    \"«\", \"»\", \"„\", \"“\", \"”\", \"‘\", \"’\", \"–\", \"—\", \"…\", \"\\u00a0\"\n};\n\nstd::vector<std::string> readLines(const char* path) {\n    std::ifstream file(path);\n    if (!file)\n        throw std::runtime_error(std::string(\"Cannot read from: \") + path);\n\n    std::vector<std::string> lines;\n    for (std::string line; std::getline(file, line);)\n        lines.push_back(line);\n    if (!file.eof() || file.bad())\n        throw std::runtime_error(std::string(\"Cannot read: \") + path);\n    return lines;\n}\n\nvoid writeLines(const char* path, const std::vector<std::string>& lines) {\n    std::ofstream file(path);\n    if (!file)\n        throw std::runtime_error(std::string(\"Cannot write to: \") + path);\n    for (const std::string& line : lines)\n        file << line << '\\n';\n    file.close();\n    if (!file)\n        throw std::runtime_error(std::string(\"Cannot write: \") + path);\n}\n\nvoid createFile(int count) {\n    std::cout << \"Enter \" << count << \" lines:\\n\";\n    std::vector<std::string> lines;\n    for (int i = 0; i < count; ++i) {\n        std::string line;\n        if (!std::getline(std::cin, line))\n            throw std::runtime_error(\"Not enough input lines.\");\n        lines.push_back(line);\n    }\n    writeLines(SOURCE, lines);\n}")

#pagebreak(weak: true)

#par[#"Печать и отбор строк"]

#listing("void printFile(const char* path) {\n    const auto lines = readLines(path);\n    std::cout << '\\n' << path << '\\n';\n    if (lines.empty())\n        std::cout << \"(empty file)\\n\";\n    for (const std::string& line : lines)\n        std::cout << line << '\\n';\n}\n\nstd::size_t separatorLength(std::string_view text) {\n    if (SEPARATORS.find(text.front()) != std::string_view::npos)\n        return 1;\n    if (static_cast<unsigned char>(text.front()) >= 0x80) {\n        for (const auto separator : UTF8_SEPARATORS)\n            if (text.starts_with(separator))\n                return separator.size();\n    }\n    return 0;\n}\n\nstd::vector<std::string_view> splitWords(std::string_view line) {\n    std::vector<std::string_view> words;\n    std::size_t begin = 0;\n    std::size_t pos = 0;\n    while (pos < line.size()) {\n        const auto separator = separatorLength(line.substr(pos));\n        if (separator == 0) {\n            ++pos;\n        } else {\n            if (begin < pos)\n                words.push_back(line.substr(begin, pos - begin));\n            pos += separator;\n            begin = pos;\n        }\n    }\n    if (begin < pos)\n        words.push_back(line.substr(begin));\n    return words;\n}\n\nbool hasRepeatedWord(std::string_view line) {\n    std::unordered_set<std::string_view> seen;\n    for (const auto word : splitWords(line))\n        if (!seen.insert(word).second)\n            return true;\n    return false;\n}\n\nvoid copyMatchingLines() {\n    const auto lines = readLines(SOURCE);\n    std::vector<std::string> selected;\n    for (const std::string& line : lines)\n        if (hasRepeatedWord(line))\n            selected.push_back(line);\n    writeLines(DESTINATION, selected);\n}")

#pagebreak(weak: true)

#par[#"Подсчёт цифр и основная функция"]

#listing("struct WordResult {\n    std::size_t number = 0;\n    std::size_t digits = 0;\n    std::string word;\n};\n\nWordResult findMostDigits() {\n    WordResult best;\n    std::size_t number = 0;\n    for (const std::string& line : readLines(DESTINATION)) {\n        for (const auto word : splitWords(line)) {\n            ++number;\n            const auto digits = static_cast<std::size_t>(\n                std::count_if(word.begin(), word.end(), [](char ch) {\n                    return ch >= '0' && ch <= '9';\n                }));\n            if (best.number == 0 || digits > best.digits)\n                best = {number, digits, std::string(word)};\n        }\n    }\n    return best;\n}\n\nint main() {\n    try {\n        std::cout << \"Number of lines (at least 10): \";\n        int count;\n        if (!(std::cin >> count) || count < 10)\n            throw std::runtime_error(\"Enter an integer of at least 10.\");\n        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\\n');\n\n        createFile(count);\n        printFile(SOURCE);\n        copyMatchingLines();\n        printFile(DESTINATION);\n\n        const auto best = findMostDigits();\n        if (best.number == 0)\n            std::cout << \"\\nThere are no words in F2.\\n\";\n        else\n            std::cout << \"\\nWord number: \" << best.number\n                      << \" (\" << best.word << \", digits: \" << best.digits\n                      << \")\\n\";\n    } catch (const std::exception& error) {\n        std::cerr << \"Error: \" << error.what() << '\\n';\n        return 1;\n    }\n    return 0;\n}")

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: true, toc: true)

#par[#"Программа собрана компилятором g++ с параметрами -std=c++20 -O2 -Wall -Wextra -Wpedantic. При сборке предупреждений не было."]

#par[#"На рисунке 17 приведено содержимое файлов F1 и F2 в контрольном запуске."]

#report-figure("img/console.png", 96%, "17", "Контрольный вывод файлов F1 и F2")

#par[#"Из десяти строк в F2 скопированы строки 2, 3, 4, 6, 7 и 8. Например, «одно, одно два» отобрана, так как запятая отделяет слово «одно». Строка «One one two» пропущена из-за различного регистра первых букв."]

#par[#"Первые четыре строки F2 содержат 12 слов. Первое слово следующей строки, item12345, получило номер 13 и содержит пять цифр. Слово code54321 тоже содержит пять цифр, но стоит позже. Программа вывела номер 13."]

#par[#"Дополнительно проверены пустой F2, строки без цифр, строка длиной более 4000 символов и ввод числа строк меньше десяти."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"Программа создаёт текстовый файл, копирует строки с повторяющимся словом и определяет номер слова с максимальным количеством цифр в F2. Результат контрольного запуска совпал с ручным подсчётом."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)

#par[#"1. Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]

#par[#"2. ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
