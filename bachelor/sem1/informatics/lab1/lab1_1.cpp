#include <iostream>
#include <iomanip>

template <typename T>
void calculate(const char* type, T a, T b) {
    T c = (a - b) * (a - b) * (a - b), d = a * a * a, e = 3 * a * a * b;
    T f = b * b * b, g = 3 * a * b * b;

    T numerator = c - (d - e), denominator = f - g;
    T res = numerator / denominator;

    std::cout << type << ": c = " << c << ", d - e = " << d - e
              << std::endl;
    std::cout << "  num = " << numerator << ", den = " << denominator
              << ", res = " << res << std::endl;
}

int main() {
    std::cout << "Lab 1, Task 1: "
              << "((a - b)^3 - (a^3 - 3a^2b)) / (b^3 - 3ab^2)"
              << std::endl;
    std::cout << "a = 1000, b = 0.0001" << std::endl;
    std::cout << std::setprecision(12);

    calculate<float>("float", 1000.0f, 0.0001f);
    calculate<double>("double", 1000.0, 0.0001);

    return 0;
}
