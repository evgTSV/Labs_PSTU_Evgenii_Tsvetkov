#include <iostream>
#include <cmath>
#include <format>

int main() {
    const int N = 7;
    double a = std::exp(-1.0);
    double sum = 0;

    std::cout << "Lab 2, Variant 25: sum of 7 terms, "
              << "a_n = n^2 * e^(-sqrt(n))" << std::endl;

    for (int n = 1; n <= N; n++) {
        sum += a;
        std::cout << std::format("n = {}  a_n = {:.6f}  S_n = {:.6f}",
                                 n, a, sum) << std::endl;
        a *= std::pow((n + 1.0) / n, 2)
           * std::exp(std::sqrt(n) - std::sqrt(n + 1.0));
    }

    std::cout << std::format("Sum of {} terms: {:.6f}", N, sum)
              << std::endl;

    return 0;
}
