#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 10. Динамические массивы. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 10"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 10 ВАРИАНТ № 25"]]
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

#par[#"Цель работы – освоить организацию динамических массивов [1]."]

#par[#"Вариант 25. Сформировать массив строк. Добавить в него строку с заданным номером."]

#par[#"Требуется ввести размер и содержимое исходного массива, сформировать новый массив, вывести результат и освободить выделенную память. Формирование, печать, преобразование и удаление массива оформляются отдельными функциями."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Элементы имеют тип std::string. Функция createArray выделяет память для n элементов операцией new[] и вводит строки через std::getline. Длина массива определяется при запуске. Печать с нумерацией выполняет printArray."]

#par[#"Пользователь вводит номер p в диапазоне от 1 до n + 1. В массиве ему соответствует индекс k = p − 1. Функция insertString выделяет новый массив из n + 1 элементов. Элементы с индексами меньше k копируются на прежние места. Затем на позицию k записывается новая строка, а остальные элементы копируются со сдвигом на одну позицию вправо."]

#par[#"При p = 1 копируется только часть после новой строки. При p = n + 1 все исходные строки остаются на своих позициях, новая строка добавляется в конец. В пустом массиве допустима позиция 1."]

#par[#"Указатели на массивы хранятся в std::unique_ptr<std::string[]>. Функция destroyArray вызывает reset(), а стандартный удалитель массива освобождает его через delete[]. При ошибке объекты std::unique_ptr также освобождают принадлежащие им массивы."]

#gost-h(2, "2.1", (text: "Блок-схемы", body: [#"Блок-схемы"]), newpage: true, toc: true)

#par[#"В блок-схемах по ГОСТ 19.701-90 [2] приведены операторы C++ из листинга. Обработчик catch функции main показан отдельно."]

#par[#"Основной алгоритм показан на рисунке 1, на рисунке 2, на рисунке 3."]

#report-figure("img/lab10_main_p1.svg", 75.792%, "1", "Блок-схема алгоритма функции main (лист 1 из 3)")

#report-figure("img/lab10_main_p2.svg", 74.883%, "2", "Блок-схема алгоритма функции main (лист 2 из 3)")

#report-figure("img/lab10_main_p3.svg", 74.883%, "3", "Блок-схема алгоритма функции main (лист 3 из 3)")

#report-figure("img/lab10_handleMainError.svg", 30.909%, "4", "Блок-схема алгоритма обработчика исключений функции main")

#report-figure("img/lab10_createArray.svg", 87.004%, "5", "Блок-схема алгоритма функции createArray")

#report-figure("img/lab10_printArray.svg", 62.762%, "6", "Блок-схема алгоритма функции printArray")

#report-figure("img/lab10_insertString.svg", 44.848%, "7", "Блок-схема алгоритма функции insertString")

#report-figure("img/lab10_destroyArray.svg", 18.788%, "8", "Блок-схема алгоритма функции destroyArray")

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: true, toc: true)

#par[#"Текст программы приведён в листинге. Исходный файл – lab10.cpp."]

#listing("#include <iostream>\n#include <limits>\n#include <memory>\n#include <stdexcept>\n#include <string>\n\nusing StringArray = std::unique_ptr<std::string[]>;\n\nStringArray createArray(int count) {\n    StringArray array(new std::string[count]);\n    std::cout << \"Enter \" << count << \" strings:\\n\";\n    for (int i = 0; i < count; ++i)\n        if (!std::getline(std::cin, array[i]))\n            throw std::runtime_error(\"Not enough input strings.\");\n    return array;\n}\n\nvoid printArray(const std::string* array, int count) {\n    if (count == 0)\n        std::cout << \"(empty array)\\n\";\n    for (int i = 0; i < count; ++i)\n        std::cout << i + 1 << \". \" << array[i] << '\\n';\n}\n\nStringArray insertString(const std::string* array, int count, int position,\n                         const std::string& value) {\n    const int index = position - 1;\n    StringArray result(new std::string[count + 1]);\n    for (int i = 0; i < index; ++i)\n        result[i] = array[i];\n\n    result[index] = value;\n    for (int i = index; i < count; ++i)\n        result[i + 1] = array[i];\n    return result;\n}\n\nvoid destroyArray(StringArray& array) {\n    array.reset();  // The default array deleter calls delete[].\n}")

#pagebreak(weak: true)

#par[#"Основная функция"]

#listing("int main() {\n    try {\n        std::cout << \"Number of strings: \";\n        int count;\n        if (!(std::cin >> count) || count < 0\n            || count == std::numeric_limits<int>::max())\n            throw std::runtime_error(\"Invalid array length.\");\n        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\\n');\n\n        auto array = createArray(count);\n        std::cout << \"\\nOriginal array:\\n\";\n        printArray(array.get(), count);\n\n        std::cout << \"\\nInsertion position (1..\" << count + 1 << \"): \";\n        int position;\n        if (!(std::cin >> position) || position < 1 || position > count + 1)\n            throw std::runtime_error(\"Invalid insertion position.\");\n        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\\n');\n\n        std::cout << \"New string: \";\n        std::string value;\n        if (!std::getline(std::cin, value))\n            throw std::runtime_error(\"Cannot read the new string.\");\n\n        auto result = insertString(array.get(), count, position, value);\n        std::cout << \"\\nResult array:\\n\";\n        printArray(result.get(), count + 1);\n        destroyArray(array);\n        destroyArray(result);\n    } catch (const std::exception& error) {\n        std::cerr << \"Error: \" << error.what() << '\\n';\n        return 1;\n    }\n    return 0;\n}")

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: true, toc: true)

#par[#"Программа собрана компилятором g++ с параметрами -std=c++20 -O2 -Wall -Wextra -Wpedantic. При сборке предупреждений не было."]

#par[#"На рисунке 9 показана вставка строки Inserted line на третье место в массиве из четырёх строк."]

#report-figure("img/console.png", 51%, "9", "Исходный массив и результат вставки")

#par[#"Первые две строки сохранили номера, новой строке присвоен номер 3. Строки Third line и Fourth line получили номера 4 и 5."]

#par[#"Дополнительно проверены крайние позиции, пустые массив и строка, а также недопустимый номер."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"Реализованы создание, печать, преобразование и освобождение динамического массива строк. При вставке формируется массив на один элемент больше, а относительный порядок исходных строк сохраняется."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)

#par[#"1. Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]

#par[#"2. ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
