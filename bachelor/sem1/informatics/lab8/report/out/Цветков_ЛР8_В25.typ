#let SIZE = 14pt
#let LEAD = 1.063em      // межстрочный 1.5 (как в Word)
#let SINGLE = 0.488em  // одинарный — для подписей и таблиц
#let LINE = 1.725em  // одна «пустая строка»
#let IND = 1.25cm
#set document(title: "Лабораторная работа № 8. Блоковый ввод-вывод. Вариант 25", author: "Е. Д. Цветков")
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
#par[#"ПО ЛАБОРАТОРНОЙ РАБОТЕ № 8"]
#par[#"по дисциплине «Информатика», «Основы алгоритмизации и программирования», «Введение в инженерную деятельность»"]
#v(1 * LINE)
#par[#"по теме:"]
#par[#strong[#"ЛАБОРАТОРНАЯ РАБОТА № 8 ВАРИАНТ № 25"]]
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

#par[#"Цель работы – освоить работу с двоичными файлами, блочный ввод-вывод структурированных данных и их хранение во внешнем файле [1]."]

#par[#"Вариант 25. Сформировать двоичный файл из записей структуры «Студент» и распечатать его содержимое. Запись включает фамилию, имя, отчество, дату рождения, домашний адрес и рейтинг."]

#par[#"Удалить элементы, у которых даты рождения совпадают. Добавить элемент перед элементом с заданной фамилией."]

#par[#"Оформить формирование, печать, удаление и добавление записей в виде функций. Для поиска записей использовать отдельные функции. При изменении содержимого использовать вспомогательный файл. Предусмотреть сообщения об ошибках открытия файла, чтения и записи."]

#gost-h(1, "2", (text: "Анализ задачи", body: [#"Анализ задачи"]), newpage: true, toc: true)

#par[#"Запись описана структурой Student. Фамилия, имя и отчество хранятся в массивах char по 41 байту, дата рождения – в массиве на 11 байт, адрес – в массиве на 121 байт. В каждом поле один байт резервируется под завершающий нуль. Рейтинг представлен типом double."]

#par[#"Ручной ввод начинается с количества записей (не менее пяти). Дата вводится в формате YYYY-MM-DD. Допустимость даты проверяется средствами <chrono>. Для чтения полей с пробелами используется std::getline."]

#par[#"Файл students.dat состоит из записей одного размера. В readFile функция fread читает один блок размером sizeof(Student) и возвращает число прочитанных байтов. Чистый конец файла отделяется от ошибки чтения и неполной записи. Такой двоичный формат рассчитан на чтение и запись одной и той же программой."]

#par[#"Функция hasDuplicateDate подсчитывает количество совпадений по дате рождения в исходном наборе. Если совпадений больше одного, удаляются все записи с этой датой. Для этого removeDuplicateDates составляет список из записей с уникальными датами, сохраняя исходный порядок."]

#par[#"Функция findSurname ищет первое точное совпадение фамилии. При успехе insertBeforeSurname вставляет новую запись перед найденной. Если в файле фамилии нет, запись не добавляется. Удаление предшествует поиску фамилии."]

#par[#"Функция writeFile записывает каждую структуру через fwrite во вспомогательный файл students.tmp. Проверяются открытие файла, число записанных элементов и закрытие. После успешной записи временный файл заменяет students.dat. При ошибке программа сообщает о ней и удаляет созданный временный файл."]

#gost-h(2, "2.1", (text: "Блок-схемы", body: [#"Блок-схемы"]), newpage: true, toc: true)

#par[#"В блок-схемах по ГОСТ 19.701-90 [2] приведены операторы C++ из листинга. Обработчик catch функции main показан отдельно. Обработчик функции writeFile также показан отдельно."]

#par[#"Основной алгоритм показан на рисунке 1, на рисунке 2."]

#report-figure("img/lab8_main_p1.svg", 72.378%, "1", "Блок-схема алгоритма функции main (лист 1 из 2)")

#report-figure("img/lab8_main_p2.svg", 77.913%, "2", "Блок-схема алгоритма функции main (лист 2 из 2)")

#report-figure("img/lab8_handleMainError.svg", 30.909%, "3", "Блок-схема алгоритма обработчика исключений функции main")

#report-figure("img/lab8_createFile.svg", 49.091%, "4", "Блок-схема алгоритма функции createFile")

#report-figure("img/lab8_readStudent_p1.svg", 87.004%, "5", "Блок-схема алгоритма функции readStudent (лист 1 из 2)")

#report-figure("img/lab8_readStudent_p2.svg", 83.974%, "6", "Блок-схема алгоритма функции readStudent (лист 2 из 2)")

#report-figure("img/lab8_readLine.svg", 77.913%, "7", "Блок-схема алгоритма функции readLine")

#report-figure("img/lab8_readField.svg", 68.822%, "8", "Блок-схема алгоритма функции readField")

#report-figure("img/lab8_validDate.svg", 68.822%, "9", "Блок-схема алгоритма функции validDate")

#report-figure("img/lab8_printFile.svg", 71.853%, "10", "Блок-схема алгоритма функции printFile")

#report-figure("img/lab8_readFile_p1.svg", 55.168%, "11", "Блок-схема алгоритма функции readFile (лист 1 из 2)")

#report-figure("img/lab8_readFile_p2.svg", 99.091%, "12", "Блок-схема алгоритма функции readFile (лист 2 из 2)")

#report-figure("img/lab8_removeDuplicateDates.svg", 77.913%, "13", "Блок-схема алгоритма функции removeDuplicateDates")

#report-figure("img/lab8_hasDuplicateDate.svg", 49.091%, "14", "Блок-схема алгоритма функции hasDuplicateDate")

#report-figure("img/lab8_insertBeforeSurname_p1.svg", 62.762%, "15", "Блок-схема алгоритма функции insertBeforeSurname (лист 1 из 2)")

#report-figure("img/lab8_insertBeforeSurname_p2.svg", 18.788%, "16", "Блок-схема алгоритма функции insertBeforeSurname (лист 2 из 2)")

#report-figure("img/lab8_findSurname.svg", 49.091%, "17", "Блок-схема алгоритма функции findSurname")

#report-figure("img/lab8_writeFile_p1.svg", 87.004%, "18", "Блок-схема алгоритма функции writeFile (лист 1 из 2)")

#report-figure("img/lab8_writeFile_p2.svg", 80.944%, "19", "Блок-схема алгоритма функции writeFile (лист 2 из 2)")

#report-figure("img/lab8_handleWriteError.svg", 36.970%, "20", "Блок-схема алгоритма обработчика исключений функции writeFile")

#gost-h(2, "2.2", (text: "Код на C++", body: [#"Код на C++"]), newpage: true, toc: true)

#par[#"Текст программы приведён в листинге. Исходный файл – lab8.cpp."]

#listing("#include <algorithm>\n#include <chrono>\n#include <cmath>\n#include <cstdio>\n#include <cstring>\n#include <filesystem>\n#include <iostream>\n#include <limits>\n#include <memory>\n#include <sstream>\n#include <stdexcept>\n#include <string>\n#include <type_traits>\n#include <vector>\n\nstruct Student {\n    char surname[41];\n    char name[41];\n    char patronymic[41];\n    char birthDate[11];\n    char address[121];\n    double rating;\n};\n\nstatic_assert(std::is_trivially_copyable_v<Student>);\n\nusing File = std::unique_ptr<std::FILE, decltype(&std::fclose)>;\n\nconst char* const DATA_FILE = \"students.dat\";\nconst char* const TEMP_FILE = \"students.tmp\";\n\nstd::string readLine(const char* prompt) {\n    std::cout << prompt;\n    std::string line;\n    if (!std::getline(std::cin, line) || line.empty())\n        throw std::runtime_error(\"A nonempty line is required.\");\n    return line;\n}\n\ntemplate<std::size_t N>\nvoid readField(char (&field)[N], const char* prompt) {\n    const std::string line = readLine(prompt);\n    if (line.size() >= N)\n        throw std::runtime_error(\"Text field is too long.\");\n    std::memcpy(field, line.c_str(), line.size() + 1);\n}\n\nbool validDate(const std::string& date) {\n    if (date.size() != 10 || date[4] != '-' || date[7] != '-'\n        || date.find_first_not_of(\"0123456789-\") != std::string::npos\n        || std::count(date.begin(), date.end(), '-') != 2)\n        return false;\n\n    using namespace std::chrono;\n    const int y = std::stoi(date.substr(0, 4));\n    const unsigned m = std::stoi(date.substr(5, 2));\n    const unsigned d = std::stoi(date.substr(8, 2));\n    return y > 0 && year_month_day(year(y), month(m), day(d)).ok();\n}\n\nStudent readStudent() {\n    Student student{};\n    readField(student.surname, \"  Surname: \");\n    readField(student.name, \"  Name: \");\n    readField(student.patronymic, \"  Patronymic: \");\n    readField(student.birthDate, \"  Birth date (YYYY-MM-DD): \");\n    if (!validDate(student.birthDate))\n        throw std::runtime_error(\"Invalid birth date.\");\n    readField(student.address, \"  Home address: \");\n\n    std::istringstream rating(readLine(\"  Rating: \"));\n    if (!(rating >> student.rating) || !std::isfinite(student.rating)\n        || !(rating >> std::ws).eof())\n        throw std::runtime_error(\"Invalid rating.\");\n    return student;\n}\n\nstd::vector<Student> readFile() {\n    File file(std::fopen(DATA_FILE, \"rb\"), &std::fclose);\n    if (!file)\n        throw std::runtime_error(\"Cannot open students.dat for reading.\");\n\n    std::vector<Student> students;\n    Student student;\n    for (;;) {\n        const auto bytes =\n            std::fread(&student, 1, sizeof student, file.get());\n        if (bytes == sizeof student) {\n            students.push_back(student);\n        } else if (bytes == 0 && std::feof(file.get())\n                   && !std::ferror(file.get())) {\n            return students;\n        } else {\n            throw std::runtime_error(\"Incomplete read from students.dat.\");\n        }\n    }\n}\n\nvoid writeFile(const std::vector<Student>& students) {\n    File file(std::fopen(TEMP_FILE, \"wb\"), &std::fclose);\n    if (!file)\n        throw std::runtime_error(\"Cannot open students.tmp for writing.\");\n    try {\n        for (const Student& student : students)\n            if (std::fwrite(&student, sizeof student, 1, file.get()) != 1)\n                throw std::runtime_error(\"Write failed for students.tmp.\");\n        if (std::fclose(file.release()) != 0)\n            throw std::runtime_error(\"Close failed for students.tmp.\");\n        std::filesystem::rename(TEMP_FILE, DATA_FILE);\n    } catch (...) {\n        file.reset();\n        std::remove(TEMP_FILE);\n        throw;\n    }\n}\n\nvoid createFile(int count) {\n    std::vector<Student> students;\n    for (int i = 0; i < count; ++i) {\n        std::cout << \"Student #\" << i + 1 << '\\n';\n        students.push_back(readStudent());\n    }\n    writeFile(students);\n}\n\nvoid printFile(const char* title) {\n    std::cout << '\\n' << title << '\\n';\n    const auto students = readFile();\n    if (students.empty())\n        std::cout << \"(empty file)\\n\";\n    for (std::size_t i = 0; i < students.size(); ++i) {\n        const Student& s = students[i];\n        std::cout << i + 1 << \". \" << s.surname << ' ' << s.name << ' '\n                  << s.patronymic << \" | \" << s.birthDate << \" | \"\n                  << s.address << \" | \" << s.rating << '\\n';\n    }\n}\n\nbool hasDuplicateDate(const std::vector<Student>& students,\n                      const Student& key) {\n    const auto sameDate = [&](const Student& s) {\n        return std::strcmp(s.birthDate, key.birthDate) == 0;\n    };\n    return std::count_if(students.begin(), students.end(), sameDate) > 1;\n}\n\nstd::size_t removeDuplicateDates() {\n    const auto students = readFile();\n    std::vector<Student> remaining;\n    for (const Student& student : students)\n        if (!hasDuplicateDate(students, student))\n            remaining.push_back(student);\n    writeFile(remaining);\n    return students.size() - remaining.size();\n}\n\nstd::vector<Student>::iterator findSurname(std::vector<Student>& students,\n                                           const std::string& surname) {\n    const auto matches = [&](const Student& s) {\n        return surname == s.surname;\n    };\n    return std::find_if(students.begin(), students.end(), matches);\n}\n\nbool insertBeforeSurname(const std::string& surname) {\n    auto students = readFile();\n    const auto position = findSurname(students, surname);\n    if (position == students.end())\n        return false;\n\n    std::cout << \"New student:\\n\";\n    const Student student = readStudent();\n    students.insert(position, student);\n    writeFile(students);\n    return true;\n}\n\nint main() {\n    try {\n        std::cout << \"Number of students (at least 5): \";\n        int count;\n        if (!(std::cin >> count) || count < 5)\n            throw std::runtime_error(\"Enter an integer of at least 5.\");\n        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\\n');\n\n        createFile(count);\n        printFile(\"Initial file\");\n        const auto removed = removeDuplicateDates();\n        std::cout << \"\\nRemoved records: \" << removed << '\\n';\n        printFile(\"After deletion\");\n\n        const auto surname = readLine(\"\\nInsert before surname: \");\n        if (!insertBeforeSurname(surname))\n            std::cout << \"Surname not found. Nothing inserted.\\n\";\n        printFile(\"Final file (students.dat)\");\n    } catch (const std::exception& error) {\n        std::cerr << \"Error: \" << error.what() << '\\n';\n        return 1;\n    }\n    return 0;\n}")

#gost-h(2, "2.3", (text: "Вывод результатов работы", body: [#"Вывод результатов работы"]), newpage: true, toc: true)

#par[#"Программа собрана компилятором g++ с параметрами -std=c++20 -O2 -Wall -Wextra -Wpedantic. При сборке предупреждений не было."]

#par[#"На рисунке 21 показан фрагмент контрольного запуска. Исходный файл содержал шесть записей."]

#report-figure("img/console.png", 76%, "21", "Исходный файл и результаты двух операций")

#par[#"Дата 2006-02-14 встретилась у Иванова, Сидорова и Козлова. Все три записи удалены. После удаления остались Петров, Смирнов и Волков."]

#par[#"При вводе фамилии Smirnov запись Орлова вставлена между Петровым и Смирновым. Итоговый файл содержит четыре записи в порядке Petrov, Orlov, Smirnov, Volkov."]

#par[#"Дополнительно проверены набор без совпадений, набор с одной общей датой, несколько групп совпадений, некорректная дата и ошибка замены файла. При пустом результате удаления и при отсутствии фамилии программа сообщает о невозможности вставки."]

#gost-h(1, "3", (text: "Выводы", body: [#"Выводы"]), newpage: true, toc: true)

#par[#"В ходе работы реализованы создание и чтение двоичного файла, удаление записей с совпадающими датами рождения и вставка перед записью с заданной фамилией. Изменения сохраняются через вспомогательный файл. Контрольные запуски подтвердили правильность порядка записей и обработки ошибок."]

#gost-struct("СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ", toc: true)

#par[#"1. Викентьева, О. Л. Программирование на языке С++ : лабораторный практикум для студентов специальности АСУ / О. Л. Викентьева, О. А. Полякова. – Пермь : ПГТУ, 2003. – Текст : непосредственный."]

#par[#"2. ГОСТ 19.701-90 (ИСО 5807-85). Единая система программной документации. Схемы алгоритмов, программ, данных и систем. Обозначения условные и правила выполнения : издание официальное : дата введения 1992-01-01. – Москва : Стандартинформ, 2010. – 23 с."]
