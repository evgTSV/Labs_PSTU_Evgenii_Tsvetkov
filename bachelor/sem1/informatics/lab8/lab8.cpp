#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <iostream>
#include <limits>
#include <memory>
#include <sstream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <vector>

struct Student {
    char surname[41];
    char name[41];
    char patronymic[41];
    char birthDate[11];
    char address[121];
    double rating;
};

static_assert(std::is_trivially_copyable_v<Student>);

using File = std::unique_ptr<std::FILE, decltype(&std::fclose)>;

const char* const DATA_FILE = "students.dat";
const char* const TEMP_FILE = "students.tmp";

std::string readLine(const char* prompt) {
    std::cout << prompt;
    std::string line;
    if (!std::getline(std::cin, line) || line.empty())
        throw std::runtime_error("A nonempty line is required.");
    return line;
}

template<std::size_t N>
void readField(char (&field)[N], const char* prompt) {
    const std::string line = readLine(prompt);
    if (line.size() >= N)
        throw std::runtime_error("Text field is too long.");
    std::memcpy(field, line.c_str(), line.size() + 1);
}

bool validDate(const std::string& date) {
    if (date.size() != 10 || date[4] != '-' || date[7] != '-'
        || date.find_first_not_of("0123456789-") != std::string::npos
        || std::count(date.begin(), date.end(), '-') != 2)
        return false;

    using namespace std::chrono;
    const int y = std::stoi(date.substr(0, 4));
    const unsigned m = std::stoi(date.substr(5, 2));
    const unsigned d = std::stoi(date.substr(8, 2));
    return y > 0 && year_month_day(year(y), month(m), day(d)).ok();
}

Student readStudent() {
    Student student{};
    readField(student.surname, "  Surname: ");
    readField(student.name, "  Name: ");
    readField(student.patronymic, "  Patronymic: ");
    readField(student.birthDate, "  Birth date (YYYY-MM-DD): ");
    if (!validDate(student.birthDate))
        throw std::runtime_error("Invalid birth date.");
    readField(student.address, "  Home address: ");

    std::istringstream rating(readLine("  Rating: "));
    if (!(rating >> student.rating) || !std::isfinite(student.rating)
        || !(rating >> std::ws).eof())
        throw std::runtime_error("Invalid rating.");
    return student;
}

std::vector<Student> readFile() {
    File file(std::fopen(DATA_FILE, "rb"), &std::fclose);
    if (!file)
        throw std::runtime_error("Cannot open students.dat for reading.");

    std::vector<Student> students;
    Student student;
    for (;;) {
        const auto bytes =
            std::fread(&student, 1, sizeof student, file.get());
        if (bytes == sizeof student) {
            students.push_back(student);
        } else if (bytes == 0 && std::feof(file.get())
                   && !std::ferror(file.get())) {
            return students;
        } else {
            throw std::runtime_error("Incomplete read from students.dat.");
        }
    }
}

void writeFile(const std::vector<Student>& students) {
    File file(std::fopen(TEMP_FILE, "wb"), &std::fclose);
    if (!file)
        throw std::runtime_error("Cannot open students.tmp for writing.");
    try {
        for (const Student& student : students)
            if (std::fwrite(&student, sizeof student, 1, file.get()) != 1)
                throw std::runtime_error("Write failed for students.tmp.");
        if (std::fclose(file.release()) != 0)
            throw std::runtime_error("Close failed for students.tmp.");
        std::filesystem::rename(TEMP_FILE, DATA_FILE);
    } catch (...) {
        file.reset();
        std::remove(TEMP_FILE);
        throw;
    }
}

void createFile(int count) {
    std::vector<Student> students;
    for (int i = 0; i < count; ++i) {
        std::cout << "Student #" << i + 1 << '\n';
        students.push_back(readStudent());
    }
    writeFile(students);
}

void printFile(const char* title) {
    std::cout << '\n' << title << '\n';
    const auto students = readFile();
    if (students.empty())
        std::cout << "(empty file)\n";
    for (std::size_t i = 0; i < students.size(); ++i) {
        const Student& s = students[i];
        std::cout << i + 1 << ". " << s.surname << ' ' << s.name << ' '
                  << s.patronymic << " | " << s.birthDate << " | "
                  << s.address << " | " << s.rating << '\n';
    }
}

bool hasDuplicateDate(const std::vector<Student>& students,
                      const Student& key) {
    const auto sameDate = [&](const Student& s) {
        return std::strcmp(s.birthDate, key.birthDate) == 0;
    };
    return std::count_if(students.begin(), students.end(), sameDate) > 1;
}

std::size_t removeDuplicateDates() {
    const auto students = readFile();
    std::vector<Student> remaining;
    for (const Student& student : students)
        if (!hasDuplicateDate(students, student))
            remaining.push_back(student);
    writeFile(remaining);
    return students.size() - remaining.size();
}

std::vector<Student>::iterator findSurname(std::vector<Student>& students,
                                           const std::string& surname) {
    const auto matches = [&](const Student& s) {
        return surname == s.surname;
    };
    return std::find_if(students.begin(), students.end(), matches);
}

bool insertBeforeSurname(const std::string& surname) {
    auto students = readFile();
    const auto position = findSurname(students, surname);
    if (position == students.end())
        return false;

    std::cout << "New student:\n";
    const Student student = readStudent();
    students.insert(position, student);
    writeFile(students);
    return true;
}

int main() {
    try {
        std::cout << "Number of students (at least 5): ";
        int count;
        if (!(std::cin >> count) || count < 5)
            throw std::runtime_error("Enter an integer of at least 5.");
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

        createFile(count);
        printFile("Initial file");
        const auto removed = removeDuplicateDates();
        std::cout << "\nRemoved records: " << removed << '\n';
        printFile("After deletion");

        const auto surname = readLine("\nInsert before surname: ");
        if (!insertBeforeSurname(surname))
            std::cout << "Surname not found. Nothing inserted.\n";
        printFile("Final file (students.dat)");
    } catch (const std::exception& error) {
        std::cerr << "Error: " << error.what() << '\n';
        return 1;
    }
    return 0;
}

