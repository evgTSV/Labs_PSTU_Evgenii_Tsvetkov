#include <iostream>
#include <limits>
#include <memory>
#include <stdexcept>
#include <string>

using StringArray = std::unique_ptr<std::string[]>;

StringArray createArray(int count) {
    StringArray array(new std::string[count]);
    std::cout << "Enter " << count << " strings:\n";
    for (int i = 0; i < count; ++i)
        if (!std::getline(std::cin, array[i]))
            throw std::runtime_error("Not enough input strings.");
    return array;
}

void printArray(const std::string* array, int count) {
    if (count == 0)
        std::cout << "(empty array)\n";
    for (int i = 0; i < count; ++i)
        std::cout << i + 1 << ". " << array[i] << '\n';
}

StringArray insertString(const std::string* array, int count, int position,
                         const std::string& value) {
    const int index = position - 1;
    StringArray result(new std::string[count + 1]);
    for (int i = 0; i < index; ++i)
        result[i] = array[i];

    result[index] = value;
    for (int i = index; i < count; ++i)
        result[i + 1] = array[i];
    return result;
}

void destroyArray(StringArray& array) {
    array.reset();  // The default array deleter calls delete[].
}

int main() {
    try {
        std::cout << "Number of strings: ";
        int count;
        if (!(std::cin >> count) || count < 0
            || count == std::numeric_limits<int>::max())
            throw std::runtime_error("Invalid array length.");
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

        auto array = createArray(count);
        std::cout << "\nOriginal array:\n";
        printArray(array.get(), count);

        std::cout << "\nInsertion position (1.." << count + 1 << "): ";
        int position;
        if (!(std::cin >> position) || position < 1 || position > count + 1)
            throw std::runtime_error("Invalid insertion position.");
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

        std::cout << "New string: ";
        std::string value;
        if (!std::getline(std::cin, value))
            throw std::runtime_error("Cannot read the new string.");

        auto result = insertString(array.get(), count, position, value);
        std::cout << "\nResult array:\n";
        printArray(result.get(), count + 1);
        destroyArray(array);
        destroyArray(result);
    } catch (const std::exception& error) {
        std::cerr << "Error: " << error.what() << '\n';
        return 1;
    }
    return 0;
}

