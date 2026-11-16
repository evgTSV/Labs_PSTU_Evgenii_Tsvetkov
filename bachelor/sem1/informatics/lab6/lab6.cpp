#include <iostream>
#include <cstring>
#include <cmath>
#ifdef _WIN32
#include <windows.h>
#endif

const int LEN = 256;
const int H = 9;
const double PI = 3.14159265358979;

void setupConsole() {
#ifdef _WIN32
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
#endif
}

bool isAllowed(unsigned char c) {
    if (c >= 0xC0 && c <= 0xDF)
        return true;
    if (c == 0xA8)
        return true;
    return std::strchr(" .,!?;:-\"'()", c) != nullptr;
}

bool isValid(const char s[]) {
    int n = std::strlen(s);
    if (n == 0)
        return false;
    for (int i = 0; i < n; i++)
        if (!isAllowed(s[i]))
            return false;
    return true;
}

double func(int f, double x) {
    switch (f) {
    case 1:
        return (std::sin(4 * PI * x) + 1) / 2;
    case 2:
        return std::sqrt(x);
    default:
        return (std::exp(3 * x) - 1) / (std::exp(3.0) - 1);
    }
}

void draw(const char s[], int f) {
    char scr[H][LEN];
    int n = std::strlen(s);
    for (int r = 0; r < H; r++)
        for (int c = 0; c < n; c++)
            scr[r][c] = ' ';
    for (int i = 0; i < n; i++) {
        double x = 0;
        if (n > 1)
            x = (double)i / (n - 1);
        int r = H - 1 - (int)std::lround(func(f, x) * (H - 1));
        if (s[i] == ' ')
            scr[r][i] = '_';
        else
            scr[r][i] = s[i];
    }
    for (int r = 0; r < H; r++) {
        int last = n - 1;
        while (last >= 0 && scr[r][last] == ' ')
            last--;
        for (int c = 0; c <= last; c++)
            std::cout << scr[r][c];
        std::cout << std::endl;
    }
}

int main() {
    char s[LEN];
    int f;
    setupConsole();

    std::cout << "Enter a sentence (capital Russian letters"
              << " and punctuation):" << std::endl;
    std::cin.getline(s, LEN);
    while (!isValid(s)) {
        std::cout << "Wrong symbols, enter again:" << std::endl;
        std::cin.getline(s, LEN);
    }

    std::cout << "Function: 1 - sine, 2 - square root, 3 - exponent: ";
    std::cin >> f;
    while (f < 1 || f > 3) {
        std::cout << "Wrong number, enter again: ";
        std::cin >> f;
    }

    draw(s, f);
    return 0;
}
