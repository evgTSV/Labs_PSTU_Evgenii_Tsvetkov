#include <algorithm>
#include <fstream>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <string_view>
#include <unordered_set>
#include <vector>

const char* const SOURCE = "F1.txt";
const char* const DESTINATION = "F2.txt";
const std::string_view SEPARATORS =
    " \t\r\n\f\v.,;:!?()[]{}<>\"'/-_\\@#%&*+=|";
const std::string_view UTF8_SEPARATORS[] = {
    "«", "»", "„", "“", "”", "‘", "’", "–", "—", "…", "\u00a0"
};

std::vector<std::string> readLines(const char* path) {
    std::ifstream file(path);
    if (!file)
        throw std::runtime_error(std::string("Cannot read from: ") + path);

    std::vector<std::string> lines;
    for (std::string line; std::getline(file, line);)
        lines.push_back(line);
    if (!file.eof() || file.bad())
        throw std::runtime_error(std::string("Cannot read: ") + path);
    return lines;
}

void writeLines(const char* path, const std::vector<std::string>& lines) {
    std::ofstream file(path);
    if (!file)
        throw std::runtime_error(std::string("Cannot write to: ") + path);
    for (const std::string& line : lines)
        file << line << '\n';
    file.close();
    if (!file)
        throw std::runtime_error(std::string("Cannot write: ") + path);
}

void createFile(int count) {
    std::cout << "Enter " << count << " lines:\n";
    std::vector<std::string> lines;
    for (int i = 0; i < count; ++i) {
        std::string line;
        if (!std::getline(std::cin, line))
            throw std::runtime_error("Not enough input lines.");
        lines.push_back(line);
    }
    writeLines(SOURCE, lines);
}

void printFile(const char* path) {
    const auto lines = readLines(path);
    std::cout << '\n' << path << '\n';
    if (lines.empty())
        std::cout << "(empty file)\n";
    for (const std::string& line : lines)
        std::cout << line << '\n';
}

std::size_t separatorLength(std::string_view text) {
    if (SEPARATORS.find(text.front()) != std::string_view::npos)
        return 1;
    if (static_cast<unsigned char>(text.front()) >= 0x80) {
        for (const auto separator : UTF8_SEPARATORS)
            if (text.starts_with(separator))
                return separator.size();
    }
    return 0;
}

std::vector<std::string_view> splitWords(std::string_view line) {
    std::vector<std::string_view> words;
    std::size_t begin = 0;
    std::size_t pos = 0;
    while (pos < line.size()) {
        const auto separator = separatorLength(line.substr(pos));
        if (separator == 0) {
            ++pos;
        } else {
            if (begin < pos)
                words.push_back(line.substr(begin, pos - begin));
            pos += separator;
            begin = pos;
        }
    }
    if (begin < pos)
        words.push_back(line.substr(begin));
    return words;
}

bool hasRepeatedWord(std::string_view line) {
    std::unordered_set<std::string_view> seen;
    for (const auto word : splitWords(line))
        if (!seen.insert(word).second)
            return true;
    return false;
}

void copyMatchingLines() {
    const auto lines = readLines(SOURCE);
    std::vector<std::string> selected;
    for (const std::string& line : lines)
        if (hasRepeatedWord(line))
            selected.push_back(line);
    writeLines(DESTINATION, selected);
}

struct WordResult {
    std::size_t number = 0;
    std::size_t digits = 0;
    std::string word;
};

WordResult findMostDigits() {
    WordResult best;
    std::size_t number = 0;
    for (const std::string& line : readLines(DESTINATION)) {
        for (const auto word : splitWords(line)) {
            ++number;
            const auto digits = static_cast<std::size_t>(
                std::count_if(word.begin(), word.end(), [](char ch) {
                    return ch >= '0' && ch <= '9';
                }));
            if (best.number == 0 || digits > best.digits)
                best = {number, digits, std::string(word)};
        }
    }
    return best;
}

int main() {
    try {
        std::cout << "Number of lines (at least 10): ";
        int count;
        if (!(std::cin >> count) || count < 10)
            throw std::runtime_error("Enter an integer of at least 10.");
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

        createFile(count);
        printFile(SOURCE);
        copyMatchingLines();
        printFile(DESTINATION);

        const auto best = findMostDigits();
        if (best.number == 0)
            std::cout << "\nThere are no words in F2.\n";
        else
            std::cout << "\nWord number: " << best.number
                      << " (" << best.word << ", digits: " << best.digits
                      << ")\n";
    } catch (const std::exception& error) {
        std::cerr << "Error: " << error.what() << '\n';
        return 1;
    }
    return 0;
}

